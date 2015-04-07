Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 1E0217F63
	for <xfs@oss.sgi.com>; Tue,  7 Apr 2015 08:37:25 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 0D93E3041EC
	for <xfs@oss.sgi.com>; Tue,  7 Apr 2015 06:37:24 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id n7sN3gNIBlseoR3Y (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 07 Apr 2015 06:37:21 -0700 (PDT)
Received: from int-mx14.intmail.prod.int.phx2.redhat.com
	(int-mx14.intmail.prod.int.phx2.redhat.com [10.5.11.27])
	by mx1.redhat.com (Postfix) with ESMTPS id 5580838590E
	for <xfs@oss.sgi.com>; Tue,  7 Apr 2015 13:37:20 +0000 (UTC)
Date: Tue, 7 Apr 2015 09:37:19 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] xfsprogs: remove unreachable code in libxfs_inode_alloc
Message-ID: <20150407133718.GF23208@bfoster.bfoster>
References: <5522C22E.4000107@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5522C22E.4000107@redhat.com>
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

On Mon, Apr 06, 2015 at 12:28:14PM -0500, Eric Sandeen wrote:
> This code does:
> 
>         if (!ialloc_context && !ip)
>                 return;
> 
>         // if !ip here, ialloc_context must be true
> 
>         if (ialloc_context) {
>                 ...
>                 if (!ip)
>                         error = ENOSPC;
>                 if (error)
>                         return error;
>                 // if !ip in this block we've returned
>         }
> 
>         // so (!ip) cannot be true here
>         if (!ip)
>                 error = ENOSPC;
> 
> (cherry picked this one out of Coverity reports)
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

> 
> diff --git a/libxfs/util.c b/libxfs/util.c
> index 6464a1b..49eb76d 100644
> --- a/libxfs/util.c
> +++ b/libxfs/util.c
> @@ -700,8 +700,6 @@ libxfs_inode_alloc(
>  		if (error)
>  			return error;
>  	}
> -	if (!ip)
> -		error = ENOSPC;
>  
>  	*ipp = ip;
>  	return error;
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
