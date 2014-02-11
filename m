Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 98E077F50
	for <xfs@oss.sgi.com>; Tue, 11 Feb 2014 14:43:42 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 1E3A5AC013
	for <xfs@oss.sgi.com>; Tue, 11 Feb 2014 12:43:38 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	p2whsUfDKBGxUD07 for <xfs@oss.sgi.com>;
	Tue, 11 Feb 2014 12:43:36 -0800 (PST)
Date: Wed, 12 Feb 2014 07:43:31 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs_repair fails to repair, run under valgrind shows "Invalid
	read..." and XFS_CORRUPTION_ERROR
Message-ID: <20140211204331.GL13647@dastard>
References: <52FA8021.9050604@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <52FA8021.9050604@linux.vnet.ibm.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Cody P Schafer <cody@linux.vnet.ibm.com>
Cc: xfs@oss.sgi.com

On Tue, Feb 11, 2014 at 11:55:13AM -0800, Cody P Schafer wrote:
> xfsprogs version: v3.2.0-alpha2-14-g6e79202
> 
> uname: Linux hostname 3.11.10-301.fc20.ppc64 #1 SMP Tue Dec 10
> 00:35:15 MST 2013 ppc64 POWER8 (architected), altivec supported CHRP
> IBM,8286-42A GNU/Linux
> 
> full log attached.

> 
> syncop8lp7 xfsprogs # valgrind ./repair/xfs_repair -n /dev/sda5                 
.....

Runs fine becuase it doesn't try to fix and write changes.

> ==6601== Memcheck, a memory error detector
> ==6601== Copyright (C) 2002-2012, and GNU GPL'd, by Julian Seward et al.
> ==6601== Using Valgrind-3.8.1 and LibVEX; rerun with -h for copyright info
> ==6601== Command: ./repair/xfs_repair -n /dev/sda5
> ==6601== 
> --6601-- WARNING: Serious error when reading debug info
> --6601-- When reading debug info from /usr/lib64/valgrind/memcheck-ppc64-linux:

Ok, so you're on ppc64. Big endian or little endian?

> syncop8lp7 xfsprogs # valgrind ./repair/xfs_repair /dev/sda5                    
....

> resetting inode 67687581 nlinks from 4 to 3
> xfs_dir3_data_write_verify: XFS_CORRUPTION_ERROR
> libxfs_writebufr: write verifer failed on bno 0x3239040/0x1000
> Invalid inode number 0xfeffffffffffffff

That's the smoking gun - the dirents in the rebuilt directory have
invalid inode numbers. They all have the same invalid inode number,
which indicates a bug in the directory reconstruction.

Can you provide a metadump of the broken filesystem to one of us fo
deeper inspection?

FWIW, the write verifiers have once again done their job - catching
corruptions caused by software bugs and preventing them from causing
further corruption to the filesystem...

> libxfs_writebufr: write verifer failed on bno 0x3298f38/0x1000
> ==6700== Syscall param pwrite64(buf) points to uninitialised byte(s)
> ==6700==    at 0x40F810C: pwrite64 (pwrite64.c:51)
> ==6700==    by 0x1003ABDB: __write_buf (rdwr.c:801)
> ==6700==    by 0x1003C1B7: libxfs_writebufr (rdwr.c:863)
> ==6700==    by 0x10036C4F: cache_flush (cache.c:600)
> ==6700==    by 0x1003C77B: libxfs_bcache_flush (rdwr.c:994)
> ==6700==    by 0x10004C6B: main (xfs_repair.c:886)
> ==6700==  Address 0xbeb0622 is 34 bytes inside a block of size 4,096 alloc'd
> ==6700==    at 0x406631C: memalign (in /usr/lib64/valgrind/vgpreload_memcheck-ppc64-linux.so)
> ==6700==    by 0x1003ADEF: __initbuf (rdwr.c:367)
> ==6700==    by 0x1003B797: libxfs_getbufr_map (rdwr.c:416)
> ==6700==    by 0x100365C3: cache_node_get (cache.c:273)
> ==6700==    by 0x1003A8DB: __cache_lookup (rdwr.c:519)
> ==6700==    by 0x1003BA6F: libxfs_getbuf_map (rdwr.c:601)
> ==6700==    by 0x1003D333: libxfs_trans_get_buf_map (trans.c:525)
> ==6700==    by 0x10059A3B: xfs_da_get_buf (xfs_da_btree.c:2580)
> ==6700==    by 0x10060E27: xfs_dir3_data_init (xfs_dir2_data.c:558)
> ==6700==    by 0x1006407F: xfs_dir2_leaf_addname (xfs_dir2_leaf.c:826)
> ==6700==    by 0x1005D59B: xfs_dir_createname (xfs_dir2.c:233)
> ==6700==    by 0x100290D3: mv_orphanage (phase6.c:1205)

And that looks kinda related. This has been triggered by the write
of a directory buffer that was created during lost+found processing,
and is a prime candidate for incorrect reconstruction. What is the
head commit of the repo you built this xfs_repair binary from, and
what version of gcc did you use?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
