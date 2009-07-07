Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n67E4RP2147956 for <xfs@oss.sgi.com>; Tue, 7 Jul 2009 09:04:27 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C63B1348DA7
	for <xfs@oss.sgi.com>; Tue,  7 Jul 2009 07:05:02 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id kJb2A680AZ1Iul63 for
	<xfs@oss.sgi.com>; Tue, 07 Jul 2009 07:05:02 -0700 (PDT)
Message-ID: <4A53560D.5080409@sandeen.net>
Date: Tue, 07 Jul 2009 09:05:01 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests: small common.config cleanup
References: <20090620173818.GA26809@infradead.org>
In-Reply-To: <20090620173818.GA26809@infradead.org>
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

Christoph Hellwig wrote:
> Don't list various non-mandatory options near the check for the
> mandatory ones, and make the test for the mandatory ones a proper if
> statements.
> 
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks ok to me:

Reviewed-by: Eric Sandeen <sandeen@sandeen.net>

> Index: xfstests-dev/common.config
> ===================================================================
> --- xfstests-dev.orig/common.config	2009-06-20 19:15:14.576805079 +0200
> +++ xfstests-dev/common.config	2009-06-20 19:16:48.956930262 +0200
> @@ -191,27 +191,18 @@ known_hosts()
>    [ -f $HOST_CONFIG_DIR/$HOST ]        && . $HOST_CONFIG_DIR/$HOST
>    [ -f $HOST_CONFIG_DIR/$HOST.config ] && . $HOST_CONFIG_DIR/$HOST.config
>  
> +  #  Mandatory Config values.
>    MC=""
> -#  Non-Mandatory Config values.
> -#  [ -z "$MODULAR" ]        && MC="$MC MODULAR"
> -#  [ -z "$TEST_LOGDEV" ]    && MC="$MC TEST_LOGDEV"
> -#  [ -z "$SCRATCH_LOGDEV" ] && MC="$MC SCRATCH_LOGDEV"
> -#  [ -z "$SCRATCH_RTDEV" ]  && MC="$MC SCRATCH_RTDEV"
> -#  [ -z "$SCRATCH_MNT" ]    && MC="$MC SCRATCH_MNT"
> -#  [ -z "$SCRATCH_DEV" ]    && MC="$MC SCRATCH_DEV"
> -
>    [ -z "$EMAIL" ]          && MC="$MC EMAIL"
>    [ -z "$TEST_DIR" ]       && MC="$MC TEST_DIR"
>    [ -z "$TEST_DEV" ]       && MC="$MC TEST_DEV"
>  
> -  [ "$MC" ] && (echo "Warning: need to define parameters for host $HOST";\
> -	        echo "       or set variables:"; \
> -		echo "       $MC")
> -#  if [ -e configs/$HOST.config ]
> -#     then echo "Not carring, we have a configfile ($HOST_CONFIG_DIR/$HOST)"
> -#  else
> -     [ "$MC" ] &&  exit 1
> -#  fi
> +  if [ -n "$MC" ]; then
> +    echo "Warning: need to define parameters for host $HOST"
> +    echo "       or set variables:"
> +    echo "       $MC"
> +    exit 1
> +  fi
>  }
>  
>  if [ -f "$HOST_OPTIONS" ]; then
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
