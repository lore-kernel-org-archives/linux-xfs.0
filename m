Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15F09318139
	for <linux-xfs@vger.kernel.org>; Fri, 10 Apr 2026 06:10:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775801447; cv=none; b=CxXAoT+taCuOEd7bNbZdJQZiUbhZTEsdV8aafiBmVGjmVYL5iEHt1hV+xX1C++RJA/lXOetzvg0zB0onEIvfQO9APVmWHdEV/ZIp8sg5lF3cRo9Z4H/Ge2wSIQBMW2Ov/ORF81oHw7amvWHGxhVt5w0RnXBVw+QEUC+NO0c5kXc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775801447; c=relaxed/simple;
	bh=E8gGMqMIYZ2j+cmKq/ZkiSTcjjyfkrw3v+4PRm+/mjQ=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:Content-Type; b=MxmU2BPazV9YJpMn6ztxxhstbqSkulJMcJC0CNJLLIbC8kMT5XY53BC5GUqa7yKcalwevS2mMaf9T9xFfwhKIZLxlbZzaRsnlXVSR/PlWQ8RdvO7zU0ccHnrg/SkM/y0ejabmVxoMRsrHCgUEU8mM9puh9E/HPNk1VL+qKueeno=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tzbiQ0Ou; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tzbiQ0Ou"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B805C19421;
	Fri, 10 Apr 2026 06:10:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775801446;
	bh=E8gGMqMIYZ2j+cmKq/ZkiSTcjjyfkrw3v+4PRm+/mjQ=;
	h=Date:Subject:From:To:Cc:From;
	b=tzbiQ0OucSg1t77cCJ0xJaK6rhG9lnJ7EDJzwFRqQ945p6gRkEKsf6YHO8EG64JrT
	 KOvyFvf/oNRkzb9gGVLCmRGnakn8fHR6nqcuMYR2fYpwFIaPpUp9AWj9hiI/R61LWQ
	 56dOmVBRHVIcL+l4FxilxrLX6YpTzRqLLZKstQmRcKjH6/vyDkqusfjkv0hKL7ViHh
	 aBH/RLLHiI3U5U1v6dwev9dw3eybEB5rZQW9hBL8xeEeB7Dx1a5KIXW4yCMgJ6hk+j
	 1X3tJeG+C49u+zhCZy+V0y+uavq1MYBW/nn6XXRPmQbyPTNZC2wDttKAn43GO0Zd96
	 zGKxNt8EtIevg==
Date: Thu, 09 Apr 2026 23:10:46 -0700
Subject: [PATCHSET v11 2/2] xfs_scrub: refactor to XFS_IOC_VERIFY_MEDIA
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <177577384929.2090237.10369276062302001541.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi all,

Originally, this was a single patch inside the autonomous self healing
patchset.  However, various issues brought up during review of the v9
codebase made it obvious that more cleanups were necessary prior to
shifting xfs_scrub to use the new media verification ioctl.  Therefore,
the xfs_scrub changes have been broken out into a separate patchset to
contain the refactorings and new functionality.

v11: various minor bug fixes detected by static checkers
v10: decouple the spacemap iterator and the read-verify pool code,
     simplify the read-verify apis, use a fixed limit of 8 verify IO
     threads per device, improve the log media error reporting

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

With a bit of luck, this should all go splendidly.
Comments and questions are, as always, welcome.

--D

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=scrub-media-verify-ioctl
---
Commits in this patchset:
 * libfrog: allow bitmap_free to handle a null bitmap pointer
 * mkfs: rename byte unit conversion macros
 * libfrog: lift *BYTES helpers to convert.h
 * xfs_scrub: report truncated devices as media errors
 * xfs_scrub: fix i18n of the decode_special_owner return value
 * scrub: remove the unused io_disk field in struct read_verify
 * xfs_scrub: move read verification scheduling to phase6.c
 * scrub: simplify the read_verify_pool_alloc interface
 * xfs_scrub: don't pass the io_end_arg around everywhere
 * scrub: use enum xfs_device for read verification
 * xfs_scrub: rename nr_io_threads
 * scrub: simplify verifier threads calculation
 * xfs_scrub: move disk media verification error injection
 * xfs_scrub: use the verify media ioctl during phase 6 if possible
 * scrub: don't allocate disk for ioctl-based media verify
 * xfs_scrub: perform media scanning of the log region
 * xfs_scrub: index read-verify pools by xfs_device ids
 * xfs_scrub: move failmap and other outputs into read_verify_pool
 * xfs_scrub: clean up device-related error messages
 * xfs_scrub: drop SCSI_VERIFY code from disk.
 * xfs_scrub: raise media verification IO limits
---
 libfrog/convert.h         |    7 +
 scrub/disk.h              |    2 
 scrub/fscounters.h        |    2 
 scrub/read_verify.h       |   34 ++-
 scrub/spacemap.h          |    5 
 scrub/xfs_scrub.h         |    9 -
 db/bmap_inflate.c         |    2 
 doc/README-env-vars.txt   |    1 
 libfrog/bitmap.c          |    3 
 libfrog/convert.c         |    7 -
 mdrestore/xfs_mdrestore.c |    5 
 mkfs/xfs_mkfs.c           |   38 ++--
 repair/agbtree.c          |    3 
 repair/bmap_repair.c      |    3 
 repair/rmap.c             |    3 
 repair/xfs_repair.c       |    5 
 scrub/common.c            |   19 +-
 scrub/disk.c              |  204 --------------------
 scrub/fscounters.c        |    4 
 scrub/phase1.c            |   91 +++++++--
 scrub/phase5.c            |    6 -
 scrub/phase6.c            |  424 +++++++++++++++++++++---------------------
 scrub/phase7.c            |    7 +
 scrub/phase8.c            |    3 
 scrub/read_verify.c       |  451 +++++++++++++++++++++++++++++++++------------
 scrub/xfs_scrub.c         |    1 
 26 files changed, 701 insertions(+), 638 deletions(-)

