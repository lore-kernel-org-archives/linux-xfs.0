Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 30D8C7CA1
	for <xfs@oss.sgi.com>; Mon,  6 Jun 2016 15:41:26 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id B112CAC003
	for <xfs@oss.sgi.com>; Mon,  6 Jun 2016 13:41:25 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id pDrSCD4Jdt8iRTSL for <xfs@oss.sgi.com>;
	Mon, 06 Jun 2016 13:41:23 -0700 (PDT)
Received: from [10.0.0.4] (liberator [10.0.0.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id A2C4322C5
	for <xfs@oss.sgi.com>; Mon,  6 Jun 2016 15:41:23 -0500 (CDT)
Subject: Re: [PATCH] mkfs: fix -l su minval
References: <1465199729-8622-1-git-send-email-jtulak@redhat.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <b324a647-efc0-da18-02be-447c46abdb93@sandeen.net>
Date: Mon, 6 Jun 2016 15:41:23 -0500
MIME-Version: 1.0
In-Reply-To: <1465199729-8622-1-git-send-email-jtulak@redhat.com>
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

On 6/6/16 2:55 AM, Jan Tulak wrote:
> -l su should be in range BBTOB(1) <= L_SU <= XLOG_MAX_RECORD_BSIZE, because the
> upper limit is imposed by kernel on iclogbuf: stripe unit can't be bigger than
> the log buffer, but the log buffer can span multiple stripe units. L_SUNIT is
> changed in the same way.
> 
> Signed-off-by: Jan Tulak <jtulak@redhat.com>

Manpage could use documentation on defaults, min, and max I suppose.

But for this code change:

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

Thanks for digging into it :)

> ---
>  mkfs/xfs_mkfs.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index 955dcfd..ed7800f 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -462,7 +462,7 @@ struct opt_params lopts = {
>  		{ .index = L_SUNIT,
>  		  .conflicts = { L_SU,
>  				 LAST_CONFLICT },
> -		  .minval = BTOBB(XLOG_MIN_RECORD_BSIZE),
> +		  .minval = 1,
>  		  .maxval = BTOBB(XLOG_MAX_RECORD_BSIZE),
>  		  .defaultval = SUBOPT_NEEDS_VAL,
>  		},
> @@ -470,7 +470,7 @@ struct opt_params lopts = {
>  		  .conflicts = { L_SUNIT,
>  				 LAST_CONFLICT },
>  		  .convert = true,
> -		  .minval = XLOG_MIN_RECORD_BSIZE,
> +		  .minval = BBTOB(1),
>  		  .maxval = XLOG_MAX_RECORD_BSIZE,
>  		  .defaultval = SUBOPT_NEEDS_VAL,
>  		},
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
