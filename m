Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mBTJsbZk021212 for <xfs@oss.sgi.com>; Mon, 29 Dec 2008 13:54:38 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B4BC81793F4B
	for <xfs@oss.sgi.com>; Mon, 29 Dec 2008 11:54:37 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id n6HpPPcLCCqpMm21 for
	<xfs@oss.sgi.com>; Mon, 29 Dec 2008 11:54:37 -0800 (PST)
Date: Mon, 29 Dec 2008 14:54:06 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: safe writing in applications (was: Re: massively truncated
	files with XFS with sudden power loss on 2.6.27 and 2.6.28)
Message-ID: <20081229195406.GA7613@infradead.org>
References: <200812291920.34123.Martin@Lichtvoll.de>
	<200812292048.41193.Martin@lichtvoll.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <200812292048.41193.Martin@lichtvoll.de>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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
To: Martin Steigerwald <Martin@lichtvoll.de>
Cc: xfs@oss.sgi.com

On Mon, Dec 29, 2008 at 08:48:40PM +0100, Martin Steigerwald wrote:
> It might be wise however to file enhancement requests for the KDE 
> applications where I observed this behavior if safer writing within the 
> applications is possible. Any hints on what application developers should 
> keep in mind when writing out config files?

Preferably use O_SYNC.  Never truncate and then rewrite, in doubt write
a new file and rename it to the right place after it was fsync'ed (the
mailserver trick)

in the meantime a nice way to hack around this is do chattr +S for all
these files which forces synchronous writes.  Doesn't help if they
actually use the rename trick above sometimes.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
