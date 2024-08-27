Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A65091CDA3C;
	Tue, 27 Aug 2024 18:44:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724784274; cv=none; b=VJwlg5v5suOA26ODTqjtJwzlRgrjhljSFHNOgeNT2hG+JaMbPPdw46Tp7y5zciiKLPWaDqaVQHkCbJzcL82xTgQMgcAMvmCWPMVBU7h5DEkHQ/ngLYOaR2Lm8issLvmbR2qR4AcbBkpT880xWiRYosEkoxgGbuVTxzw0veM37k4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724784274; c=relaxed/simple;
	bh=S+tKeRnjIVAVCcZ5QA7azWjbf7rUUFysF5bCcV9/Jms=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SCW5nvpDyguxe+mOj8Jlolm9cM+uid2jF0O1G1aHihD0N7QcXJRw6Xd5XU7Z2Pcmo659d5EM7tDM3nvFiXsSLDic6Ir6KZLmwY9kGierxVrr0BFzk2xxQkdAOoSOgYXlxdllHvyqzt/LA08ZDmtrC2WyAOYFzD6+P97keoJ5eqk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QmM7XxW2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QmM7XxW2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29CAAC4FE98;
	Tue, 27 Aug 2024 18:44:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724784274;
	bh=S+tKeRnjIVAVCcZ5QA7azWjbf7rUUFysF5bCcV9/Jms=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=QmM7XxW2aYQ1xgt1lCrivSbvrhpgI+5W8IK/x0K8YXpyfI7qXwqPkIj/7L8Zd6eWU
	 ch7e6wKEjtnZhbE+JkViB7BfavqADk9jGOmmqhR9F+wfEZ7S4McDsBhT2XZ4NZpIyU
	 9RQMMhDgKjFQMVYkk93Pk1UGtEO6M+bJ4MTBXlvakWYlWkooyciYPpPOlREB7zQil/
	 hhDVg8+Sn7lOsvJOR+HKFzci+n/4RnmuYoau6NHnVNgTh7Gakc5LtEzRBVl6lDESU+
	 iP3Jr/SuL4qpD83XtCpEhlW8+8mxrW5igezAnC6kbu1e8ufFcGx+LeCkUQ7mWzRNaO
	 d+i4g2I2f6gWw==
Date: Tue, 27 Aug 2024 11:44:33 -0700
Subject: [PATCHSET v31.0 1/5] fstests: detect deceptive filename extensions
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: hch@lst.de, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <172478422285.2039346.9658505409794335819.stgit@frogsfrogsfrogs>
In-Reply-To: <20240827184204.GM6047@frogsfrogsfrogs>
References: <20240827184204.GM6047@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi all,

In early 2023, malware researchers disclosed a phishing attack that was
targeted at people running Linux workstations.  The attack vector
involved the use of filenames containing what looked like a file
extension but instead contained a lookalike for the full stop (".")
and a common extension ("pdf").  Enhance xfs_scrub phase 5 to detect
these types of attacks and warn the system administrator.  Add
functional testing for this code.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=scrub-detect-deceptive-extensions

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=scrub-detect-deceptive-extensions
---
Commits in this patchset:
 * generic/453: test confusable name detection with 32-bit unicode codepoints
 * generic/453: check xfs_scrub detection of confusing job offers
---
 tests/generic/453 |  111 +++++++++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 99 insertions(+), 12 deletions(-)

