Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0NCTuaE185539 for <xfs@oss.sgi.com>; Sat, 23 Jan 2010 06:29:56 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D871412F5E34
	for <xfs@oss.sgi.com>; Sat, 23 Jan 2010 04:30:57 -0800 (PST)
Received: from mail.internode.on.net (bld-mail16.adl2.internode.on.net
	[150.101.137.101]) by cuda.sgi.com with ESMTP id
	5PjdHBa8MwD7H3rz for <xfs@oss.sgi.com>;
	Sat, 23 Jan 2010 04:30:57 -0800 (PST)
Date: Sat, 23 Jan 2010 23:30:53 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: nfs performance delta between filesystems
Message-ID: <20100123123053.GF25842@discord.disaster>
References: <20100122185419.63ae6430@harpe.intellique.com>
	<20100122183848.GB28561@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100122183848.GB28561@sgi.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: bpm@sgi.com
Cc: xfs@oss.sgi.com

On Fri, Jan 22, 2010 at 12:38:48PM -0600, bpm@sgi.com wrote:
> Hey Emmanuel,
> 
> I did some research on this in April last year on an old, old kernel.
> One of the codepaths I flagged:
> 
> nfsd_create
>   write_inode_now
>     __sync_single_inode
>       write_inode
>         xfs_fs_write_inode
> 	  xfs_inode_flush
> 	    xfs_iflush
> 
> There were small gains to be had by reordering the sync of the parent and
> child syncs where the two inodes were in the same cluster.  The larger
> problem seemed to be that we're not treating the log as stable storage.
> By calling write_inode_now we've written the changes to the log first
> and then gone and also written them out to the inode.  

Pretty much right, but there are historical reasons for that
behaviour. The ->write_inode() path is the only
method for the higher layers to say "write this inode to disk".
That's how XFS has been treating it for a long time - as a command
to _physically_ write a dirty inode some time after it was first
changed and the transaction is already on disk.

Unfortunately, NFS is using the same call for is a method for saying
"commit this changed inode to disk immediately", which is a
different semantic to the way the sync code uses it and physical
inode IO really hurts here.

> nfsd_create, nfsd_link, and nfsd_setattr all do this (or do in the old
> kernel I'm looking at).  I have a patchset that changes
> this to an fsync so we force the log and call it good.  I'll be happy to
> dust it off if someone hasn't already addressed this situation.

The delayed write inode flushing patchset I'm finalising does this.
We now have reliable tracking of dirty inodes in XFS and a method
for efficient physical writeback, so we no longer need to rely on
->write_inode to tell us to write inodes to disk. Hence the patchset
turns the inode write into a an xfs_fsync() if it is a sync write or
a delayed write if it is async.  I'm hoping to have that ready for
.34 inclusion sometime next week...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
