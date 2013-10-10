Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 980C97F8B
	for <xfs@oss.sgi.com>; Thu, 10 Oct 2013 09:21:29 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 7657E8F804B
	for <xfs@oss.sgi.com>; Thu, 10 Oct 2013 07:21:26 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id MyPNK2bwypqkrYcn for
	<xfs@oss.sgi.com>; Thu, 10 Oct 2013 07:21:25 -0700 (PDT)
Received: from int-mx10.intmail.prod.int.phx2.redhat.com
	(int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r9AELOcM029475
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Thu, 10 Oct 2013 10:21:25 -0400
Received: from orion.maiolino.org (ovpn-113-149.phx2.redhat.com [10.3.113.149])
	by int-mx10.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id r9AELKOA027168
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <xfs@oss.sgi.com>; Thu, 10 Oct 2013 10:21:23 -0400
Date: Thu, 10 Oct 2013 11:21:20 -0300
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH 2/2] xfsdump: fix DEBUGPARTIALS build
Message-ID: <20131010142119.GA3434@orion.maiolino.org>
References: <525480A6.3000202@redhat.com>
 <525487CD.7080900@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <525487CD.7080900@sandeen.net>
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

Looks good to me indeed

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
On Tue, Oct 08, 2013 at 05:31:41PM -0500, Eric Sandeen wrote:
> the DEBUGPARTIALS debug code might have been helpful
> in this saga, so get it building again.
> 
> The primary build failure is that STREAM_MAX isn't
> defined for the num_partials[STREAM_MAX] array;
> the loop which uses that array iterates "drivecnt"
> times, so just allocate an array of that size.
> 
> Fix a few printf format warnings while we're at it.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> diff --git a/restore/content.c b/restore/content.c
> index cc49336..8ad0f00 100644
> --- a/restore/content.c
> +++ b/restore/content.c
> @@ -8857,22 +8857,23 @@ dump_partials(void)
>  	int i;
>  
>  	pi_lock();
> -	printf("\npartial_reg: count=%d\n", persp->a.parrestcnt);
> +	printf("\npartial_reg: count=%d\n", (int)persp->a.parrestcnt);
>  	if (persp->a.parrestcnt > 0) {
>  		for (i=0; i < partialmax; i++ ) {
>  			if (persp->a.parrest[i].is_ino > 0) {
>  				int j;
>  
>  				isptr = &persp->a.parrest[i];
> -				printf( "\tino=%lld ", isptr->is_ino);
> +				printf("\tino=%llu ",
> +				       (unsigned long long)isptr->is_ino);
>  				for (j=0, bsptr=isptr->is_bs;
>  				     j < drivecnt; 
>  				     j++, bsptr++)
>  				{
>  					if (bsptr->endoffset > 0) {
>  						printf("%d:%lld-%lld ",
> -						     j, bsptr->offset, 
> -						     bsptr->endoffset);
> +						   j, (long long)bsptr->offset,
> +						   (long long)bsptr->endoffset);
>  					} 
>  				}
>  				printf( "\n");
> @@ -8892,13 +8893,17 @@ dump_partials(void)
>  void
>  check_valid_partials(void)
>  {
> -        int num_partials[STREAM_MAX]; /* sum of partials for a given drive */
> +	int *num_partials; /* array for sum of partials for a given drive */
>  	partial_rest_t *isptr = NULL;
>  	bytespan_t *bsptr = NULL;
>  	int i;
>  
>  	/* zero the sums for each stream */
> -        memset(num_partials, 0, sizeof(num_partials));
> +	num_partials = calloc(drivecnt, sizeof(int));
> +	if (!num_partials) {
> +		perror("num_partials array allocation");
> +		return;
> +	}
>  
>  	pi_lock();
>  	if (persp->a.parrestcnt > 0) {
> @@ -8926,6 +8931,7 @@ check_valid_partials(void)
>  		}
>  	}
>  	pi_unlock();
> +	free(num_partials);
>  }
>  #endif
>  
> 
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
