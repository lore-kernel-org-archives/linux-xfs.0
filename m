Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 17 Jul 2006 03:24:38 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k6HANwDW019747
	for <linux-xfs@oss.sgi.com>; Mon, 17 Jul 2006 03:24:09 -0700
Subject: TAKE 954580 - sparse fixes and annotations
Message-Id: <20060717102318.C536858C4C01@chook.melbourne.sgi.com>
Date: Mon, 17 Jul 2006 20:23:18 +1000 (EST)
From: nathans@sgi.com (Nathan Scott)
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-xfs@oss.sgi.com, sgi.bugs.xfs@engr.sgi.com

All xfs_disk_dquot_t values are (as the name says) disk endian.  Before
putting them into struct statfs they should be endian-swapped.

Signed-off-by: Christoph Hellwig <hch@lst.de>


Date:  Mon Jul 17 16:50:36 AEST 2006
Workarea:  chook.melbourne.sgi.com:/build/nathans/xfs-linux
Inspected by:  Christoph Hellwig <hch@lst.de>

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/xfs-kern/xfs-linux-melb


Modid:  xfs-linux-melb:xfs-kern:26550a
quota/xfs_qm_bhv.c - 1.22 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/quota/xfs_qm_bhv.c.diff?r1=text&tr1=1.22&r2=text&tr2=1.21&f=h
	- All xfs_disk_dquot_t values are (as the name says) disk endian.  Before
	  putting them into struct statfs they should be endian-swapped.


Fix rounding bug in xfs_free_file_space found by sparse checking.

Date:  Mon Jul 17 16:52:20 AEST 2006
Workarea:  chook.melbourne.sgi.com:/build/nathans/xfs-linux
Inspected by:  dgc

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/xfs-kern/xfs-linux-melb


Modid:  xfs-linux-melb:xfs-kern:26551a
xfs_vnodeops.c - 1.681 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_vnodeops.c.diff?r1=text&tr1=1.681&r2=text&tr2=1.680&f=h


Fix sparse warning found when page tracing enabled, due to overloaded gfp_t param.

Date:  Mon Jul 17 16:53:45 AEST 2006
Workarea:  chook.melbourne.sgi.com:/build/nathans/xfs-linux
Inspected by:  dgc

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/xfs-kern/xfs-linux-melb


Modid:  xfs-linux-melb:xfs-kern:26552a
xfsidbg.c - 1.305 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfsidbg.c.diff?r1=text&tr1=1.305&r2=text&tr2=1.304&f=h
linux-2.6/xfs_aops.c - 1.132 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_aops.c.diff?r1=text&tr1=1.132&r2=text&tr2=1.131&f=h
linux-2.4/xfs_aops.c - 1.105 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.4/xfs_aops.c.diff?r1=text&tr1=1.105&r2=text&tr2=1.104&f=h


endianess annotation for xfs_agfl_t.
Trivial, xfs_agfl_t is always used for ondisk values.

Signed-off-by: Christoph Hellwig <hch@lst.de>


Date:  Mon Jul 17 16:59:13 AEST 2006
Workarea:  chook.melbourne.sgi.com:/build/nathans/xfs-linux
Inspected by:  hch

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/xfs-kern/xfs-linux-melb


Modid:  xfs-linux-melb:xfs-kern:26553a
xfs_ag.h - 1.58 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_ag.h.diff?r1=text&tr1=1.58&r2=text&tr2=1.57&f=h
xfs_alloc.c - 1.182 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_alloc.c.diff?r1=text&tr1=1.182&r2=text&tr2=1.181&f=h
	- endianess annotation for xfs_agfl_t.


endianess annotations for xfs_inobt_rec_t / xfs_inobt_key_t

Signed-off-by: Christoph Hellwig <hch@lst.de>


Date:  Mon Jul 17 20:05:30 AEST 2006
Workarea:  chook.melbourne.sgi.com:/build/nathans/xfs-linux
Inspected by:  hch

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/xfs-kern/xfs-linux-melb


Modid:  xfs-linux-melb:xfs-kern:26556a
xfs_ialloc.c - 1.190 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_ialloc.c.diff?r1=text&tr1=1.190&r2=text&tr2=1.189&f=h
xfs_itable.c - 1.140 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_itable.c.diff?r1=text&tr1=1.140&r2=text&tr2=1.139&f=h
xfs_ialloc_btree.h - 1.31 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_ialloc_btree.h.diff?r1=text&tr1=1.31&r2=text&tr2=1.30&f=h
xfs_ialloc_btree.c - 1.84 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_ialloc_btree.c.diff?r1=text&tr1=1.84&r2=text&tr2=1.83&f=h
xfs_btree.c - 1.115 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_btree.c.diff?r1=text&tr1=1.115&r2=text&tr2=1.114&f=h
xfs_btree.h - 1.62 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_btree.h.diff?r1=text&tr1=1.62&r2=text&tr2=1.61&f=h
	- endianess annotations for xfs_inobt_rec_t / xfs_inobt_key_t


remove left over INT_ comments in *alloc*.c
We can verify endianess handling with sparse now, no need for comments.

Signed-off-by: Christoph Hellwig <hch@lst.de>


Date:  Mon Jul 17 20:06:58 AEST 2006
Workarea:  chook.melbourne.sgi.com:/build/nathans/xfs-linux
Inspected by:  hch

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/xfs-kern/xfs-linux-melb


Modid:  xfs-linux-melb:xfs-kern:26557a
xfs_ialloc_btree.c - 1.85 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_ialloc_btree.c.diff?r1=text&tr1=1.85&r2=text&tr2=1.84&f=h
xfs_alloc_btree.c - 1.88 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_alloc_btree.c.diff?r1=text&tr1=1.88&r2=text&tr2=1.87&f=h
	- remove left over INT_ comments


add xfs_btree_check_lptr_disk variant which handles endian conversion

Signed-off-by: Christoph Hellwig <hch@lst.de>


Date:  Mon Jul 17 20:10:12 AEST 2006
Workarea:  chook.melbourne.sgi.com:/build/nathans/xfs-linux
Inspected by:  hch

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/xfs-kern/xfs-linux-melb


Modid:  xfs-linux-melb:xfs-kern:26558a
xfs_bmap_btree.c - 1.154 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_bmap_btree.c.diff?r1=text&tr1=1.154&r2=text&tr2=1.153&f=h
xfs_btree.h - 1.63 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_btree.h.diff?r1=text&tr1=1.63&r2=text&tr2=1.62&f=h
xfs_bmap.c - 1.354 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_bmap.c.diff?r1=text&tr1=1.354&r2=text&tr2=1.353&f=h
	- add xfs_btree_check_lptr_disk variant which handles endian conversion


endianess annotations for xfs_bmbt_ptr_t/xfs_bmdr_ptr_t

Signed-off-by: Christoph Hellwig <hch@lst.de>


Date:  Mon Jul 17 20:12:13 AEST 2006
Workarea:  chook.melbourne.sgi.com:/build/nathans/xfs-linux
Inspected by:  hch

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/xfs-kern/xfs-linux-melb


Modid:  xfs-linux-melb:xfs-kern:26559a
xfs_bmap_btree.h - 1.73 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_bmap_btree.h.diff?r1=text&tr1=1.73&r2=text&tr2=1.72&f=h
	- endianess annotations for xfs_bmbt_ptr_t/xfs_bmdr_ptr_t


endianess annotate XFS_BMAP_BROOT_PTR_ADDR
Make sure it returns a __be64 and let the callers use the proper macros.

Signed-off-by: Christoph Hellwig <hch@lst.de>


Date:  Mon Jul 17 20:14:07 AEST 2006
Workarea:  chook.melbourne.sgi.com:/build/nathans/xfs-linux
Inspected by:  hch

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/xfs-kern/xfs-linux-melb


Modid:  xfs-linux-melb:xfs-kern:26560a
xfs_bmap_btree.c - 1.155 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_bmap_btree.c.diff?r1=text&tr1=1.155&r2=text&tr2=1.154&f=h
xfs_btree.h - 1.64 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_btree.h.diff?r1=text&tr1=1.64&r2=text&tr2=1.63&f=h
xfs_bmap.c - 1.355 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_bmap.c.diff?r1=text&tr1=1.355&r2=text&tr2=1.354&f=h
	- endianess annotate XFS_BMAP_BROOT_PTR_ADDR
	  Make sure it returns a __be64 and let the callers use the proper macros.


endianess annotations for xfs_bmbt_key
Trivial as there are no incore users.

Signed-off-by: Christoph Hellwig <hch@lst.de>


Date:  Mon Jul 17 20:21:16 AEST 2006
Workarea:  chook.melbourne.sgi.com:/build/nathans/xfs-linux
Inspected by:  hch

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/xfs-kern/xfs-linux-melb


Modid:  xfs-linux-melb:xfs-kern:26561a
xfs_bmap_btree.h - 1.74 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_bmap_btree.h.diff?r1=text&tr1=1.74&r2=text&tr2=1.73&f=h
xfs_bmap_btree.c - 1.156 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_bmap_btree.c.diff?r1=text&tr1=1.156&r2=text&tr2=1.155&f=h
xfs_btree.c - 1.116 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_btree.c.diff?r1=text&tr1=1.116&r2=text&tr2=1.115&f=h
xfs_bmap.c - 1.356 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_bmap.c.diff?r1=text&tr1=1.356&r2=text&tr2=1.355&f=h
	- endianess annotations for xfs_bmbt_key
