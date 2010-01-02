Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o02BA7GL096292 for <xfs@oss.sgi.com>; Sat, 2 Jan 2010 05:10:08 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 72568137390
	for <xfs@oss.sgi.com>; Sat,  2 Jan 2010 03:10:57 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id B278Lgtk16zCsfE0 for
	<xfs@oss.sgi.com>; Sat, 02 Jan 2010 03:10:57 -0800 (PST)
Date: Sat, 2 Jan 2010 06:10:55 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/3] repair: compare superblock / AG headers fields
	against manual counts
Message-ID: <20100102111055.GA22222@infradead.org>
References: <20091201150503.958283878@bombadil.infradead.org>
	<20091201151037.707510379@bombadil.infradead.org>
	<20091230224314.GD13802@discord.disaster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20091230224314.GD13802@discord.disaster>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Thu, Dec 31, 2009 at 09:43:14AM +1100, Dave Chinner wrote:
> Might be worth a comment here saying that we are only calculating
> totals from the ABTC btree scan. OTOH, is is worth checking that the
> two btrees add up to the same number of free blocks, same maximum
> length extent, etc?

Yes, I'll look into adding that additional check.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
