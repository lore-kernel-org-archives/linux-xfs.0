Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 15 Jun 2007 00:41:06 -0700 (PDT)
Received: from stitch.e-626.net (60.153.216.81.static.spa.siw.siwnet.net [81.216.153.60])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l5F7f1Wt001176
	for <xfs@oss.sgi.com>; Fri, 15 Jun 2007 00:41:02 -0700
Subject: Re: xfs_fsr allocation group optimization
From: Johan Andersson <johan@e-626.net>
In-Reply-To: <46723DC4.1080107@sgi.com>
References: <1181544692.19145.44.camel@gentoo-johan.transmode.se>
	 <20070612014452.GK86004887@sgi.com>  <46723DC4.1080107@sgi.com>
Content-Type: text/plain
Date: Fri, 15 Jun 2007 09:40:27 +0200
Message-Id: <1181893227.30958.24.camel@gentoo-johan.transmode.se>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Timothy Shimmin <tes@sgi.com>
Cc: David Chinner <dgc@sgi.com>, xfs@oss.sgi.com, Nathan Scott <nscott@aconex.com>

On Fri, 2007-06-15 at 17:20 +1000, Timothy Shimmin wrote:
> David Chinner wrote:
> > On Mon, Jun 11, 2007 at 08:51:32AM +0200, Johan Andersson wrote:
> >> Does anyone know of a good way to find one filename that points o a
> >> certain inode?
> > 
> > We need an rmap....
> > 
> > We have some prototype linux code that does parent pointers (i.e.
> > each inode has a back pointer to it's parent inode), but that, IIUC,
> > is a long way from prime-time. Tim?
> > 
> > Cheers,
> > 
> > Dave.
> 
> I don't know about a "long way" (longer to fully supported, yes)
> Firstly, I need to move its hooks out of linux-2.6/xfs_iops.c which were 
> referring to xfs inodes (instead of vnodes) probably back where they were in
> xfs_vnodeops.c.
> 
> Nathan, did you have some other suggestion than this - unfortunately,
> I haven't looked at this code (until recently) for a while.
> 
> Cheers,
> Tim.
> 

I have another idea that i plan to try. The idea was to add an ioctl to
"clone" an inode. By using the original inode (the one to be
defragmented) as parent "directory" in the call to xfs_dir_ialloc(), the
new inode should be allocated near the original inode. The fsr can then
open the new inode with jdm_open and proceed as normal.
This would also solve another problem that I see with fsr, the mtime of
every directory in the fs is updated when fsr is run. 

I do see one problem with this: If the defrag is aborted for some
reason, we can get orphaned inodes. Will fsck handle this?

/Johan Andersson
