Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 8FACE7F54
	for <xfs@oss.sgi.com>; Wed, 12 Aug 2015 20:32:50 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 1598CAC005
	for <xfs@oss.sgi.com>; Wed, 12 Aug 2015 18:32:49 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	XKhGTh6QIbmj5N0c for <xfs@oss.sgi.com>;
	Wed, 12 Aug 2015 18:32:46 -0700 (PDT)
Date: Thu, 13 Aug 2015 11:32:44 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/8] xfs: Introduce writeback context for writepages
Message-ID: <20150813013244.GP3902@dastard>
References: <1439333388-16452-1-git-send-email-david@fromorbit.com>
	<1439333388-16452-2-git-send-email-david@fromorbit.com>
	<20150812072635.GA32399@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150812072635.GA32399@infradead.org>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Wed, Aug 12, 2015 at 12:26:35AM -0700, Christoph Hellwig wrote:
> Introducing this separate from the actual users is a bit odd to follow.
> Compare to my patch from a few years ago:
> 
> http://thread.gmane.org/gmane.comp.file-systems.xfs.general/39030/focus=39009

I completely forgot you did this. I'll go back and look at it
and see what I can pull from it. Thanks for the reminder, Christoph.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
