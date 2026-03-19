Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29CB835B63A
	for <linux-xfs@vger.kernel.org>; Thu, 19 Mar 2026 04:38:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773895125; cv=none; b=kWCV5K2zbVS8ek4RCUIvoTImYznPSKmX9kt5GWDjs6uZNMY25sw+lDtY0/HhuVAm8ziWjhOdHedz56WAJMGgSyePmAzhJt+iEHldiAc4xR9v6FuZ0fLW6HLJbcFMRkFGHOr5Qu0vpmwS4BsEWQFZf//a2rQx2EnyoHWcBnJDibA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773895125; c=relaxed/simple;
	bh=OySbScNID4OWU1AOf1tHH+MSlgytYRmlqJt44U6QFK8=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eAwT5JHiDjXrIwhdWO862OskkXgvC3YwymBFuah7kACb6nXEXCm8sGvTlgwpxxpWAmbT+wHrRT84cFTQMrjBmkJzECrhU5X6o6Kz57PqpzjygzrX/GuyYAhpaZi3rst1uxlVYNKGGFGS+4KJPHZKTUdBWUOJacJ0SoQf86iMBLM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LeEGAiij; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LeEGAiij"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDFB3C19425;
	Thu, 19 Mar 2026 04:38:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773895125;
	bh=OySbScNID4OWU1AOf1tHH+MSlgytYRmlqJt44U6QFK8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=LeEGAiijVfdyMrZ4a2b/6dzKt6JXqZuvl2OQvjCodQdqNBsscAS7qj+0Mz43AHRya
	 kir7juiRdIHVCeywAzxyOTA4Pxs5F3WgqVUrIzxI488FMQtnyCPrt0McyY2WXBF5KL
	 NE0FHFkBfaqkj0D2u1aJethIIxTQZ8r5qEEDDcGKDRPF/+zT4MAXX/G+88Hl04uPP5
	 XLgngep1KpZLXIM+9DsXeoUDn/rEfnhKOksSPMLGDRfwlWA9HIst9CQaQJH2dI+hIl
	 t4s6RUx1JVBesPI9TOUePBRbjJqMgUStiugdctAaVss7wUqRpX09Hu3yVLpeR5EPI3
	 0O/d+XGIQL8UA==
Date: Wed, 18 Mar 2026 21:38:44 -0700
Subject: [PATCHSET v10 2/2] xfs_scrub: refactor to XFS_IOC_VERIFY_MEDIA
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <177389506832.3681140.14985419190965827651.stgit@frogsfrogsfrogs>
In-Reply-To: <20260319043707.GO1770774@frogsfrogsfrogs>
References: <20260319043707.GO1770774@frogsfrogsfrogs>
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
 * xfs_scrub: allow overrides of the media verification IO limits
---
 libfrog/convert.h         |    7 +
 scrub/disk.h              |    2 
 scrub/read_verify.h       |   34 ++-
 scrub/spacemap.h          |    5 
 scrub/xfs_scrub.h         |    9 -
 db/bmap_inflate.c         |    2 
 doc/README-env-vars.txt   |    4 
 libfrog/bitmap.c          |    3 
 libfrog/convert.c         |    7 -
 mdrestore/xfs_mdrestore.c |    5 
 mkfs/xfs_mkfs.c           |   38 ++--
 repair/agbtree.c          |    3 
 repair/bmap_repair.c      |    3 
 repair/rmap.c             |    3 
 repair/xfs_repair.c       |    5 
 scrub/common.c            |   19 +-
 scrub/disk.c              |  204 -------------------
 scrub/phase1.c            |   91 ++++++--
 scrub/phase5.c            |    6 -
 scrub/phase6.c            |  417 +++++++++++++++++++--------------------
 scrub/phase8.c            |    3 
 scrub/read_verify.c       |  485 +++++++++++++++++++++++++++++++++------------
 scrub/xfs_scrub.c         |    4 
 23 files changed, 722 insertions(+), 637 deletions(-)

