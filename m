Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 20 Nov 2006 12:51:01 -0800 (PST)
Received: from lucidpixels.com (lucidpixels.com [66.45.37.187])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id kAKKoraG003241
	for <xfs@oss.sgi.com>; Mon, 20 Nov 2006 12:50:54 -0800
Received: from localhost (localhost [127.0.0.1])
	by lucidpixels.com (Postfix) with ESMTP id F040416172EB3
	for <xfs@oss.sgi.com>; Mon, 20 Nov 2006 15:50:02 -0500 (EST)
Date: Mon, 20 Nov 2006 15:50:02 -0500 (EST)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: XFS CORRUPTION 2.6.17.13?
In-Reply-To: <Pine.LNX.4.64.0611201459420.17165@p34.internal.lan>
Message-ID: <Pine.LNX.4.64.0611201549510.20082@p34.internal.lan>
References: <Pine.LNX.4.64.0611201459420.17165@p34.internal.lan>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

I meant 2.6.17.6 w/patch -> 2.6.17.13

On Mon, 20 Nov 2006, Justin Piszcz wrote:

> Anyone know what could cause this?
> Is the last good kernel to use 2.6.17.6 w/XFS bugfix patch?
> 
> Was a new bug introduced from 2.6.16.6 -> 2.6.17.13?
> 
> Nov 20 13:16:58 box [4299533.469000] 0x0: 00 00 00 00 00 00 00 00 00 00 00 
> 00 00
> 00 00 00
> Nov 20 13:16:58 box [4299533.469000] Filesystem "hda2": XFS internal error
> xfs_da_do_buf(2) at line 2212 of file fs/xfs/xfs_da_btree.c.  Caller 
> 0xc01ffcad
> Nov 20 13:16:58 box [4299533.469000]  <c02126fd>
> Nov 20 13:16:58 box xfs_corruption_error+0xf2/0x11a
> Nov 20 13:16:58 box
> Nov 20 13:16:58 box  <c01ffcad>
> Nov 20 13:16:58 box xfs_da_read_buf+0x3b/0x3f
> Nov 20 13:16:58 box
> Nov 20 13:16:58 box [4299533.469000]  <c0241320>
> Nov 20 13:16:58 box kmem_zone_alloc+0x60/0xdd
> Nov 20 13:16:58 box
> Nov 20 13:16:58 box  <c01ff227>
> Nov 20 13:16:58 box xfs_da_buf_make+0xf7/0x14c
> Nov 20 13:16:58 box
> Nov 20 13:16:58 box [4299533.469000]  <c01ffbb1>
> Nov 20 13:16:58 box xfs_da_do_buf+0x935/0x98d
> Nov 20 13:16:58 box
> Nov 20 13:16:58 box  <c01ffcad>
> Nov 20 13:16:58 box xfs_da_read_buf+0x3b/0x3f
> Nov 20 13:16:58 box
> Nov 20 13:16:58 box [4299533.469000]  <c013dd54>
> Nov 20 13:16:58 box __alloc_pages+0x53/0x2d6
> Nov 20 13:16:58 box
> Nov 20 13:16:58 box  <c01ffcad>
> Nov 20 13:16:58 box xfs_da_read_buf+0x3b/0x3f
> Nov 20 13:16:58 box
> Nov 20 13:16:58 box [4299533.469000]  <c0202a79>
> Nov 20 13:16:58 box xfs_da_node_lookup_int+0xd0/0x399
> Nov 20 13:16:58 box
> Nov 20 13:16:58 box  <c0202a79>
> Nov 20 13:16:58 box xfs_da_node_lookup_int+0xd0/0x399
> Nov 20 13:16:58 box
> Nov 20 13:16:58 box [4299533.469000]  <c020a921>
> Nov 20 13:16:58 box xfs_dir2_node_lookup+0x3f/0xb9
> Nov 20 13:16:58 box
> Nov 20 13:16:58 box  <c020549a>
> Nov 20 13:16:58 box xfs_dir2_lookup+0x137/0x139
> Nov 20 13:16:58 box
> Nov 20 13:16:58 box [4299533.470000]  <c013dd54>
> Nov 20 13:16:58 box __alloc_pages+0x53/0x2d6
> Nov 20 13:16:58 box
> Nov 20 13:16:58 box  <c0236080>
> Nov 20 13:16:58 box xfs_dir_lookup_int+0x40/0x125
> Nov 20 13:16:58 box
> Nov 20 13:16:58 box [4299533.470000]  <c023a72f>
> Nov 20 13:16:58 box xfs_lookup+0x5f/0x88
> Nov 20 13:16:58 box
> Nov 20 13:16:58 box  <c0248d0f>
> Nov 20 13:16:58 box xfs_vn_lookup+0x4f/0x93
> Nov 20 13:16:58 box
> Nov 20 13:16:58 box [4299533.470000]  <c0164009>
> Nov 20 13:16:58 box do_lookup+0x12d/0x15f
> Nov 20 13:16:58 box
> Nov 20 13:16:58 box  <c0165387>
> 
> 
