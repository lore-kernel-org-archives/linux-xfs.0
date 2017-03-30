Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:41492 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933041AbdC3AYP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 29 Mar 2017 20:24:15 -0400
Date: Wed, 29 Mar 2017 17:23:28 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: The XFS_IOC_FSGEOMETRY ioctl doesn't like fds that are opened
 O_PATH
Message-ID: <20170330002328.GD4864@birch.djwong.org>
References: <859.1490824354@warthog.procyon.org.uk>
 <29183.1490711359@warthog.procyon.org.uk>
 <5587.1490831828@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5587.1490831828@warthog.procyon.org.uk>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: David Howells <dhowells@redhat.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>, Andreas Dilger <adilger@dilger.ca>, Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org, Eric Sandeen <sandeen@sandeen.net>

On Thu, Mar 30, 2017 at 12:57:08AM +0100, David Howells wrote:
> Should XFS_IOC_FSGEOMETRY work on fds that are opened O_PATH on an XFS
> filesystem?  Or should xfs_io not call that ioctl on O_PATH fds?

Given that read/write don't work under O_PATH, I wouldn't expect ioctls
to work either.

I tried to write a two line program to call FSGEOMETRY to see what
actually happens but got so bogged down in trying to figure out what
magic incantation of C headers one needs to pull in the appropriate
structure typedefs for an ioctl I wasn't even trying to call that I gave
up.

Seriously, what the f*ck do you have to #include just to be able to use
O_PATH?

--D

> 
> David
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
