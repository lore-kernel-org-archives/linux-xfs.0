Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 25 Jan 2008 00:01:31 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m0P81NhA007063
	for <xfs@oss.sgi.com>; Fri, 25 Jan 2008 00:01:27 -0800
Date: Fri, 25 Jan 2008 19:01:34 +1100
From: David Chinner <dgc@sgi.com>
Subject: Re: kernel oops on debian, 2.6.18-5, large xfs volume
Message-ID: <20080125080134.GJ155407@sgi.com>
References: <200801251516352343935@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200801251516352343935@163.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: lxh <lxhzju@163.com>
Cc: xfs <xfs@oss.sgi.com>

On Fri, Jan 25, 2008 at 03:16:36PM +0800, lxh wrote:
> Hello, 
>    we have dozens of file servers with a 1.5TB/2.5 TB large xfs file system
>    volume running on a RAID6 SATA array.  Each volume contains about
>    10,000,000 files. The Operating system is debian GNU/Linux 2.6.18-5-amd64
>    #1 SMP. we got a kernel oops frequently last year.
> 
> here is the oops :
>  Filesystem "cciss/c0d1": XFS internal error xfs_trans_cancel at line 1138
>  of file fs/xfs/xfs_trans.c.  Caller 0xffffffff881df006
>  Call Trace:
>  [<ffffffff881fed18>] :xfs:xfs_trans_cancel+0x5b/0xfe
>  [<ffffffff88207006>] :xfs:xfs_create+0x58b/0x5dd
>  [<ffffffff8820f496>] :xfs:xfs_vn_mknod+0x1bd/0x3c8

Are you running out of space in the filesystem?

The only vectors I've seen that can cause this are I/O errors
or ENOSPC during file create after we've already checked that
this cannot happen. Are there any I/O errors in the log?

This commit:

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=45c34141126a89da07197d5b89c04c6847f1171a

which is in 2.6.23 fixed the last known cause of the ENOSPC
issue, so upgrading the kernel or patching this fix back
to the 2.6.18 kernel may fix the problem if it is related to
ENOSPC.

>  Every time the error occurs, the volume can not be accessed. So we have to
>  umount this volume, run xfs_repair, and then remount it. This problem
>  causes seriously impact of our service.

Anyway, next time it happens, can you please run xfs_check on the
filesystem first and post the output? If there is no output, then
the filesystem is fine and you don't need to run repair.

If it is not fine, can also post the output of xfs_repair?

Once the filesystem has been fixed up, can you then post the
output of this command to tell us the space usage in the filesystems?

# xfs_db -r -c 'sb 0' -c p <dev>

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
