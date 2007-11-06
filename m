Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 06 Nov 2007 08:07:07 -0800 (PST)
Received: from spike.grumly.eu.org (spike.grumly.eu.org [195.5.253.226])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id lA6G6xxb030197
	for <xfs@oss.sgi.com>; Tue, 6 Nov 2007 08:07:02 -0800
Date: Tue, 6 Nov 2007 17:07:21 +0100
From: Cedric - Equinoxe Media <cedric@e-m.fr>
Subject: Re: xfs crash
Message-ID: <20071106160721.GB25295@e-m.fr>
References: <20071105215135.GA12238@e-m.fr> <20071106082632.GU995458@sgi.com> <20071106092157.GB16694@e-m.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20071106092157.GB16694@e-m.fr>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: xfs@oss.sgi.com

I just had exactly the same crash again today :
/dev/sda4 on /filer type xfs (rw,noexec,nosuid,nodev,noatime)

Nov  6 16:40:24 fng2 kernel: XFS internal error XFS_WANT_CORRUPTED_GOTO at line 1563 of file fs/xfs/xfs_alloc.c.  Caller 0xffffffff88113b35
Nov  6 16:40:24 fng2 kernel: 
Nov  6 16:40:24 fng2 kernel: Call Trace:
Nov  6 16:40:24 fng2 kernel:  [<ffffffff88111fcb>] :xfs:xfs_free_ag_extent+0x1a6/0x6b5
Nov  6 16:40:24 fng2 kernel:  [<ffffffff88113b35>] :xfs:xfs_free_extent+0xa9/0xc9
Nov  6 16:40:24 fng2 kernel:  [<ffffffff8811cf77>] :xfs:xfs_bmap_finish+0xee/0x167
Nov  6 16:40:24 fng2 kernel:  [<ffffffff8813c843>] :xfs:xfs_itruncate_finish+0x19b/0x2e0
Nov  6 16:40:24 fng2 kernel:  [<ffffffff881543c1>] :xfs:xfs_setattr+0x841/0xe57
Nov  6 16:40:24 fng2 kernel:  [<ffffffff8815c328>] :xfs:xfs_fs_get_dentry+0x38/0x59
Nov  6 16:40:24 fng2 kernel:  [<ffffffff80229db3>] task_rq_lock+0x3d/0x6f
Nov  6 16:40:24 fng2 kernel:  [<ffffffff80229976>] __activate_task+0x26/0x38
Nov  6 16:40:24 fng2 kernel:  [<ffffffff8815eae8>] :xfs:xfs_vn_setattr+0x121/0x144
Nov  6 16:40:24 fng2 kernel:  [<ffffffff80296791>] notify_change+0x156/0x2f1
Nov  6 16:40:24 fng2 kernel:  [<ffffffff88309aba>] :nfsd:nfsd_setattr+0x334/0x4b1
Nov  6 16:40:24 fng2 kernel:  [<ffffffff883102e2>] :nfsd:nfsd3_proc_setattr+0xa2/0xae
Nov  6 16:40:24 fng2 kernel:  [<ffffffff8830524d>] :nfsd:nfsd_dispatch+0xdd/0x19e
Nov  6 16:40:24 fng2 kernel:  [<ffffffff88283180>] :sunrpc:svc_process+0x3df/0x6ef
Nov  6 16:40:24 fng2 kernel:  [<ffffffff803f4cc2>] __down_read+0x12/0x9a
Nov  6 16:40:24 fng2 kernel:  [<ffffffff88305815>] :nfsd:nfsd+0x191/0x2ac
Nov  6 16:40:24 fng2 kernel:  [<ffffffff8020aba8>] child_rip+0xa/0x12
Nov  6 16:40:24 fng2 kernel:  [<ffffffff88305684>] :nfsd:nfsd+0x0/0x2ac
Nov  6 16:40:24 fng2 kernel:  [<ffffffff8020ab9e>] child_rip+0x0/0x12
Nov  6 16:40:24 fng2 kernel: 
Nov  6 16:40:24 fng2 kernel: xfs_force_shutdown(sda4,0x8) called from line 4258 of file fs/xfs/xfs_bmap.c.  Return address = 0xffffffff8811cfb4
Nov  6 16:40:24 fng2 kernel: Filesystem "sda4": Corruption of in-memory data detected.  Shutting down filesystem: sda4
Nov  6 16:40:24 fng2 kernel: Please umount the filesystem, and rectify the problem(s)

Seems to be again on a setattr() ?

Regards.
Cédric
