Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o69DBUUM114877 for <xfs@oss.sgi.com>; Fri, 9 Jul 2010 08:11:30 -0500
Subject: Re: [PATCH 1/2] Allow to specify unsupported file systems
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <1278602632-12425-1-git-send-email-lczerner@redhat.com>
References: <1278602632-12425-1-git-send-email-lczerner@redhat.com>
Date: Fri, 09 Jul 2010 08:14:19 -0500
Message-ID: <1278681259.5154.19.camel@doink>
Mime-Version: 1.0
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
To: Lukas Czerner <lczerner@redhat.com>
Cc: esandeen@redhat.com, xfs@oss.sgi.com

On Thu, 2010-07-08 at 17:23 +0200, Lukas Czerner wrote:
> As an addition to checking for supported file systems it would be nice
> to be able to specify unsupported file system. In combination with
> "generic" fs it can be useful. This patch adds that feature. For example
> to set ext3 as an unsupported fs add "!ext3" into list.

Interesting idea, I agree it could be useful to
exclude rather than have to enumerate everything.

I don't think there's any need to make use of it
except where needed--i.e., don't go changing things,
just use it where it fits from here on.

One comment below.

> Also specify ext3 and ex4 as unsupported file systems in 213 and 214
> since those fs does not support fallocate. There may be others though.
> 
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>
> ---
>  213       |    2 +-
>  214       |    2 +-
>  common.rc |   22 +++++++++++++++++-----
>  3 files changed, 19 insertions(+), 7 deletions(-)
> 
> diff --git a/213 b/213
> index 9982dd4..3e90c0a 100755
> --- a/213
> +++ b/213
> @@ -47,7 +47,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
>  
>  # real QA test starts here
>  # generic, but xfs_io's fallocate must work
> -_supported_fs generic
> +_supported_fs generic !ext3 !ext3

Did you mean !ext2 for the second one here?

>  # only Linux supports fallocate
>  _supported_os Linux
>  
> diff --git a/214 b/214
> index cef7626..c01ef30 100755
> --- a/214
> +++ b/214
> @@ -45,7 +45,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
>  
>  # real QA test starts here
>  # generic, but xfs_io's fallocate must work
> -_supported_fs generic
> +_supported_fs generic !ext3 !ext2
>  # only Linux supports fallocate
>  _supported_os Linux
>  
> diff --git a/common.rc b/common.rc
> index 6bf1e12..f2f4cc3 100644
> --- a/common.rc
> +++ b/common.rc
> @@ -656,15 +656,27 @@ _fail()
>  #
>  _supported_fs()
>  {
> +    supp=0
>      for f
>      do
> -	if [ "$f" = "$FSTYP" -o "$f" = "generic" ]
> -	then
> -	    return
> -	fi
> +        if [ "$f" = \!"$FSTYP" ]
> +        then
> +            supp=0
> +            break
> +        fi
> +
> +        if [ "$f" = "$FSTYP" -o "$f" = "generic" ]
> +        then
> +            supp=1
> +        fi
>      done
>  
> -    _notrun "not suitable for this filesystem type: $FSTYP"
> +    if [ $supp -eq 1 ]
> +    then
> +        return
> +    else
> +        _notrun "not suitable for this filesystem type: $FSTYP"
> +    fi
>  }
>  
>  # tests whether $FSTYP is one of the supported OSes for a test





_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
