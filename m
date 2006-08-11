Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 11 Aug 2006 02:03:38 -0700 (PDT)
Received: from mx.wurtel.net (a83-68-3-130.adsl.cistron.nl [83.68.3.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k7B938DW021261
	for <xfs@oss.sgi.com>; Fri, 11 Aug 2006 02:03:13 -0700
Date: Fri, 11 Aug 2006 11:02:18 +0200
From: Paul Slootman <paul@wurtel.net>
Subject: Re: cache_purge: shake on cache 0x5880a0 left 8 nodes!?
Message-ID: <20060811090218.GB22934@wurtel.net>
References: <20060810164222.GA16332@wurtel.net> <200608110125.LAA18091@larry.melbourne.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200608110125.LAA18091@larry.melbourne.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Barry Naujok <bnaujok@melbourne.sgi.com>
Cc: xfs@oss.sgi.com

On Fri 11 Aug 2006, Barry Naujok wrote:
> 
> What you are seeing is fine. The current libxfs cache with the directory update code is leaving some blocks referenced,
> and the libxfs code is printing out these blocks with outstanding references. 
> 
> The actual data was written to disk (prior to 2.8.10 it may not have). 

Hmmm....

Unfortunately, the filesystem panicked again last night.
This was after the double repair, and rebooting into 2.6.17.7, which
shouldn't have the bug, right?
I'll run another repair now :-(


Paul Slootman

The latest kernel message:


rip copy_user_generic_c+0x8/0x26
Filesystem "md6": XFS internal error xfs_trans_cancel at line 1150 of file fs/xfs/xfs_trans.c.  Caller 0xffffffff880577d3

Call Trace: <ffffffff880501d0>{:xfs:xfs_trans_cancel+96}
       <ffffffff880577d3>{:xfs:xfs_create+1587} <ffffffff88062381>{:xfs:xfs_vn_mknod+433}
       <ffffffff8802cff9>{:xfs:xfs_dir2_leafn_lookup_int+89}
       <ffffffff8805076c>{:xfs:xfs_trans_unlocked_item+44}
       <ffffffff8805e1ae>{:xfs:xfs_buf_rele+62} <ffffffff8802ea28>{:xfs:xfs_dir2_node_lookup+184}
       <ffffffff88027bab>{:xfs:xfs_dir2_lookup+267} <ffffffff802892ef>{link_path_walk+415}
       <ffffffff880560aa>{:xfs:xfs_access+74} <ffffffff80289e9e>{vfs_create+142}
       <ffffffff8028a22f>{open_namei+383} <ffffffff80278ff7>{do_filp_open+39}
       <ffffffff80279211>{get_unused_fd+113} <ffffffff80279406>{do_sys_open+70}
       <ffffffff80209b5a>{system_call+126}
xfs_force_shutdown(md6,0x8) called from line 1151 of file fs/xfs/xfs_trans.c.  Return address = 0xffffffff88065ba8
xfs_force_shutdown(md6,0x2) called from line 729 of file fs/xfs/xfs_log.c.  Return address = 0xffffffff88065ba8
Filesystem "md6": Corruption of in-memory data detected.  Shutting down filesystem: md6
Please umount the filesystem, and rectify the problem(s)
