Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 8370C7F37
	for <xfs@oss.sgi.com>; Thu, 21 Jan 2016 09:04:49 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 64C5B8F8035
	for <xfs@oss.sgi.com>; Thu, 21 Jan 2016 07:04:45 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id eVCd4I98mVVHeKC8 for <xfs@oss.sgi.com>;
	Thu, 21 Jan 2016 07:04:43 -0800 (PST)
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id 494AE63CBCE8
	for <xfs@oss.sgi.com>; Thu, 21 Jan 2016 09:04:43 -0600 (CST)
Subject: Re: [PATCH] Minor whitespace cleanups - V2
References: <1453386825-9097-1-git-send-email-cmaiolino@redhat.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <56A0F38A.80105@sandeen.net>
Date: Thu, 21 Jan 2016 09:04:42 -0600
MIME-Version: 1.0
In-Reply-To: <1453386825-9097-1-git-send-email-cmaiolino@redhat.com>
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

On 1/21/16 8:33 AM, Carlos Maiolino wrote:
> While investigating a quota issue, I fixed a few whitespaces.
> 
> Changelog:
> 	V2 - fix also whitespaces between comments as suggested by Eric
> 
> Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>

Looks fine to me - I'll leave it up to Dave whether he wants to merge
whitespace fixes :) but -

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
>  include/xqm.h | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/include/xqm.h b/include/xqm.h
> index 47f58a0..116ce00 100644
> --- a/include/xqm.h
> +++ b/include/xqm.h
> @@ -55,14 +55,14 @@ typedef struct fs_disk_quota {
>  	__s32		d_itimer;	/* zero if within inode limits */
>  					/* if not, we refuse service */
>  	__s32		d_btimer;	/* similar to above; for disk blocks */
> -	__u16	  	d_iwarns;       /* # warnings issued wrt num inodes */
> -	__u16	  	d_bwarns;       /* # warnings issued wrt disk blocks */
> +	__u16		d_iwarns;	/* # warnings issued wrt num inodes */
> +	__u16		d_bwarns;	/* # warnings issued wrt disk blocks */
>  	__s32		d_padding2;	/* padding2 - for future use */
>  	__u64		d_rtb_hardlimit;/* absolute limit on realtime blks */
>  	__u64		d_rtb_softlimit;/* preferred limit on RT disk blks */
>  	__u64		d_rtbcount;	/* # realtime blocks owned */
>  	__s32		d_rtbtimer;	/* similar to above; for RT disk blks */
> -	__u16	  	d_rtbwarns;     /* # warnings issued wrt RT disk blks */
> +	__u16		d_rtbwarns;	/* # warnings issued wrt RT disk blks */
>  	__s16		d_padding3;	/* padding3 - for future use */
>  	char		d_padding4[8];	/* yet more padding */
>  } fs_disk_quota_t;
> @@ -73,7 +73,7 @@ typedef struct fs_disk_quota {
>  #define FS_DQ_ISOFT	(1<<0)
>  #define FS_DQ_IHARD	(1<<1)
>  #define FS_DQ_BSOFT	(1<<2)
> -#define FS_DQ_BHARD 	(1<<3)
> +#define FS_DQ_BHARD	(1<<3)
>  #define FS_DQ_RTBSOFT	(1<<4)
>  #define FS_DQ_RTBHARD	(1<<5)
>  #define FS_DQ_LIMIT_MASK	(FS_DQ_ISOFT | FS_DQ_IHARD | FS_DQ_BSOFT | \
> @@ -87,7 +87,7 @@ typedef struct fs_disk_quota {
>   */
>  #define FS_DQ_BTIMER	(1<<6)
>  #define FS_DQ_ITIMER	(1<<7)
> -#define FS_DQ_RTBTIMER 	(1<<8)
> +#define FS_DQ_RTBTIMER	(1<<8)
>  #define FS_DQ_TIMER_MASK	(FS_DQ_BTIMER | FS_DQ_ITIMER | FS_DQ_RTBTIMER)
>  
>  /*
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
