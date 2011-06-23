Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p5NIDQp0207291 for <xfs@oss.sgi.com>; Thu, 23 Jun 2011 13:13:26 -0500
Date: Thu, 23 Jun 2011 14:13:17 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2] xfs: Silence bounds checking compiler warning
Message-ID: <20110623181317.GA26945@infradead.org>
References: <4E037001.8090306__42924.0493024283$1308849791$gmane$org@gmail.com>
	<m2boxocvb5.fsf@firstfloor.org>
	<20110623175533.GK11521@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110623175533.GK11521@ZenIV.linux.org.uk>
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
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Maarten Lankhorst <m.b.lankhorst@gmail.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com, xfs-masters@oss.sgi.com, Andi Kleen <andi@firstfloor.org>, Alex Elder <aelder@sgi.com>

On Thu, Jun 23, 2011 at 06:55:33PM +0100, Al Viro wrote:
> ... and even better is to write in real C and have u8 name[]; in the
> end of your structure.  That's the standard C99 for this kind of thing
> (see 6.7.2.1p2, p16).  Zero-sized array is a gccism predating standard
> flexible array members and since the standard syntax is accepted by
> any gcc version that might be recent enough to build the kernel...

The situation is even more nasty - the one sized fake flex-array
actually is in the middle of the structure.  Besides sizeof-expressions
taking the one member array into account only members before the
variable sized array are used.  I've started a series cleaning up the
few structures that were done that way (for whatever reason), but it's
pretty intrusive.  I don't think papering over these warnings at this
point is a good idea.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
