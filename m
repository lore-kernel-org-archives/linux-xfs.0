Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:49264 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725822AbfAaRlO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 31 Jan 2019 12:41:14 -0500
Date: Thu, 31 Jan 2019 09:40:59 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [RFC PATCH] ext4: add link file support for {GET,SET}XATTR ioctl
Message-ID: <20190131174059.GA10211@magnolia>
References: <1548899232-30311-1-git-send-email-wshilong1991@gmail.com>
 <20190131034106.GJ4205@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190131034106.GJ4205@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Wang Shilong <wangshilong1991@gmail.com>, linux-ext4@vger.kernel.org, linux-fs@vger.kernel.org, linux-xfs@vger.kernel.org, Wang Shilong <wshilong@ddn.com>, Andreas Dilger <adilger@dilger.ca>, Li Xi <lixi@ddn.com>

On Thu, Jan 31, 2019 at 02:41:06PM +1100, Dave Chinner wrote:
> On Thu, Jan 31, 2019 at 10:47:12AM +0900, Wang Shilong wrote:
> > From: Wang Shilong <wshilong@ddn.com>
> > 
> > Currently there is no way to change project ID of
> > symlink file itself, this is important to implement
> > Directory quota for an existed directory.
> 
> This seems like something open(O_PATH|O_NOFOLLOW) should allow.
> from open(2):

...but I thought O_PATH|O_NOFOLLOW file descriptions didn't allow ioctl
calls?

$ ln -sf urk /mnt/cow
$ xfs_io -c 'open -PL /mnt/cow' -c 'chproj 6'
setprojid: Bad file descriptor
$ ls -la /mnt/
lrwxrwxrwx 1 root root 3 Jan 31 09:30 /mnt/cow -> moo

> 	If pathname is a symbolic link and the O_NOFOLLOW flag is
> 	also specified, then the call returns a file  descriptor
> 	referring  to  the symbolic  link.  This  file  descriptor
> 	can  be used as the dirfd argument in calls to fchownat(2),
> 	fstatat(2), linkat(2), and read¿ linkat(2) with an empty
> 	pathname to have the calls operate on the symbolic link.
> 
> Changing the project id is the equivalent of fchownat().....

/me & others wonder (on the ext4 call) if maybe we should promote
project id to a vfs level concept?  i.e. store project id in struct
inode instead of the fs-specific inode structures.  Then we can use the
existing setattr infrastructure to persist those changes.

As for fchownat, how about a new flag that means "use the value in the
gid field to set the project id"?

--D

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
