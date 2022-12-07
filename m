Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A5A9C63703
	for <linux-xfs@archiver.kernel.org>; Wed,  7 Dec 2022 23:38:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230122AbiLGXiI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 7 Dec 2022 18:38:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229675AbiLGXiI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 7 Dec 2022 18:38:08 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C4C7528A4
        for <linux-xfs@vger.kernel.org>; Wed,  7 Dec 2022 15:38:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BA0D861CC3
        for <linux-xfs@vger.kernel.org>; Wed,  7 Dec 2022 23:38:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E478C433D6;
        Wed,  7 Dec 2022 23:38:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670456286;
        bh=Brv95WIsEpwMCXAE6Ar6T0kYvKpXe8jnVYrDbWzpdVc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=G1Xve4QE+U6JDKgkuMytfCsQ9DANd4qxHD3+ENoKLjGlm5hQ1/7S4lGOkEIyczQMH
         xpM2jCXVy8jQ12h9Gly8lQYjqeVRk8UsfPonGOGv7byd1E19n016JmCWRybnmtDKf+
         sLUftojST6agQUiMLIX4OAJDwsEAIb4zD+PLKu8eZlHQqjH5DO0jLnOtpjTUGxNC/C
         UOpu4F12CCF6DtfavGK0vC3a2YOOpvvqo+IMM3eR+PzatFkcSdPPMYKeq6+jBxpNaG
         Zm0qLoSshSjo78mKEg9fPQcM0XyZ2xEjFyFBia69v/jxaLaGfc8Z2fjWu5YaqqkAph
         il8jUz+Inxlpw==
Date:   Wed, 7 Dec 2022 15:38:05 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Catherine Hoang <catherine.hoang@oracle.com>,
        Carlos Maiolino <cmaiolino@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v1 2/2] xfs_admin: get UUID of mounted filesystem
Message-ID: <Y5Ej3Q9DWtpQ4+Cq@magnolia>
References: <20221207022346.56671-1-catherine.hoang@oracle.com>
 <20221207022346.56671-3-catherine.hoang@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221207022346.56671-3-catherine.hoang@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Dec 06, 2022 at 06:23:46PM -0800, Catherine Hoang wrote:
> Adapt this tool to call xfs_io to retrieve the UUID of a mounted filesystem.
> This is a precursor to enabling xfs_admin to set the UUID of a mounted
> filesystem.
> 
> Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
> ---
>  db/xfs_admin.sh | 21 ++++++++++++++++++---
>  1 file changed, 18 insertions(+), 3 deletions(-)
> 
> diff --git a/db/xfs_admin.sh b/db/xfs_admin.sh
> index 409975b2..0dcb9940 100755
> --- a/db/xfs_admin.sh
> +++ b/db/xfs_admin.sh
> @@ -6,6 +6,8 @@
>  
>  status=0
>  DB_OPTS=""
> +DB_EXTRA_OPTS=""
> +IO_OPTS=""

This seemed oddly familiar until I remembered that we've been here
before:
https://lore.kernel.org/linux-xfs/ac736821-83de-4bde-a1a1-d0d2711932d7@sandeen.net/

And now that I've reread that thread, I've now realized /why/ I gave up
on adding things to this script -- there were too many questions from
the maintainer for which I couldn't come up with any satisfying answer.
Then I burned out and gave up.

Ofc now we have a new maintainer, so I'll put the questions to the new
one.  To summarize:

What happens if there are multiple sources of truth because the fs is
mounted?  Do we stop after processing the online options and ignore the
offline ones?  Do we keep going, even though -f is almost certainly
required?

If the user specifies multiple options, is it ok to change the order in
which we run them so that we can run xfs_io and then xfs_db?

If it's not ok to change the order, how do we make the two tools run in
lockstep so we only have to open the filesystem once?

If it's not ok to change the order and we cannot do lockstep, is it ok
to invoke io/db once for each subcommand instead of assembling a giant
cli option array like we now for db?

If we have to invoke io/db multiple times, what do we do if the state
changes between invocations (e.g. someone else mounts the block dev or
unmounts the fs)?  What happens if this all results in multiple
xfs_repair invocations?

Can we prohibit people from running multiple subcommands?  Even if
that's a breaking change for someone who might be relying on the exact
behaviors of this shell script?

What if, instead of trying to find answers to all these annoying
questions, we instead decide that either all the subcommands have to
target a mountpoint or they all have to target a blockdev, or xfs_admin
will exit with an error code?

--D

>  REPAIR_OPTS=""
>  REPAIR_DEV_OPTS=""
>  LOG_OPTS=""
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
> @@ -38,14 +41,26 @@ set -- extra $@
>  shift $OPTIND
>  case $# in
>  	1|2)
> +		# Use xfs_io if mounted and xfs_db if not mounted
> +		if [ -n "$(findmnt -t xfs -T $1)" ]; then
> +			DB_EXTRA_OPTS=""
> +		else
> +			IO_OPTS=""
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
> -- 
> 2.25.1
> 
