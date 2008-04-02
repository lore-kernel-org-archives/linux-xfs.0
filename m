Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 01 Apr 2008 23:57:08 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m326uTxI012058
	for <xfs@oss.sgi.com>; Tue, 1 Apr 2008 23:56:33 -0700
Date: Wed, 02 Apr 2008 16:58:46 +1000
Subject: Re: [Patch] xfsqa: 091 needs to support sector size != 512 bytes
From: "Barry Naujok" <bnaujok@sgi.com>
Content-Type: text/plain; format=flowed; delsp=yes; charset=utf-8
MIME-Version: 1.0
References: <20080402053451.GE103491721@sgi.com>
Message-ID: <op.t8y1n8p23jf8g2@pc-bnaujok.melbourne.sgi.com>
In-Reply-To: <20080402053451.GE103491721@sgi.com>
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>, xfs-dev <xfs-dev@sgi.com>
Cc: xfs-oss <xfs@oss.sgi.com>

Not tested yet, but looks fine.

On Wed, 02 Apr 2008 15:34:51 +1000, David Chinner <dgc@sgi.com> wrote:

> Test 091 assumes a direct I/O alignment of 512 bytes,
> a hold over from 2.4 kernels. On 2.6. kernels, direct
> I/O needs to be aligned to the sector size the filesystem
> was mkfs'd with.
>
> Teach 091 about 2.6 kernels and grab the sector size from the
> xfs_info output.
>
> Signed-off-by: Dave Chinner <dgc@sgi.com>
> ---
>  xfstests/091 |   12 +++++++++++-
>  1 file changed, 11 insertions(+), 1 deletion(-)
>
> Index: xfs-cmds/xfstests/091
> ===================================================================
> --- xfs-cmds.orig/xfstests/091	2007-03-19 08:49:37.000000000 +1100
> +++ xfs-cmds/xfstests/091	2008-04-02 15:27:39.266824430 +1000
> @@ -43,10 +43,20 @@ run_fsx()
> psize=`$here/src/feature -s`
>  bsize=512
> -# 2.4 Linux kernels support bsize aligned direct I/O only
>  kernel=`uname -r  | sed -e 's/\(2\..\).*/\1/'`
> +
> +# 2.4 Linux kernels support bsize aligned direct I/O only
>  [ "$HOSTOS" = "Linux" -a "$kernel" = "2.4" ] && bsize=$psize
> +# 2.6 Linux kernels support sector aligned direct I/O only
> +if [ "$HOSTOS" = "Linux" -a "$kernel" = "2.6" ]; then
> +	xfs_info $TEST_DIR | _filter_mkfs 2> $tmp.info
> +	if [ $? -eq 0 ]; then
> +		source $tmp.info
> +		bsize=$sectsz
> +	fi
> +fi
> +
>  # fsx usage:
>  #
>  # -N numops: total # operations to do
>
>
