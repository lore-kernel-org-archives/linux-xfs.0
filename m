Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 19 Apr 2007 07:00:16 -0700 (PDT)
Received: from mr3.cc.ic.ac.uk (mr3.cc.ic.ac.uk [155.198.5.113])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l3JE0CfB003297
	for <xfs@oss.sgi.com>; Thu, 19 Apr 2007 07:00:13 -0700
Received: from icexp2.cc.ic.ac.uk ([155.198.3.42] helo=icex.imperial.ac.uk)
	by mr3.cc.ic.ac.uk with smtp (Exim 4.63)
	(envelope-from <s.burbidge@imperial.ac.uk>)
	id 1HeWhO-0000uL-45
	for xfs@oss.sgi.com; Thu, 19 Apr 2007 14:29:22 +0100
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Subject: XFS internal error XFS_WANT_CORRUPTED_GOTO
Date: Thu, 19 Apr 2007 14:28:24 +0100
Message-ID: <735C1873E656C24699818814048F8FB0054C43B4@icex1.ic.ac.uk>
From: "Burbidge, Simon A" <s.burbidge@imperial.ac.uk>
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com


Hi,

We've had a couple of occurrnces of xfs shutdowns on one of our
fileservers.
The latest had the message:

Apr 19 10:35:00 fs3 kernel: XFS internal error XFS_WANT_CORRUPTED_GOTO
at line 1745 of file fs/xfs/xfs_alloc.c.  Caller 0xffffffff8819bc7c
Apr 19 10:35:00 fs3 kernel:
Apr 19 10:35:00 fs3 kernel: Call
Trace:<ffffffff8819a399>{:xfs:xfs_free_ag_extent+1449}
<ffffffff8819bc7c>{:xfs:xfs_free_extent+188}
Apr 19 10:35:00 fs3 kernel:
<ffffffff881c6967>{:xfs:xfs_efd_init+71}
<ffffffff881a7b38>{:xfs:xfs_bmap_finish+264}
Apr 19 10:35:00 fs3 kernel:
<ffffffff881cdde7>{:xfs:xfs_itruncate_finish+439}
<ffffffff881eab3e>{:xfs:xfs_inactive+622}
Apr 19 10:35:00 fs3 kernel:
<ffffffff881f33c7>{:xfs:validate_fields+39}
<ffffffff881f71d3>{:xfs:vn_rele+99}
Apr 19 10:35:00 fs3 kernel:
<ffffffff881f5e92>{:xfs:linvfs_clear_inode+18}
<ffffffff801a7c74>{clear_inode+228}
Apr 19 10:35:00 fs3 kernel:
<ffffffff801a82cd>{generic_delete_inode+253}
<ffffffff801a629a>{d_delete+202}
Apr 19 10:35:00 fs3 kernel:        <ffffffff8019d2e4>{vfs_unlink+500}
<ffffffff88364288>{:nfsd:nfsd_unlink+520}
Apr 19 10:35:00 fs3 kernel:
<ffffffff8836ccc8>{:nfsd:nfsd3_proc_remove+200}
<ffffffff8835f350>{:nfsd:nfsd_dispatch+240}
Apr 19 10:35:00 fs3 kernel:        <ffffffff8034b999>{svc_process+1049}
<ffffffff8035d2b1>{__down_read+49}
Apr 19 10:35:00 fs3 kernel:        <ffffffff8835f618>{:nfsd:nfsd+472}
<ffffffff80137d10>{schedule_tail+64}
Apr 19 10:35:00 fs3 kernel:        <ffffffff8010f92e>{child_rip+8}
<ffffffff8835f440>{:nfsd:nfsd+0}
Apr 19 10:35:00 fs3 kernel:        <ffffffff8010f926>{child_rip+0}
Apr 19 10:35:00 fs3 kernel: xfs_force_shutdown(dm-0,0x8) called from
line 4086 of file fs/xfs/xfs_bmap.c.  Return address =
0xffffffff881a7b7f
Apr 19 10:35:00 fs3 kernel: Filesystem "dm-0": Corruption of in-memory
data detected.  Shutting down filesystem: dm-0
Apr 19 10:35:00 fs3 kernel: Please umount the filesystem, and rectify
the problem(s)

xfs_repair didn't find any errors.

An earlier occurrence had a bunch of corrupt dinode messages, followed
by :

Apr  8 07:23:30 fs3 kernel: XFS internal error XFS_WANT_CORRUPTED_GOTO
at line 1583 of file fs/xfs/xfs_alloc.c.  Caller 0xffffffff88225c7c
Apr  8 07:23:30 fs3 kernel:
Apr  8 07:23:30 fs3 kernel: Call
Trace:<ffffffff88223fa4>{:xfs:xfs_free_ag_extent+436}
<ffffffff88225c7c>{:xfs:xfs_free_extent+188}
Apr  8 07:23:30 fs3 kernel:
<ffffffff88250967>{:xfs:xfs_efd_init+71}
<ffffffff8826c5fb>{:xfs:xfs_trans_get_efd+43}
Apr  8 07:23:30 fs3 kernel:
<ffffffff88231b38>{:xfs:xfs_bmap_finish+264}
<ffffffff88257de7>{:xfs:xfs_itruncate_finish+439}
Apr  8 07:23:30 fs3 kernel:
<ffffffff882702af>{:xfs:xfs_inactive_free_eofblocks+415}
Apr  8 07:23:30 fs3 kernel:
<ffffffff88274a23>{:xfs:xfs_inactive+339}
<ffffffff88256c68>{:xfs:xfs_iunlock+56}
Apr  8 07:23:30 fs3 kernel:
<ffffffff882746bc>{:xfs:xfs_reclaim+188}
<ffffffff8828154b>{:xfs:vn_purge+475}
Apr  8 07:23:30 fs3 kernel:        <ffffffff882811d3>{:xfs:vn_rele+99}
<ffffffff8827fe92>{:xfs:linvfs_clear_inode+18}
Apr  8 07:23:30 fs3 kernel:        <ffffffff801a7c74>{clear_inode+228}
<ffffffff801a7d18>{dispose_list+104}
Apr  8 07:23:30 fs3 kernel:
<ffffffff801a7faa>{shrink_icache_memory+490}
<ffffffff8017209c>{shrink_slab+220}
Apr  8 07:23:30 fs3 kernel:        <ffffffff8017368b>{balance_pgdat+619}
<ffffffff801739c7>{kswapd+343}
Apr  8 07:23:30 fs3 kernel:
<ffffffff80153070>{autoremove_wake_function+0}
<ffffffff80137d10>{schedule_tail+64}
Apr  8 07:23:30 fs3 kernel:        <ffffffff8010f92e>{child_rip+8}
<ffffffff80173870>{kswapd+0}
Apr  8 07:23:30 fs3 kernel:        <ffffffff8010f926>{child_rip+0}
Apr  8 07:23:30 fs3 kernel: xfs_force_shutdown(dm-0,0x8) called from
line 4086 of file fs/xfs/xfs_bmap.c.  Return address =
0xffffffff88231b7f
Apr  8 07:23:30 fs3 kernel: Filesystem "dm-0": Corruption of in-memory
data detected.  Shutting down filesystem: dm-0
Apr  8 07:23:30 fs3 kernel: Please umount the filesystem, and rectify
the problem(s)

xfs_repair did find and correct some bits for this.


Suggestions welcomed!

Thanks in advance,
Simon
