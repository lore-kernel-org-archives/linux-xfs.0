Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:32805 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754551AbdC3C4Y (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 29 Mar 2017 22:56:24 -0400
Date: Wed, 29 Mar 2017 19:56:20 -0700
From: Eric Biggers <ebiggers3@gmail.com>
Subject: Re: The XFS_IOC_FSGEOMETRY ioctl doesn't like fds that are opened
 O_PATH
Message-ID: <20170330025620.GA789@zzz>
References: <859.1490824354@warthog.procyon.org.uk>
 <29183.1490711359@warthog.procyon.org.uk>
 <5587.1490831828@warthog.procyon.org.uk>
 <20170330002328.GD4864@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170330002328.GD4864@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: David Howells <dhowells@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>, Andreas Dilger <adilger@dilger.ca>, Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org, Eric Sandeen <sandeen@sandeen.net>

On Wed, Mar 29, 2017 at 05:23:28PM -0700, Darrick J. Wong wrote:
> On Thu, Mar 30, 2017 at 12:57:08AM +0100, David Howells wrote:
> > Should XFS_IOC_FSGEOMETRY work on fds that are opened O_PATH on an XFS
> > filesystem?  Or should xfs_io not call that ioctl on O_PATH fds?
> 
> Given that read/write don't work under O_PATH, I wouldn't expect ioctls
> to work either.
> 
> I tried to write a two line program to call FSGEOMETRY to see what
> actually happens but got so bogged down in trying to figure out what
> magic incantation of C headers one needs to pull in the appropriate
> structure typedefs for an ioctl I wasn't even trying to call that I gave
> up.
> 
> Seriously, what the f*ck do you have to #include just to be able to use
> O_PATH?

>From open(2):

      "The O_DIRECT, O_NOATIME, O_PATH, and  O_TMPFILE  flags  are
      Linux-specific.  One must define _GNU_SOURCE to obtain their definitions."

Also, ioctl() with an O_PATH file descriptor always fails with EBADF because
sys_ioctl() uses fdget() rather than fdget_raw().  The filesystem isn't involved
at all.  This is intentional, I believe.

- Eric
