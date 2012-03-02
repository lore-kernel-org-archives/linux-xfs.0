Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q227p5aq012815 for <xfs@oss.sgi.com>; Fri, 2 Mar 2012 01:51:06 -0600
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	VWD4UL6oBusj4lE8 (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Thu, 01 Mar 2012 23:51:05 -0800 (PST)
Date: Fri, 2 Mar 2012 02:51:04 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 8/8] xfs: add a shrinker for quotacheck
Message-ID: <20120302075104.GG4117@infradead.org>
References: <1330661507-1121-1-git-send-email-david@fromorbit.com>
	<1330661507-1121-9-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1330661507-1121-9-git-send-email-david@fromorbit.com>
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
Cc: xfs@oss.sgi.com

Hmm, I don't like this complication all that much.

Why would we even bother caching inodes during quotacheck?  The bulkstat
is a 100% sequential read only workload going through all inodes in the
filesystem.  I think we should simply not cache any inodes while in
quotacheck.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
