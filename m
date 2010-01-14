Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0EMaXeA042616 for <xfs@oss.sgi.com>; Thu, 14 Jan 2010 16:36:33 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6E8F61676D7
	for <xfs@oss.sgi.com>; Thu, 14 Jan 2010 14:37:29 -0800 (PST)
Received: from mail.internode.on.net (bld-mail12.adl6.internode.on.net
	[150.101.137.97]) by cuda.sgi.com with ESMTP id
	QzDxmwUnPASuKFxn for <xfs@oss.sgi.com>;
	Thu, 14 Jan 2010 14:37:29 -0800 (PST)
Date: Fri, 15 Jan 2010 09:37:25 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 0/10] Perag lookup rework
Message-ID: <20100114223725.GY17483@discord.disaster>
References: <1263210469-22171-1-git-send-email-david@fromorbit.com>
	<1AB9A794DBDDF54A8A81BE2296F7BDFE012A696E@cf--amer001e--3.americas.sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1AB9A794DBDDF54A8A81BE2296F7BDFE012A696E@cf--amer001e--3.americas.sgi.com>
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
To: Alex Elder <aelder@sgi.com>
Cc: xfs@oss.sgi.com

On Thu, Jan 14, 2010 at 12:42:12PM -0600, Alex Elder wrote:
> Dave Chinner wrote:
> > This is the previous set of patches all put together in the one series
> > for the current xfs-dev tree.
> > 
> > Patch 10 is a new patch - it embeds the busy extent list into the perag
> > structure rather than leaving as a separate allocation.
> 
> All 10 patches look good.  I am adding the following descriptions
> to these patches which lacked them:
> 
> http://patchwork.xfs.org/patch/429/
> [03/10] XFS: Convert filestreams code to use per-ag get/put routines
> 
> Description:
> Use xfs_perag_get() and xfs_perag_put() in the filestreams code.

I'd consier that redundant and therefore unnecssary. I don't put
a descriptio in if the subject line describes the patch
sufficiently. It seems to be a pretty common practise, actually.

> http://patchwork.xfs.org/patch/417/
> [09/10] xfs: handle ENOMEM correctly during initialisation of perag structures
> 
> Description:
> Add proper error handling in case an error occurs while initializing
> new perag structures for a mount point.  The mount structure is
> restored to its previous state by deleting and freeing any perag
> structures added during the call.

That describes what the code does, which I'd also consider
redundant... ;)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
