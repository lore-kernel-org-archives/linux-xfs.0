Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58607C433E0
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Feb 2021 17:23:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0F66564EA6
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Feb 2021 17:23:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233001AbhBIRXi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 9 Feb 2021 12:23:38 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:21507 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232633AbhBIRXg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 9 Feb 2021 12:23:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612891330;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=OUyQprqzWQqUxDW4uEMGYCKtZ8RzU5r2qsChYwndY9s=;
        b=gd2CKuqOjOL7WZt8fq2+9kq1TTyE7h9rzDQ+/JLBBSjX1uaqhxW3kG0z8uRWcH8SHUXLi+
        hit1Vy105P1A0ETYeWGYHInMpVHrnWlapBnK4Jv6YhUrrdxsigfHdOv6Wmwgx9N2rd7ojd
        K4JF96Jz4zUy/aFUYzYYnxMit4QgeKY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-200-aX4jVSNZPb-d8yK2vQhV9g-1; Tue, 09 Feb 2021 12:22:08 -0500
X-MC-Unique: aX4jVSNZPb-d8yK2vQhV9g-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EFF631005501;
        Tue,  9 Feb 2021 17:22:06 +0000 (UTC)
Received: from bfoster (ovpn-113-234.rdu2.redhat.com [10.10.113.234])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 7ADAB10016F5;
        Tue,  9 Feb 2021 17:22:06 +0000 (UTC)
Date:   Tue, 9 Feb 2021 12:22:04 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 10/10] xfs_admin: support adding features to V5
 filesystems
Message-ID: <20210209172204.GH14273@bfoster>
References: <161284380403.3057868.11153586180065627226.stgit@magnolia>
 <161284386088.3057868.16559496991921219277.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161284386088.3057868.16559496991921219277.stgit@magnolia>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Feb 08, 2021 at 08:11:00PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Teach the xfs_admin script how to add features to V5 filesystems.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  db/xfs_admin.sh      |    6 ++++--
>  man/man8/xfs_admin.8 |   22 ++++++++++++++++++++++
>  2 files changed, 26 insertions(+), 2 deletions(-)
> 
> 
> diff --git a/db/xfs_admin.sh b/db/xfs_admin.sh
> index 430872ef..7a467dbe 100755
> --- a/db/xfs_admin.sh
> +++ b/db/xfs_admin.sh
> @@ -8,9 +8,10 @@ status=0
>  DB_OPTS=""
>  REPAIR_OPTS=""
>  REPAIR_DEV_OPTS=""
> -USAGE="Usage: xfs_admin [-efjlpuV] [-c 0|1] [-L label] [-r rtdev] [-U uuid] device [logdev]"
> +DB_LOG_OPTS=""
> +USAGE="Usage: xfs_admin [-efjlpuV] [-c 0|1] [-L label] [-O v5_feature] [-r rtdev] [-U uuid] device [logdev]"

Technically this would pass through the lazy counter variant on a v4
super, right? I wonder if we should just call it "[-O feature]" here.

>  
> -while getopts "c:efjlL:pr:uU:V" c
> +while getopts "c:efjlL:O:pr:uU:V" c
>  do
>  	case $c in
>  	c)	REPAIR_OPTS=$REPAIR_OPTS" -c lazycount="$OPTARG;;
...
> diff --git a/man/man8/xfs_admin.8 b/man/man8/xfs_admin.8
> index cccbb224..3f3aeea8 100644
> --- a/man/man8/xfs_admin.8
> +++ b/man/man8/xfs_admin.8
...
> @@ -106,6 +108,26 @@ The filesystem label can be cleared using the special "\c
>  " value for
>  .IR label .
>  .TP
> +.BI \-O " feature1" = "status" , "feature2" = "status..."
> +Add or remove features on an existing a V5 filesystem.

s/existing a/existing/

Also, similar question around the lazycount variant. If it works, should
it not be documented here?

Brian

> +The features should be specified as a comma-separated list.
> +.I status
> +should be either 0 to disable the feature or 1 to enable the feature.
> +Note, however, that most features cannot be disabled.
> +.IP
> +.B NOTE:
> +Administrators must ensure the filesystem is clean by running
> +.B xfs_repair -n
> +to inspect the filesystem before performing the upgrade.
> +If corruption is found, recovery procedures (e.g. reformat followed by
> +restoration from backup; or running
> +.B xfs_repair
> +without the
> +.BR -n )
> +must be followed to clean the filesystem.
> +.IP
> +There are currently no feature options.
> +.TP
>  .BI \-U " uuid"
>  Set the UUID of the filesystem to
>  .IR uuid .
> 

