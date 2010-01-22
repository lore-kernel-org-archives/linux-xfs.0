Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0MIbOX1134466 for <xfs@oss.sgi.com>; Fri, 22 Jan 2010 12:37:25 -0600
Date: Fri, 22 Jan 2010 12:38:48 -0600
From: bpm@sgi.com
Subject: Re: nfs performance delta between filesystems
Message-ID: <20100122183848.GB28561@sgi.com>
References: <20100122185419.63ae6430@harpe.intellique.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100122185419.63ae6430@harpe.intellique.com>
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
To: Emmanuel Florac <eflorac@intellique.com>
Cc: xfs@oss.sgi.com

Hey Emmanuel,

I did some research on this in April last year on an old, old kernel.
One of the codepaths I flagged:

nfsd_create
  write_inode_now
    __sync_single_inode
      write_inode
        xfs_fs_write_inode
	  xfs_inode_flush
	    xfs_iflush

There were small gains to be had by reordering the sync of the parent and
child syncs where the two inodes were in the same cluster.  The larger
problem seemed to be that we're not treating the log as stable storage.
By calling write_inode_now we've written the changes to the log first
and then gone and also written them out to the inode.  

nfsd_create, nfsd_link, and nfsd_setattr all do this (or do in the old
kernel I'm looking at).  I have a patchset that changes
this to an fsync so we force the log and call it good.  I'll be happy to
dust it off if someone hasn't already addressed this situation.

-Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
