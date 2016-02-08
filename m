Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id A76F27CA2
	for <xfs@oss.sgi.com>; Mon,  8 Feb 2016 04:06:45 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 95A718F8035
	for <xfs@oss.sgi.com>; Mon,  8 Feb 2016 02:06:42 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id dRv0mN4Xh3tijk1H (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 08 Feb 2016 02:06:37 -0800 (PST)
Date: Mon, 8 Feb 2016 02:06:36 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 6/7] libxfs: keep unflushable buffers off the cache MRUs
Message-ID: <20160208100636.GA27683@infradead.org>
References: <1454627108-19036-1-git-send-email-david@fromorbit.com>
	<1454627108-19036-7-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1454627108-19036-7-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

> --- a/include/cache.h
> +++ b/include/cache.h
> @@ -51,6 +51,7 @@ enum {
>  #define CACHE_BASE_PRIORITY	0
>  #define CACHE_PREFETCH_PRIORITY	8
>  #define CACHE_MAX_PRIORITY	15
> +#define CACHE_DIRTY_PRIORITY	(CACHE_MAX_PRIORITY + 1)

Sizing arrays based on, and iterating up to CACHE_DIRTY_PRIORITY seems
rather odd.  Maybe add a new

#define CACHE_NR_PRIORITIES		CACHE_DIRTY_PRIORITY

and a comment explaining the magic to make it more obvious?

> +cache_move_to_dirty_mru(
> +	struct cache		*cache,
> +	struct cache_node	*node)
> +{
> +	struct cache_mru	*mru;
> +
> +	mru = &cache->c_mrus[CACHE_DIRTY_PRIORITY];
> +
> +	pthread_mutex_lock(&mru->cm_mutex);
> +	node->cn_priority = CACHE_DIRTY_PRIORITY;
> +	list_move(&node->cn_mru, &mru->cm_list);
> +	mru->cm_count++;
> +	pthread_mutex_unlock(&mru->cm_mutex);
> +}

Maybe it would better to just do a list_add here and leave the
list_del to the caller to avoid needing to nest two different
cm_mutex instances.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
