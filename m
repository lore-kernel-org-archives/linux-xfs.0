Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n9FCCFYR009410
	for <linux-xfs@oss.sgi.com>; Thu, 15 Oct 2009 07:12:18 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 691181D7F49B
	for <linux-xfs@oss.sgi.com>; Thu, 15 Oct 2009 05:13:45 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id 4iLnexkkSKwNHWt2 for
	<linux-xfs@oss.sgi.com>; Thu, 15 Oct 2009 05:13:45 -0700 (PDT)
Date: Thu, 15 Oct 2009 08:13:45 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: deadlocks with fallocate
Message-ID: <20091015121345.GA18234@infradead.org>
References: <hak2l2$ko2$1@ger.gmane.org> <20091014150951.GA13123@infradead.org>
	<200910150758.06003.tneumann@users.sourceforge.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <200910150758.06003.tneumann@users.sourceforge.net>
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
To: Thomas Neumann <tneumann@users.sourceforge.net>
Cc: Christoph Hellwig <hch@infradead.org>, linux-xfs@oss.sgi.com

On Thu, Oct 15, 2009 at 07:58:05AM +0200, Thomas Neumann wrote:
> I did some more tests, and indeed the patch makes the deadlock go away. Your 
> description of it as a hack makes me somewhat concerned about using it 
> permanently, but hopefully you will find a proper solution ;)

It's basically a flag to say all allocations from this thread should
not recurse back into filesystem code.  I'll either need to change
the allocations manually or keep this flag and write a comment
documenting why.  I'll decide what to on my long airplane ride tomorrow
and will make sure it goes off to Linus' tree ASAP after that.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
