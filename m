Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1DI2N7j029506 for <xfs@oss.sgi.com>; Mon, 13 Feb 2012 12:02:23 -0600
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	AVapgzmVak307Avn (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Mon, 13 Feb 2012 10:02:22 -0800 (PST)
Date: Mon, 13 Feb 2012 13:02:20 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: XFS unlink still slow on 3.1.9 kernel ?
Message-ID: <20120213180220.GA24163@infradead.org>
References: <4F394116.8080200@cape-horn-eng.com>
	<20120213170825.GA7197@infradead.org>
	<4F394442.9020307@cape-horn-eng.com>
	<20120213171556.GA13449@infradead.org>
	<4F3947D6.5060402@cape-horn-eng.com>
	<20120213172937.GA25248@infradead.org>
	<4F394E10.9000804@cape-horn-eng.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4F394E10.9000804@cape-horn-eng.com>
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
To: Richard Ems <richard.ems@cape-horn-eng.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Mon, Feb 13, 2012 at 06:53:20PM +0100, Richard Ems wrote:
> I will try to install a > 3.2 kernel and will create new XFS partitions
> with "-i size=1024", since we use ACLs a lot for user access.
> Is there a chance to change existing XFS partitions to "-i size=1024" ?

Unfortunately not.  Note that the speedups in 3.2 only matter for
out of line attributes - once you store the ACLs inside the inode the
code that makes it dog slow in old kernels is never used.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
