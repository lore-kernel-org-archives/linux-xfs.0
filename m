Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:56152 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932323AbdHWPtF (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 23 Aug 2017 11:49:05 -0400
Subject: Re: [PATCH 1/4] fiemap: Move global variables out of function scope
References: <5fc15693-7df3-c1bf-9f78-020eed30b567@sandeen.net>
 <1503501082-16983-1-git-send-email-nborisov@suse.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <33bf538b-a67f-016b-bb23-4e0090fa0f9a@sandeen.net>
Date: Wed, 23 Aug 2017 10:49:04 -0500
MIME-Version: 1.0
In-Reply-To: <1503501082-16983-1-git-send-email-nborisov@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Nikolay Borisov <nborisov@suse.com>
Cc: linux-xfs@vger.kernel.org

On 8/23/17 10:11 AM, Nikolay Borisov wrote:
> Move the blocksize and max_extent variables to the top of the file since they
> are globals. Also blocksize never changes to mark it const. Also stop passing
> max_extents around and refer to it directly.

I think this is fine, though it could probably go further.  If blocksize is
always 512, we could just use the BTOBBT() macro, which converts bytes
to "basic blocks" (512 units), and do away with the variable
entirely...



> Signed-off-by: Nikolay Borisov <nborisov@suse.com>
> ---
>  io/fiemap.c | 14 +++++---------
>  1 file changed, 5 insertions(+), 9 deletions(-)
> 
> diff --git a/io/fiemap.c b/io/fiemap.c
> index 75e882057362..d1584aba7818 100644
> --- a/io/fiemap.c
> +++ b/io/fiemap.c
> @@ -24,6 +24,8 @@
>  #include "io.h"
>  
>  static cmdinfo_t fiemap_cmd;
> +static const __u64 blocksize = 512;
> +static int max_extents = 0;
>  
>  static void
>  fiemap_help(void)
> @@ -57,7 +59,6 @@ print_verbose(
>  	int			boff_w,
>  	int			tot_w,
>  	int			flg_w,
> -	int			max_extents,
>  	int			*cur_extent,
>  	__u64			*last_logical)
>  {
> @@ -113,7 +114,6 @@ print_plain(
>  	struct fiemap_extent	*extent,
>  	int			lflag,
>  	int			blocksize,
> -	int			max_extents,
>  	int			*cur_extent,
>  	__u64			*last_logical)
>  {
> @@ -165,7 +165,7 @@ calc_print_format(
>  	int			*tot_w,
>  	int			*flg_w)
>  {
> -	int 			i;
> +	int			i;
>  	char			lbuf[32];
>  	char			bbuf[32];
>  	__u64			logical;
> @@ -199,7 +199,6 @@ fiemap_f(
>  	char		**argv)
>  {
>  	struct fiemap	*fiemap;
> -	int		max_extents = 0;
>  	int		num_extents = 32;
>  	int		last = 0;
>  	int		lflag = 0;
> @@ -214,7 +213,6 @@ fiemap_f(
>  	int		boff_w = 16;
>  	int		tot_w = 5;	/* 5 since its just one number */
>  	int		flg_w = 5;
> -	__u64		blocksize = 512;
>  	__u64		last_logical = 0;
>  	struct stat	st;
>  
> @@ -288,12 +286,10 @@ fiemap_f(
>  
>  				print_verbose(extent, blocksize, foff_w,
>  					      boff_w, tot_w, flg_w,
> -					      max_extents, &cur_extent,
> -					      &last_logical);
> +					      &cur_extent, &last_logical);
>  			} else
>  				print_plain(extent, lflag, blocksize,
> -					    max_extents, &cur_extent,
> -					    &last_logical);
> +					    &cur_extent, &last_logical);
>  
>  			if (extent->fe_flags & FIEMAP_EXTENT_LAST) {
>  				last = 1;
> 
