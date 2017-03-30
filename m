Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:38840 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754328AbdC3DZs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 29 Mar 2017 23:25:48 -0400
Date: Wed, 29 Mar 2017 20:25:14 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: The XFS_IOC_FSGEOMETRY ioctl doesn't like fds that are opened
 O_PATH
Message-ID: <20170330032514.GE4874@birch.djwong.org>
References: <859.1490824354@warthog.procyon.org.uk>
 <29183.1490711359@warthog.procyon.org.uk>
 <5587.1490831828@warthog.procyon.org.uk>
 <20170330002328.GD4864@birch.djwong.org>
 <20170330025620.GA789@zzz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170330025620.GA789@zzz>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Biggers <ebiggers3@gmail.com>
Cc: David Howells <dhowells@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>, Andreas Dilger <adilger@dilger.ca>, Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org, Eric Sandeen <sandeen@sandeen.net>

On Wed, Mar 29, 2017 at 07:56:20PM -0700, Eric Biggers wrote:
> On Wed, Mar 29, 2017 at 05:23:28PM -0700, Darrick J. Wong wrote:
> > On Thu, Mar 30, 2017 at 12:57:08AM +0100, David Howells wrote:
> > > Should XFS_IOC_FSGEOMETRY work on fds that are opened O_PATH on an XFS
> > > filesystem?  Or should xfs_io not call that ioctl on O_PATH fds?
> > 
> > Given that read/write don't work under O_PATH, I wouldn't expect ioctls
> > to work either.
> > 
> > I tried to write a two line program to call FSGEOMETRY to see what
> > actually happens but got so bogged down in trying to figure out what
> > magic incantation of C headers one needs to pull in the appropriate
> > structure typedefs for an ioctl I wasn't even trying to call that I gave
> > up.
> > 
> > Seriously, what the f*ck do you have to #include just to be able to use
> > O_PATH?
> 
> From open(2):
> 
>       "The O_DIRECT, O_NOATIME, O_PATH, and  O_TMPFILE  flags  are
>       Linux-specific.  One must define _GNU_SOURCE to obtain their definitions."

Ah, thank you.  I missed that, having skipped straight to the section on
O_PATH... ($deity I hate userspace)

> Also, ioctl() with an O_PATH file descriptor always fails with EBADF because
> sys_ioctl() uses fdget() rather than fdget_raw().  The filesystem isn't involved
> at all.  This is intentional, I believe.

Yes, it is.

--D

> 
> - Eric
