Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mBN8ekro029108 for <xfs@oss.sgi.com>; Tue, 23 Dec 2008 02:40:46 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C386C177B7F2
	for <xfs@oss.sgi.com>; Tue, 23 Dec 2008 00:40:44 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id e0yAQLWCDrHQQLMk for
	<xfs@oss.sgi.com>; Tue, 23 Dec 2008 00:40:44 -0800 (PST)
Date: Tue, 23 Dec 2008 03:40:13 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [Fwd: [PATCH] Fix race in xfs_write() between direct and
	buffered I/O with DMAPI]
Message-ID: <20081223084013.GA7604@infradead.org>
References: <493779B1.3010703@sgi.com> <20081208225125.GA15647@infradead.org>
	<493DFDBD.7060909@sgi.com> <20081209092240.GA23915@infradead.org>
	<20081222085311.GB24795@infradead.org> <49503378.2080508@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <49503378.2080508@sgi.com>
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
To: Lachlan McIlroy <lachlan@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs-oss <xfs@oss.sgi.com>

On Tue, Dec 23, 2008 at 11:40:24AM +1100, Lachlan McIlroy wrote:
> Christoph Hellwig wrote:
> > Do you need more input on this one?
> 
> Actually I just might.  Based on your last reponse I wasn't sure if
> you wanted me to make further changes.

Well, my reponse was that I think we could do it more effecient, but the
patch still looks correct to me.

> Then I got side-tracked wondering
> why we even have the 'goto retry' in the dmapi post event - why retry the
> write if we get ENOSPC when we don't if dmapi is not enabled?  Could the
> write get stuck in an infinite loop?

We only retry on ENOSPC if the dmapi nospace even is enabled, or am I
missing something?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
