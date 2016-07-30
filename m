Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 88E957CA0
	for <xfs@oss.sgi.com>; Sat, 30 Jul 2016 11:36:20 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 08637AC004
	for <xfs@oss.sgi.com>; Sat, 30 Jul 2016 09:36:19 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id 7Y6PmifWu8xHyT9L for <xfs@oss.sgi.com>;
	Sat, 30 Jul 2016 09:36:13 -0700 (PDT)
Received: from [10.0.0.4] (liberator [10.0.0.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id 545C5EC3
	for <xfs@oss.sgi.com>; Sat, 30 Jul 2016 11:36:13 -0500 (CDT)
Subject: Re: [PATCH xfsprogs 2/2] linux.h: Define xfs_off_t as int64_t
References: <20160730133737.GB5895@nyan>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <05dd3ff7-1784-9f9c-4d9e-170372d60e28@sandeen.net>
Date: Sat, 30 Jul 2016 11:36:12 -0500
MIME-Version: 1.0
In-Reply-To: <20160730133737.GB5895@nyan>
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

On 7/30/16 8:37 AM, Felix Janda wrote:
> int64_t is guaranteed to have the correct size and signedness and is
> always avaible because linux.h has a <inttypes.h> include.
> 
> Fixes compilation error "unkown type name 'off64_t'" on linux when the
> public header <xfs.h> is included without _LARGEFILE64_SOURCE or
> _GNU_SOURCE defined. This bug was introduced in commit
> cb898f157f8410a03cf5f3400baa1df9e5eecd33.

Ok, I think that makes sense.  So the progression was:

Originally:	typedef loff_t         xfs_off_t;

(But, "musl does not know loff_t")

Next:		typedef off64_t        xfs_off_t;

(But, can break compilation w/o special defines)

Now:		typedef int64_t	       xfs_off_t;

which... I guess... satisfies everyone?  A comment
about why this, and not loff_t, might be worthwhile.

So I have to ask, seeing __int64_t right below this
int64_t; what's the difference/point in that?  Does
this need the __int64_t treatment for any other reason,
can you tell?

Just trying to avoid a 3rd change down the road.  ;)

Thanks,
-Eric

> Signed-off-by: Felix Janda <felix.janda@posteo.de>
> ---
>  include/linux.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/include/linux.h b/include/linux.h
> index 5614719..7653cac 100644
> --- a/include/linux.h
> +++ b/include/linux.h
> @@ -137,7 +137,7 @@ platform_discard_blocks(int fd, uint64_t start, uint64_t len)
>  #define EFSCORRUPTED	EUCLEAN	/* Filesystem is corrupted */
>  #define EFSBADCRC	EBADMSG	/* Bad CRC detected */
>  
> -typedef off64_t		xfs_off_t;
> +typedef int64_t		xfs_off_t;
>  typedef __uint64_t	xfs_ino_t;
>  typedef __uint32_t	xfs_dev_t;
>  typedef __int64_t	xfs_daddr_t;
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
