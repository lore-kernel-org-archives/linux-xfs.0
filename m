Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nACNkTuT038653 for <xfs@oss.sgi.com>; Thu, 12 Nov 2009 17:46:30 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id AD4BC82C68
	for <xfs@oss.sgi.com>; Thu, 12 Nov 2009 15:46:47 -0800 (PST)
Received: from mail.internode.on.net (bld-mail18.adl2.internode.on.net
	[150.101.137.103]) by cuda.sgi.com with ESMTP id
	u9DeByGqIVSNOMt1 for <xfs@oss.sgi.com>;
	Thu, 12 Nov 2009 15:46:47 -0800 (PST)
Date: Fri, 13 Nov 2009 10:46:43 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 06/14] repair: use a btree instead of a radix tree for
	theprefetch queue
Message-ID: <20091112234643.GJ25494@discord.disaster>
References: <20090902175840.740632507@bombadil.infradead.org>
	<1AB9A794DBDDF54A8A81BE2296F7BDFE83ADEB@cf--amer001e--3.americas.sgi.com>
	<20091112100408.GA25058@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20091112100408.GA25058@infradead.org>
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
Cc: xfs@oss.sgi.com, Barry Naujok <bnaujok@optusnet.com.au>, Alex Elder <aelder@sgi.com>

On Thu, Nov 12, 2009 at 05:04:08AM -0500, Christoph Hellwig wrote:
> On Wed, Oct 21, 2009 at 12:12:33PM -0500, Alex Elder wrote:
> > - Related to the previous one--it would be good to have
> >   a little info about why the value 7 was chosen as the
> >   number of keys per node.  Perhaps I just don't know
> >   enough of the history (or content of the upcoming
> >   patches).

I think I can answer this one:

> +/*
> + * Maximum number of keys per node.  Must be greater than 2 for the code
> + * to work.
> + */
> +#define BTREE_KEY_MAX		7
> +#define BTREE_KEY_MIN		(BTREE_KEY_MAX / 2)
> +
> +#define BTREE_PTR_MAX		(BTREE_KEY_MAX + 1)
> +
> +struct btree_node {
> +	unsigned long		num_keys;
> +	unsigned long		keys[BTREE_KEY_MAX];
> +	struct btree_node	*ptrs[BTREE_PTR_MAX];
> +};

BTREE_KEY_MAX = 7 results in a btree_node exactly filling
a 64 byte cacheline on 32 bit, and 2 cachelines on 64 bit.
Cacheline aligned and sized nodes minimises the number of cache
misses when traversing/searching the btree....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
