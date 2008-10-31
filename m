Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 30 Oct 2008 21:02:45 -0700 (PDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9V42Krn017285
	for <xfs@oss.sgi.com>; Thu, 30 Oct 2008 21:02:21 -0700
Received: from ipmail05.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D4A9D14B55B9
	for <xfs@oss.sgi.com>; Thu, 30 Oct 2008 21:02:19 -0700 (PDT)
Received: from ipmail05.adl2.internode.on.net (ipmail05.adl2.internode.on.net [203.16.214.145]) by cuda.sgi.com with ESMTP id CuABVhTTky9NkCPK for <xfs@oss.sgi.com>; Thu, 30 Oct 2008 21:02:19 -0700 (PDT)
Date: Fri, 31 Oct 2008 15:02:05 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 5/7] kill xfs_dinode_core_t
Message-ID: <20081031040205.GV17077@disturbed>
References: <20081027133912.GF1109@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081027133912.GF1109@infradead.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Mon, Oct 27, 2008 at 09:39:12AM -0400, Christoph Hellwig wrote:
> Now that we have a separate xfs_icdinode_t for the in-core inode which
> gets logged there is no need anymore for the xfs_dinode vs xfs_dinode_core
> split - the fact that part of the structure gets logged through the inode
> log item and a small part not can better be described in a comment.
> 
> All sizeof operations on the dinode_core either really wanted the
> icdinode and are switched to that one, or had already added the size
> of the agi unlinked list pointer.  Later both will be replaced with
> helpers once we get the larger CRC-enabled dinode.
> 
> Removing the data and attribute fork unions also has the advantage that
> xfs_dinode.h doesn't need to pull in every header under the sun.
> 
> While we're at it also add some more comments describing the dinode
> structure.
> 
> (First sent on October 7th)

There's a problem with this patch somewhere. I haven't had it in my
test stack for the last couple of days, and when I re-added it
a couple of hours back after updating the base kernel and master
branch I'm now getting shortform directory corruption from 
xfsqa test 001. Platform is x86_64 UML:

[42949510.230000] Assertion failed: i8count == sfp->hdr.i8count, file: fs/xfs/xfs_dir2_sf.c, line: 634

Program received signal SIGILL, Illegal instruction.
assfail (expr=<value optimized out>, file=<value optimized out>, line=<value optimized out>) at fs/xfs/support/debug.c:81
81              BUG();
(gdb) bt
#0  assfail (expr=<value optimized out>, file=<value optimized out>, line=<value optimized out>)
    at fs/xfs/support/debug.c:81
#1  0x0000000060139956 in xfs_dir2_sf_check (args=<value optimized out>) at fs/xfs/xfs_dir2_sf.c:634
#2  0x000000006013acb5 in xfs_dir2_sf_lookup (args=0x80913620) at fs/xfs/xfs_dir2_sf.c:822
#3  0x00000000601317f1 in xfs_dir_lookup (tp=0x0, dp=0x80da5958, name=0x80913b40, inum=0x80913b00, ci_name=0x0)
    at fs/xfs/xfs_dir2.c:303
#4  0x000000006015efeb in xfs_lookup (dp=0x80da5958, name=0x80913b40, ipp=0x80913b58, ci_name=0x0)
    at fs/xfs/xfs_vnodeops.c:1361
#5  0x0000000060168b25 in xfs_vn_lookup (dir=<value optimized out>, dentry=0x80dac550, nd=<value optimized out>)
    at fs/xfs/xfs_inode.h:301
#6  0x000000006007a451 in __lookup_hash (name=0x80913c10, base=0x80dac740, nd=0x80913c00) at fs/namei.c:1200
#7  0x000000006007a4aa in lookup_hash (nd=0x80913c00) at fs/namei.c:1222
#8  0x000000006007a4fe in lookup_create (nd=0x80913c00, is_dir=1) at fs/namei.c:1902
#9  0x000000006007c721 in sys_mkdirat (dfd=<value optimized out>, pathname=<value optimized out>, mode=493)
    at fs/namei.c:2061
#10 0x000000006007c7fb in sys_mkdir (pathname=<value optimized out>, mode=<value optimized out>) at fs/namei.c:2085
#11 0x000000006001515d in handle_syscall (r=0x7fb0b500) at arch/um/kernel/skas/syscall.c:35
#12 0x0000000060024303 in userspace (regs=0x7fb0b500) at arch/um/os-Linux/skas/process.c:201
#13 0x00000000600127cd in fork_handler () at arch/um/kernel/process.c:179
#14 0x0000000000000000 in ?? ()

(gdb) p i8count
$6 = 1
(gdb) p /x sfp->hdr.i8count
$7 = 0x80

I *didn't* see this problem a few days ago, so updating the tree has
brought in something that this patch doesn't like. I don't have time
to track this down now, so I'll leave it to you for the moment,
Christoph.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
