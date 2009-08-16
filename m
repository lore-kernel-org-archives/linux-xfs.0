Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n7GDqtew254627 for <xfs@oss.sgi.com>; Sun, 16 Aug 2009 08:53:10 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 220821D5A49B
	for <xfs@oss.sgi.com>; Sun, 16 Aug 2009 06:53:20 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id 6jzsWUuSPidO5LLH for
	<xfs@oss.sgi.com>; Sun, 16 Aug 2009 06:53:20 -0700 (PDT)
Date: Sun, 16 Aug 2009 09:53:15 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH, RFC] xfs: batched discard support
Message-ID: <20090816135315.GA25251@infradead.org>
References: <20090816004705.GA7347@infradead.org> <4A876255.10606@rtr.ca>
	<4A876CA9.20906@rtr.ca> <20090816022500.GA12392@infradead.org>
	<4A8802F3.6010908@rtr.ca>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4A8802F3.6010908@rtr.ca>
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
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, jens.axboe@oracle.com, linux-fsdevel@vger.kernel.org

On Sun, Aug 16, 2009 at 09:00:35AM -0400, Mark Lord wrote:
> Okay, this gives me ENOSYS now --> discard/trim support is missing from
> the lower layers.

ENOSYS or EOPNOTSUPP?

> What other patches do I need to make this work?
>
> The latest from Matthew's discard tree (May 2009) don't appear to be sufficient,
> even after updating them for 2.6.31-rc6.

Hmm.  That was kinda the reason why I didn't want to post stuff yet.  In
current mainline only MTD implements the prepare_discard_fn, and we'll
need it implemented and working.  I think Matthews patches should be
sufficient, unless they have some ATA revision check to not issue the
TRIM for your device.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
