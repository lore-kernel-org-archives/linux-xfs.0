Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7RIGtPv228101 for <xfs@oss.sgi.com>; Mon, 27 Aug 2012 13:16:56 -0500
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	f1OdDHW00tx0E90D (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Mon, 27 Aug 2012 11:17:44 -0700 (PDT)
Date: Mon, 27 Aug 2012 14:17:42 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 020/102] xfs: warn if direct reclaim tries to writeback
	pages
Message-ID: <20120827181742.GA13970@infradead.org>
References: <1345698180-13612-1-git-send-email-david@fromorbit.com>
	<1345698180-13612-21-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1345698180-13612-21-git-send-email-david@fromorbit.com>
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
Cc: Mel Gorman <mgorman@suse.de>, xfs@oss.sgi.com

On Thu, Aug 23, 2012 at 03:01:38PM +1000, Dave Chinner wrote:
> From: Mel Gorman <mgorman@suse.de>
> 
> Upstream commit: 94054fa3fca1fd78db02cb3d68d5627120f0a1d4
> 
> Direct reclaim should never writeback pages.  For now, handle the
> situation and warn about it.  Ultimately, this will be a BUG_ON.

Is this actually the case on 3.0-stable?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
