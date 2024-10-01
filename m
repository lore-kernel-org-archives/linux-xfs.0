Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAE9427448;
	Tue,  1 Oct 2024 16:48:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727801325; cv=none; b=bLT/nuaCsdKkG3Nz3IU9N7V+gqsxO8qj0IBd8bys4cqe+ObNQrCB/68pye9bERV7r+M0Ues2NqouP+9kMboIEUNGrk1c7oio8pSybrcqpECgsKb7KT/yi3bt2pCzL+XqvbCwEBqQyoTjFwd+VmAc293qSfC+wyBvTV0MDEBPn10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727801325; c=relaxed/simple;
	bh=68i61jNK5nuvBLmyGNIWOOAI22NxbKXQ0b/SHlECwHk=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:Content-Type; b=CWVo0uF+T9PYDY00K94tS8XcTpIkuzTLUjktOdoBaxaKnrq/cYkQmEuR01WWEXtfYp1rQ28BaBydlnaMDoYApD7qJSVij9BltjtSL4Cfr9MHvtRwshTPMeWkdwg37rQqEElU+PJ4Q2sEDqH7zfCWejJwv156X9sH+rSN+tdogbw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hDG6F2OO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hDG6F2OO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C5AAC4CEC6;
	Tue,  1 Oct 2024 16:48:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727801325;
	bh=68i61jNK5nuvBLmyGNIWOOAI22NxbKXQ0b/SHlECwHk=;
	h=Date:Subject:From:To:Cc:From;
	b=hDG6F2OOYkF2DKp+b5EOpRDXKC2nOE5vp6YLkttJ6Fq/Ohj5CE7mkXNNkHwMWLjvy
	 WHO1RrsWBkU7Vcw6GBDrKwyLqdd1hd1eopLAjO59hD/P+hpZGpdq+NGYZ+ywzVdmdY
	 x3IhMKK9K2SqE4KxFx+gEtXlrL+0zO6DclYZLOxMt/Fh2iwqdSedgsPBL+K5Xs/hWs
	 GZJU8FWwrhdFFI3dinaeiNH8SKKsNI09YimZ/BJn3uAkPcTLWxuwAIYXLtFIlV8XGm
	 h7rdzk+v2D4UJu1g2KBg42szlP1B7SaRixp1oXEyYluMUAsgwOJbv1IIqdFadfX7IU
	 XNbLJCMN8S+kg==
Date: Tue, 01 Oct 2024 09:48:44 -0700
Subject: [PATCHSET 1/2] fstests: random fixes for v2024.09.29
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: allison.henderson@oracle.com, fstests@vger.kernel.org,
 linux-xfs@vger.kernel.org
Message-ID: <172780125677.3586386.15055943889531479456.stgit@frogsfrogsfrogs>
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

Here's the usual odd fixes for fstests.  Most of these are cleanups and
bug fixes that have been aging in my djwong-wtf branch forever.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

With a bit of luck, this should all go splendidly.
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=random-fixes

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=random-fixes

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=random-fixes
---
Commits in this patchset:
 * common/populate: fix bash syntax error in _fill_fs
---
 common/populate |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

