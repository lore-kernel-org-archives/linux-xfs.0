Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8252EC433DB
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Feb 2021 17:21:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3ADFA64E5A
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Feb 2021 17:21:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233023AbhBIRV0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 9 Feb 2021 12:21:26 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:39396 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232912AbhBIRVY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 9 Feb 2021 12:21:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612891197;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=IHyQ7vt7Rzk4BfnSNbPfi6tJ7jRrk0PI/I5GK1MZ7Ms=;
        b=gi3nnyBvu+7Xpc29CfAhwfGMm0D7ZsiNkXSFT2cxJ8VZBMadmllJbMilPDlIbtsxmSf9fj
        uien4/DIftCU5S+pC+hzbRjnasL8edxpDASV04PxX2C9rZzggFGIt/q5zGCM9XJ2Nm5v6d
        aWXQZDN9xNuPjdlj4mFSBkdRgWDarXU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-279-h4s0lHyYN_CQuVJ6vc1U1A-1; Tue, 09 Feb 2021 12:19:55 -0500
X-MC-Unique: h4s0lHyYN_CQuVJ6vc1U1A-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 137FE803F4A;
        Tue,  9 Feb 2021 17:19:54 +0000 (UTC)
Received: from bfoster (ovpn-113-234.rdu2.redhat.com [10.10.113.234])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 8A3B319C59;
        Tue,  9 Feb 2021 17:19:53 +0000 (UTC)
Date:   Tue, 9 Feb 2021 12:19:51 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 02/10] xfs_admin: support filesystems with realtime
 devices
Message-ID: <20210209171951.GA14273@bfoster>
References: <161284380403.3057868.11153586180065627226.stgit@magnolia>
 <161284381548.3057868.17951198536217853244.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161284381548.3057868.17951198536217853244.stgit@magnolia>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Feb 08, 2021 at 08:10:15PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Add a -r option to xfs_admin so that we can pass the name of the
> realtime device to xfs_repair.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  db/xfs_admin.sh      |   11 ++++++-----
>  man/man8/xfs_admin.8 |    8 ++++++++
>  2 files changed, 14 insertions(+), 5 deletions(-)
> 
> 
> diff --git a/db/xfs_admin.sh b/db/xfs_admin.sh
> index 71a9aa98..430872ef 100755
> --- a/db/xfs_admin.sh
> +++ b/db/xfs_admin.sh
> @@ -7,9 +7,10 @@
>  status=0
>  DB_OPTS=""
>  REPAIR_OPTS=""
> -USAGE="Usage: xfs_admin [-efjlpuV] [-c 0|1] [-L label] [-U uuid] device [logdev]"
> +REPAIR_DEV_OPTS=""
> +USAGE="Usage: xfs_admin [-efjlpuV] [-c 0|1] [-L label] [-r rtdev] [-U uuid] device [logdev]"
>  
> -while getopts "efjlpuc:L:U:V" c
> +while getopts "c:efjlL:pr:uU:V" c
>  do
>  	case $c in
>  	c)	REPAIR_OPTS=$REPAIR_OPTS" -c lazycount="$OPTARG;;
> @@ -19,6 +20,7 @@ do
>  	l)	DB_OPTS=$DB_OPTS" -r -c label";;
>  	L)	DB_OPTS=$DB_OPTS" -c 'label "$OPTARG"'";;
>  	p)	DB_OPTS=$DB_OPTS" -c 'version projid32bit'";;
> +	r)	REPAIR_DEV_OPTS=" -r '$OPTARG'";;
>  	u)	DB_OPTS=$DB_OPTS" -r -c uuid";;
>  	U)	DB_OPTS=$DB_OPTS" -c 'uuid "$OPTARG"'";;
>  	V)	xfs_db -p xfs_admin -V
> @@ -37,8 +39,7 @@ case $# in
>  		# Pick up the log device, if present
>  		if [ -n "$2" ]; then
>  			DB_OPTS=$DB_OPTS" -l '$2'"
> -			test -n "$REPAIR_OPTS" && \
> -				REPAIR_OPTS=$REPAIR_OPTS" -l '$2'"
> +			REPAIR_DEV_OPTS=$REPAIR_DEV_OPTS" -l '$2'"
>  		fi
>  
>  		if [ -n "$DB_OPTS" ]
> @@ -53,7 +54,7 @@ case $# in
>  			# running xfs_admin.
>  			# Ideally, we need to improve the output behaviour
>  			# of repair for this purpose (say a "quiet" mode).
> -			eval xfs_repair $REPAIR_OPTS "$1" 2> /dev/null
> +			eval xfs_repair $REPAIR_DEV_OPTS $REPAIR_OPTS "$1" 2> /dev/null
>  			status=`expr $? + $status`
>  			if [ $status -ne 0 ]
>  			then
> diff --git a/man/man8/xfs_admin.8 b/man/man8/xfs_admin.8
> index 8afc873f..cccbb224 100644
> --- a/man/man8/xfs_admin.8
> +++ b/man/man8/xfs_admin.8
> @@ -13,6 +13,9 @@ xfs_admin \- change parameters of an XFS filesystem
>  ] [
>  .B \-U
>  .I uuid
> +] [
> +.B \-r
> +.I rtdev
>  ]
>  .I device
>  [
> @@ -123,6 +126,11 @@ not be able to mount the filesystem.  To remove this incompatible flag, use
>  which will restore the original UUID and remove the incompatible
>  feature flag as needed.
>  .TP
> +.BI \-r " rtdev"
> +Specifies the device special file where the filesystem's realtime section
> +resides.
> +Only for those filesystems which use a realtime section.
> +.TP
>  .B \-V
>  Prints the version number and exits.
>  .PP
> 

