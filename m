Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61828215F4E
	for <linux-xfs@vger.kernel.org>; Mon, 17 Feb 2025 09:40:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739785237; cv=none; b=mbQinybd9LmrPx92oE33yfyY0vZtcoGzSfhW2esY4tPOxN5+X9gcvbAPXLQhxxAX5+o1EtOK3WG+t5z/DYwIME/S9LRiQOr9n8+Jb+KMwYg6OyDAF9Qq9PpE45oQVDvBTKG06eVaFBf7r4tBPn9bTnviGeqk/igz4LDlpkkaJ+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739785237; c=relaxed/simple;
	bh=vRPwF1yyTwe8DhcpR09cq8omKP6kEEbP1z5thly9H30=;
	h=From:Date:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=ELQRrNQ/jj/Z6hMFAvy63FP9/nsmB6j7IMU0pNj9KVDON4rOeOrg9Tj/pi4MLzj8d/gkmfssO6Rln09JAIGKh4tLadS5TutYpzhGtzeUJ0JRfYaNy5FSqdyGVKqk12IxOHySLz8eyXrAI3NTgn1yKGZefJLQI5nGRJ7iOxsc9wM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=JlzK6bsV; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JlzK6bsV"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1739785233;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=zSRMnflEHWv0j/6iFiKVTlzWFQQbQcGeL7FNtIEwSs4=;
	b=JlzK6bsVZYOcEQ+tdAhxhHYmxdfGs+Oe/SnCZ8k0egFFWxX2xRZj3IW1+BAv8EPx6KvIeR
	vUCsdW9rWe84dNaO3LGBYQM0ot8iJimPE1xacU+E3zsZeh/0wIarCEdNu+XZthLuWV/tC6
	OlA7W61esn0qJlDEf72u1IeqMM4SMWQ=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-397-E_51KWX5OYiECV5MyUl_9A-1; Mon, 17 Feb 2025 04:40:31 -0500
X-MC-Unique: E_51KWX5OYiECV5MyUl_9A-1
X-Mimecast-MFC-AGG-ID: E_51KWX5OYiECV5MyUl_9A_1739785230
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-43933b8d9b1so21581015e9.3
        for <linux-xfs@vger.kernel.org>; Mon, 17 Feb 2025 01:40:31 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739785230; x=1740390030;
        h=content-disposition:mime-version:message-id:subject:cc:to:date:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zSRMnflEHWv0j/6iFiKVTlzWFQQbQcGeL7FNtIEwSs4=;
        b=aURtQLVziCaLjMD9ActhuyXrPml9pWwJdz5xNyoiphhjIlOmp6VQtwI48iAfCzLg07
         tKMRBWelpjB8CiWCLocb2zkVG/JSNSOKLXyDIvXl2W6hN7/ewKEabQzGaUN8jXQorcDk
         MfwRzUKRXjePdqwNFSabkUy+O/WIFAZi/93eBGLEHgP8DKAqDcIKxVICxWANJzgK1cXg
         iyYDM7CKfN838fH+mtsMEUBgyo54Yn63zyxzVVTWSQjRvyonvJP10CbQ2ca0yPVvrpw1
         0tJ++Dx3YXQ522S39QdaayVSmMEuFfvkPyhVTslB8and38qtJ33MCLP+mHBDHknU8PuA
         O2uA==
X-Gm-Message-State: AOJu0YwnfyXRiCdprNrWMh5FA7N00ywz92RUjjqXw3qm54PER8jiT4ua
	RGhAnRXZ7nZqUZdhfVV9VdfruyflHgIfq53104NjeJSmvVlft5dbrH08+od2ew8ClBc96cG/sLM
	ZWc7hutdOEOtWmiSw1CsyhHOxHuRAWe3VGQ0gRtrB/J2rA3CH7MhZ6I3Pxgux2kgQSxiuk/6Xg7
	OQeUlRxpuMavHoDdoZeUDrzABOdb1FbhMYzs5/+56D
X-Gm-Gg: ASbGncsx3nGzLo26PSCH4hPktsDjcAJrcm2yHp1bSWO5apD2yPHGrSplOVZO6kjaddb
	osrXoEhHj/leip9yxuwEcRtWUme4BH1RGsVrr8wRNL31ztTVOTQavQK1RBX4euIVwfPlncVjZvs
	dVkCPV9lrN/2vCBGu2mSPqF331aZAELceNm2WNBqU7ol3zE7enJN9hzrSDj1haLW6QvE9ejEIFM
	nkZM96qqFhXQ6GXBsXcpieMHZ+WPaUIF6V52xAkBcx9aLZusD9gABL8vx2ivrQe31AnWgmVU0b2
	4QuU+OoOztlHM8UK5wwkINzZ
X-Received: by 2002:a5d:59af:0:b0:385:ee40:2d88 with SMTP id ffacd0b85a97d-38f33f117d1mr6338021f8f.3.1739785229454;
        Mon, 17 Feb 2025 01:40:29 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHARW1/QJ4h8Me0o6d4WYxg/A+N7wss2VVWrrPXPhrHb0CCppsKwTqCEqiuTorFDQxS5akmJQ==
X-Received: by 2002:a5d:59af:0:b0:385:ee40:2d88 with SMTP id ffacd0b85a97d-38f33f117d1mr6337976f8f.3.1739785228868;
        Mon, 17 Feb 2025 01:40:28 -0800 (PST)
Received: from thinky (ip-217-030-074-039.aim-net.cz. [217.30.74.39])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38f258b41b5sm11906367f8f.14.2025.02.17.01.40.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Feb 2025 01:40:28 -0800 (PST)
From: Andrey Albershteyn <aalbersh@redhat.com>
X-Google-Original-From: Andrey Albershteyn <aalbersh@kernel.org>
Date: Mon, 17 Feb 2025 10:40:26 +0100
To: linux-xfs <linux-xfs@vger.kernel.org>
Cc: aalbersh@kernel.org, bfoster@redhat.com, brauner@kernel.org, 
	chizhiling@kylinos.cn, dan.carpenter@linaro.org, david@fromorbit.com, 
	dchinner@redhat.com, djwong@kernel.org, hch@lst.de, jlayton@kernel.org, 
	josef@toxicpanda.com, jpalus@fastmail.com, leo.lilong@huawei.com, 
	ojaswin@linux.ibm.com, rdunlap@infradead.org, tom.samstag@netrise.io, cem@kernel.org
Subject: [ANNOUNCE] xfsprogs v6.13.0 released
Message-ID: <e6xvyro6u2ovl4ubjzpocyp5nfjlu5gd6p7iuvvuqgf642cb7i@av4wyire6bao>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi folks,

The xfsprogs repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git

has just been updated.

Patches often get missed, so if your outstanding patches are properly reviewed
on the list and not included in this update, please let me know.

The for-next branch has also been updated to match the state of master.

The new head of the master branch is commit:

4fd999332e19993fb7fd381f5fcd40ff943d98ac

New commits:

Andrey Albershteyn (1):
      [4fd999332e19] xfsprogs: Release v6.13.0

Chi Zhiling (1):
      [3eb8c349c5cd] xfs_logprint: Fix super block buffer interpretation issue

Christoph Hellwig (40):
      [969625bf3c64] xfs: remove the unused pagb_count field in struct xfs_perag
      [e6205866b11e] xfs: remove the unused pag_active_wq field in struct xfs_perag
      [b3cdbd924f3e] xfs: pass a pag to xfs_difree_inode_chunk
      [bf91bd162fde] xfs: remove the agno argument to xfs_free_ag_extent
      [25e0d55968c7] xfs: add xfs_agbno_to_fsb and xfs_agbno_to_daddr helpers
      [ef7499e4a071] xfs: add a xfs_agino_to_ino helper
      [88e008a183cf] xfs: pass a pag to xfs_extent_busy_{search,reuse}
      [50fe5d5393e0] xfs: pass a perag structure to the xfs_ag_resv_init_error trace point
      [0601845b215f] xfs: pass objects to the xfs_irec_merge_{pre,post} trace points
      [ffae013ef77b] xfs: convert remaining trace points to pass pag structures
      [d74a561fdec4] xfs: split xfs_initialize_perag
      [b61c38ce0381] xfs: insert the pag structures into the xarray later
      [6a271c73058f] xfs: factor out a generic xfs_group structure
      [4a384bc53d5a] xfs: add a xfs_group_next_range helper
      [4f87efa3a68d] xfs: switch perag iteration from the for_each macros to a while based iterator
      [8e80c83ece3b] xfs: move metadata health tracking to the generic group structure
      [b744c034a290] xfs: move draining of deferred operations to the generic group structure
      [21cc7c27882b] xfs: move the online repair rmap hooks to the generic group structure
      [63db770a4cd2] xfs: convert busy extent tracking to the generic group structure
      [1fa5e300cb25] xfs: add a generic group pointer to the btree cursor
      [5214e3c43682] xfs: add group based bno conversion helpers
      [0cf510a91e3f] xfs: store a generic group structure in the intents
      [3c5ff15d106f] xfs_repair: refactor generate_rtinfo
      [7ac3ad4cb4a1] xfs: add a xfs_bmap_free_rtblocks helper
      [55ed4049350e] xfs: move RT bitmap and summary information to the rtgroup
      [884acdc480c9] xfs: support creating per-RTG files in growfs
      [b3d80952d04d] xfs: refactor xfs_rtbitmap_blockcount
      [3241cd2c17ae] xfs: refactor xfs_rtsummary_blockcount
      [49e1064f0169] xfs: make RT extent numbers relative to the rtgroup
      [15fb060e4e9b] xfs: add a helper to prevent bmap merges across rtgroup boundaries
      [9f09e4e0f14b] xfs: make the RT allocator rtgroup aware
      [2d1ca729a96d] xfs: don't call xfs_bmap_same_rtgroup in xfs_bmap_add_extent_hole_delay
      [0b64a342dbfc] man: document rgextents geom field
      [88a387f8f05a] xfs_repair: refactor phase4
      [4933b7fa4d42] xfs_repair: simplify rt_lock handling
      [92ba3b0d5a54] xfs_repair: add a real per-AG bitmap abstraction
      [6ba6f3933ee6] xfs_db: metadump metadir rt bitmap and summary files
      [04c339138706] xfs_scrub: cleanup fsmap keys initialization
      [773c4c6f33cf] xfs: don't return an error from xfs_update_last_rtgroup_size for !XFS_RT
      [c988ff56258a] mkfs: use a default sector size that is also suitable for the rtdev

Darrick J. Wong (165):
      [d49bd00aee5e] xfs_repair: fix maximum file offset comparison
      [98bf9c3b811b] man: document the -n parent mkfs option
      [bbfcbe40e6ea] xfs: constify the xfs_sb predicates
      [ffcb97b2320b] xfs: rename metadata inode predicates
      [65713c2c2ec3] xfs: define the on-disk format for the metadir feature
      [3c2daed21627] xfs: iget for metadata inodes
      [5889f16f1cd8] xfs: enforce metadata inode flag
      [1be54c612170] xfs: read and write metadata inode directory tree
      [da7865a2310a] xfs: disable the agi rotor for metadata inodes
      [9e6f3dd96757] xfs: advertise metadata directory feature
      [428684e8467a] xfs: allow bulkstat to return metadata directories
      [52d695723abd] xfs: adjust xfs_bmap_add_attrfork for metadir
      [261690fea209] xfs: record health problems with the metadata directory
      [bfc916d8ef51] xfs: check metadata directory file path connectivity
      [b99309ee42d6] libxfs: constify the xfs_inode predicates
      [1540262661e6] libxfs: load metadata directory root at mount time
      [e864cf06c21c] libxfs: enforce metadata inode flag
      [c62845d6d32c] man2: document metadata directory flag in fsgeom ioctl
      [81abb915afd4] man: update scrub ioctl documentation for metadir
      [50d69630adb9] libfrog: report metadata directories in the geometry report
      [da3e1d69b0ca] libfrog: allow METADIR in xfrog_bulkstat_single5
      [5e48ae670011] xfs_io: support scrubbing metadata directory paths
      [d9e3a0008ef0] xfs_db: disable xfs_check when metadir is enabled
      [5d14b7288b75] xfs_db: report metadir support for version command
      [b0a7c44df0ca] xfs_db: don't obfuscate metadata directories and attributes
      [ca4b24df1e05] xfs_db: support metadata directories in the path command
      [720eb8752fdd] xfs_db: show the metadata root directory when dumping superblocks
      [e2d3445361ff] xfs_db: display di_metatype
      [19346fffd815] xfs_db: drop the metadata checking code from blockget
      [82c8718724df] xfs_io: support flag for limited bulkstat of the metadata directory
      [aa9cb1bd5f01] xfs_io: support scrubbing metadata directory paths
      [b480672f1fa1] xfs_spaceman: report health of metadir inodes too
      [a6e089903f2f] xfs_scrub: tread zero-length read verify as an IO error
      [cd9d49b326ef] xfs_scrub: scan metadata directories during phase 3
      [de00cd47384b] xfs_scrub: re-run metafile scrubbers during phase 5
      [93f4922c92b8] xfs_repair: handle sb_metadirino correctly when zeroing supers
      [92657514ddfd] xfs_repair: dont check metadata directory dirent inumbers
      [4041da53acc0] xfs_repair: refactor fixing dotdot
      [66a0ebc3c5de] xfs_repair: refactor marking of metadata inodes
      [58e7dc339dc2] xfs_repair: refactor root directory initialization
      [0032c19e192f] xfs_repair: refactor grabbing realtime metadata inodes
      [34a4618b7597] xfs_repair: check metadata inode flag
      [62087e193116] xfs_repair: use libxfs_metafile_iget for quota/rt inodes
      [529a5b4e9cef] xfs_repair: rebuild the metadata directory
      [920e4cc6c91a] xfs_repair: don't let metadata and regular files mix
      [1bd352339960] xfs_repair: update incore metadata state whenever we create new files
      [750afdf6989d] xfs_repair: pass private data pointer to scan_lbtree
      [e3cbc6358ac9] xfs_repair: mark space used by metadata files
      [2797f8a41636] xfs_repair: adjust keep_fsinos to handle metadata directories
      [f1184d8d28c5] xfs_repair: metadata dirs are never plausible root dirs
      [03e7de0cb18e] xfs_repair: drop all the metadata directory files during pass 4
      [278d707272d9] xfs_repair: truncate and unmark orphaned metadata inodes
      [089c1e7d5b69] xfs_repair: do not count metadata directory files when doing quotacheck
      [9d4c07124e57] mkfs.xfs: enable metadata directories
      [b48164b8cd76] libxfs: resync libxfs_alloc_file_space interface with the kernel
      [73fb78e5ee89] mkfs: support copying in large or sparse files
      [51bf422aa4bb] mkfs: support copying in xattrs
      [6aace700b7b8] mkfs: add a utility to generate protofiles
      [001b79f0b7fc] xfs: create incore realtime group structures
      [5a96f6eed331] xfs: define locking primitives for realtime groups
      [abb0172a9a34] xfs: add a lockdep class key for rtgroup inodes
      [15c6dada7cb7] xfs: support caching rtgroup metadata inodes
      [16ddcc41229c] libfrog: add memchr_inv
      [1278e817a799] xfs: define the format of rt groups
      [96867b5dd9f8] xfs: update realtime super every time we update the primary fs super
      [4215af60f6d3] xfs: export realtime group geometry via XFS_FSOP_GEOM
      [74dd0d11a449] xfs: check that rtblock extents do not break rtsupers or rtgroups
      [6fae9d99d9c8] xfs: add frextents to the lazysbcounters when rtgroups enabled
      [2342f2c03c97] xfs: record rt group metadata errors in the health system
      [b69571adb79e] xfs: export the geometry of realtime groups to userspace
      [06fb4ab27d62] xfs: add block headers to realtime bitmap and summary blocks
      [5d1ceb55d570] xfs: encode the rtbitmap in big endian format
      [af4bcc58f7ea] xfs: encode the rtsummary in big endian format
      [c643e707d311] xfs: grow the realtime section when realtime groups are enabled
      [2f8a0a5a02af] xfs: support logging EFIs for realtime extents
      [e200799d5bbd] xfs: support error injection when freeing rt extents
      [f95f8a062de9] xfs: use realtime EFI to free extents when rtgroups are enabled
      [5b4cdd7bae76] xfs: don't merge ioends across RTGs
      [5397ae40aa84] xfs: scrub the realtime group superblock
      [70c4fd2bc463] xfs: scrub metadir paths for rtgroup metadata
      [86e2966742f9] xfs: mask off the rtbitmap and summary inodes when metadir in use
      [6fd224bcfdbe] xfs: create helpers to deal with rounding xfs_fileoff_t to rtx boundaries
      [7901a592698c] xfs: create helpers to deal with rounding xfs_filblks_t to rtx boundaries
      [606a37448e30] xfs: make xfs_rtblock_t a segmented address like xfs_fsblock_t
      [6713ab810c4e] xfs: adjust min_block usage in xfs_verify_agbno
      [fdaaa0cb7a0c] xfs: move the min and max group block numbers to xfs_group
      [84daa9bd1b59] xfs: implement busy extent tracking for rtgroups
      [adf9494338ae] xfs: use metadir for quota inodes
      [29a6df5a4112] xfs: scrub quota file metapaths
      [7f45426fd4fe] xfs: enable metadata directory feature
      [8a4045cbe17a] xfs: convert struct typedefs in xfs_ondisk.h
      [f20309e8a094] xfs: separate space btree structures in xfs_ondisk.h
      [318c294dcb53] xfs: port ondisk structure checks from xfs/122 to the kernel
      [6af3957ea58a] xfs: return a 64-bit block count from xfs_btree_count_blocks
      [372aa942c32c] xfs: fix error bailout in xfs_rtginode_create
      [22f727e766f4] xfs: update btree keys correctly when _insrec splits an inode root block
      [2af08a75e4d1] xfs: fix sb_spino_align checks for large fsblock sizes
      [3e8a2c473d88] xfs: return from xfs_symlink_verify early on V4 filesystems
      [d4d205f82842] libxfs: remove XFS_ILOCK_RT*
      [762043aee95d] libxfs: adjust xfs_fsb_to_db to handle segmented rtblocks
      [595b5cecf6b2] xfs_repair,mkfs: port to libxfs_rt{bitmap,summary}_create
      [b15a12d42050] libxfs: use correct rtx count to block count conversion
      [f018c3eb2277] libfrog: scrub the realtime group superblock
      [a9330b7fb3c0] man: document the rt group geometry ioctl
      [f2d61c12f4e5] libxfs: port userspace deferred log item to handle rtgroups
      [8ea12bc87e16] libxfs: implement some sanity checking for enormous rgcount
      [57e5eb6d1dc2] libfrog: support scrubbing rtgroup metadata paths
      [6351c6b3fb36] libfrog: report rt groups in output
      [3516c7fe892e] libfrog: add bitmap_clear
      [61f5d4a4a5c8] xfs_logprint: report realtime EFIs
      [840194be7872] xfs_repair: adjust rtbitmap/rtsummary word updates to handle big endian values
      [607b7197c021] xfs_repair: refactor offsetof+sizeof to offsetofend
      [9fe5aa9c9c23] xfs_repair: improve rtbitmap discrepancy reporting
      [7c541c90fd77] xfs_repair: support realtime groups
      [b1803dc7b63b] xfs_repair: find and clobber rtgroup bitmap and summary files
      [76507468b265] xfs_repair: support realtime superblocks
      [5ef84567a5f9] xfs_repair: repair rtbitmap and rtsummary block headers
      [cffeab562105] xfs_db: enable the rtblock and rtextent commands for segmented rt block numbers
      [903072467481] xfs_db: enable rtconvert to handle segmented rtblocks
      [627513cabdcd] xfs_db: listify the definition of enum typnm
      [ef420536009d] xfs_db: support dumping realtime group data and superblocks
      [03101e4578ab] xfs_db: support changing the label and uuid of rt superblocks
      [47ead87bff83] xfs_db: enable conversion of rt space units
      [6bc20c5edbab] xfs_db: metadump realtime devices
      [2be091fb5314] xfs_db: dump rt bitmap blocks
      [e5bd3d74aa02] xfs_db: dump rt summary blocks
      [bd76dc340f67] xfs_db: report rt group and block number in the bmap command
      [6e7d726d6fe2] xfs_io: support scrubbing rtgroup metadata
      [18e3b756d550] xfs_io: support scrubbing rtgroup metadata paths
      [b15ffb571150] xfs_io: add a command to display allocation group information
      [39adf908f930] xfs_io: add a command to display realtime group information
      [1bb785d57404] xfs_io: display rt group in verbose bmap output
      [06f8edf3e634] xfs_io: display rt group in verbose fsmap output
      [c1464833d94d] xfs_mdrestore: refactor open-coded fd/is_file into a structure
      [32432bbff943] xfs_mdrestore: restore rt group superblocks to realtime device
      [a3c38eecc97b] xfs_spaceman: report on realtime group health
      [241d915d69d4] xfs_scrub: scrub realtime allocation group metadata
      [816f973a8ff6] xfs_scrub: check rtgroup metadata directory connections
      [a68eb7c7fde1] xfs_scrub: call GETFSMAP for each rt group in parallel
      [d464c9cfb583] xfs_scrub: trim realtime volumes too
      [1fc3de707fc5] xfs_scrub: use histograms to speed up phase 8 on the realtime volume
      [aaf86f87ea58] mkfs: add headers to realtime bitmap blocks
      [0d7c490474e5] mkfs: format realtime groups
      [a1474f1b8509] libfrog: scrub quota file metapaths
      [ff7a96372378] xfs_db: support metadir quotas
      [8cb45fdf6de1] xfs_repair: refactor quota inumber handling
      [8b41e9bb3f0f] xfs_repair: hoist the secondary sb qflags handling
      [b790ab2a303d] xfs_repair: support quota inodes in the metadata directory
      [d6aa9b80f482] xfs_repair: try not to trash qflags on metadir filesystems
      [525f826429a8] mkfs: add quota flags when setting up filesystem
      [0ef6ac32d3ca] xfs_quota: report warning limits for realtime space quotas
      [b921f97bcf43] mkfs: enable rt quota options
      [741eb9b6f9a8] xfs_db: fix multiple dblock commands
      [c08fe89d4441] xfs_repair: don't obliterate return codes
      [fe9efcb37d1f] libxfs: fix uninit variable in libxfs_alloc_file_space
      [c414a08700c5] xfs_db: improve error message when unknown btree type given to btheight
      [93711a36ed54] mkfs: fix parsing of value-less -d/-l concurrency cli option
      [43025caf770e] m4: fix statx override selection if /usr/include doesn't define it
      [e1d3ce600d70] build: initialize stack variables to zero by default
      [34738ff0ee80] mkfs: allow sizing realtime allocation groups for concurrency
      [ff12f3956648] xfs_scrub_all.timer: don't run if /var/lib/xfsprogs is readonly
      [ca10888d51a5] xfs_repair: require zeroed quota/rt inodes in metadir superblocks
      [a62ea4ad9cac] mkfs: fix file size setting when interpreting a protofile
      [a9d781ec5505] xfs_protofile: fix mode formatting error
      [eff7226942a5] xfs_protofile: fix device number encoding

Dave Chinner (2):
      [9c0c39ae9703] xfs: sb_spino_align is not verified
      [12a11a2bfaa2] xfs: fix sparse inode limits on runt AG

Jan Palus (1):
      [acadff195e10] man: fix ioctl_xfs_commit_range man page install

Jeff Layton (1):
      [0319f1600252] xfs: switch to multigrain timestamps

Long Li (2):
      [bc494cfd76a4] xfs: remove the redundant xfs_alloc_log_agf
      [94a12f8aa5d9] xfs: remove unknown compat feature check in superblock write validation

Ojaswin Mujoo (3):
      [1ea8166cdd74] include/linux.h: use linux/magic.h to get XFS_SUPER_MAGIC
      [e6b48f451a5d] xfs_io: allow foreign FSes to show FS_IOC_FSGETXATTR details
      [19bca351dcdf] xfs_io: add extsize command support

Code Diffstat:

 VERSION                               |   2 +-
 configure.ac                          |   3 +-
 db/Makefile                           |   1 +
 db/block.c                            |  38 +-
 db/block.h                            |  16 -
 db/bmap.c                             |  56 ++-
 db/btheight.c                         |   6 +
 db/check.c                            | 292 +-----------
 db/command.c                          |   2 +
 db/convert.c                          | 119 ++++-
 db/dquot.c                            |  59 ++-
 db/faddr.c                            |   1 -
 db/field.c                            |  22 +
 db/field.h                            |  11 +
 db/fsmap.c                            |  10 +-
 db/info.c                             |   7 +-
 db/inode.c                            | 126 ++++-
 db/inode.h                            |   2 +
 db/iunlink.c                          |   6 +-
 db/metadump.c                         | 444 ++++++++++--------
 db/namei.c                            |  71 ++-
 db/rtgroup.c                          | 154 ++++++
 db/rtgroup.h                          |  21 +
 db/sb.c                               | 133 +++++-
 db/type.c                             |  16 +
 db/type.h                             |  32 +-
 db/xfs_metadump.sh                    |   5 +-
 debian/changelog                      |   6 +
 doc/CHANGES                           | 104 +++++
 include/builddefs.in                  |   2 +-
 include/libxfs.h                      |  10 +-
 include/linux.h                       |   3 +-
 include/platform_defs.h               |  33 ++
 include/xfs.h                         |  15 +
 include/xfs_inode.h                   |  23 +-
 include/xfs_metadump.h                |   8 +
 include/xfs_mount.h                   |  76 ++-
 include/xfs_trace.h                   |  38 +-
 include/xfs_trans.h                   |   4 +
 include/xqm.h                         |   5 +-
 io/Makefile                           |   1 +
 io/aginfo.c                           | 215 +++++++++
 io/bmap.c                             |  27 +-
 io/bulkstat.c                         |  16 +-
 io/fsmap.c                            |  22 +-
 io/init.c                             |   1 +
 io/io.h                               |   1 +
 io/open.c                             |   2 +-
 io/scrub.c                            | 131 +++++-
 io/stat.c                             |  63 +--
 libfrog/bitmap.c                      |  25 +-
 libfrog/bitmap.h                      |   1 +
 libfrog/bulkstat.c                    |   3 +-
 libfrog/div64.h                       |   6 +
 libfrog/fsgeom.c                      |  30 +-
 libfrog/fsgeom.h                      |  16 +
 libfrog/radix-tree.h                  |   9 +
 libfrog/scrub.c                       |  58 ++-
 libfrog/scrub.h                       |   3 +
 libfrog/util.c                        |  26 ++
 libfrog/util.h                        |   5 +
 libxfs/Makefile                       |   8 +
 libxfs/defer_item.c                   | 102 ++--
 libxfs/init.c                         | 115 ++++-
 libxfs/inode.c                        |  62 +++
 libxfs/iunlink.c                      |  11 +-
 libxfs/libxfs_api_defs.h              |  46 +-
 libxfs/libxfs_io.h                    |   1 +
 libxfs/libxfs_priv.h                  |  52 +--
 libxfs/rdwr.c                         |  17 +
 libxfs/topology.c                     |  42 ++
 libxfs/topology.h                     |   3 +
 libxfs/trans.c                        |  70 ++-
 libxfs/util.c                         | 221 +++++++--
 libxfs/xfs_ag.c                       | 258 ++++------
 libxfs/xfs_ag.h                       | 205 ++++----
 libxfs/xfs_ag_resv.c                  |  22 +-
 libxfs/xfs_alloc.c                    | 119 ++---
 libxfs/xfs_alloc.h                    |  19 +-
 libxfs/xfs_alloc_btree.c              |  30 +-
 libxfs/xfs_attr.c                     |   5 +-
 libxfs/xfs_bmap.c                     | 131 ++++--
 libxfs/xfs_bmap.h                     |   2 +-
 libxfs/xfs_btree.c                    |  71 +--
 libxfs/xfs_btree.h                    |   5 +-
 libxfs/xfs_btree_mem.c                |   6 +-
 libxfs/xfs_defer.c                    |   6 +
 libxfs/xfs_defer.h                    |   1 +
 libxfs/xfs_dquot_buf.c                | 190 ++++++++
 libxfs/xfs_format.h                   | 201 ++++++--
 libxfs/xfs_fs.h                       |  53 ++-
 libxfs/xfs_group.c                    | 223 +++++++++
 libxfs/xfs_group.h                    | 164 +++++++
 libxfs/xfs_health.h                   |  89 ++--
 libxfs/xfs_ialloc.c                   | 191 ++++----
 libxfs/xfs_ialloc_btree.c             |  35 +-
 libxfs/xfs_inode_buf.c                |  90 +++-
 libxfs/xfs_inode_buf.h                |   3 +
 libxfs/xfs_inode_util.c               |   6 +-
 libxfs/xfs_log_format.h               |   8 +-
 libxfs/xfs_metadir.c                  | 480 +++++++++++++++++++
 libxfs/xfs_metadir.h                  |  47 ++
 libxfs/xfs_metafile.c                 |  52 +++
 libxfs/xfs_metafile.h                 |  31 ++
 libxfs/xfs_ondisk.h                   | 186 ++++++--
 libxfs/xfs_quota_defs.h               |  43 ++
 libxfs/xfs_refcount.c                 |  33 +-
 libxfs/xfs_refcount.h                 |   2 +-
 libxfs/xfs_refcount_btree.c           |  17 +-
 libxfs/xfs_rmap.c                     |  42 +-
 libxfs/xfs_rmap.h                     |   6 +-
 libxfs/xfs_rmap_btree.c               |  28 +-
 libxfs/xfs_rtbitmap.c                 | 405 ++++++++++------
 libxfs/xfs_rtbitmap.h                 | 247 ++++++----
 libxfs/xfs_rtgroup.c                  | 694 +++++++++++++++++++++++++++
 libxfs/xfs_rtgroup.h                  | 284 +++++++++++
 libxfs/xfs_sb.c                       | 284 +++++++++--
 libxfs/xfs_sb.h                       |   6 +-
 libxfs/xfs_shared.h                   |   4 +
 libxfs/xfs_symlink_remote.c           |   4 +-
 libxfs/xfs_trans_inode.c              |   6 +-
 libxfs/xfs_trans_resv.c               |   2 +-
 libxfs/xfs_types.c                    |  44 +-
 libxfs/xfs_types.h                    |  16 +-
 logprint/log_misc.c                   |  19 +-
 logprint/log_print_all.c              |  30 +-
 logprint/log_redo.c                   |  57 ++-
 m4/package_libcdev.m4                 |   2 +-
 m4/package_sanitizer.m4               |  14 +
 man/man2/ioctl_xfs_commit_range.2     |   2 +-
 man/man2/ioctl_xfs_fsgeometry.2       |   9 +-
 man/man2/ioctl_xfs_rtgroup_geometry.2 |  99 ++++
 man/man2/ioctl_xfs_scrub_metadata.2   |  53 +++
 man/man8/mkfs.xfs.8.in                | 130 ++++++
 man/man8/xfs_db.8                     |  69 ++-
 man/man8/xfs_io.8                     |  40 +-
 man/man8/xfs_mdrestore.8              |  10 +
 man/man8/xfs_metadump.8               |  11 +
 man/man8/xfs_protofile.8              |  33 ++
 man/man8/xfs_spaceman.8               |   5 +-
 mdrestore/xfs_mdrestore.c             | 163 ++++---
 mkfs/Makefile                         |  10 +-
 mkfs/lts_4.19.conf                    |   1 +
 mkfs/lts_5.10.conf                    |   1 +
 mkfs/lts_5.15.conf                    |   1 +
 mkfs/lts_5.4.conf                     |   1 +
 mkfs/lts_6.1.conf                     |   1 +
 mkfs/lts_6.12.conf                    |   1 +
 mkfs/lts_6.6.conf                     |   1 +
 mkfs/proto.c                          | 494 +++++++++++++++-----
 mkfs/xfs_mkfs.c                       | 581 ++++++++++++++++++++++-
 mkfs/xfs_protofile.in                 | 152 ++++++
 quota/state.c                         |   1 +
 repair/agbtree.c                      |  27 +-
 repair/agheader.c                     | 230 +++++----
 repair/agheader.h                     |  10 +
 repair/bmap_repair.c                  |  11 +-
 repair/bulkload.c                     |   9 +-
 repair/dino_chunks.c                  | 103 +++-
 repair/dinode.c                       | 380 +++++++++++----
 repair/dinode.h                       |   6 +-
 repair/dir2.c                         |  76 ++-
 repair/globals.c                      | 123 ++++-
 repair/globals.h                      |  30 +-
 repair/incore.c                       | 235 +++++++---
 repair/incore.h                       |  99 +++-
 repair/incore_ext.c                   |   3 +-
 repair/incore_ino.c                   |   1 +
 repair/phase1.c                       |   2 +
 repair/phase2.c                       | 103 ++--
 repair/phase3.c                       |   4 +
 repair/phase4.c                       | 351 ++++++++------
 repair/phase5.c                       |  20 +-
 repair/phase6.c                       | 858 ++++++++++++++++++++++++++--------
 repair/pptr.c                         |  94 ++++
 repair/pptr.h                         |   2 +
 repair/prefetch.c                     |   2 +-
 repair/quotacheck.c                   | 140 +++++-
 repair/quotacheck.h                   |   3 +
 repair/rmap.c                         |  16 +-
 repair/rt.c                           | 601 ++++++++++++++++++++----
 repair/rt.h                           |  35 +-
 repair/sb.c                           |  47 ++
 repair/scan.c                         |  79 +++-
 repair/scan.h                         |   7 +-
 repair/versions.c                     |  16 +-
 repair/xfs_repair.c                   |  88 +++-
 scrub/Makefile                        |   6 +-
 scrub/inodes.c                        |  11 +-
 scrub/inodes.h                        |   5 +-
 scrub/phase2.c                        | 124 +++--
 scrub/phase3.c                        |   7 +-
 scrub/phase5.c                        | 122 ++++-
 scrub/phase6.c                        |  41 +-
 scrub/phase7.c                        |   7 +
 scrub/phase8.c                        |  36 +-
 scrub/read_verify.c                   |   8 +
 scrub/repair.c                        |   1 +
 scrub/scrub.c                         |  25 +
 scrub/scrub.h                         |  18 +
 scrub/spacemap.c                      | 102 +++-
 scrub/xfs_scrub.c                     |   2 +
 scrub/xfs_scrub.h                     |   1 +
 scrub/xfs_scrub_all.timer             |  16 -
 scrub/xfs_scrub_all.timer.in          |  23 +
 spaceman/health.c                     |  65 ++-
 206 files changed, 11787 insertions(+), 3124 deletions(-)
 create mode 100644 db/rtgroup.c
 create mode 100644 db/rtgroup.h
 create mode 100644 io/aginfo.c
 create mode 100644 libxfs/xfs_group.c
 create mode 100644 libxfs/xfs_group.h
 create mode 100644 libxfs/xfs_metadir.c
 create mode 100644 libxfs/xfs_metadir.h
 create mode 100644 libxfs/xfs_metafile.c
 create mode 100644 libxfs/xfs_metafile.h
 create mode 100644 libxfs/xfs_rtgroup.c
 create mode 100644 libxfs/xfs_rtgroup.h
 create mode 100644 man/man2/ioctl_xfs_rtgroup_geometry.2
 create mode 100644 man/man8/xfs_protofile.8
 create mode 100644 mkfs/xfs_protofile.in
 delete mode 100644 scrub/xfs_scrub_all.timer
 create mode 100644 scrub/xfs_scrub_all.timer.in

-- 
- Andrey

