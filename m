Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id ABE4C7F91
	for <xfs@oss.sgi.com>; Fri, 21 Aug 2015 12:24:59 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 8CADE8F804B
	for <xfs@oss.sgi.com>; Fri, 21 Aug 2015 10:24:56 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id teRKuzJWxJJP35CO for <xfs@oss.sgi.com>;
	Fri, 21 Aug 2015 10:24:54 -0700 (PDT)
Message-ID: <55D75EE6.4080703@sandeen.net>
Date: Fri, 21 Aug 2015 12:24:54 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH 2/2] xfsdump: don't do pointer math twice
References: <20150821193047.661578219@gulag1.americas.sgi.com>
	<20150821193241.973348815@gulag1.americas.sgi.com>
In-Reply-To: <20150821193241.973348815@gulag1.americas.sgi.com>
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
To: rjohnston@sgi.com, xfs@oss.sgi.com

On 8/21/15 9:01 AM, rjohnston@sgi.com wrote:
> The pointer math when calculating the address for the call to memset
> is incorrect, so we are clearing the wrong memory location.
> 
> i2gmap is of type i2gseg_t 
> 
> oldsize has already computed the pointer offset
> 	oldsize = inomap.hnkmaplen * SEGPERHNK * sizeof(i2gseg_t);
> the memset call is using
> 	inomap.i2gmap + oldsize == &inomap.i2gmap[oldsize]
> so we were doing the pointer math twice.
> 
> We already compensate for the length of each item in oldsize so
> adding need to add a (char *) cast to the memset parameter.


What about just doing:

			memset(&inomap.i2gmap[numsegs - SEGPERHNK], 0,
 			       SEGPERHNK * sizeof(i2gseg_t));

which more clearly shows that we're setting the new array members
to zero.

(could do oldsegs = inomap.hnkmaplen * SEGPERHNK; prior to the
hnkmaplen++, if that makes it any more readable...)

*shrug* it seems a little clearer to me, anyway.

Thanks,
-Eric

> ---
>  dump/inomap.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Index: b/dump/inomap.c
> ===================================================================
> --- a/dump/inomap.c
> +++ b/dump/inomap.c
> @@ -1143,7 +1143,7 @@ cb_add_inogrp( void *arg1, intgen_t fsfd
>  				return -1;
>  
>  			/* zero the new portion of the i2gmap */
> -			memset(inomap.i2gmap + oldsize,
> +			memset((char *)inomap.i2gmap + oldsize,
>  			       0,
>  			       SEGPERHNK * sizeof(i2gseg_t));
>  		}
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
