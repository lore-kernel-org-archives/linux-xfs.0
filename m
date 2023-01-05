Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3154BC3DA7A
	for <linux-xfs@archiver.kernel.org>; Thu,  5 Jan 2023 19:48:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235058AbjAETsB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 5 Jan 2023 14:48:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234720AbjAETrh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 Jan 2023 14:47:37 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8351E14D29
        for <linux-xfs@vger.kernel.org>; Thu,  5 Jan 2023 11:47:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 207EE61C17
        for <linux-xfs@vger.kernel.org>; Thu,  5 Jan 2023 19:47:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76798C433D2;
        Thu,  5 Jan 2023 19:47:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672948055;
        bh=G5u9p44cxoovzog286o8B2olPPAs3q8LR0N00fIqxE4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=H7GhSgMxg55Dc2u0rChigJTNdLTOhX7Wm4/hGo+0OSme7heIiLjqM7fIUVH0LpsAS
         f6bS3JoruemyO1AH3Fw7fLEPbtvlTd6PG07lbbiAeBmUlEGoqEZSQMfW6ueowVEOdT
         dVQOxkPZYzLKQA220CYY9lml1RF8f/T0AY4xcZxcr2fdP9+qGea64INGkmcXM/Diw1
         Wke7rEN7SBxR8sbrbgjtqwE76pYeht5DshuqMBzbDZoQNuNrtOtWOGuU5363NJ+09D
         YLZGnDDn67DPrm2VZWr6CjxM/1hsVDfc4tR0enrJ4d5J5vaStmSapReU6HqdcxE14H
         1XStNuydI6y+A==
Date:   Thu, 5 Jan 2023 11:47:34 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Catherine Hoang <catherine.hoang@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v3 2/2] xfs_admin: get UUID of mounted filesystem
Message-ID: <Y7cpVnPqLwBLFHmM@magnolia>
References: <20230105003613.29394-1-catherine.hoang@oracle.com>
 <20230105003613.29394-3-catherine.hoang@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230105003613.29394-3-catherine.hoang@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jan 04, 2023 at 04:36:13PM -0800, Catherine Hoang wrote:
> Adapt this tool to call xfs_io to retrieve the UUID of a mounted filesystem.
> This is a precursor to enabling xfs_admin to set the UUID of a mounted
> filesystem.
> 
> Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
> ---
>  db/xfs_admin.sh | 61 +++++++++++++++++++++++++++++++++++++++++--------
>  1 file changed, 51 insertions(+), 10 deletions(-)
> 
> diff --git a/db/xfs_admin.sh b/db/xfs_admin.sh
> index 409975b2..b73fb3ad 100755
> --- a/db/xfs_admin.sh
> +++ b/db/xfs_admin.sh
> @@ -5,8 +5,11 @@
>  #
>  
>  status=0
> +require_offline=""
> +require_online=""
>  DB_OPTS=""
>  REPAIR_OPTS=""
> +IO_OPTS=""
>  REPAIR_DEV_OPTS=""
>  LOG_OPTS=""
>  USAGE="Usage: xfs_admin [-efjlpuV] [-c 0|1] [-L label] [-O v5_feature] [-r rtdev] [-U uuid] device [logdev]"
> @@ -14,17 +17,37 @@ USAGE="Usage: xfs_admin [-efjlpuV] [-c 0|1] [-L label] [-O v5_feature] [-r rtdev
>  while getopts "c:efjlL:O:pr:uU:V" c
>  do
>  	case $c in
> -	c)	REPAIR_OPTS=$REPAIR_OPTS" -c lazycount="$OPTARG;;
> -	e)	DB_OPTS=$DB_OPTS" -c 'version extflg'";;
> -	f)	DB_OPTS=$DB_OPTS" -f";;
> -	j)	DB_OPTS=$DB_OPTS" -c 'version log2'";;
> +	c)	REPAIR_OPTS=$REPAIR_OPTS" -c lazycount="$OPTARG
> +		require_offline=1
> +		;;
> +	e)	DB_OPTS=$DB_OPTS" -c 'version extflg'"
> +		require_offline=1
> +		;;
> +	f)	DB_OPTS=$DB_OPTS" -f"
> +		require_offline=1
> +		;;
> +	j)	DB_OPTS=$DB_OPTS" -c 'version log2'"
> +		require_offline=1
> +		;;
>  	l)	DB_OPTS=$DB_OPTS" -r -c label";;

Now that xfs_admin can issue commands directly against mounted
filesystems, I suppose it ought to wire up support for querying and
changing the label as well.  Doing that should be trivial, and
definitely an idea for a separate patch:

# xfs_io -c 'label' /mnt
label = "hi"
# xfs_io -c 'label -s bye' /mnt
label = "bye"
# xfs_io -c 'label' /mnt
label = "bye"

*This* patch looks correct to me, so
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> -	L)	DB_OPTS=$DB_OPTS" -c 'label "$OPTARG"'";;
> -	O)	REPAIR_OPTS=$REPAIR_OPTS" -c $OPTARG";;
> -	p)	DB_OPTS=$DB_OPTS" -c 'version projid32bit'";;
> -	r)	REPAIR_DEV_OPTS=" -r '$OPTARG'";;
> -	u)	DB_OPTS=$DB_OPTS" -r -c uuid";;
> -	U)	DB_OPTS=$DB_OPTS" -c 'uuid "$OPTARG"'";;
> +	L)	DB_OPTS=$DB_OPTS" -c 'label "$OPTARG"'"
> +		require_offline=1
> +		;;
> +	O)	REPAIR_OPTS=$REPAIR_OPTS" -c $OPTARG"
> +		require_offline=1
> +		;;
> +	p)	DB_OPTS=$DB_OPTS" -c 'version projid32bit'"
> +		require_offline=1
> +		;;
> +	r)	REPAIR_DEV_OPTS=" -r '$OPTARG'"
> +		require_offline=1
> +		;;
> +	u)	DB_OPTS=$DB_OPTS" -r -c uuid"
> +		IO_OPTS=$IO_OPTS" -r -c fsuuid"
> +		;;
> +	U)	DB_OPTS=$DB_OPTS" -c 'uuid "$OPTARG"'"
> +		require_offline=1
> +		;;
>  	V)	xfs_db -p xfs_admin -V
>  		status=$?
>  		exit $status
> @@ -38,6 +61,24 @@ set -- extra $@
>  shift $OPTIND
>  case $# in
>  	1|2)
> +		if mntpt="$(findmnt -t xfs -f -n -o TARGET "$1" 2>/dev/null)"; then
> +			# filesystem is mounted
> +			if [ -n "$require_offline" ]; then
> +				echo "$1: filesystem is mounted."
> +				exit 2
> +			fi
> +
> +			if [ -n "$IO_OPTS" ]; then
> +				exec xfs_io -p xfs_admin $IO_OPTS "$mntpt"
> +			fi
> +		fi
> +
> +		# filesystem is not mounted
> +		if [ -n "$require_online" ]; then
> +			echo "$1: filesystem is not mounted"
> +			exit 2
> +		fi
> +
>  		# Pick up the log device, if present
>  		if [ -n "$2" ]; then
>  			LOG_OPTS=" -l '$2'"
> -- 
> 2.25.1
> 
