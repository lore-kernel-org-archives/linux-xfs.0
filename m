Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59D38C433DB
	for <linux-xfs@archiver.kernel.org>; Wed, 24 Mar 2021 20:49:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1D17860C3E
	for <linux-xfs@archiver.kernel.org>; Wed, 24 Mar 2021 20:49:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238162AbhCXUsT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 24 Mar 2021 16:48:19 -0400
Received: from sandeen.net ([63.231.237.45]:38034 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238108AbhCXUr4 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 24 Mar 2021 16:47:56 -0400
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 03D8A7904;
        Wed, 24 Mar 2021 15:47:10 -0500 (CDT)
To:     "Darrick J. Wong" <djwong@kernel.org>,
        Eric Sandeen <sandeen@redhat.com>
Cc:     xfs <linux-xfs@vger.kernel.org>, Brian Foster <bfoster@redhat.com>
References: <20210324021018.GQ22100@magnolia>
From:   Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH] xfs_admin: pick up log arguments correctly
Message-ID: <773c904b-4468-e16e-dc17-5942988c997c@sandeen.net>
Date:   Wed, 24 Mar 2021 15:47:54 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210324021018.GQ22100@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 3/23/21 9:10 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> In commit ab9d8d69, we added support to xfs_admin to pass an external
> log to xfs_db and xfs_repair.  Unfortunately, we didn't do this
> correctly -- by appending the log arguments to DB_OPTS, we now guarantee
> an invocation of xfs_db when we don't have any work for it to do.
> 
> Brian Foster noticed that this results in xfs/764 hanging fstests
> because xfs_db (when not compiled with libeditline) will wait for input
> on stdin.  I didn't notice because my build includes libeditline and my
> test runner script does silly things with pipes such that xfs_db would
> exit immediately.
> 
> Reported-by: Brian Foster <bfoster@redhat.com>
> Fixes: ab9d8d69 ("xfs_admin: support adding features to V5 filesystems")
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>

This seems fine.  While astute bashophiles will have no problem with this,
at some point it might be nice to add some comments above DB_OPTS and
REPAIR_OPTS that point out hey, if you set these, you WILL be invoking the
tool.

I also chafe a little at accumulating some device options in REPAIR_DEV_OPTS
and others in LOG_OPTS; why not REPAIR_DEV_OPTS and DB_DEV_OPTS for some
consistency?

But, this does seem to solve the problem, and in the
Spirit of Lets Not Navel-Gaze And Just Keep Fixing Things(tm),

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
>  db/xfs_admin.sh |    9 ++++-----
>  1 file changed, 4 insertions(+), 5 deletions(-)
> 
> diff --git a/db/xfs_admin.sh b/db/xfs_admin.sh
> index 916050cb..409975b2 100755
> --- a/db/xfs_admin.sh
> +++ b/db/xfs_admin.sh
> @@ -8,7 +8,7 @@ status=0
>  DB_OPTS=""
>  REPAIR_OPTS=""
>  REPAIR_DEV_OPTS=""
> -DB_LOG_OPTS=""
> +LOG_OPTS=""
>  USAGE="Usage: xfs_admin [-efjlpuV] [-c 0|1] [-L label] [-O v5_feature] [-r rtdev] [-U uuid] device [logdev]"
>  
>  while getopts "c:efjlL:O:pr:uU:V" c
> @@ -40,19 +40,18 @@ case $# in
>  	1|2)
>  		# Pick up the log device, if present
>  		if [ -n "$2" ]; then
> -			DB_OPTS=$DB_OPTS" -l '$2'"
> -			REPAIR_DEV_OPTS=$REPAIR_DEV_OPTS" -l '$2'"
> +			LOG_OPTS=" -l '$2'"
>  		fi
>  
>  		if [ -n "$DB_OPTS" ]
>  		then
> -			eval xfs_db -x -p xfs_admin $DB_OPTS "$1"
> +			eval xfs_db -x -p xfs_admin $LOG_OPTS $DB_OPTS "$1"
>  			status=$?
>  		fi
>  		if [ -n "$REPAIR_OPTS" ]
>  		then
>  			echo "Running xfs_repair to upgrade filesystem."
> -			eval xfs_repair $REPAIR_DEV_OPTS $REPAIR_OPTS "$1"
> +			eval xfs_repair $LOG_OPTS $REPAIR_DEV_OPTS $REPAIR_OPTS "$1"
>  			status=`expr $? + $status`
>  		fi
>  		;;
> 
