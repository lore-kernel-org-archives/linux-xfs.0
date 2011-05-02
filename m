Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p42JTQhw245427 for <xfs@oss.sgi.com>; Mon, 2 May 2011 14:29:26 -0500
Subject: Re: [PATCH] xfstests: support post-udev device mapper nodes
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20110502160232.GA14457@infradead.org>
References: <20110502160232.GA14457@infradead.org>
Date: Mon, 2 May 2011 14:32:59 -0500
Message-ID: <1304364779.3077.41.camel@doink>
MIME-Version: 1.0
Reply-To: aelder@sgi.com
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Mon, 2011-05-02 at 12:02 -0400, Christoph Hellwig wrote:
> Because of udevs complaining device mapper now creates /dev/dm-N as the real
> device nodes, and just symlinks the /dev/mapper/ names to it.  This would be
> easy if everything used the /dev/mapper clear names, but most system utilities
> translate them back to the /dev/mapper/ names and thus confuse various test
> cases.  Add support to _is_block_dev to read symlinks, and add documentation
> on how to run xfstests on device mapper volumes.

I'm not 100% sure I'm parsing the above right.  What
I read is that, although we want to use the "real"
device (not the link), the utilities tend to report
the /dev/mapper names.  Therefore we want to use
/dev/mapper names and internally translate them to
their real devices.

Based on that understanding I think what you're trying
to do is fine, but there a few problems with what you sent.
Note that I'm not even looking at the specifics of
/dev/mapper links at the moment.

> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Index: xfstests-dev/common.rc
> ===================================================================
> --- xfstests-dev.orig/common.rc	2011-05-02 12:45:25.000000000 +0000
> +++ xfstests-dev/common.rc	2011-05-02 12:45:28.000000000 +0000
> @@ -587,7 +587,14 @@ _is_block_dev()
>  	exit 1
>      fi
>  
> -    [ -b $1 ] && src/lstat64 $1 | $AWK_PROG '/Device type:/ { print $9 }'
> +    _dev=$1
> +    if [ -L ${_dev} ]; then
> +        _dev=`readlink -f ${_dev}`

Although it typically shouldn't, if the "readlink -f" fails,
it will make _dev have an empty value...

> +    fi
> +
> +    if [ -b ${_dev} ]; then

...which will lead to some sort of shell "syntax error"
message here, which is rather unhelpful.

At a minimum, I think putting quotes around it here
would avoid that (but you should test), i.e.,
    if [ -b "${_dev}" ]; then

> +        src/lstat64 ${_dev} | $AWK_PROG '/Device type:/ { print $9 }'
> +    fi
>  }
>  
>  # Do a command, log it to $seq.full, optionally test return status
> @@ -700,10 +707,12 @@ _require_scratch()
>  	*)
>  		 if [ -z "$SCRATCH_DEV" -o "`_is_block_dev $SCRATCH_DEV`" = "" ]
>  		 then
> +		     echo "no a block device";

This and the next one appear to be junk that should
be removed.

>  		     _notrun "this test requires a valid \$SCRATCH_DEV"
>  		 fi
>  		 if [ "`_is_block_dev $SCRATCH_DEV`" = "`_is_block_dev $TEST_DEV`" ]
>  		 then
> +		    echo "foo"
>  		     _notrun "this test requires a valid \$SCRATCH_DEV"
>  		 fi
>  		if [ ! -d "$SCRATCH_MNT" ]
> Index: xfstests-dev/README.device-mapper
> ===================================================================
> --- /dev/null	1970-01-01 00:00:00.000000000 +0000
> +++ xfstests-dev/README.device-mapper	2011-05-02 15:51:24.000000000 +0000
> @@ -0,0 +1,8 @@
> +
> +To use xfstests on device mapper always use the /dev/mapper/<name> symlinks,
> +not the /dev/dm-* devices, or the symlinks created by LVM.
> +
> +For example:
> +
> +TEST_DEV=/dev/mapper/test
> +SCRATCH_DEV=/dev/mapper/scratch
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
