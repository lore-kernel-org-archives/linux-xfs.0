Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:54402 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751215AbeE1Dwm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 27 May 2018 23:52:42 -0400
From: Allison Henderson <allison.henderson@oracle.com>
Subject: Re: [PATCH 5/7] fsck: fix more bashisms
References: <152728629694.22515.17699396814561914788.stgit@magnolia>
 <152728632778.22515.10077636373761717143.stgit@magnolia>
Message-ID: <0e373663-3c31-71f2-ddfe-aebd23bf573c@oracle.com>
Date: Sun, 27 May 2018 20:52:27 -0700
MIME-Version: 1.0
In-Reply-To: <152728632778.22515.10077636373761717143.stgit@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, sandeen@redhat.com
Cc: linux-xfs@vger.kernel.org

Alrighty, you can add my review
Reviewed by: Allison Henderson <allison.henderson@oracle.com>

On 05/25/2018 03:12 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> command -v is a bashism, so we need to get rid of it.  The shell returns
> an error code of 127 if it couldn't invoke xfs_repair, so teach
> repair2fsck_code to deal with this.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>   fsck/xfs_fsck.sh |   12 +++++-------
>   1 file changed, 5 insertions(+), 7 deletions(-)
> 
> 
> diff --git a/fsck/xfs_fsck.sh b/fsck/xfs_fsck.sh
> index 1916c07e..6af0f224 100755
> --- a/fsck/xfs_fsck.sh
> +++ b/fsck/xfs_fsck.sh
> @@ -20,6 +20,10 @@ repair2fsck_code() {
>   		;;
>   	4)  return 1 # The fs has been fixed
>   		;;
> +	127)
> +		echo "$NAME error: xfs_repair was not found!" 1>&2
> +		return 4
> +		;;
>   	*)  echo "$NAME error: An unknown return code from xfs_repair '$1'" 1>&2
>   		return 4 # something went wrong with xfs_repair
>   	esac
> @@ -59,13 +63,7 @@ if [ -n "$PS1" -o -t 0 ]; then
>   fi
>   
>   if $FORCE; then
> -	XFS_REPAIR=`command -v xfs_repair`
> -	if [ ! -x "$XFS_REPAIR" ] ; then
> -		echo "$NAME error: xfs_repair was not found!" 1>&2
> -		exit 4
> -	fi
> -
> -	$XFS_REPAIR -e $DEV
> +	xfs_repair -e $DEV
>   	repair2fsck_code $?
>   	exit $?
>   fi
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  https://urldefense.proofpoint.com/v2/url?u=http-3A__vger.kernel.org_majordomo-2Dinfo.html&d=DwICaQ&c=RoP1YumCXCgaWHvlZYR8PZh8Bv7qIrMUB65eapI_JnE&r=LHZQ8fHvy6wDKXGTWcm97burZH5sQKHRDMaY1UthQxc&m=esB0ntIPOKHhY_lkqtduLsdDYUrE4GycWhxY5h4WJLo&s=rMUHX1OjhARCGXqcRie_xKoEdOlq1hooycaZJzLEqX0&e=
> 
