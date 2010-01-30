Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0UHO5YM224520 for <xfs@oss.sgi.com>; Sat, 30 Jan 2010 11:24:06 -0600
Received: from thunker.thunk.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9B01513661FB
	for <xfs@oss.sgi.com>; Sat, 30 Jan 2010 09:25:10 -0800 (PST)
Received: from thunker.thunk.org (THUNK.ORG [69.25.196.29]) by cuda.sgi.com
	with ESMTP id SVVnlsaI4AVSKgMJ for <xfs@oss.sgi.com>;
	Sat, 30 Jan 2010 09:25:10 -0800 (PST)
Date: Sat, 30 Jan 2010 12:25:02 -0500
From: tytso@mit.edu
Subject: Re: [PATCH] xfstests 224: test aio hole-fill at 4g
Message-ID: <20100130172502.GA788@thunk.org>
References: <4B633F9A.8000404@sandeen.net>
	<20100130105501.GA22909@infradead.org> <4B645B0D.205@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4B645B0D.205@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Christoph Hellwig <hch@infradead.org>, ext4 development <linux-ext4@vger.kernel.org>, Giel de Nijs <giel@vectorwise.com>, xfs-oss <xfs@oss.sgi.com>

On Sat, Jan 30, 2010 at 10:15:09AM -0600, Eric Sandeen wrote:
> > me on a 32-bit machine.  The patch below fixes it up, but it seems like
> > we should rather add a variant of that code as aio_read/write commands
> > to xfs_io instead of adding a new test program.
> 
> ok, that's probably better - again, though, it takes at least a release
> cycle before most folks can test it.  But I guess that's not the end of
> the world.

Stupid question --- who uses xfs_io besides xfstests?  Any chance we
could consider dropping in some version of xfs_io into xfstests, or
actually moving it into xfstests from xfsprogs if xfstests is the
exclusive user of that program?  I've been trying to get more people
to use xfstests, since it would be good if more companies and more
projects were using it --- and one of the things that makes it hard is
all of the dependencies that it has.  If there was some way we could
gradually make xfstests more self-contained, it would certainly be
nice.

						- Ted

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
