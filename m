Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794573852;
	b=SjUF2JY01TkwRrH/yr6h2htfg7mRaj12DV7frzsMEc+pRewG0UT6TLfsPI5eWA247cig
	 4Rmgq0DssPBXoED4IOuYt0i8CcMcMlIlYLjCrSTpwqDvVr0vnTIH95CxbCqilQ6dsPLtn
	 7ob+TzVle8GmUU7hHjXBceN4tiokYTR6xCZncR/BueCbYOUgq/cNulC5kzbCBK1wfBrnc
	 PWkPU7cihlfY9/5f1vCS6W346ATC4P59j7lT2Cx++Bf6h5rXLb+ocxebJEX5K1LSGcsvD
	 jus4mdh/yn2b1ixiIBYkJZ4Q6Xgw0u0fZQ026e5Y3lGf0rGzR5QwcsyxN/jq/B2PxfQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794573852;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 MIME-Version:Content-Type:Content-Disposition;
	bh=RCCZgsCQKIfCtLCzQ8cWSF069fHI6xwLCB12zNRTLvI=;
	b=c4fQ4U16aGqfbQKj0NqUuZc3ZxOD2F/NfAnJWOH/ff+aJOe3iMyo6znEwwosco5eAJtG
	 narLwhignSStz5B+OBYFGA+IFf9MyQ1iwiWM4c4miYe8ICulhyPN3DrU3d40GZyp0JUNU
	 6hKUX64WiQk9OQoM6WCC9myqzlIplwajCd50OTXiDEOluTKioY2PuQ0awCvYLWw2/Zhmb
	 V6fOGv3GIh0m7+7SVpcbIMCY2yduo3R6A6Km0dm9ukds697/LwPGxCxIZP2MTgsCzrPRX
	 5oUJVr/yHlJXL/DYKabg7wVAQdFhMF5Yjd/Csmg9f0rCvGggO6T8dRltX9XdsdvpgWw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JTpwJinA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C7A2606A323
	for <linux-xfs@vger.kernel.org>; Fri, 13 Nov 2026 12:44:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JTpwJinA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21D941F000C4;
	Fri, 13 Nov 2026 12:44:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794573851;
	bh=RCCZgsCQKIfCtLCzQ8cWSF069fHI6xwLCB12zNRTLvI=;
	h=Date:From:To:Cc:Subject;
	b=JTpwJinAbJDH97VXxl3J9Fymmxjnur0vvzRYPmGKiU+9004rngdXIF+URSfDgq/qV
	 gfk1umgFBmWH0t5MGhCJXURtY1WAcZsX1h6El+b7YoxTfd9oapyoRTmkMlTTpiiR7o
	 MW/GELP3UrZtCj3V7ylegS/9TULBN03lnSsbM4+R+mwAYrv7Q8c8jjpuKYAGTkfmvl
	 5h0Kg5vsyzVX5tEn9Ne3ildGiz5n+e+5oZFSVrhCJ+DKYS/PO7sagU/FfVIydDe+aL
	 ScyH4WsQyagwoD/rTegrB45wE047wQ68SLMiBXDWkEeQ/H7/hp4fKmT/eb0jCxrULw
	 8LBlY3HWFdaIQ==
Date: Fri, 13 Nov 2026 13:44:04 +0100
From: Andrey Albershteyn <aalbersh@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: aalbersh@kernel.org, cem@kernel.org, 
	chris.thomas@antimatter-studios.com, cihan.cihan@gmail.com, cmaiolino@redhat.com, dchinner@redhat.com, 
	dgc@kernel.org, djwong@kernel.org, floss@jetm.me, hch@lst.de, 
	hemanth.selam@gmail.com, jiapenglin@tencent.com, johannes.thumshirn@wdc.com, 
	kees+treewide@kernel.org, muhammad_hazley_samsudin_from.tp@tech.gov.sg, 
	norbert@doyensec.com, preichl@redhat.com, sandeen@redhat.com, 
	syzbot+837bcd54843dd6262f2f@syzkaller.appspotmail.com, yijiangshan@kylinos.cn, yun.zhou@windriver.com, 
	zenghongling@kylinos.cn
Subject: [ANNOUNCE] xfsprogs: v7.3.0 released
Message-ID: <avcFtK6orlaKoQIa@aalbersh-thinkpadx1carbongen13.rmtcz.csb>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi folks,

The xfsprogs master branch in repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git

has just been updated.

This release has a fix for CVE-2026-108472 [1]. This release enables metadata
directory trees by default for newly created filesystems. This release includes
multiple fixes gcc 16.2 warnings. The xfs_db now correctly lists shortform
parent pointers with 13 byte names. The rest of the changes is sync with kernel
code and updates to maintainer tools.

1: https://access.redhat.com/security/cve/cve-2026-108472

Patches often get missed, so if your outstanding patches are properly reviewed
on the list and not included in this update, please let me know.

The for-next branch has also been updated to match the state of master.

The new head of the master branch is commit:

e02d0a8efd81d454481641c9bd5680b5febb1261

New commits:

Andrey Albershteyn (5):
      [1c042af146e6] libxfs: remove stale xfs_trans_mod_sb() declaration
      [c50fa8510ac1] xfs: fix two warnings in xfs_alloc.c
      [7ebfc20eb88e] xfsprogs: add gcc generated stack usage files to gitignore
      [1c122bbd3c88] xfs_admin: remove eval use
      [e02d0a8efd81] xfsprogs: Release v7.3.0

Christoph Hellwig (9):
      [80018a28a877] xfs: remove spurious XBF_DONE clearing on readahead validation failure
      [180a2e434c12] xfs: hide b_flags manipulation from code outside of xfs_buf.c
      [5085dca9f68d] libfrog: constify getprnam
      [63b7ae1b61a8] libfrog: constify cvt*
      [6f8bef3a2c5f] db: constify construct_records_per_block
      [859beedfa796] repair: remove the unused queues_started variable in do_inode_prefetch
      [b62bd03a6d1b] stubs: use the i paramter to trace_xfs_trans_resv_calc_minlogsize
      [5ad4d0812a3c] platform: use the iomap_flags argument to xfs_bmbt_to_iomap
      [2ee6bbe82c0f] stubs: use more arguments to xfs_extent_busy_insert

Christopher Thomas (1):
      [850cb9654f6a] xfs_db: read a shortform parent pointer's value after its name

Cihan Karadag (1):
      [6beb86682dc7] xfs: use kmalloc_objs() instead of kmalloc() in xfs_da_grow_inode_int

Darrick J. Wong (11):
      [ea42938abb7a] mkfs: add config file for the 2026 LTS kernel
      [a0b95a987608] mkfs: enable metadata directory trees by default
      [83b41647a724] tools: add a new script to generate fixes tags
      [65ae0151999d] xfs: fix the rtrmap and rtrefcount _maxlevels_ondisk functions
      [5a1354e6af1c] xfs: fix xfs_rtrmapbt_mem_cursor for non-rmap filesystems
      [f119fbadba2b] xfs: preserve owner on in-memory btree creation
      [0442536d62fc] xfs: don't leak new_bp if xfs_btree_bload_drop_buf fails
      [d7a3896a4e61] xfs: fix under-reservation of blocks when repairing sf directories
      [2072b93c7e07] xfs: don't let hidden_space go negative in xfs_metafile_resv_init
      [82fdb617af23] xfs: fix wild memcpy access when formatting ondisk rtrefcount btree roots
      [5815674fbe35] xfs: fix exchange-range-to-eof file size exchange

Eric Sandeen (1):
      [1688728b6c90] libxfs: capture error return of cache_node_allocate()

Hemanth Selam (1):
      [07ff777ef47a] xfs: fix typos and repeated words in comments

Hongling Zeng (1):
      [6789f05429a3] xfs: validate attr entry pointer before field access

Javier Tia (6):
      [0a5e07e1a1ad] xfs: initialise error in xfs_defer_finish_one()
      [474b14a4cd52] xfs: give the deferred barrier op type a name
      [673000170fbc] xfs: report the error that made deferred work shut down the fs
      [7c1efc4e8ea6] xfs: correct the parent pointer space reservation comment
      [ee39c700588a] xfs: initialise args->total for parent pointer updates
      [5405a44f484a] xfs: assert the reservation covers each da fork growth

Jiangshan Yi (1):
      [17fe3cd5718c] xfs: remove duplicate INO1_WRITTEN check

Johannes Thumshirn (4):
      [b9a16b80f60d] xfs: add xfs_metadir_create_file helper
      [817b0d825073] xfs: create quota metadir inodes using xfs_metadir_create_file
      [d7890cb8656d] xfs: create rtgroup metadir inodes using xfs_metadir_create_file
      [377dc7ef91ab] xfs: mark internal metadir file creation helpers static

Kees Cook (1):
      [577eccc58bd8] treewide: refresh kmalloc_obj() conversions

Lin Jiapeng (1):
      [b7365c4b67a3] xfs: fix exchange-range reflink flag clearing issue with INO1_WRITTEN

Norbert Szetei (1):
      [e923094ba9c1] xfs: stop exchanging reflink flags when exchanging mappings

Yun Zhou (1):
      [6166ba6451de] xfs: don't hold buffer locks across sync transaction commit in xfs_sync_sb_buf

Code Diffstat:

 .gitignore                     |   1 +
 VERSION                        |   4 +-
 configure.ac                   |   2 +-
 db/btheight.c                  |   2 +-
 db/namei.c                     |   2 +-
 db/xfs_admin.sh                | 142 ++++++++++++++++++++++++++++-------------
 debian/changelog               |   6 ++
 doc/CHANGES                    |  13 ++++
 include/kmem.h                 |  14 ++++
 libfrog/convert.c              |  20 +++---
 libfrog/convert.h              |  24 +++----
 libfrog/projects.c             |   2 +-
 libfrog/projects.h             |   2 +-
 libxfs/cache.c                 |   2 +-
 libxfs/stubs/xfs_extent_busy.h |   9 ++-
 libxfs/stubs/xfs_mount.h       |   4 ++
 libxfs/stubs/xfs_trace.h       |   2 +-
 libxfs/trans.c                 |   2 +-
 libxfs/xfs_ag.h                |   2 +-
 libxfs/xfs_alloc.c             |   4 +-
 libxfs/xfs_attr_leaf.c         |  16 ++++-
 libxfs/xfs_btree_mem.c         |   2 +
 libxfs/xfs_btree_staging.c     |  11 ++--
 libxfs/xfs_da_btree.c          |  10 +--
 libxfs/xfs_da_btree.h          |   2 +
 libxfs/xfs_defer.c             |  18 +++++-
 libxfs/xfs_dquot_buf.c         |  47 ++++----------
 libxfs/xfs_errortag.h          |   2 +-
 libxfs/xfs_exchmaps.c          |  95 +++++----------------------
 libxfs/xfs_format.h            |   2 +-
 libxfs/xfs_ialloc.c            |   2 +-
 libxfs/xfs_inode_buf.c         |  17 ++---
 libxfs/xfs_log_format.h        |   4 +-
 libxfs/xfs_metadir.c           |  84 ++++++++++++++----------
 libxfs/xfs_metadir.h           |   8 ++-
 libxfs/xfs_metafile.c          |   8 +--
 libxfs/xfs_parent.c            |  12 +++-
 libxfs/xfs_platform.h          |  10 ++-
 libxfs/xfs_rtgroup.c           |  58 ++++++++---------
 libxfs/xfs_rtgroup.h           |   6 +-
 libxfs/xfs_rtrefcount_btree.c  |  11 ++--
 libxfs/xfs_rtrmap_btree.c      |   6 +-
 libxfs/xfs_sb.c                |  37 +++++------
 libxfs/xfs_trans_space.c       |  19 +++++-
 man/man8/mkfs.xfs.8.in         |   6 +-
 mkfs/Makefile                  |   3 +-
 mkfs/lts_7.3.conf              |  29 +++++++++
 mkfs/xfs_mkfs.c                |   1 +
 repair/prefetch.c              |   2 -
 tools/git-fixes                |  62 ++++++++++++++++++
 50 files changed, 517 insertions(+), 332 deletions(-)
 create mode 100644 mkfs/lts_7.3.conf
 create mode 100755 tools/git-fixes

-- 
- Andrey
