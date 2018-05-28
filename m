Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wr0-f174.google.com ([209.85.128.174]:38117 "EHLO
        mail-wr0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1165422AbeE1OCo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 28 May 2018 10:02:44 -0400
Received: by mail-wr0-f174.google.com with SMTP id 94-v6so20469165wrf.5
        for <linux-xfs@vger.kernel.org>; Mon, 28 May 2018 07:02:44 -0700 (PDT)
Date: Mon, 28 May 2018 16:02:39 +0200
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH 5/7] fsck: fix more bashisms
Message-ID: <20180528140239.fg632s7bj3yksepx@odin.usersys.redhat.com>
References: <152728629694.22515.17699396814561914788.stgit@magnolia>
 <152728632778.22515.10077636373761717143.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <152728632778.22515.10077636373761717143.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: sandeen@redhat.com, linux-xfs@vger.kernel.org

On Fri, May 25, 2018 at 03:12:07PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> command -v is a bashism, so we need to get rid of it.  The shell returns
> an error code of 127 if it couldn't invoke xfs_repair, so teach
> repair2fsck_code to deal with this.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

> ---
>  fsck/xfs_fsck.sh |   12 +++++-------
>  1 file changed, 5 insertions(+), 7 deletions(-)
> 
> 
> diff --git a/fsck/xfs_fsck.sh b/fsck/xfs_fsck.sh
> index 1916c07e..6af0f224 100755
> --- a/fsck/xfs_fsck.sh
> +++ b/fsck/xfs_fsck.sh
> @@ -20,6 +20,10 @@ repair2fsck_code() {
>  		;;
>  	4)  return 1 # The fs has been fixed
>  		;;
> +	127)
> +		echo "$NAME error: xfs_repair was not found!" 1>&2
> +		return 4
> +		;;
>  	*)  echo "$NAME error: An unknown return code from xfs_repair '$1'" 1>&2
>  		return 4 # something went wrong with xfs_repair
>  	esac
> @@ -59,13 +63,7 @@ if [ -n "$PS1" -o -t 0 ]; then
>  fi
>  
>  if $FORCE; then
> -	XFS_REPAIR=`command -v xfs_repair`
> -	if [ ! -x "$XFS_REPAIR" ] ; then
> -		echo "$NAME error: xfs_repair was not found!" 1>&2
> -		exit 4
> -	fi
> -
> -	$XFS_REPAIR -e $DEV
> +	xfs_repair -e $DEV
>  	repair2fsck_code $?
>  	exit $?
>  fi
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Carlos
