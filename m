Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 7BB1B7CA2
	for <xfs@oss.sgi.com>; Fri,  5 Feb 2016 08:23:19 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 1A4CAAC002
	for <xfs@oss.sgi.com>; Fri,  5 Feb 2016 06:23:18 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 8IbxJa8NchogQtEd (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 05 Feb 2016 06:23:18 -0800 (PST)
Date: Fri, 5 Feb 2016 09:23:16 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 7/7] libxfs: reset dirty buffer priority on lookup
Message-ID: <20160205142315.GD52478@bfoster.bfoster>
References: <1454627108-19036-1-git-send-email-david@fromorbit.com>
	<1454627108-19036-8-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1454627108-19036-8-git-send-email-david@fromorbit.com>
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

On Fri, Feb 05, 2016 at 10:05:08AM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> When a buffer on the dirty MRU is looked up and found, we remove the
> buffer from the MRU. However, we've already set the priority ofthe

							       of the

> buffer to "dirty" so when we are donw with it it will go back on the

				   done

> dirty buffer MRU regardless of whether it needs to or not.
> 
> Hence when we move a buffer to a the dirty MRU, reocrd the old

						  record

> priority and restore it when we remove the buffer from the MRU on
> lookup. This will prevent us from putting fixed, now writeable
> buffers back on the dirty MRU and allow the cache routine to write,
> shake and reclaim the buffers once they are clean.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  include/cache.h | 1 +
>  libxfs/cache.c  | 7 +++++++
>  2 files changed, 8 insertions(+)
> 
...
> diff --git a/libxfs/cache.c b/libxfs/cache.c
> index d4b4a4e..0398be3 100644
> --- a/libxfs/cache.c
> +++ b/libxfs/cache.c
...
> @@ -434,6 +436,10 @@ cache_node_get(
>  				mru->cm_count--;
>  				list_del_init(&node->cn_mru);
>  				pthread_mutex_unlock(&mru->cm_mutex);
> +				if (node->cn_old_priority != -1) {

Might be good to ASSERT(node->cn_priority == CACHE_DIRTY_PRIORITY) here.
Otherwise looks good:

Reviewed-by: Brian Foster <bfoster@redhat.com>

> +					node->cn_priority = node->cn_old_priority;
> +					node->cn_old_priority = -1;
> +				}
>  			}
>  			node->cn_count++;
>  
> @@ -534,6 +540,7 @@ cache_node_set_priority(
>  	pthread_mutex_lock(&node->cn_mutex);
>  	ASSERT(node->cn_count > 0);
>  	node->cn_priority = priority;
> +	node->cn_old_priority = -1;
>  	pthread_mutex_unlock(&node->cn_mutex);
>  }
>  
> -- 
> 2.5.0
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
