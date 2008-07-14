Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 14 Jul 2008 16:02:02 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m6EN1xlD022967
	for <xfs@oss.sgi.com>; Mon, 14 Jul 2008 16:02:00 -0700
Received: from ipmail01.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id DC90B2EF126
	for <xfs@oss.sgi.com>; Mon, 14 Jul 2008 16:03:04 -0700 (PDT)
Received: from ipmail01.adl6.internode.on.net (ipmail01.adl6.internode.on.net [203.16.214.146]) by cuda.sgi.com with ESMTP id HI6WhCJdqUZ44sBJ for <xfs@oss.sgi.com>; Mon, 14 Jul 2008 16:03:04 -0700 (PDT)
Date: Tue, 15 Jul 2008 09:03:00 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: question about xfs_fsync on linux
Message-ID: <20080714230300.GY29319@disturbed>
References: <200807142213.m6EMDeE23640@elf.torek.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200807142213.m6EMDeE23640@elf.torek.net>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Chris Torek <chris.torek@windriver.com>
Cc: xfs@oss.sgi.com

On Mon, Jul 14, 2008 at 04:13:40PM -0600, Chris Torek wrote:
> The implementation of xfs_fsync() in 2.6.2x, for reasonably late x,
> reads as follows in xfs_vnodeops.c:

What kernel(s), exactly, is/are showing this problem?

> 	error = filemap_fdatawait(vn_to_inode(XFS_ITOV(ip))->i_mapping);
> 
> We have a customer who is seeing data not "make it" to disk on a
> stress test that involves doing an fsync() or fdatasync() and then
> deliberately rebooting the machine (to simulate a failure; note
> that the underlying RAID has its own battery backup and this is
> just one of many different parts of the stress-test).

What is the symptom? The file size does not change? The file the
right size but has no data in it?

> Looking into this, I am now wondering if this call should read:
> 
> 	error = filemap_write_and_wait(vn_to_inode(XFS_ITOV(ip))->i_mapping);
> 
> instead.

No, the filemap_fdatawrite() has already been executed by this
point. We only need to wait for I/O completion here. See do_fsync():

 78 long do_fsync(struct file *file, int datasync)
 79 {
.....
 90         ret = filemap_fdatawrite(mapping);
.....
 97         err = file->f_op->fsync(file, file->f_path.dentry, datasync);
.....

The ->fsync() method in XFS is xfs_fsync()....

However, I do ask exactly what kernel version you are running,
because this mod that has gone into 2.6.26:

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=978b7237123d007b9fa983af6e0e2fa8f97f9934

might be the fix you need for .24 or .25 kernels, (not sure about .22 or .23
where all this changed, nor .21 or earlier which I don't think even had the
wait...)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
