Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p72APNJg097769 for <xfs@oss.sgi.com>; Tue, 2 Aug 2011 05:25:23 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 17B9812F4322
	for <xfs@oss.sgi.com>; Tue,  2 Aug 2011 03:26:05 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	jKDO85AEDkK6MQtL for <xfs@oss.sgi.com>;
	Tue, 02 Aug 2011 03:26:05 -0700 (PDT)
Date: Tue, 2 Aug 2011 06:25:16 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] jfs: flush journal completely before releasing metadata
	inodes
Message-ID: <20110802102516.GA24575@infradead.org>
References: <20110729155039.GA28306@infradead.org>
	<4E32D9EB.9020406@oracle.com> <4E36F086.4070900@oracle.com>
	<20110801183255.GA30985@infradead.org>
	<4E3706D0.1000304@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4E3706D0.1000304@oracle.com>
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
To: Dave Kleikamp <dave.kleikamp@oracle.com>
Cc: jfs-discussion@lists.sourceforge.net, xfs@oss.sgi.com

On Mon, Aug 01, 2011 at 03:04:32PM -0500, Dave Kleikamp wrote:
> It runs through them all. A lot of tests get skipped claiming not to be
> supported on jfs. A failure because jfs doesn't support fallocate and
> hole-punch, but no crashes.

Looks like the fallocate feature tests are broken, I'll look into fixing
it.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
