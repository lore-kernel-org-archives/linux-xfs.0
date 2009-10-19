Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n9J3s8gS025484 for <xfs@oss.sgi.com>; Sun, 18 Oct 2009 22:54:08 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9C498A94553
	for <xfs@oss.sgi.com>; Sun, 18 Oct 2009 20:55:41 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id ewvjz8jYLO52hqgf for
	<xfs@oss.sgi.com>; Sun, 18 Oct 2009 20:55:41 -0700 (PDT)
Date: Sun, 18 Oct 2009 23:55:38 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: XFS mount failuer on RAID5
Message-ID: <20091019035538.GC18296@infradead.org>
References: <389deec70910152009i7656aaf2s9d929b8b68e4e740@mail.gmail.com>
	<200910161019.10286@zmi.at> <4AD890D1.4010208@sandeen.net>
	<200910172327.05122@zmi.at>
	<20091019013018.GQ9464@discord.disaster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20091019013018.GQ9464@discord.disaster>
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
Cc: Michael Monnerie <michael.monnerie@is.it-management.at>, xfs@oss.sgi.com

On Mon, Oct 19, 2009 at 12:30:18PM +1100, Dave Chinner wrote:
> 
> IIRC, the main reason for 4k sectors on MD RAID5/6 is that changing
> the IO alignment from 4k to 512 byte IOs (i.e. sub-page sized)
> causes MD to flush and invalidate the stripe cache. Hence every
> time XFS writes a super block, AGF, AGFL or AGI, things go much
> slower because of this flush/invalidate. By setting the sector size
> to 4k, the SB/AGF/AGFL/AGI are all 4k in size and hence IO alignment

This should not happen anymore with 2.6 series kernels.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
