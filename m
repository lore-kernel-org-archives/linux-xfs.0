Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CB2923C4F3;
	Wed,  9 Sep 2026 06:02:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788933778; cv=none; b=Ptyn05WwW51+Hjm3ZLw+TX9pmEA2E1q+xV3TmNQ1LkcDcms2uFVt8nPObsLVY/z4bFJVSrBN8JS7drLWcHokM6gTVSa2aSkqtOKePXKLbqt6hjGl6nCK9WbF837KziwPn/EtmPGWHFgru2ecs2R5P0GwFO8dVG40wOpBSBg5C8I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788933778; c=relaxed/simple;
	bh=sKRw7KZ8ttvQl+KNBbYCwWysyjdFWCFJ92pGwlp2nvE=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:Content-Type; b=SeXkiwN+8+HFjhSRSuavBDlNZD73CmpBFHWqRxvKeKSsA+29NBykWwhG2OdMvlicj7x0av0PMD/Cscb8Qid8uaOpYt6IwEOVEun8egFqYwF+VawBsM821yOl8wNL7OhwNMkNgMPrmYcE304VZeGYBQr8muMIDlYzYDpG74FRzZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kpKDLfCO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kpKDLfCO"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id D6F781F00A3D;
	Wed,  9 Sep 2026 06:02:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788933776;
	bh=LGdU9JpPO53XoOGb/QS4XJv2hXc40JLhapQB9dQUZKw=;
	h=Date:Subject:From:To:Cc;
	b=kpKDLfCOfUSyyjtJ4Jj4Q7S74y5jHOQZ4WkRLwsctb8RlHhPDEpEDuRfkmxreSQGG
	 qVurMd+3Gh9sJhW+jqvulqIwfFh/9Ik5CkjvGuBn8CSz4oiQYXsxcCJ/+iROj1ZrCv
	 stfu9JA5/m0C6Yy8hxgs0RwTp5xzFeAMFiczRkjQIAhVANTPna1VpeEDalcttlrJhK
	 8MK4oWkLCiaB2j6HIM5BiuF3/7DatW8p8cbaUVrBdKC0RxBex3Itu3ezGGoNKBiy4y
	 CDa9iMgkqFDdqFde/bikichmv8MncVqBKKkYPud0rThqKJUUYDhjdwsfuQu/FBmOdi
	 37ol8OAeDHr1w==
Date: Tue, 08 Sep 2026 23:02:56 -0700
Subject: [PATCHSET 2/2] xfs: LLM-inspired bug fixes, part 12
From: "Darrick J. Wong" <djwong@kernel.org>
To: hch@lst.de, cem@kernel.org, djwong@kernel.org
Cc: floss@jetm.me, dgc@kernel.org, stable@vger.kernel.org,
 linux-xfs@vger.kernel.org
Message-ID: <178892936573.4057962.16225191041041958394.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi all,

Here's a twelveth batch of xfs fixes resulting from a LLaMma.  Mwa mwa
mwa...

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

With a bit of luck, this should all go splendidly.
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=llm-fixes-12
---
Commits in this patchset:
 * xfs: fix under-reservation of blocks when repairing sf directories
 * xfs: actually check internal-rtdev fields in the superblock
 * xfs: fix rtrmap cross-referencing elision logic
 * xfs: fix termination logic in xchk_bmap
 * xfs: fix replaying dirent removals into the temporary directory
 * xfs: reset parent pointer args before each dir tree unlink repair
 * xfs: advance the findparent inode scan cursor while holding ILOCK
---
 fs/xfs/scrub/agheader.c       |    7 +++++
 fs/xfs/scrub/attr_repair.c    |    2 +-
 fs/xfs/scrub/bmap.c           |    7 +++--
 fs/xfs/scrub/dir_repair.c     |    4 ++-
 fs/xfs/scrub/dirtree_repair.c |    1 +
 fs/xfs/scrub/findparent.c     |   54 +++++++++++++++++++++++++++--------------
 fs/xfs/scrub/tempfile.c       |   28 ++++++++++++++++-----
 7 files changed, 72 insertions(+), 31 deletions(-)

