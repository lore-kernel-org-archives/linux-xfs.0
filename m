Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:46448 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727188AbfGJVoh (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 10 Jul 2019 17:44:37 -0400
Subject: Re: [PATCH] Fix the inconsistency between the code and the manual
 page of mkfs.xfs.
References: <1560421580-22920-1-git-send-email-Alvin@linux.alibaba.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <aa442f3b-e0ee-ea55-efcd-9aa3a499fdec@sandeen.net>
Date: Wed, 10 Jul 2019 16:44:34 -0500
MIME-Version: 1.0
In-Reply-To: <1560421580-22920-1-git-send-email-Alvin@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Alvin@linux.alibaba.com, linux-xfs@vger.kernel.org, sandeen@redhat.com
Cc: caspar@linux.alibaba.com

On 6/13/19 5:26 AM, Alvin@linux.alibaba.com wrote:
> From: Alvin Zheng <Alvin@linux.alibaba.com>
> 
> Signed-off-by: Alvin Zheng <Alvin@linux.alibaba.com>

Sorry for getting to this so late.  First of all, we need a descriptive
changelog, something like:



mkfs.xfs.8: Fix an inconsistency between the code and the man page

The man page currently states that block and sector size units cannot
be used for other option values unless they are explicitly specified,
when in fact the default sizes will be used in that case.

Change the man page to clarify this.


> ---
>  man/man8/mkfs.xfs.8 | 23 ++++++++++++++---------
>  1 file changed, 14 insertions(+), 9 deletions(-)
> 
> diff --git a/man/man8/mkfs.xfs.8 b/man/man8/mkfs.xfs.8
> index 4b8c78c..bf2ad54 100644
> --- a/man/man8/mkfs.xfs.8
> +++ b/man/man8/mkfs.xfs.8
> @@ -115,9 +115,12 @@ When specifying parameters in units of sectors or filesystem blocks, the
>  .B \-s
>  option or the
>  .B \-b
> -option first needs to be added to the command line.
> -Failure to specify the size of the units will result in illegal value errors
> -when parameters are quantified in those units.
> +option can be used to specify the size of the sector or block. The 

trailing whitespace there

> +.B \-s
> +option and the
> +.B \-b
> +should be placed before any options in units of sectors or blocks. If the size of the block
> +or sector is not specified, the default size (block: 4KiB, sector: 512B) will be used.

 > 80 col lines.

But also, it seems that it's not actually necessary to state them first, as this works
as expected:

# mkfs/mkfs.xfs -d size=65536b,file,name=fsfile -b size=2k
                        ^^^^^^                     ^^^^^^^
meta-data=fsfile                 isize=512    agcount=4, agsize=16384 blks
         =                       sectsz=512   attr=2, projid32bit=1
         =                       crc=1        finobt=1, sparse=1, rmapbt=0
         =                       reflink=1
data     =                       bsize=2048   blocks=65536, imaxpct=25
                                       ^^^^          ^^^^^
         =                       sunit=0      swidth=0 blks

...

# mkfs/mkfs.xfs -d size=65536s,file,name=fsfile -s size=2k
                        ^^^^^^                     ^^^^^^^
meta-data=fsfile                 isize=512    agcount=4, agsize=8192 blks
         =                       sectsz=2048  attr=2, projid32bit=1
                                        ^^^^
         =                       crc=1        finobt=1, sparse=1, rmapbt=0
         =                       reflink=1
data     =                       bsize=4096   blocks=32768, imaxpct=25
                                                     ^^^^^
         =                       sunit=0      swidth=0 blks

I think this is because we only parse the string to start:

data_opts_parser()

        case D_SIZE:
                cli->dsize = getstr(value, opts, subopt);
                break;

and in fact this is true for all the things that can take this type of unit:

        /* parameters that depend on sector/block size being validated. */
        char    *dsize;
        char    *agsize;
        char    *dsu;
        char    *dirblocksize;
        char    *logsize;
        char    *lsu;
        char    *rtextsize;
        char    *rtsize;

So we validate blocksize & sector size and move them from cli or defaults
into cfg, as needed:

        validate_blocksize(&cfg, &cli, &dft);
        validate_sectorsize(&cfg, &cli, &dft, &ft, dfile, dry_run,
                            force_overwrite);

and from then on we can start converting other sizes using those units:

        /*
         * we've now completed basic validation of the features, sector and
         * block sizes, so from this point onwards we use the values found in
         * the cfg structure for them, not the command line structure.
         */ 
        validate_dirblocksize(&cfg, &cli);
        validate_inodesize(&cfg, &cli); 
...

so I think the changes which indicate that -s size and -b size must be stated
first are not actually correct, as it was intentional to handle them being
stated in any order.  (I know Dave said otherwise, but I think he was 
wrong, and he forgot how he wrote this code) ;)

-Eric

>  .PP
>  Many feature options allow an optional argument of 0 or 1, to explicitly
>  disable or enable the functionality.
> @@ -136,9 +139,10 @@ The filesystem block size is specified with a
>  in bytes. The default value is 4096 bytes (4 KiB), the minimum is 512, and the
>  maximum is 65536 (64 KiB).
>  .IP
> -To specify any options on the command line in units of filesystem blocks, this
> -option must be specified first so that the filesystem block size is
> -applied consistently to all options.
> +If a non-default filesystem block size is specified, the option
> +must be specified before any options that use filesystem block size
> +units so that the non-default filesystem block size is applied
> +consistently to all options.
>  .IP
>  Although
>  .B mkfs.xfs
> @@ -895,9 +899,10 @@ is 512 bytes. The minimum value for sector size is
>  must be a power of 2 size and cannot be made larger than the
>  filesystem block size.
>  .IP
> -To specify any options on the command line in units of sectors, this
> -option must be specified first so that the sector size is
> -applied consistently to all options.
> +If a non-default sector size is specified, the option
> +must be specified before any options that use sector size
> +units so that the non-default sector size is applied
> +consistently to all options.
>  .RE
>  .TP
>  .BI \-L " label"
> 
