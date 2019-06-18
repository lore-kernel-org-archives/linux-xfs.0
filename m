Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:55840 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730429AbfFRSyi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 Jun 2019 14:54:38 -0400
Date: Tue, 18 Jun 2019 11:54:32 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 1/9] libxfs: break out the GETXATTR/SETXATTR manpage
Message-ID: <20190618185432.GH5387@magnolia>
References: <155993574034.2343530.12919951702156931143.stgit@magnolia>
 <155993574662.2343530.11024375240678275350.stgit@magnolia>
 <1def4f4f-e938-76e2-2583-a07fc18b3ed8@sandeen.net>
 <20190615164332.GL3773859@magnolia>
 <d1930542-58e7-1709-3847-fe688b08d256@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d1930542-58e7-1709-3847-fe688b08d256@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: linux-xfs@vger.kernel.org

On Mon, Jun 17, 2019 at 09:55:44AM -0500, Eric Sandeen wrote:
> On 6/15/19 11:43 AM, Darrick J. Wong wrote:
> > On Fri, Jun 14, 2019 at 04:17:10PM -0500, Eric Sandeen wrote:
> >> On 6/7/19 2:29 PM, Darrick J. Wong wrote:
> >>> From: Darrick J. Wong <darrick.wong@oracle.com>
> >>>
> >>> Break out the xfs file attribute get and set ioctls into a separate
> >>> manpage to reduce clutter in xfsctl.
> >>
> >> <comes up for air>
> >>
> >> Now that we've uh, hoisted it to be a generic vfs interface,
> >> FS_IOC_FSGETXATTR, shouldn't we be documenting it as that instead
> >> of the (old) xfs variant?
> > 
> > No, first we document the old xfs ioctl, then we move the manpage over
> > to the main man-pages.git project as the vfs ioctl, and then we update
> > the xfsprogs manpage to say "Please refer to the VFS documentation but
> > in case your system doesn't have it, here you go..." :)
> 
> I guess it's kind of a sad state of affairs that I'm not quite sure
> if this is serious.  :)

It is, because the other implementers of this ioctl are not maintaining
the same behavior as xfs.  The first step to doing that is to document
our behaviors, and then get the code under testing.

Granted, those users (ext4/f2fs) aren't using most of the fields or
flags anyway so there's not a lot to test...

--D

> >>
> >> (honestly that'd be mostly just search and replace for this patch)
> >>
> >> Except of course XFS_IOC_FSGETXATTRA has no vfs variant.  :/
> >>
> >> I also wonder if FS_IOC_SETFLAGS should be mentioned, and/or a
> >> SEE_ALSO because some of the functionality overlaps?
> > 
> > Oh, wow, there's actually a manpage for it...
> > 
> > ...bleh, it's the weekend, I'll respond to the rest later.
> 
> ok thanks
> 
> -Eric
