Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 9F1AC7CA1
	for <xfs@oss.sgi.com>; Thu, 23 Jun 2016 12:35:21 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 70EA7304048
	for <xfs@oss.sgi.com>; Thu, 23 Jun 2016 10:35:18 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id jrQnCCG0bYUWbz9l for <xfs@oss.sgi.com>;
	Thu, 23 Jun 2016 10:35:14 -0700 (PDT)
Received: from [10.0.0.4] (liberator [10.0.0.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id 6499D15B3B
	for <xfs@oss.sgi.com>; Thu, 23 Jun 2016 12:35:14 -0500 (CDT)
Subject: Re: [PATCH] xfs_repair: resolve Coverity OVERFLOW_BEFORE_WIDEN
References: <1466701630-6380-1-git-send-email-billodo@redhat.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <f1844664-4eea-9fdc-f617-39a602977201@sandeen.net>
Date: Thu, 23 Jun 2016 12:35:14 -0500
MIME-Version: 1.0
In-Reply-To: <1466701630-6380-1-git-send-email-billodo@redhat.com>
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



On 6/23/16 12:07 PM, Bill O'Donnell wrote:
> Coverity complains that when multiplying two 32 bit values that
> eventually will be stored in a 64 bit value that it's possible
> the math could overflow unless one of the values being multiplied
> is type cast to the proper size.
> 
> Signed-off-by: Bill O'Donnell <billodo@redhat.com>

Makes sense.  Given that this is repair, and either value could
be larger than expected, we need the skip value to be accurate.

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
>  repair/sb.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/repair/sb.c b/repair/sb.c
> index 3965953..8d4843c 100644
> --- a/repair/sb.c
> +++ b/repair/sb.c
> @@ -230,7 +230,7 @@ find_secondary_sb(xfs_sb_t *rsb)
>  	do_warn(_("\nattempting to find secondary superblock...\n"));
>  
>  	if (verify_sb_blocksize(rsb) == 0) {
> -		skip = rsb->sb_agblocks * rsb->sb_blocksize;
> +		skip = (__uint64_t)rsb->sb_agblocks * rsb->sb_blocksize;
>  		if (skip >= XFS_AG_MIN_BYTES && skip <= XFS_AG_MAX_BYTES)
>  			retval = __find_secondary_sb(rsb, skip, skip);
>  	}
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
