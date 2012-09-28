Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q8SCXmWx222602 for <xfs@oss.sgi.com>; Fri, 28 Sep 2012 07:33:48 -0500
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	iPHGHfvQbAr0O1uG (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Fri, 28 Sep 2012 05:35:07 -0700 (PDT)
Date: Fri, 28 Sep 2012 08:35:06 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 07/13] xfs: syncd workqueue is no more
Message-ID: <20120928123506.GE14284@infradead.org>
References: <1348807485-20165-1-git-send-email-david@fromorbit.com>
	<1348807485-20165-8-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1348807485-20165-8-git-send-email-david@fromorbit.com>
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

On Fri, Sep 28, 2012 at 02:44:39PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> With the syncd functions moved to the log and/or removed, the syncd
> workqueue is the only remaining bit left. It is used by the log
> covering/ail pushing work, as well as by the inode reclaim work.
> 
> Given how cheap workqueues are these days, give the log and inode
> reclaim work their own work queues and kill the syncd work queue.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
