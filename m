Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 15 Aug 2006 04:55:49 -0700 (PDT)
Received: from mx.wurtel.net (xs.wurtel.net [83.68.3.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k7FBtYDW006683
	for <xfs@oss.sgi.com>; Tue, 15 Aug 2006 04:55:39 -0700
Received: from wurtel ([192.168.1.1] helo=wurtel-ws.wurtel.net)
	by mx.wurtel.net with esmtp (Exim 3.36 #1 (Debian))
	id 1GCxVK-00086K-00
	for <xfs@oss.sgi.com>; Tue, 15 Aug 2006 13:54:42 +0200
Received: from paul by wurtel-ws.wurtel.net with local (Exim 4.62)
	(envelope-from <paul@wurtel-ws.wurtel.net>)
	id 1GCxVK-0002PP-FZ
	for xfs@oss.sgi.com; Tue, 15 Aug 2006 13:54:42 +0200
Date: Tue, 15 Aug 2006 13:54:42 +0200
From: Paul Slootman <paul@wurtel.net>
Subject: Re: XFS internal error XFS_WANT_CORRUPTED_GOTO
Message-ID: <20060815115442.GA9248@wurtel.net>
References: <20060810164222.GA16332@wurtel.net> <200608110125.LAA18091@larry.melbourne.sgi.com> <20060811090218.GB22934@wurtel.net> <20060812091451.GA16661@wurtel.net> <20060814141731.GA9098@wurtel.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20060814141731.GA9098@wurtel.net>
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

On Mon 14 Aug 2006, Paul Slootman wrote:
> 
> kernel: 2.6.17.7 x86_64
> xfstools: 2.8.11 from CVS last week
> 
> I'm now running the "standard" debian xfs_repair (version 2.6.20) for kicks,
> as the 2.8.11 version didn't really seem to help much. I'm now getting
> plenty of these errors:
[snip]

After all that, again, tonight:

Aug 15 01:11:57 boes kernel: Filesystem "md6": XFS internal error xfs_trans_cancel at line 1150 of file fs/xfs/xfs_trans.c.  Caller 0xffffffff880577d3
Aug 15 01:11:57 boes kernel: 
Aug 15 01:11:57 boes kernel: Call Trace: <ffffffff880501d0>{:xfs:xfs_trans_cancel+96}
Aug 15 01:11:57 boes kernel:        <ffffffff880577d3>{:xfs:xfs_create+1587} <ffffffff88062381>{:xfs:xfs_vn_mknod+433}
Aug 15 01:11:57 boes kernel:        <ffffffff8805076c>{:xfs:xfs_trans_unlocked_item+44}
Aug 15 01:11:57 boes kernel:        <ffffffff8805e1ae>{:xfs:xfs_buf_rele+62} <ffffffff880260f1>{:xfs:xfs_da_brelse+129}
Aug 15 01:11:57 boes kernel:        <ffffffff8802c24b>{:xfs:xfs_dir2_leaf_lookup_int+555}
Aug 15 01:11:57 boes kernel:        <ffffffff8802bf93>{:xfs:xfs_dir2_leaf_lookup+35} <ffffffff8802842f>{:xfs:xfs_dir2_isleaf+31}
Aug 15 01:11:57 boes kernel:        <ffffffff88027b9f>{:xfs:xfs_dir2_lookup+255} <ffffffff802892ef>{link_path_walk+415}
Aug 15 01:11:57 boes kernel:        <ffffffff880560aa>{:xfs:xfs_access+74} <ffffffff80289e9e>{vfs_create+142}
Aug 15 01:11:57 boes kernel:        <ffffffff8028a22f>{open_namei+383} <ffffffff80278ff7>{do_filp_open+39}
Aug 15 01:11:57 boes kernel:        <ffffffff80279211>{get_unused_fd+113} <ffffffff80279406>{do_sys_open+70}
Aug 15 01:11:57 boes kernel:        <ffffffff80209b5a>{system_call+126}
Aug 15 01:11:57 boes kernel: xfs_force_shutdown(md6,0x8) called from line 1151 of file fs/xfs/xfs_trans.c.  Return address = 0xffffffff88065ba8
Aug 15 01:11:57 boes kernel: Filesystem "md6": Corruption of in-memory data detected.  Shutting down filesystem: md6
Aug 15 01:11:57 boes kernel: Please umount the filesystem, and rectify the problem(s)


The only thing the (2.8.11) xfs_repair reported was, in phase 3:

    data fork in ino 2995825682 claims free block 251664817


Paul Slootman
