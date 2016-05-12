Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id C19947CA0
	for <xfs@oss.sgi.com>; Thu, 12 May 2016 08:59:38 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 8219D8F8039
	for <xfs@oss.sgi.com>; Thu, 12 May 2016 06:59:35 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id la5AHRpr8SPfPRHO (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 12 May 2016 06:59:34 -0700 (PDT)
Received: from int-mx11.intmail.prod.int.phx2.redhat.com
	(int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx1.redhat.com (Postfix) with ESMTPS id 149D962662
	for <xfs@oss.sgi.com>; Thu, 12 May 2016 13:59:34 +0000 (UTC)
Received: from redhat.com (unused [10.10.50.52] (may be forged))
	by int-mx11.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id u4CDxU3V021323
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=NO) for <xfs@oss.sgi.com>; Thu, 12 May 2016 09:59:33 -0400
Date: Thu, 12 May 2016 15:59:29 +0200
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH] mkfs.xfs: annotate fallthrough cases in cvtnum
Message-ID: <20160512135929.GC28780@redhat.com>
References: <51117671-6856-0fb7-d86e-0fdf6a29b5e5@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <51117671-6856-0fb7-d86e-0fdf6a29b5e5@sandeen.net>
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

On Wed, May 11, 2016 at 09:47:45PM -0500, Eric Sandeen wrote:
> We should really collapse our 3 cvtnum variants,
> but for now at least shut up Coverity about this
> intentional case fallthrough.
> 

Looks good

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

> Addresses-Coverity-ID: 1361553
> Addresses-Coverity-ID: 1361554
> Addresses-Coverity-ID: 1361555
> Addresses-Coverity-ID: 1361556
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index 955dcfd..12fe8f3 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -3623,14 +3623,19 @@ cvtnum(
>  	switch (c) {
>  	case 'e':
>  		i *= 1024LL;
> +		/* fall through */
>  	case 'p':
>  		i *= 1024LL;
> +		/* fall through */
>  	case 't':
>  		i *= 1024LL;
> +		/* fall through */
>  	case 'g':
>  		i *= 1024LL;
> +		/* fall through */
>  	case 'm':
>  		i *= 1024LL;
> +		/* fall through */
>  	case 'k':
>  		return i * 1024LL;
>  	default:
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

-- 
Carlos

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
