Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03B6826F467
	for <linux-xfs@vger.kernel.org>; Thu, 27 Feb 2025 20:07:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740686843; cv=none; b=iWbR6O4VDguowyHnHdmjPw9tO0F/mJ3i5oxuVqU8pLbHil1tuGcUukWsmOUjmDeGYJfVXalNQ0lLTVBRAQz/kDhxAw3ESMOVPAoXaAEin/dYtgaknLwIIDKPwgSAt0Jwiqgj91JVZ4o0DDyapBfQZs1d4jIONbRIGgzUdg5tQig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740686843; c=relaxed/simple;
	bh=5oma1htIDbsAFINnldU/IOjPnw9spW5jFW4XwikjLdQ=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=FKs6yg6Vak9onmXRkf9WR61UAcYyIVinf7TsvcOY45Hd3feGWiHHSNvrFFtbaROq5UcOPmj1SgGs1rM0/5oDyhi9XWHImBKrBIuwTohA9jgqHDsYPbZFLIYhwS4g+tSSYjZKB2ahbfcL1IyAi4BW30Oa1dsJCM/uvXGm6aM2D+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=GJe/000S; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GJe/000S"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1740686839;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=8kHOipVZAv9wwl70OuPgEw4DnUGToi9PzXoAMy6Tv2U=;
	b=GJe/000SoYccerdv8BmTHU1/C9pjPGFBgFPPpGhGJTfvw4xptHr7mp4j1RwEUdueUIfT2j
	wcCYs8c+53I0gJ1/zMGdxGA0ChQrzrD6FhAMurkZYcCG1EVaOLXNDhm2fWKhHgBSUzyTrv
	8IO+PqCymAOsNWT/GHoLY9ybH6bqmjo=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-590-R2zS_bM5PF-fRvRYeUyeXQ-1; Thu, 27 Feb 2025 15:07:18 -0500
X-MC-Unique: R2zS_bM5PF-fRvRYeUyeXQ-1
X-Mimecast-MFC-AGG-ID: R2zS_bM5PF-fRvRYeUyeXQ_1740686837
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-ab68fbe53a4so191624866b.2
        for <linux-xfs@vger.kernel.org>; Thu, 27 Feb 2025 12:07:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740686836; x=1741291636;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8kHOipVZAv9wwl70OuPgEw4DnUGToi9PzXoAMy6Tv2U=;
        b=F0soP0ZIQ1K3/ncR6LtGvGA5B57P8I3Yd/LMHhEMLKWnQI/j7eApwify1Vn38x8HbP
         DdgxQHRDRDZP80h07zKLUyM5JHGqSmwSieu0wor49VWw/5KDPV5T29Fxhq9uSHUP5+NW
         zs1/ju0bx6EaSw0n4Ie2gV8q5THgEXOWrVbp8Si7apTpThi8MTaF9tNZwSJE+5u+ERmB
         lLmD0VS0/m9V/jYI+V3LbGL1ldOqJkOKanXV04mGgfMUgS8G//UaZXy7QQbT5HWq2Jhq
         ow4bok5jIo6LnkrUT9PJLOmAHs3wclKi/xdhOMp+RmELHzj46751yPBCvGYM1Mit7Nhf
         d7dA==
X-Gm-Message-State: AOJu0Yy9HWcguDSLCZl0SDn+j97kIYUuq2djB73Gy+id6aQr9FPv2g2o
	MaWumopozMs6t2MRpLk5Hryv0WgeCZUxyJu6J4o8UvYJnscYuxANk+HufMG4iiWiflfBJ2IuYY2
	zeDHeS3BsEDgA6SMvagN/+l86ZcB439PzZeXpt5KqojR/kZHHnlXhfCOQzLAZrvM/eP3QAaLoGz
	XSn+4ODKW0+eYDOvy9X5/XWGnp04w1yCvSbWKq50iD
X-Gm-Gg: ASbGnctVglo4VARIBwHDXoOH/glaI0LsjJhJ2Rn4FdkoHvY7dDovsz6Dg9t2PxQMf2N
	pnE2Rr8Z/zG+A+f0NetQw5OxS6N5LCZINzhpREiS8Fjb/AmoIcwZRGlQow/VSc3ITZ18ALBAgIn
	cofxrO5b61GHbJQlUVcdWyqoOIScRo8ORCcikwTTfGYjMM159xo+pCO5PIFv42nY8Yp44/ZOS2X
	1/Rq9GZ1xlycv10xHqLWbN/9msG2S6DxzfaKrVmS7pQ74aNkCLpqV3S4c635CElXMWCBQKrYVJb
	S3u1kq8wBxSjCofIRbebz1n1rLQai4c2n/E=
X-Received: by 2002:a17:907:6e8a:b0:ab6:c4e0:2d18 with SMTP id a640c23a62f3a-abf25fdbdbemr77482566b.16.1740686836008;
        Thu, 27 Feb 2025 12:07:16 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEVzxO8eOgLti1MM5ljnuQS99XJBJVJe3IA09PxDWzlBZcWncLb8aNRHBCn5Hfh7SQVWCBG+g==
X-Received: by 2002:a17:907:6e8a:b0:ab6:c4e0:2d18 with SMTP id a640c23a62f3a-abf25fdbdbemr77476166b.16.1740686835555;
        Thu, 27 Feb 2025 12:07:15 -0800 (PST)
Received: from thinky (ip-217-030-074-039.aim-net.cz. [217.30.74.39])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-abf0c7c18a3sm170390466b.185.2025.02.27.12.07.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Feb 2025 12:07:15 -0800 (PST)
Date: Thu, 27 Feb 2025 21:07:14 +0100
From: Andrey Albershteyn <aalbersh@redhat.com>
To: linux-xfs <linux-xfs@vger.kernel.org>
Cc: aalbersh@kernel.org, ailiop@suse.com, alexjlzheng@tencent.com, 
	cem@kernel.org, chandanbabu@kernel.org, cmaiolino@redhat.com, 
	david@fromorbit.com, dchinner@redhat.com, djwong@kernel.org, hch@lst.de, hi@alyssa.is, 
	linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, mtodorovac69@gmail.com, 
	preichl@redhat.com
Subject: [ANNOUNCE] xfsprogs: for-next updated to a5466cee9874
Message-ID: <4t75gzqgk6y6mq3wwh2q56ti5q25khrydqu5b5o74oalascoxi@ev2ymy2pvslg>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello.

The xfsprogs for-next branch, located at:

https://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git/refs/?h=for-next

Has just been updated.

Patches often get missed, so if your outstanding patches are properly reviewed on
the list and not included in this update, please let me know.

The new head of the for-next branch is commit:

a5466cee9874412cfdd187f07c5276e1d4ef0fea

135 new commits:

Alyssa Ross (1):
      [0b3e7284c7fa] configure: additionally get icu-uc from pkg-config

Andrey Albershteyn (1):
      [8682be1ab7fd] libxfs-apply: fix stgit detection

Anthony Iliopoulos (1):
      [6c01ed5d6d3a] xfs_io: don't fail FS_IOC_FSGETXATTR on filesystems that lack support

Christoph Hellwig (4):
      [c1963d498ad2] libxfs: mark xmbuf_{un,}map_page static
      [e4d11913a16e] xfs: mark xfs_dir_isempty static
      [03beed742d24] xfs: remove XFS_ILOG_NONCORE
      [55a3eca07e4f] xfs: constify feature checks

Darrick J. Wong (125):
      [d776ab01f54a] mkfs,xfs_repair: don't pass a daddr as the flags argument
      [83586af40e70] xfs_db: obfuscate rt superblock label when metadumping
      [6b6239689e36] libxfs: unmap xmbuf pages to avoid disaster
      [087994aa7b55] man: document new XFS_BULK_IREQ_METADIR flag to bulkstat
      [13af03943627] libfrog: wrap handle construction code
      [cb3647bb33a3] xfs_scrub: don't report data loss in unlinked inodes twice
      [279b0d0e8d73] xfs_scrub: call bulkstat directly if we're only scanning user files
      [ae49784289f7] xfs_scrub: remove flags argument from scrub_scan_all_inodes
      [b95546f18e6b] xfs_scrub: selectively re-run bulkstat after re-running inumbers
      [c053cf87f950] xfs_scrub: actually iterate all the bulkstat records
      [174298876add] xfs_scrub: don't double-scan inodes during phase 3
      [8bc15fa18617] xfs_scrub: don't (re)set the bulkstat request icount incorrectly
      [3653b83e9076] xfs_scrub: don't complain if bulkstat fails
      [1dbcb28da38a] xfs_scrub: return early from bulkstat_for_inumbers if no bulkstat data
      [2451a9973c4e] xfs_scrub: don't blow away new inodes in bulkstat_single_step
      [b0289f631ca9] xfs_scrub: hoist the phase3 bulkstat single stepping code
      [20dbdd616162] xfs_scrub: ignore freed inodes when single-stepping during phase 3
      [7ae92e1cb0ae] xfs_scrub: try harder to fill the bulkstat array with bulkstat()
      [8887c70c3eea] xfs: tidy up xfs_iroot_realloc
      [5b8ba0530d84] xfs: refactor the inode fork memory allocation functions
      [ac52a577dda2] xfs: make xfs_iroot_realloc take the new numrecs instead of deltas
      [5d7c26f31d8c] xfs: make xfs_iroot_realloc a bmap btree function
      [40b2ce349bae] xfs: tidy up xfs_bmap_broot_realloc a bit
      [ee20e6554537] xfs: hoist the node iroot update code out of xfs_btree_new_iroot
      [afab9ff346f8] xfs: hoist the node iroot update code out of xfs_btree_kill_iroot
      [41f06edee32b] xfs: add some rtgroup inode helpers
      [06778e784abc] xfs: prepare to reuse the dquot pointer space in struct xfs_inode
      [cf20a9c61852] xfs: simplify the xfs_rmap_{alloc,free}_extent calling conventions
      [ab1b3de74ded] xfs: support storing records in the inode core root
      [2711590ccdf1] xfs: allow inode-based btrees to reserve space in the data device
      [17b2871269b0] xfs: introduce realtime rmap btree ondisk definitions
      [b866a98211e9] xfs: realtime rmap btree transaction reservations
      [5dd143e1210d] xfs: add realtime rmap btree operations
      [edbc7b476c88] xfs: prepare rmap functions to deal with rtrmapbt
      [bb8f58e8524a] xfs: add a realtime flag to the rmap update log redo items
      [206412b8eb10] xfs: pretty print metadata file types in error messages
      [64c60f5242f3] xfs: support file data forks containing metadata btrees
      [5a9a1f896f29] xfs: add realtime reverse map inode to metadata directory
      [e7f5630c994f] xfs: add metadata reservations for realtime rmap btrees
      [b8d1b5cab552] xfs: wire up a new metafile type for the realtime rmap
      [5cc11f5995c8] xfs: wire up rmap map and unmap to the realtime rmapbt
      [872ccd1b2c7b] xfs: create routine to allocate and initialize a realtime rmap btree inode
      [be68986abf70] xfs: report realtime rmap btree corruption errors to the health system
      [48f6f14b0721] xfs: scrub the realtime rmapbt
      [5fa81501522a] xfs: scrub the metadir path of rt rmap btree files
      [cbffd34fe943] xfs: online repair of realtime bitmaps for a realtime group
      [aa55ff9f9e63] xfs: online repair of the realtime rmap btree
      [57f34d777438] xfs: create a shadow rmap btree during realtime rmap repair
      [803f79897071] xfs: namespace the maximum length/refcount symbols
      [4b7bd0810c92] xfs: introduce realtime refcount btree ondisk definitions
      [4e596f98de07] xfs: realtime refcount btree transaction reservations
      [db387f6765db] xfs: add realtime refcount btree operations
      [842d5d6da677] xfs: prepare refcount functions to deal with rtrefcountbt
      [82d0c7cb934b] xfs: add a realtime flag to the refcount update log redo items
      [0f2ef731a9f5] xfs: add realtime refcount btree inode to metadata directory
      [c6b093eafff1] xfs: add metadata reservations for realtime refcount btree
      [b81e004c3de6] xfs: wire up a new metafile type for the realtime refcount
      [cbf370eb8232] xfs: wire up realtime refcount btree cursors
      [5e6146c24344] xfs: create routine to allocate and initialize a realtime refcount btree inode
      [3209f6f1d3f8] xfs: update rmap to allow cow staging extents in the rt rmap
      [aa133a817a79] xfs: compute rtrmap btree max levels when reflink enabled
      [2b61459df1f9] xfs: allow inodes to have the realtime and reflink flags
      [456e2832b48d] xfs: recover CoW leftovers in the realtime volume
      [d243e767dfa8] xfs: fix xfs_get_extsz_hint behavior with realtime alwayscow files
      [1bc6b533a80c] xfs: apply rt extent alignment constraints to CoW extsize hint
      [3ae3aadc4fc3] xfs: enable extent size hints for CoW operations
      [12e3ae7365e0] xfs: report realtime refcount btree corruption errors to the health system
      [b71fbe4c3da2] xfs: scrub the realtime refcount btree
      [56ca835f32b6] xfs: scrub the metadir path of rt refcount btree files
      [c522cfc4cd54] libxfs: compute the rt rmap btree maxlevels during initialization
      [0fdde4c69f1e] libxfs: add a realtime flag to the rmap update log redo items
      [3dea53566fda] libfrog: enable scrubbing of the realtime rmap
      [f60bc2f896c5] man: document userspace API changes due to rt rmap
      [4b8d71bef9ee] xfs_db: compute average btree height
      [37ebf93592e9] xfs_db: don't abort when bmapping on a non-extents/bmbt fork
      [fede3030942c] xfs_db: display the realtime rmap btree contents
      [833c901faa2c] xfs_db: support the realtime rmapbt
      [16415de26623] xfs_db: copy the realtime rmap btree
      [3bea15682f5f] xfs_db: make fsmap query the realtime reverse mapping tree
      [66ae8591b1cd] xfs_db: add an rgresv command
      [f5286ce39ae9] xfs_spaceman: report health status of the realtime rmap btree
      [a0181ca83392] xfs_repair: tidy up rmap_diffkeys
      [7149219ff5a6] xfs_repair: flag suspect long-format btree blocks
      [b97c69658efd] xfs_repair: use realtime rmap btree data to check block types
      [a4e46736da79] xfs_repair: create a new set of incore rmap information for rt groups
      [f3804b11c6b1] xfs_repair: refactor realtime inode check
      [4e39e32763dd] xfs_repair: find and mark the rtrmapbt inodes
      [3cf4b2e166bd] xfs_repair: check existing realtime rmapbt entries against observed rmaps
      [400985de9be0] xfs_repair: always check realtime file mappings against incore info
      [d8ad5e2dfcea] xfs_repair: rebuild the realtime rmap btree
      [e3429101cdbd] xfs_repair: check for global free space concerns with default btree slack levels
      [7a90561b1d04] xfs_repair: rebuild the bmap btree for realtime files
      [40c35393ebd0] xfs_repair: reserve per-AG space while rebuilding rt metadata
      [032ed61ee62c] xfs_logprint: report realtime RUIs
      [d3fc26fa2ac9] mkfs: create the realtime rmap inode
      [310df80d8202] libxfs: compute the rt refcount btree maxlevels during initialization
      [e28f633706df] libxfs: add a realtime flag to the refcount update log redo items
      [2e776b319786] libxfs: apply rt extent alignment constraints to CoW extsize hint
      [fde25d898834] libfrog: enable scrubbing of the realtime refcount data
      [aacdd9ad9d01] man: document userspace API changes due to rt reflink
      [97897d6823f0] xfs_db: display the realtime refcount btree contents
      [31076935f0b7] xfs_db: support the realtime refcountbt
      [4f341db6bc29] xfs_db: copy the realtime refcount btree
      [e971e843428f] xfs_db: add rtrefcount reservations to the rgresv command
      [52c4a72a67f2] xfs_spaceman: report health of the realtime refcount btree
      [bf58660c1083] xfs_repair: allow CoW staging extents in the realtime rmap records
      [a9b8f0134594] xfs_repair: use realtime refcount btree data to check block types
      [bc4e26cb42b6] xfs_repair: find and mark the rtrefcountbt inode
      [7669fbdf42f7] xfs_repair: compute refcount data for the realtime groups
      [bd212fd416c4] xfs_repair: check existing realtime refcountbt entries against observed refcounts
      [ae6a810b8ccc] xfs_repair: reject unwritten shared extents
      [293b7cad2673] xfs_repair: rebuild the realtime refcount btree
      [593709052fb5] xfs_repair: allow realtime files to have the reflink flag set
      [256d9dd3d44c] xfs_repair: validate CoW extent size hint on rtinherit directories
      [90941e554f49] xfs_logprint: report realtime CUIs
      [c811cfb491a4] mkfs: validate CoW extent size hint when rtinherit is set
      [17408f8871e1] mkfs: enable reflink on the realtime device
      [c68e2766c614] xfs_db: pass const pointers when we're not modifying them
      [02e1a64925da] xfs_db: use an empty transaction to try to prevent livelocks in path_navigate
      [6cccd3dcd5a6] xfs_db: make listdir more generally useful
      [8c4e704f370e] xfs_db: add command to copy directory trees out of filesystems
      [a55329da927a] xfs_scrub: fix buffer overflow in string_escape
      [87c2a10e77d7] xfs_scrub: don't warn about zero width joiner control characters
      [195777d3d64f] xfs_scrub: use the display mountpoint for reporting file corruptions
      [e10c19979396] libxfs-apply: allow stgit users to force-apply a patch

Jinliang Zheng (1):
      [c89b1f70b43d] xfs: fix the entry condition of exact EOF block allocation optimization

Mirsad Todorovac (1):
      [dce20b26c5b0] xfs/libxfs: replace kmalloc() and memcpy() with kmemdup()

Pavel Reichl (1):
      [a5466cee9874] xfsprogs: Fix mismatched return type of filesize()

Code Diffstat:

 db/Makefile                           |    3 +-
 db/bmap.c                             |   17 +-
 db/bmroot.c                           |  270 +++++++++
 db/bmroot.h                           |    4 +
 db/btblock.c                          |  156 +++++
 db/btblock.h                          |   10 +
 db/btdump.c                           |   71 +++
 db/btheight.c                         |   41 ++
 db/command.c                          |    1 +
 db/command.h                          |    1 +
 db/field.c                            |   26 +
 db/field.h                            |   11 +
 db/fsmap.c                            |  149 ++++-
 db/info.c                             |  132 +++++
 db/inode.c                            |   44 +-
 db/metadump.c                         |  245 ++++++++
 db/namei.c                            |  115 ++--
 db/namei.h                            |   19 +
 db/rdump.c                            | 1056 +++++++++++++++++++++++++++++++++
 db/type.c                             |   10 +
 db/type.h                             |    2 +
 include/cache.h                       |    6 +
 include/kmem.h                        |    9 +
 include/libxfs.h                      |    3 +
 include/xfs_inode.h                   |    5 +-
 include/xfs_mount.h                   |   27 +-
 include/xfs_trace.h                   |    7 +
 io/inject.c                           |    1 +
 io/parent.c                           |    9 +-
 io/stat.c                             |    6 +-
 libfrog/Makefile                      |    1 +
 libfrog/bitmask.h                     |    6 +
 libfrog/handle_priv.h                 |   55 ++
 libfrog/scrub.c                       |   20 +
 libxfs/Makefile                       |    4 +
 libxfs/buf_mem.c                      |  159 ++++-
 libxfs/buf_mem.h                      |    3 -
 libxfs/cache.c                        |   11 +
 libxfs/defer_item.c                   |   69 ++-
 libxfs/init.c                         |   25 +-
 libxfs/libxfs_api_defs.h              |   40 ++
 libxfs/libxfs_priv.h                  |   11 +
 libxfs/logitem.c                      |   14 +
 libxfs/xfs_ag_resv.c                  |    3 +
 libxfs/xfs_attr.c                     |    4 +-
 libxfs/xfs_bmap.c                     |   47 +-
 libxfs/xfs_bmap_btree.c               |  111 ++++
 libxfs/xfs_bmap_btree.h               |    3 +
 libxfs/xfs_btree.c                    |  410 ++++++++++---
 libxfs/xfs_btree.h                    |   28 +-
 libxfs/xfs_btree_mem.c                |    1 +
 libxfs/xfs_btree_staging.c            |   10 +-
 libxfs/xfs_defer.h                    |    2 +
 libxfs/xfs_dir2.c                     |    9 +-
 libxfs/xfs_dir2.h                     |    1 -
 libxfs/xfs_errortag.h                 |    4 +-
 libxfs/xfs_exchmaps.c                 |    4 +-
 libxfs/xfs_format.h                   |   51 +-
 libxfs/xfs_fs.h                       |   10 +-
 libxfs/xfs_health.h                   |    6 +-
 libxfs/xfs_inode_buf.c                |   65 +-
 libxfs/xfs_inode_fork.c               |  201 +++----
 libxfs/xfs_inode_fork.h               |    6 +-
 libxfs/xfs_log_format.h               |   16 +-
 libxfs/xfs_metadir.c                  |    3 +
 libxfs/xfs_metafile.c                 |  221 +++++++
 libxfs/xfs_metafile.h                 |   13 +
 libxfs/xfs_ondisk.h                   |    4 +
 libxfs/xfs_refcount.c                 |  277 +++++++--
 libxfs/xfs_refcount.h                 |   23 +-
 libxfs/xfs_rmap.c                     |  178 ++++--
 libxfs/xfs_rmap.h                     |   12 +-
 libxfs/xfs_rtbitmap.c                 |    2 +-
 libxfs/xfs_rtbitmap.h                 |    9 +
 libxfs/xfs_rtgroup.c                  |   74 ++-
 libxfs/xfs_rtgroup.h                  |   58 +-
 libxfs/xfs_rtrefcount_btree.c         |  755 +++++++++++++++++++++++
 libxfs/xfs_rtrefcount_btree.h         |  189 ++++++
 libxfs/xfs_rtrmap_btree.c             | 1034 ++++++++++++++++++++++++++++++++
 libxfs/xfs_rtrmap_btree.h             |  210 +++++++
 libxfs/xfs_sb.c                       |   14 +
 libxfs/xfs_shared.h                   |   21 +
 libxfs/xfs_trans_resv.c               |   37 +-
 libxfs/xfs_trans_space.h              |   13 +
 libxfs/xfs_types.h                    |    7 +
 logprint/log_misc.c                   |    4 +
 logprint/log_print_all.c              |   16 +
 logprint/log_redo.c                   |   48 +-
 m4/package_icu.m4                     |    2 +-
 man/man2/ioctl_xfs_bulkstat.2         |    8 +
 man/man2/ioctl_xfs_rtgroup_geometry.2 |    3 +
 man/man2/ioctl_xfs_scrub_metadata.2   |   16 +-
 man/man8/xfs_db.8                     |  147 ++++-
 mkfs/proto.c                          |   33 +-
 mkfs/xfs_mkfs.c                       |  171 +++++-
 repair/Makefile                       |    2 +
 repair/agbtree.c                      |    9 +-
 repair/bmap_repair.c                  |  109 +++-
 repair/bulkload.c                     |   41 ++
 repair/bulkload.h                     |    2 +
 repair/dino_chunks.c                  |   24 +
 repair/dinode.c                       |  728 ++++++++++++++++++++---
 repair/dir2.c                         |   12 +
 repair/globals.c                      |    6 +
 repair/globals.h                      |    2 +
 repair/incore.h                       |    2 +
 repair/phase4.c                       |   48 +-
 repair/phase5.c                       |  116 +++-
 repair/phase6.c                       |   84 +++
 repair/rmap.c                         |  634 +++++++++++++++-----
 repair/rmap.h                         |   30 +-
 repair/rt.c                           |    2 +-
 repair/rt.h                           |    8 +
 repair/rtrefcount_repair.c            |  257 ++++++++
 repair/rtrmap_repair.c                |  265 +++++++++
 repair/scan.c                         |  740 ++++++++++++++++++++++-
 repair/scan.h                         |   70 +++
 repair/xfs_repair.c                   |    8 +-
 scrub/common.c                        |   61 +-
 scrub/inodes.c                        |  552 ++++++++++++++---
 scrub/inodes.h                        |   12 +-
 scrub/phase3.c                        |    7 +-
 scrub/phase5.c                        |   14 +-
 scrub/phase6.c                        |   18 +-
 scrub/repair.c                        |    2 +
 scrub/unicrash.c                      |   10 +-
 spaceman/health.c                     |   29 +-
 tools/libxfs-apply                    |   66 ++-
 128 files changed, 10524 insertions(+), 914 deletions(-)
 create mode 100644 db/namei.h
 create mode 100644 db/rdump.c
 create mode 100644 libfrog/handle_priv.h
 create mode 100644 libxfs/xfs_rtrefcount_btree.c
 create mode 100644 libxfs/xfs_rtrefcount_btree.h
 create mode 100644 libxfs/xfs_rtrmap_btree.c
 create mode 100644 libxfs/xfs_rtrmap_btree.h
 create mode 100644 repair/rtrefcount_repair.c
 create mode 100644 repair/rtrmap_repair.c

-- 
- Andrey

