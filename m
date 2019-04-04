Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:56106 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727263AbfDDWI4 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 4 Apr 2019 18:08:56 -0400
Subject: Re: [PATCH 41/36] xfs_repair: better cli option parameter checking
References: <155259742281.31886.17157720770696604377.stgit@magnolia>
 <20190320193630.GE1183@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <95ecad84-34ba-92c7-8c6d-17457dc42dbb@sandeen.net>
Date: Thu, 4 Apr 2019 17:08:54 -0500
MIME-Version: 1.0
In-Reply-To: <20190320193630.GE1183@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On 3/20/19 2:36 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> For the xfs_repair options that require a parameter, check that the user
> actually provided one instead of segfaulting.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

looks good, but, uh, neither 

-c lazycount=
nor
-o phase2_threads=

is documented in the man page.  :(

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
>  repair/xfs_repair.c |   12 ++++++++++++
>  1 file changed, 12 insertions(+)
> 
> diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
> index 2d333d50..9657503f 100644
> --- a/repair/xfs_repair.c
> +++ b/repair/xfs_repair.c
> @@ -233,10 +233,16 @@ process_args(int argc, char **argv)
>  					if (max_mem_specified)
>  						do_abort(
>  		_("-o bhash option cannot be used with -m option\n"));
> +					if (!val)
> +						do_abort(
> +		_("-o bhash requires a parameter\n"));
>  					libxfs_bhash_size = (int)strtol(val, NULL, 0);
>  					bhash_option_used = 1;
>  					break;
>  				case AG_STRIDE:
> +					if (!val)
> +						do_abort(
> +		_("-o ag_stride requires a parameter\n"));
>  					ag_stride = (int)strtol(val, NULL, 0);
>  					break;
>  				case FORCE_GEO:
> @@ -247,6 +253,9 @@ process_args(int argc, char **argv)
>  					force_geo = 1;
>  					break;
>  				case PHASE2_THREADS:
> +					if (!val)
> +						do_abort(
> +		_("-o phase2_threads requires a parameter\n"));
>  					phase2_threads = (int)strtol(val, NULL, 0);
>  					break;
>  				default:
> @@ -262,6 +271,9 @@ process_args(int argc, char **argv)
>  
>  				switch (getsubopt(&p, c_opts, &val)) {
>  				case CONVERT_LAZY_COUNT:
> +					if (!val)
> +						do_abort(
> +		_("-c lazycount requires a parameter\n"));
>  					lazy_count = (int)strtol(val, NULL, 0);
>  					convert_lazy_count = 1;
>  					break;
> 
