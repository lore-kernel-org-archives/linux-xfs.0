Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:37334 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727024AbeK2Q2a (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 29 Nov 2018 11:28:30 -0500
Subject: Re: [PATCH v2 7/6] xfs_db: add missing string name for DBM_COWDATA
References: <154181071499.3727.3910572718199592407.stgit@magnolia>
 <20181127231545.GA8125@magnolia> <20181129005454.GK8125@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <1d279b25-13b3-08a0-fe16-9060a231dd09@sandeen.net>
Date: Wed, 28 Nov 2018 23:24:22 -0600
MIME-Version: 1.0
In-Reply-To: <20181129005454.GK8125@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, Eric Sandeen <sandeen@redhat.com>
Cc: linux-xfs@vger.kernel.org



On 11/28/18 6:54 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> In db/check.c, typename[] is supposed to have strings for every DBM_
> type, but we forgot one.  Add it now.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
> v2: add build time check
> ---
>  db/check.c |   11 +++++++++++
>  1 file changed, 11 insertions(+)
> 
> diff --git a/db/check.c b/db/check.c
> index 352aab3f..442600be 100644
> --- a/db/check.c
> +++ b/db/check.c
> @@ -164,8 +164,19 @@ static const char	*typename[] = {
>  	"btrmap",
>  	"btrefcnt",
>  	"rldata",
> +	"cowdata",
>  	NULL
>  };
> +
> +/*
> + * Make sure typename has the same number of elements as there are DBM types.
> + * This function isn't called anywhere; we just use it to trip up the compiler.
> + */
> +static inline void check_typename(void)
> +{
> +	BUILD_BUG_ON(ARRAY_SIZE(typename) != DBM_NDBM + 1);
> +}
> +
>  static int		verbose;
>  
>  #define	CHECK_BLIST(b)	(blist_size && check_blist(b))

Seems ok, if it won't cause unused warnings ...

Reviewed-by: Eric Sandeen <sandeen@redhat.com>
