Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:29921 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725917AbeI1EkV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 28 Sep 2018 00:40:21 -0400
Date: Fri, 28 Sep 2018 08:19:48 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Leaking Path in XFS's ioctl interface(missing LSM check)
Message-ID: <20180927221948.GH31060@dastard>
References: <5EF0D46A-C098-4B51-AD13-225FFCA35D4C@vt.edu>
 <20180926013329.GD31060@dastard>
 <20180926192426.472360ea@alans-desktop>
 <20180927013812.GF31060@dastard>
 <alpine.LRH.2.21.1809280720330.8410@namei.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.21.1809280720330.8410@namei.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: James Morris <jmorris@namei.org>
Cc: Alan Cox <gnomes@lxorguk.ukuu.org.uk>, TongZhang <ztong@vt.edu>, darrick.wong@oracle.com, linux-xfs@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, linux-security-module@vger.kernel.org, Wenbo Shen <shenwenbosmile@gmail.com>

On Fri, Sep 28, 2018 at 07:23:42AM +1000, James Morris wrote:
> On Thu, 27 Sep 2018, Dave Chinner wrote:
> 
> > Sure, but there are so many CAP_SYS_ADMIN-only ioctls in the kernel
> > that have no LSM coverage that this is not an isolated problem that
> > people setting up such systems have to deal with. 
> 
> I could be missing something here, but all ioctls are mediated by LSM at a 
> high level (security_file_ioctl). Some problematic ones are singled out at 
> that point by LSMs for special handling.

selinux_file_ioctl() checks whether a specific /file/ has
permissions to execute ioctls, but it doesn't know anything about
what that ioctl actually does. It has special cases for a handful of
ioctls, but misses a large number of ioctls that perform similar
functionality (e.g. file getattr/setattr type ioctls).

smack just checks for read/write permissions depending on the
IOW/IOR/IORW definition of the ioctl.  Tomoyo does a path check
based on the path associated with the file passed to it to see if an
ioctl can be run.

IOWs, none of there really know anything about what the ioctl does,
and they sure as hell don't check any of the arguments for other
file descriptors that the ioctl might be accessing. It's basically a
"does we allow ioctls to this inode/path from this user?" check and
nothing more.

That just doesn't work for ioctls structured like the XFS filehandle
operations. The ioctl is performed on a "fshandle" file descriptor,
which generally points at the root directory of the filesystem the
file handle belongs to. This gives the ioctl the superblock context
that it is to operate on, and nothing more. It then opens a new file
based on the filehandle that was in the ioctl argument, and performs
the required operation on that file it opened itself.

IOWs, the security_file_ioctl() hook is almost completely useless in
cases like this - you can't isolate the ioctl based on the file
argument, because it can point to any file or directory in the
filesystem. And without actually parsing, decoding and instantiating
the the ioctl arguments, you can't tell the ioctl it can't act on
specific targets. And because filehandle to dentry resolution
results in disconnected dentries, the paths are not complete and
hence path based security checks (e.g. tomoyo) are likely to be
broken and unfixable...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
