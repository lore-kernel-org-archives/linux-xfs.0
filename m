Return-Path: <SRS0=7MVS=IG=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5F62C433DB
	for <linux-xfs@archiver.kernel.org>; Mon,  8 Mar 2021 12:18:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6BF3E651C3
	for <linux-xfs@archiver.kernel.org>; Mon,  8 Mar 2021 12:18:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229919AbhCHMRd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 8 Mar 2021 07:17:33 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:48089 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229904AbhCHMRR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 8 Mar 2021 07:17:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615205836;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=gVscXrL1fTPL09IJRmXzIR6qzAX3+RlpbE1v2HaXZVc=;
        b=ITePOwq9uYXbqP4QsVcidW2WQ4ZSsDHzxM3lNEKSGsllhy3Xv0ZeEHykcmnRakwW30onkk
        aE8YVlicJcrVhsXKq6Gnz7TG10Xw09222YLKpfUwaBNnYPo7vC0LnSfo/r2+Qw4ihWWmKU
        OeK5gGQBGcx9mNMU0mYtR7vzG6ZoN5c=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-6-qCtAgV8YNOKExfvX5H1tNg-1; Mon, 08 Mar 2021 07:17:14 -0500
X-MC-Unique: qCtAgV8YNOKExfvX5H1tNg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8017E8190BE;
        Mon,  8 Mar 2021 12:17:13 +0000 (UTC)
Received: from bfoster (ovpn-112-124.rdu2.redhat.com [10.10.112.124])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A754C5D9D3;
        Mon,  8 Mar 2021 12:17:09 +0000 (UTC)
Date:   Mon, 8 Mar 2021 07:17:07 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Eric Sandeen <sandeen@redhat.com>, xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs_admin: don't hide the xfs_repair output when
 upgrading
Message-ID: <YEYVw8xCPZsNL0Hn@bfoster>
References: <20210305220021.GI3419940@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210305220021.GI3419940@magnolia>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Mar 05, 2021 at 02:00:21PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Currently, xfs_admin suppresses the output from xfs_repair when it tries
> to upgrade a filesystem, and prints a rather unhelpful message if the
> upgrade fails.
> 
> Neither of these behaviors are useful -- repair can fail for reasons
> outside of the filesystem being mounted, and if it does, the admin will
> never know what actually happened.
> 
> Worse yet, if repair finds corruptions on disk, the upgrade script
> silently throws all that away, which means that nobody will ever be able
> to report what happened if an upgrade trashes a filesystem.
> 
> Therefore, allow the console to capture all of repair's stdout/stderr
> reports.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---

Personally, I prefer either the current behavior where a user can always
run xfs_repair directly to see the low level output, or even the verbose
flag option since ISTM that if repair fails, it's going to fail the next
time around for similar reasons in the most common cases. That said, I'm
not tied to any particular behavior and we've had negative feedback on
the current approach, so:

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  db/xfs_admin.sh |   12 ++----------
>  1 file changed, 2 insertions(+), 10 deletions(-)
> 
> diff --git a/db/xfs_admin.sh b/db/xfs_admin.sh
> index 02f34b73..916050cb 100755
> --- a/db/xfs_admin.sh
> +++ b/db/xfs_admin.sh
> @@ -51,17 +51,9 @@ case $# in
>  		fi
>  		if [ -n "$REPAIR_OPTS" ]
>  		then
> -			# Hide normal repair output which is sent to stderr
> -			# assuming the filesystem is fine when a user is
> -			# running xfs_admin.
> -			# Ideally, we need to improve the output behaviour
> -			# of repair for this purpose (say a "quiet" mode).
> -			eval xfs_repair $REPAIR_DEV_OPTS $REPAIR_OPTS "$1" 2> /dev/null
> +			echo "Running xfs_repair to upgrade filesystem."
> +			eval xfs_repair $REPAIR_DEV_OPTS $REPAIR_OPTS "$1"
>  			status=`expr $? + $status`
> -			if [ $status -ne 0 ]
> -			then
> -				echo "Conversion failed, is the filesystem unmounted?"
> -			fi
>  		fi
>  		;;
>  	*)	echo $USAGE 1>&2
> 

