Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 621F9C4332F
	for <linux-xfs@archiver.kernel.org>; Tue, 20 Dec 2022 22:29:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229750AbiLTW32 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 20 Dec 2022 17:29:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233010AbiLTW30 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 20 Dec 2022 17:29:26 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7340B60FE
        for <linux-xfs@vger.kernel.org>; Tue, 20 Dec 2022 14:29:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0EF8661507
        for <linux-xfs@vger.kernel.org>; Tue, 20 Dec 2022 22:29:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D540C433D2;
        Tue, 20 Dec 2022 22:29:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671575364;
        bh=bZpqAtWbNxc3CgouXlqO65tHUbo24qYLgsnkD50ObzI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Ivb7I9iVq0+rSpCvdOiscHq7cfA29+Ohc746zotPIYeQxT8QaI/4sQCQvUbkzZNLG
         rrpyTNDFMTKPb3ToKsjrJkhCPluCfl0yi+xy/zG2H2GEJvDHXEHSPmxyqCiTR5B/Mv
         3o/eoTk6IRlYOFQk0xEBZwcfpY6ZTbdx4orx2Jy11q/GWwZVXefkkeKPWKU1ocJ+l6
         9bHUoW+7lCxd7y35zjnHN0zmzFRF8hVHaXDn/IobsHM/zzhVQqdvmnWSWwyzEFsE+s
         M8piRJZfsWzK+xGwhXJdGafvLytcPVMX8L8VULSxqBG3rPxOBgqCyitVBj5qaH0YCB
         ghNRkUWNVMfHg==
Date:   Tue, 20 Dec 2022 14:29:23 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Catherine Hoang <catherine.hoang@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2 2/2] xfs_admin: get UUID of mounted filesystem
Message-ID: <Y6I3Q28TAOv7VVET@magnolia>
References: <20221219181824.25157-1-catherine.hoang@oracle.com>
 <20221219181824.25157-3-catherine.hoang@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221219181824.25157-3-catherine.hoang@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Dec 19, 2022 at 10:18:24AM -0800, Catherine Hoang wrote:
> Adapt this tool to call xfs_io to retrieve the UUID of a mounted filesystem.
> This is a precursor to enabling xfs_admin to set the UUID of a mounted
> filesystem.
> 
> Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
> Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
> ---
>  db/xfs_admin.sh      | 27 +++++++++++++++++++++++----
>  man/man8/xfs_admin.8 |  4 ++++
>  2 files changed, 27 insertions(+), 4 deletions(-)
> 
> diff --git a/db/xfs_admin.sh b/db/xfs_admin.sh
> index 409975b2..cc9a2150 100755
> --- a/db/xfs_admin.sh
> +++ b/db/xfs_admin.sh
> @@ -6,10 +6,12 @@
>  
>  status=0
>  DB_OPTS=""
> +DB_EXTRA_OPTS=""
> +IO_OPTS=""
>  REPAIR_OPTS=""
>  REPAIR_DEV_OPTS=""
>  LOG_OPTS=""
> -USAGE="Usage: xfs_admin [-efjlpuV] [-c 0|1] [-L label] [-O v5_feature] [-r rtdev] [-U uuid] device [logdev]"
> +USAGE="Usage: xfs_admin [-efjlpuV] [-c 0|1] [-L label] [-O v5_feature] [-r rtdev] [-U uuid] [mountpoint|device] [logdev]"

I don't think it's necessary to expand xfs_admin to take a mount point,
since findmnt returns the mount point associated with a block device.

>  
>  while getopts "c:efjlL:O:pr:uU:V" c
>  do
> @@ -23,7 +25,8 @@ do
>  	O)	REPAIR_OPTS=$REPAIR_OPTS" -c $OPTARG";;
>  	p)	DB_OPTS=$DB_OPTS" -c 'version projid32bit'";;
>  	r)	REPAIR_DEV_OPTS=" -r '$OPTARG'";;
> -	u)	DB_OPTS=$DB_OPTS" -r -c uuid";;
> +	u)	DB_EXTRA_OPTS=$DB_EXTRA_OPTS" -r -c uuid";
> +		IO_OPTS=$IO_OPTS" -r -c fsuuid";;
>  	U)	DB_OPTS=$DB_OPTS" -c 'uuid "$OPTARG"'";;
>  	V)	xfs_db -p xfs_admin -V
>  		status=$?
> @@ -38,14 +41,30 @@ set -- extra $@
>  shift $OPTIND
>  case $# in
>  	1|2)
> +		# Target either a device or mountpoint, not both
> +		if [ -n "$(findmnt -t xfs -T $1)" ]; then

Note that xfs_io acts upon a mountpoint, not a block device, so you
need to save the mount point that findmnt returns here.  You might also
want to look at the -o option to constrain its output to only the
information you need.

> +			if [ -n "$DB_OPTS" ] || [ -n "$REPAIR_OPTS" ]; then
> +				echo "Offline options target a device, not mountpoint."
> +				exit 2
> +			fi
> +			DB_EXTRA_OPTS=""
> +		else
> +			IO_OPTS=""

Hmm.  DB_EXTRA_OPS is really the container of xfs_db commands that also
have xfs_io alternatives, whereas DB_OPTS/REPAIR_OPTS are things that
require an unmounted fs.  Yet we can't access OPTIND until after we've
completely finished getopts processing.  I suspect this isn't a great
way to be handling this, because what does "EXTRA" mean, actually?  It's
not immediately obvious from the name.

I can't help but wonder if the behaviors would be clearer if we tracked
explicitly which subcommands require a mounted fs, which ones require an
unmounted fs (nearly all of them), and which ones can go back and forth.
Something like this:

require_offline=""
require_online=""
DB_OPTS=""
REPAIR_OPTS=""
IO_OPTS=""
<more initialization>

while getopts "c:efjlL:O:pr:uU:V" c
do
	case $c in
	c)
		REPAIR_OPTS=$REPAIR_OPTS" -c lazycount="$OPTARG
		require_offline=1
		;;

	<more options here>

	u)
		DB_OPTS=$DB_OPTS" -r -c uuid"
		IO_OPTS=$IO_OPTS" -c uuid"
		;;
	U)
		DB_OPTS=$DB_OPTS" -c 'uuid "$OPTARG"'"
		require_offline=1
		;;

	<rest of options here>
done

...and then later on when it's time to take action...

		if mntpt="$(findmnt -t xfs -f -n -o TARGET "$1" 2>/dev/null)"; then
			# filesystem is mounted
			if [ -n "$require_offline" ]; then
				echo "$1: filesystem is mounted."
				exit 2
			fi

			exec xfs_io -p xfs_admin "$IO_OPTS" "$mntpt"
		fi

		# filesystem is not mounted
		if [ -n "$require_offline" ]; then
			echo "$1: filesystem is not mounted"
			exit 2
		fi

		<regular DB_OPTS/REPAIR_OPTS processing>

--D

> +		fi
> +
>  		# Pick up the log device, if present
>  		if [ -n "$2" ]; then
>  			LOG_OPTS=" -l '$2'"
>  		fi
>  
> -		if [ -n "$DB_OPTS" ]
> +		if [ -n "$DB_OPTS" ] || [ -n "$DB_EXTRA_OPTS" ]
> +		then
> +			eval xfs_db -x -p xfs_admin $LOG_OPTS $DB_OPTS $DB_EXTRA_OPTS "$1"
> +			status=$?
> +		fi
> +		if [ -n "$IO_OPTS" ]
>  		then
> -			eval xfs_db -x -p xfs_admin $LOG_OPTS $DB_OPTS "$1"
> +			eval xfs_io -x -p xfs_admin $IO_OPTS "$1"
>  			status=$?
>  		fi
>  		if [ -n "$REPAIR_OPTS" ]
> diff --git a/man/man8/xfs_admin.8 b/man/man8/xfs_admin.8
> index 4794d677..2c7ddc15 100644
> --- a/man/man8/xfs_admin.8
> +++ b/man/man8/xfs_admin.8
> @@ -19,7 +19,11 @@ xfs_admin \- change parameters of an XFS filesystem
>  .B \-r
>  .I rtdev
>  ]
> +[
> +.I mount-point
> +|
>  .I device
> +]
>  [
>  .I logdev
>  ]
> -- 
> 2.25.1
> 
