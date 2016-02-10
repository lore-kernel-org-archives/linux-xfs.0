Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 6190B7CAE
	for <xfs@oss.sgi.com>; Wed, 10 Feb 2016 14:38:32 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 550648F8059
	for <xfs@oss.sgi.com>; Wed, 10 Feb 2016 12:38:32 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id Qm5SgjpFOCFcAtTT for <xfs@oss.sgi.com>;
	Wed, 10 Feb 2016 12:38:26 -0800 (PST)
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id B299663C607A
	for <xfs@oss.sgi.com>; Wed, 10 Feb 2016 14:38:25 -0600 (CST)
Subject: Re: [PATCH] xfs: fix two memory leaks in xfs_attr_list.c error paths
References: <1455129337-19255-1-git-send-email-mguzik@redhat.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <56BB9FC0.1080202@sandeen.net>
Date: Wed, 10 Feb 2016 14:38:24 -0600
MIME-Version: 1.0
In-Reply-To: <1455129337-19255-1-git-send-email-mguzik@redhat.com>
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
To: xfs@oss.sgi.com

On 2/10/16 12:35 PM, Mateusz Guzik wrote:
> This plugs 2 trivial leaks in xfs_attr_shortform_list and
> xfs_attr3_leaf_list_int.
> 
> Signed-off-by: Mateusz Guzik <mguzik@redhat.com>
> Cc: <stable@vger.kernel.org>

Looks good (tho I wonder why coverity didn't spot...)

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> 
> ---
>  fs/xfs/xfs_attr_list.c | 19 ++++++++++---------
>  1 file changed, 10 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/xfs/xfs_attr_list.c b/fs/xfs/xfs_attr_list.c
> index 0ef7c2e..4fa1482 100644
> --- a/fs/xfs/xfs_attr_list.c
> +++ b/fs/xfs/xfs_attr_list.c
> @@ -202,8 +202,10 @@ xfs_attr_shortform_list(xfs_attr_list_context_t *context)
>  					sbp->namelen,
>  					sbp->valuelen,
>  					&sbp->name[sbp->namelen]);
> -		if (error)
> +		if (error) {
> +			kmem_free(sbuf);
>  			return error;
> +		}
>  		if (context->seen_enough)
>  			break;
>  		cursor->offset++;
> @@ -454,14 +456,13 @@ xfs_attr3_leaf_list_int(
>  				args.rmtblkcnt = xfs_attr3_rmt_blocks(
>  							args.dp->i_mount, valuelen);
>  				retval = xfs_attr_rmtval_get(&args);
> -				if (retval)
> -					return retval;
> -				retval = context->put_listent(context,
> -						entry->flags,
> -						name_rmt->name,
> -						(int)name_rmt->namelen,
> -						valuelen,
> -						args.value);
> +				if (!retval)
> +					retval = context->put_listent(context,
> +							entry->flags,
> +							name_rmt->name,
> +							(int)name_rmt->namelen,
> +							valuelen,
> +							args.value);
>  				kmem_free(args.value);
>  			} else {
>  				retval = context->put_listent(context,
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
