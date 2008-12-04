Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mB4FTc4I012076 for <xfs@oss.sgi.com>; Thu, 4 Dec 2008 09:29:39 -0600
Message-ID: <4937F75F.8070302@sandeen.net>
Date: Thu, 04 Dec 2008 09:29:35 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] Remove unused variable in ktrace_free()
References: <4937765D.2030601@sgi.com>
In-Reply-To: <4937765D.2030601@sgi.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: lachlan@sgi.com
Cc: xfs-oss <xfs@oss.sgi.com>

Lachlan McIlroy wrote:
> entries_size is probably left over from when we used to pass the
> size to kmem_free().

Reviewed-by: Eric Sandeen <sandeen@sandeen.net>

> --- xfs-fix.orig/fs/xfs/support/ktrace.c
> +++ xfs-fix/fs/xfs/support/ktrace.c
> @@ -113,21 +113,16 @@ ktrace_alloc(int nentries, unsigned int
>   void
>   ktrace_free(ktrace_t *ktp)
>   {
> -	int     entries_size;
> -
>   	if (ktp == (ktrace_t *)NULL)
>   		return;
> 
>   	/*
>   	 * Special treatment for the Vnode trace buffer.
>   	 */
> -	if (ktp->kt_nentries == ktrace_zentries) {
> +	if (ktp->kt_nentries == ktrace_zentries)
>   		kmem_zone_free(ktrace_ent_zone, ktp->kt_entries);
> -	} else {
> -		entries_size = (int)(ktp->kt_nentries * sizeof(ktrace_entry_t));
> -
> +	else
>   		kmem_free(ktp->kt_entries);
> -	}
> 
>   	kmem_zone_free(ktrace_hdr_zone, ktp);
>   }
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
