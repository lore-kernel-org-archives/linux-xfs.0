Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n7GEPrFF256398 for <xfs@oss.sgi.com>; Sun, 16 Aug 2009 09:26:08 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 479851B6FF1A
	for <xfs@oss.sgi.com>; Sun, 16 Aug 2009 07:26:41 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id vLsJbcSoBt3Z807f for
	<xfs@oss.sgi.com>; Sun, 16 Aug 2009 07:26:41 -0700 (PDT)
Date: Sun, 16 Aug 2009 10:23:31 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH, RFC] xfs: batched discard support
Message-ID: <20090816142331.GA4284@infradead.org>
References: <20090816004705.GA7347@infradead.org> <4A876255.10606@rtr.ca>
	<4A876CA9.20906@rtr.ca> <20090816022500.GA12392@infradead.org>
	<4A8802F3.6010908@rtr.ca> <4A8810C4.3050800@rtr.ca>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4A8810C4.3050800@rtr.ca>
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
To: Mark Lord <liml@rtr.ca>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, IDE/ATA development list <linux-ide@vger.kernel.org>, jens.axboe@oracle.com, linux-fsdevel@vger.kernel.org

On Sun, Aug 16, 2009 at 09:59:32AM -0400, Mark Lord wrote:
> Okay, I got Matthews patches updated onto 2.6.31, and fixed the incompatibilities
> between those and the XFS TRIM patch (from Christoph), plus a sector_t printk issue.
>
> My apologies for attachments, but I am attaching the updated Christoph patch,
> as well as my hacked-up forward-port of Matthew's patches.
>
> Not pretty, but they work.  :)
>
> Now.. running Christoph's "xfs trim" on a 4.6GB mostly already-trimmed
> XFS partition gave this for the first time around:

> The problem is, it still issues TRIMs to the LLD one extent at a time.
> Compare this with doing it all in a single TRIM command
> with the wiper.sh script (filesystem unmounted):

I could do a variant which issues a single TRIM, but that would require
us to lock out all other allocations for the time the trim takes.  I'll
hack that up once I get some time.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
