Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id DDB8C7F55
	for <xfs@oss.sgi.com>; Mon, 27 Oct 2014 06:26:06 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id BCDDD304051
	for <xfs@oss.sgi.com>; Mon, 27 Oct 2014 04:26:06 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 8qPjDHiuQzBQiIOV (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 27 Oct 2014 04:26:05 -0700 (PDT)
Received: from int-mx10.intmail.prod.int.phx2.redhat.com
	(int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s9RBQ4aQ031176
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=FAIL) for <xfs@oss.sgi.com>; Mon, 27 Oct 2014 07:26:05 -0400
Date: Mon, 27 Oct 2014 07:26:03 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] xfsprogs: fix harmless sparse endian nit
Message-ID: <20141027112603.GB39598@bfoster.bfoster>
References: <544992F1.8050803@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <544992F1.8050803@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>
Cc: xfs-oss <xfs@oss.sgi.com>

On Thu, Oct 23, 2014 at 06:44:49PM -0500, Eric Sandeen wrote:
> h_crc is __le32 but cpu_to_be32() is... __be32.  So sparse
> complains, even though it's harmless.
> 
> Although sparse is smart about bare 0s, and we could
> drop the swap, other places explicitly swap to keep
> things clear (I guess?) so "swap" the 0 with the proper
> routine.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---

Looks good. I agree that the swap helps with clarity.

Reviewed-by: Brian Foster <bfoster@redhat.com>

> 
> diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
> index 9ee89d3..dd8baa6 100644
> --- a/libxfs/rdwr.c
> +++ b/libxfs/rdwr.c
> @@ -187,7 +187,7 @@ libxfs_log_header(
>  		head->h_len = cpu_to_be32(sunit - BBSIZE);
>  	else
>  		head->h_len = cpu_to_be32(20);
> -	head->h_crc = cpu_to_be32(0);
> +	head->h_crc = cpu_to_le32(0);
>  	head->h_prev_block = cpu_to_be32(-1);
>  	head->h_num_logops = cpu_to_be32(1);
>  	head->h_cycle_data[0] = cpu_to_be32(0xb0c0d0d0);
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
