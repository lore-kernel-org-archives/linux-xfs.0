Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:38900 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750782AbeCFRHN (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 6 Mar 2018 12:07:13 -0500
Subject: Re: [PATCH V2] xfs_io: add RWF_DSYNC support to pwrite
References: <20180301013633.28364-1-david@fromorbit.com>
 <20180305040853.GB18129@dastard>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <4233abeb-3fba-459a-1b31-e60fbda3a2bb@sandeen.net>
Date: Tue, 6 Mar 2018 11:07:12 -0600
MIME-Version: 1.0
In-Reply-To: <20180305040853.GB18129@dastard>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org



On 3/4/18 10:08 PM, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Enable testing write behaviour with the per-io RWF_DSYNC flag.
> 
> Signed-Off-By: Dave Chinner <dchinner@redhat.com>


thanks for the update.

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
> 
> V2: updated shortform help string and added command to the man page.
> 
>  io/pwrite.c       |  8 ++++++--
>  man/man8/xfs_io.8 | 10 ++++++++--
>  2 files changed, 14 insertions(+), 4 deletions(-)
> 
> diff --git a/io/pwrite.c b/io/pwrite.c
> index a89edfd0496f..74cc5882fe4b 100644
> --- a/io/pwrite.c
> +++ b/io/pwrite.c
> @@ -56,6 +56,7 @@ pwrite_help(void)
>  #endif
>  #ifdef HAVE_PWRITEV2
>  " -N   -- Perform the pwritev2() with RWF_NOWAIT\n"
> +" -D   -- Perform the pwritev2() with RWF_DSYNC\n"
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
> @@ -469,7 +473,7 @@ pwrite_init(void)
>  	pwrite_cmd.argmax = -1;
>  	pwrite_cmd.flags = CMD_NOMAP_OK | CMD_FOREIGN_OK;
>  	pwrite_cmd.args =
> -_("[-i infile [-dwNOW] [-s skip]] [-b bs] [-S seed] [-FBR [-Z N]] [-V N] off len");
> +_("[-i infile [-dDwNOW] [-s skip]] [-b bs] [-S seed] [-FBR [-Z N]] [-V N] off len");
>  	pwrite_cmd.oneline =
>  		_("writes a number of bytes at a specified offset");
>  	pwrite_cmd.help = pwrite_help;
> diff --git a/man/man8/xfs_io.8 b/man/man8/xfs_io.8
> index 8bf3f57bd30e..ad9cf390b3c9 100644
> --- a/man/man8/xfs_io.8
> +++ b/man/man8/xfs_io.8
> @@ -222,7 +222,7 @@ See the
>  .B pread
>  command.
>  .TP
> -.BI "pwrite [ \-i " file " ] [ \-dwNOW ] [ \-s " skip " ] [ \-b " size " ] [ \-S " seed " ] [ \-FBR [ \-Z " zeed " ] ] [ \-V " vectors " ] " "offset length"
> +.BI "pwrite [ \-i " file " ] [ \-dDwNOW ] [ \-s " skip " ] [ \-b " size " ] [ \-S " seed " ] [ \-FBR [ \-Z " zeed " ] ] [ \-V " vectors " ] " "offset length"
>  Writes a range of bytes in a specified blocksize from the given
>  .IR offset .
>  The bytes written can be either a set pattern or read in from another
> @@ -248,7 +248,13 @@ once all writes are complete (included in timing results)
>  Perform the
>  .BR pwritev2 (2)
>  call with
> -.I RWF_NOWAIT.
> +.IR RWF_NOWAIT .
> +.TP
> +.B \-D
> +Perform the
> +.BR pwritev2 (2)
> +call with
> +.IR RWF_DSYNC .
>  .TP
>  .B \-O
>  perform pwrite once and return the (maybe partial) bytes written.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
