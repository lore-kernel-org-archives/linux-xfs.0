Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o1H4fDtY205323 for <xfs@oss.sgi.com>; Tue, 16 Feb 2010 22:41:13 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4B77C13B08D0
	for <xfs@oss.sgi.com>; Tue, 16 Feb 2010 20:42:30 -0800 (PST)
Received: from mail.internode.on.net (bld-mail18.adl2.internode.on.net
	[150.101.137.103]) by cuda.sgi.com with ESMTP id
	H0I4P7qpQtCDTu0p for <xfs@oss.sgi.com>;
	Tue, 16 Feb 2010 20:42:30 -0800 (PST)
Date: Wed, 17 Feb 2010 15:42:27 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: stop passing opaque handles to xfs_log.c routines
Message-ID: <20100217044227.GO28392@discord.disaster>
References: <20100215233454.GB28817@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100215233454.GB28817@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Mon, Feb 15, 2010 at 06:34:54PM -0500, Christoph Hellwig wrote:
> Currenly we pass opaque xfs_log_ticket_t handles instead of struct
> xlog_ticket pointers, and void pointers instead of struct xlog_in_core
> pointers to various log manager functions.  Instead pass properly
> typed pointers after adding forward declarations for them to
> xfs_log.h, and adjust the touched function prototypes to the standard
> XFS style while at it.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

This is almost identical to a patch I've got in my stack ATM :)
Looks good.

Reviewed-by: Dave Chinner <david@fromorbit.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
