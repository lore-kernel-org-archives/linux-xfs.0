Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 1EFDF7F37
	for <xfs@oss.sgi.com>; Sat, 23 Jan 2016 07:13:29 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 018CC304039
	for <xfs@oss.sgi.com>; Sat, 23 Jan 2016 05:13:29 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 4c8YEloZFqmn4H2H (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Sat, 23 Jan 2016 05:13:27 -0800 (PST)
Received: from int-mx14.intmail.prod.int.phx2.redhat.com
	(int-mx14.intmail.prod.int.phx2.redhat.com [10.5.11.27])
	by mx1.redhat.com (Postfix) with ESMTPS id AC7D18CB55
	for <xfs@oss.sgi.com>; Sat, 23 Jan 2016 13:13:27 +0000 (UTC)
Date: Sat, 23 Jan 2016 08:13:26 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] mkfs.xfs.8: Clarify mkfs vs. mount block size limits.
Message-ID: <20160123131326.GB2795@bfoster.bfoster>
References: <56A02144.9030206@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <56A02144.9030206@redhat.com>
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
Cc: dwysocha@redhat.com, xfs@oss.sgi.com

On Wed, Jan 20, 2016 at 06:07:32PM -0600, Eric Sandeen wrote:
> The current explanation is a bit vague to the uninitiated;
> clarify the text to make it obvious that while the mkfs.xfs
> utility is able to create valid filesystems with block sizes
> up to 65536, the Linux kernel can only mount filesystems with
> page sized or smaller blocks.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

> 
> diff --git a/man/man8/mkfs.xfs.8 b/man/man8/mkfs.xfs.8
> index 1fe510b..980c7bc 100644
> --- a/man/man8/mkfs.xfs.8
> +++ b/man/man8/mkfs.xfs.8
> @@ -126,7 +126,10 @@ or in bytes with
>  .BR size= .
>  The default value is 4096 bytes (4 KiB), the minimum is 512, and the
>  maximum is 65536 (64 KiB).
> -XFS on Linux currently only supports pagesize or smaller blocks.
> +Although
> +.B mkfs.xfs
> +will accept any of these values and create a valid filesystem,
> +XFS on Linux can only mount filesystems with pagesize or smaller blocks.
>  .TP
>  .BI \-m " global_metadata_options"
>  These options specify metadata format options that either apply to the entire
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
