Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q3INpdA7249671 for <xfs@oss.sgi.com>; Wed, 18 Apr 2012 18:51:39 -0500
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	dwq5RUz8q6JhPw6c for <xfs@oss.sgi.com>;
	Wed, 18 Apr 2012 16:51:37 -0700 (PDT)
Date: Thu, 19 Apr 2012 09:51:35 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/3 V2] xfstests 198, 240, common.rc: added check for
	aiodio-sparse2
Message-ID: <20120418235135.GS6734@dastard>
References: <y> <1334654687-25450-1-git-send-email-tmarek@redhat.com>
	<1334654687-25450-2-git-send-email-tmarek@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1334654687-25450-2-git-send-email-tmarek@redhat.com>
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
To: Tom Marek <tmarek@redhat.com>
Cc: lczerner@redhat.com, dchinner@redhat.com, xfs@oss.sgi.com

On Tue, Apr 17, 2012 at 11:24:46AM +0200, Tom Marek wrote:
> Tests number 198 and 240 could fail when aiodio-sparse2 was not build.
> _require_aiodio helper was added to common.rc file to fix this.
> 
> Cc: david@fromorbit.com
> Signed-off-by: Tom Marek <tmarek@redhat.com>
> Reviewed-by: Lukas Czerner <lczerner@redhat.com>
.....
> @@ -770,6 +770,14 @@ _require_scratch()
>      fi
>  }
>  
> +# this test needs aio-dio-regress to be built
> +#
> +_require_aiodio()
> +{
> +    [ -x $here/src/aio-dio-regress/aiodio_sparse2 ] || \
> +        _notrun "This tests requires src/aio-dio-regress/ to be built"
> +}

This function already exists in common.rc, which is why I pointed it
out for use.

# this test requires that a (specified) aio-dio executable exists
# $1 - command (optional)
#
_require_aiodio()
{
    if [ -z "$1" ]
    then
        AIO_TEST=src/aio-dio-regress/aiodio_sparse2
        [ -x $AIO_TEST ] || _notrun "aio-dio utilities required"
    else
        AIO_TEST=src/aio-dio-regress/$1
        [ -x $AIO_TEST ] || _notrun "$AIO_TEST not built"
    fi
}

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
