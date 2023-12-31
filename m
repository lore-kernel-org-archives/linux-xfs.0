Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51585C8C8;
	Sun, 31 Dec 2023 19:58:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JONQByPA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21EB7C433C7;
	Sun, 31 Dec 2023 19:58:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704052692;
	bh=sxffpr0EDDoWXSSkSdvfizJIzw/xs8NBswHTKAw6G/k=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=JONQByPA0nGQUv5fyaJcsGPIEG4wfMa8ax7rsIhSdEO2Eo85jdOctakNKp5hQk1sr
	 nN/xFLlW42gb7PMMdQAv9XyO1e5FAnGHpeY+WcKWl0OiFwtZYFV1mZaKMQt+qMA1iM
	 MHf3pIX5qOvDHpYS64JwsnjAEjIUfaHfQu3iP4hb0RmdI/CjgSTvIOgA9ZqyzYuJpG
	 mKXnp5nrCqRlSyhSuizqFnMpWjUFjpKa0RphT9Lp7lMpieFdwM6ZSjXJAhq8ML5Ysd
	 rRGgOPeCaNlClwNj4IG3coMvr6csvR3RVyYUhv12nOfnu5m4Z78ds78nkJYlGvtqZG
	 kdd1PYMseNWww==
Date: Sun, 31 Dec 2023 11:58:11 -0800
Subject: [PATCHSET v29.0 5/8] fstests: detect deceptive filename extensions
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org, guan@eryu.me
Message-ID: <170405026901.1823868.13486465510706218027.stgit@frogsfrogsfrogs>
In-Reply-To: <20231231181215.GA241128@frogsfrogsfrogs>
References: <20231231181215.GA241128@frogsfrogsfrogs>
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
 tests/generic/453 |  111 +++++++++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 99 insertions(+), 12 deletions(-)

