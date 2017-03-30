Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:10898 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932864AbdC3ID6 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 30 Mar 2017 04:03:58 -0400
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20170330025620.GA789@zzz>
References: <20170330025620.GA789@zzz> <859.1490824354@warthog.procyon.org.uk> <29183.1490711359@warthog.procyon.org.uk> <5587.1490831828@warthog.procyon.org.uk> <20170330002328.GD4864@birch.djwong.org>
Subject: Re: The XFS_IOC_FSGEOMETRY ioctl doesn't like fds that are opened O_PATH
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <8866.1490861034.1@warthog.procyon.org.uk>
Date: Thu, 30 Mar 2017 09:03:54 +0100
Message-ID: <8867.1490861034@warthog.procyon.org.uk>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Biggers <ebiggers3@gmail.com>
Cc: dhowells@redhat.com, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs <linux-xfs@vger.kernel.org>, Andreas Dilger <adilger@dilger.ca>, Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org, Eric Sandeen <sandeen@sandeen.net>

Eric Biggers <ebiggers3@gmail.com> wrote:

> Also, ioctl() with an O_PATH file descriptor always fails with EBADF because
> sys_ioctl() uses fdget() rather than fdget_raw().  The filesystem isn't
> involved at all.  This is intentional, I believe.

Yeah.  Apparently so, though some ioctls might make sense if they're asking
about the filesystem.

Anyway, I need to fix xfs_io for that now too if I'm going to use that.  I
wonder what xfs_io needs the geometry for.

I'm getting the impression xfs_io isn't really the tool I should be using for
this.

Dvid
