Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q3DN4tmx111883 for <xfs@oss.sgi.com>; Fri, 13 Apr 2012 18:04:55 -0500
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	dqHV6pGTmLe8f78l for <xfs@oss.sgi.com>;
	Fri, 13 Apr 2012 16:04:53 -0700 (PDT)
Date: Sat, 14 Apr 2012 09:04:51 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 02/18] xfs: pass shutdown method into
	xfs_trans_ail_delete_bulk
Message-ID: <20120413230451.GS6734@dastard>
References: <1334319061-12968-1-git-send-email-david@fromorbit.com>
	<1334319061-12968-3-git-send-email-david@fromorbit.com>
	<4F88651E.2030908@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4F88651E.2030908@sgi.com>
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
To: Mark Tinguely <tinguely@sgi.com>
Cc: xfs@oss.sgi.com

On Fri, Apr 13, 2012 at 12:40:46PM -0500, Mark Tinguely wrote:
> On 04/13/12 07:10, Dave Chinner wrote:
> >From: Dave Chinner<dchinner@redhat.com>
> >
> >xfs_trans_ail_delete_bulk() can be called from different contexts so
> >if the item is not in the AIL we need different shutdown for each
> >context.  Pass in the shutdown method needed so the correct action
> >can be taken.
> >
> >Signed-off-by: Dave Chinner<dchinner@redhat.com>
> >Reviewed-by: Christoph Hellwig<hch@lst.de>
> >Reviewed-by: Mark Tinguely<tinguely@sgi.com>
> 
> 
> 
> These items in my copy of Christoph's xfsbufd series are not
> resolved in this patch:

Ah, oh, that's my fault. I re-ordered the series so that all my
patches were after christoph's, and when reapplying christophs
patches from my series there were a few merge conflicts I obviously
didn't resolve correctly.

I'll fix my tree up and repost this patch.

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
