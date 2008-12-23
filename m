Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mBN0d1um016327 for <xfs@oss.sgi.com>; Mon, 22 Dec 2008 18:39:01 -0600
Message-ID: <49503378.2080508@sgi.com>
Date: Tue, 23 Dec 2008 11:40:24 +1100
From: Lachlan McIlroy <lachlan@sgi.com>
MIME-Version: 1.0
Subject: Re: [Fwd: [PATCH] Fix race in xfs_write() between direct and	buffered
	I/O with DMAPI]
References: <493779B1.3010703@sgi.com> <20081208225125.GA15647@infradead.org>
	<493DFDBD.7060909@sgi.com> <20081209092240.GA23915@infradead.org>
	<20081222085311.GB24795@infradead.org>
In-Reply-To: <20081222085311.GB24795@infradead.org>
Reply-To: lachlan@sgi.com
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs-oss <xfs@oss.sgi.com>

Christoph Hellwig wrote:
> Do you need more input on this one?

Actually I just might.  Based on your last reponse I wasn't sure if
you wanted me to make further changes.  Then I got side-tracked wondering
why we even have the 'goto retry' in the dmapi post event - why retry the
write if we get ENOSPC when we don't if dmapi is not enabled?  Could the
write get stuck in an infinite loop?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
