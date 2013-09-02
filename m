Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 1BCB97F52
	for <xfs@oss.sgi.com>; Mon,  2 Sep 2013 05:10:57 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id B9796AC002
	for <xfs@oss.sgi.com>; Mon,  2 Sep 2013 03:10:56 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	7lsuTBdo1MBebwig for <xfs@oss.sgi.com>;
	Mon, 02 Sep 2013 03:10:55 -0700 (PDT)
Date: Mon, 2 Sep 2013 20:09:57 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/2] xfs: fix some minor sparse warnings
Message-ID: <20130902100957.GE12779@dastard>
References: <1378092179-24973-1-git-send-email-david@fromorbit.com>
	<1378092179-24973-3-git-send-email-david@fromorbit.com>
	<20130902081954.GD11210@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130902081954.GD11210@infradead.org>
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

On Mon, Sep 02, 2013 at 01:19:54AM -0700, Christoph Hellwig wrote:
> > --- a/fs/xfs/xfs_dquot_item.c
> > +++ b/fs/xfs/xfs_dquot_item.c
> > @@ -143,6 +143,8 @@ STATIC uint
> >  xfs_qm_dquot_logitem_push(
> >  	struct xfs_log_item	*lip,
> >  	struct list_head	*buffer_list)
> > +	__releases(&lip->li_ailp->xa_lock)
> > +	__acquires(&lip->li_ailp->xa_lock)
> >  {
> 
> Having these markers indented the same amount as the parameters isn't
> very readable.  Maybe give them another tab level?

Sure. Can do.

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
