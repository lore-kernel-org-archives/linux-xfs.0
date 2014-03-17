Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 29F9B7F5D
	for <xfs@oss.sgi.com>; Sun, 16 Mar 2014 19:29:28 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 0DC4D304039
	for <xfs@oss.sgi.com>; Sun, 16 Mar 2014 17:29:24 -0700 (PDT)
Received: from ZenIV.linux.org.uk (zeniv.linux.org.uk [195.92.253.2]) by
	cuda.sgi.com with ESMTP id YqQ8T0F6tvCWbiQR (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sun, 16 Mar 2014 17:29:23 -0700 (PDT)
Date: Mon, 17 Mar 2014 00:29:18 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: fs corruption exposed by "xfs: increase prealloc size to double
	that of the previous extent"
Message-ID: <20140317002918.GT18016@ZenIV.linux.org.uk>
References: <20140315210216.GP18016@ZenIV.linux.org.uk>
	<20140317001130.GA7072@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140317001130.GA7072@dastard>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: linux-fsdevel@vger.kernel.org, Brian Foster <bfoster@redhat.com>, xfs@oss.sgi.com, Dave Chinner <dchinner@redhat.com>

On Mon, Mar 17, 2014 at 11:11:30AM +1100, Dave Chinner wrote:

> Yes, we've known about this since 2011.  Right - that's a long
> standing problem, and one I've never been able to isolate and so
> reproduce with any luck. It can only be reproduced when you use mmap
> and direct IO on the same file, and every time I've added debug to
> find out where the tail block corruption was being introduced, the
> data corruption goes away. It behaves just like a race condition....

See downthread.  And I would be *very* surprised if it was a race -
don't forget the msync() done before that write().

I think I know what's going on - O_DIRECT write starting a bit before
EOF on a file with the last extent that can be grown.  It fills
a buffer_head with b_size extending quite a bit past the EOF; the
blocks are really allocated.  What causes the problem is that we
have the flags set for the *first* block.  IOW, buffer_new(bh) is
false - the first block has already been allocated.  And for
direct-io.c it means "no zeroing the tail of the last block".

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
