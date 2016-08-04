Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 436837CA0
	for <xfs@oss.sgi.com>; Thu,  4 Aug 2016 11:13:27 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id A8D17AC002
	for <xfs@oss.sgi.com>; Thu,  4 Aug 2016 09:13:23 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id quelWDtknEapAs5H (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 04 Aug 2016 09:13:22 -0700 (PDT)
Date: Thu, 4 Aug 2016 11:13:18 -0500
From: "Bill O'Donnell" <billodo@redhat.com>
Subject: Re: [PATCH] xfs_metadump: don't warn about unobfuscated log with -o
Message-ID: <20160804161318.GA739@redhat.com>
References: <541974d2-5877-a7ef-af3c-7d1a47e227c0@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <541974d2-5877-a7ef-af3c-7d1a47e227c0@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs-oss <xfs@oss.sgi.com>

On Thu, Aug 04, 2016 at 10:51:12AM -0500, Eric Sandeen wrote:
> It makes no sense to warn about un-obfuscated logs
> when we asked xfs_metadump to not obfuscate metadata:
> 
> # xfs_metadump -o /dev/loop2 bad.metadump
> xfs_metadump: Filesystem log is dirty; image will contain unobfuscated metadata in log.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Reviewed-by: Bill O'Donnell <billodo@redhat.com>
> ---
> 
> diff --git a/db/metadump.c b/db/metadump.c
> index d7ff6e5..01a51c4 100644
> --- a/db/metadump.c
> +++ b/db/metadump.c
> @@ -2575,12 +2575,14 @@ copy_log(void)
>  		break;
>  	case 1:
>  		/* keep the dirty log */
> -		print_warning(
> +		if (obfuscate)
> +			print_warning(
>  _("Filesystem log is dirty; image will contain unobfuscated metadata in log."));
>  		break;
>  	case -1:
>  		/* log detection error */
> -		print_warning(
> +		if (obfuscate)
> +			print_warning(
>  _("Could not discern log; image will contain unobfuscated metadata in log."));
>  		break;
>  	}
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
