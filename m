Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:39130 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751716AbdKIE1v (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 8 Nov 2017 23:27:51 -0500
Subject: Re: [PATCH v3 2/3] xfs_io: Add RWF_NOWAIT to pwritev2()
References: <20171010105802.31353-1-rgoldwyn@suse.de>
 <20171010105802.31353-2-rgoldwyn@suse.de>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <9c9e611e-b38d-e85b-98dd-40009446095d@sandeen.net>
Date: Wed, 8 Nov 2017 22:27:50 -0600
MIME-Version: 1.0
In-Reply-To: <20171010105802.31353-2-rgoldwyn@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Goldwyn Rodrigues <rgoldwyn@suse.de>, linux-xfs@vger.kernel.org
Cc: darrick.wong@oracle.com, david@fromorbit.com, bfoster@redhat.com, Goldwyn Rodrigues <rgoldwyn@suse.com>

On 10/10/17 5:58 AM, Goldwyn Rodrigues wrote:
> From: Goldwyn Rodrigues <rgoldwyn@suse.com>
> 
> This allows to make pwritev2() calls with RWF_NOWAIT,
> which would fail in case the call blocks.
> 
> Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
> 
> Changes since v2:
> 	- ifdef around -N which set RWF_NOWAIT
> ---
>  io/pwrite.c       | 10 +++++++++-
>  man/man8/xfs_io.8 |  6 ++++++
>  2 files changed, 15 insertions(+), 1 deletion(-)
> 
> diff --git a/io/pwrite.c b/io/pwrite.c
> index 5ceb26c7..e06dfb46 100644
> --- a/io/pwrite.c
> +++ b/io/pwrite.c
> @@ -53,6 +53,9 @@ pwrite_help(void)
>  #ifdef HAVE_PWRITEV
>  " -V N -- use vectored IO with N iovecs of blocksize each (pwritev)\n"
>  #endif
> +#ifdef HAVE_PWRITEV2
> +" -N   -- Perform the pwritev2() with RWF_NOWAIT\n"
> +#endif
>  "\n"));
>  }

This "-N" option didn't get added to the short help:

void
pwrite_init(void)
{
        pwrite_cmd.name = "pwrite";
        pwrite_cmd.altname = "w";
        pwrite_cmd.cfunc = pwrite_f;
        pwrite_cmd.argmin = 2;
        pwrite_cmd.argmax = -1;
        pwrite_cmd.flags = CMD_NOMAP_OK | CMD_FOREIGN_OK;
        pwrite_cmd.args =
_("[-i infile [-d] [-s skip]] [-b bs] [-S seed] [-wW] [-FBR [-Z N]] [-V N] off len");

Is there any clean way to do that conditionally on the #ifdef as is done for long
help?  Otherwise just more #ifdefs I guess.
  
> @@ -279,7 +282,7 @@ pwrite_f(
>  	init_cvtnum(&fsblocksize, &fssectsize);
>  	bsize = fsblocksize;
>  
> -	while ((c = getopt(argc, argv, "b:BCdf:Fi:qRs:S:uV:wWZ:")) != EOF) {
> +	while ((c = getopt(argc, argv, "b:BCdf:Fi:NqRs:S:uV:wWZ:")) != EOF) {
>  		switch (c) {
>  		case 'b':
>  			tmp = cvtnum(fsblocksize, fssectsize, optarg);
> @@ -308,6 +311,11 @@ pwrite_f(
>  		case 'i':
>  			infile = optarg;
>  			break;
> +#ifdef HAVE_PWRITEV2
> +		case 'N':
> +			pwritev2_flags |= RWF_NOWAIT;
> +			break;
> +#endif

If pwritev2 isn't present at build time, specifying -N gives somewhat unexpected behavior:

xfs_io> pwrite -N 0 1k
pwrite [-i infile [-d] [-s skip]] [-b bs] [-S seed] [-wW] [-FBR [-Z N]] [-V N] off len -- writes a number of bytes at a specified offset
xfs_io>

vs a wholly unknown option:

xfs_io> pwrite -K 0 1k
pwrite: invalid option -- 'K'
xfs_io>

because you have 'N' in the getopt string.  I wonder if there's a better
way to handle it besides moar ifdefs ... I guess this wouldn't be
terrible:

+		case 'N':
+#ifdef HAVE_PWRITEV2
+			pwritev2_flags |= RWF_NOWAIT;
+#else
+			printf(_("Not built with pwritev2 functionality\n"));
+#endif
+			break;

>  		case 's':
>  			skip = cvtnum(fsblocksize, fssectsize, optarg);
>  			if (skip < 0) {
> diff --git a/man/man8/xfs_io.8 b/man/man8/xfs_io.8
> index 0fd9b951..9c58914f 100644
> --- a/man/man8/xfs_io.8
> +++ b/man/man8/xfs_io.8
> @@ -282,6 +282,12 @@ Use the vectored IO write syscall
>  with a number of blocksize length iovecs. The number of iovecs is set by the
>  .I vectors
>  parameter.
> +.TP
> +.B \-N
> +Perform the
> +.BR pwritev2 (2)
> +call with
> +.I RWF_NOWAIT.

I guess maybe this should say something about "if it's built w/ pwritev2 functionality?"
I'm less worried about this, tbh, especially if -N gives the explanation above
if xfs_io doesn't have the support.

-Eric

>  .RE
>  .PD
>  .TP
> 
