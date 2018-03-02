Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:59214 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1163301AbeCBDpo (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 1 Mar 2018 22:45:44 -0500
Subject: Re: [PATCH] xfs_io: add RWF_DSYNC support to pwrite
References: <20180301013633.28364-1-david@fromorbit.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <fa38bfa3-2d30-be52-5bde-80b34aee3587@sandeen.net>
Date: Thu, 1 Mar 2018 21:45:43 -0600
MIME-Version: 1.0
In-Reply-To: <20180301013633.28364-1-david@fromorbit.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org

On 2/28/18 7:36 PM, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Enable testing write behaviour with the per-io RWF_DSYNC flag.
> 
> Signed-Off-By: Dave Chinner <dchinner@redhat.com>
> ---
>  io/pwrite.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/io/pwrite.c b/io/pwrite.c
> index a89edfd0496f..58867b764635 100644
> --- a/io/pwrite.c
> +++ b/io/pwrite.c
> @@ -56,6 +56,7 @@ pwrite_help(void)
>  #endif
>  #ifdef HAVE_PWRITEV2
>  " -N   -- Perform the pwritev2() with RWF_NOWAIT\n"
> +" -D   -- Perform the pwritev2() with RWF_DSYNC\n"

Needs an xfs_io manpage update and a pwrite_cmd.args
(short help) update, please.

Thanks,
-Eric

>  #endif
>  "\n"));
>  }
> @@ -299,7 +300,7 @@ pwrite_f(
>  	init_cvtnum(&fsblocksize, &fssectsize);
>  	bsize = fsblocksize;
>  
> -	while ((c = getopt(argc, argv, "b:BCdf:Fi:NqRs:OS:uV:wWZ:")) != EOF) {
> +	while ((c = getopt(argc, argv, "b:BCdDf:Fi:NqRs:OS:uV:wWZ:")) != EOF) {
>  		switch (c) {
>  		case 'b':
>  			tmp = cvtnum(fsblocksize, fssectsize, optarg);
> @@ -335,6 +336,9 @@ pwrite_f(
>  		case 'N':
>  			pwritev2_flags |= RWF_NOWAIT;
>  			break;
> +		case 'D':
> +			pwritev2_flags |= RWF_DSYNC;
> +			break;
>  #endif
>  		case 's':
>  			skip = cvtnum(fsblocksize, fssectsize, optarg);
> 
