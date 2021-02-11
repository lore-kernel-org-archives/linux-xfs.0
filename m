Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A01E5C433DB
	for <linux-xfs@archiver.kernel.org>; Thu, 11 Feb 2021 14:02:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 53F2E64D9C
	for <linux-xfs@archiver.kernel.org>; Thu, 11 Feb 2021 14:02:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231683AbhBKOCK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 11 Feb 2021 09:02:10 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:41094 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232093AbhBKOAN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 11 Feb 2021 09:00:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613051926;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=AZC4i+zb1qEoY+kG/XuUE0SvjsGfgbaDhb3usUK80YY=;
        b=HT3WpbeLFUErSgfZMcUV/FWiVTdRGs6cNAaJb8YHgJFo/XBm4MX5mAXJTIgiwTFghM6SDR
        RY1ybQzQhZYY50mRBwK5P6vVssPAiUJVamITSJTJvYPy/sF4nEsq8/lVxwM4cDJyDJ8EKw
        2HpYLga6unpwv9imv7I2HVFAuR31r/I=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-357-Vo01m6GJPdiZUZKFb14rew-1; Thu, 11 Feb 2021 08:58:44 -0500
X-MC-Unique: Vo01m6GJPdiZUZKFb14rew-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D3C451084456;
        Thu, 11 Feb 2021 13:58:41 +0000 (UTC)
Received: from bfoster (ovpn-113-234.rdu2.redhat.com [10.10.113.234])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 26A595DA27;
        Thu, 11 Feb 2021 13:58:41 +0000 (UTC)
Date:   Thu, 11 Feb 2021 08:58:39 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, guan@eryu.me
Subject: Re: [PATCH 1/6] config: wrap xfs_metadump as $XFS_METADUMP_PROG like
 the other tools
Message-ID: <20210211135839.GA222065@bfoster>
References: <161292577956.3504537.3260962158197387248.stgit@magnolia>
 <161292578528.3504537.14906312392933175461.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161292578528.3504537.14906312392933175461.stgit@magnolia>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Feb 09, 2021 at 06:56:25PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> When we set up a fstests run, preserve the path xfs_metadump binary with
> an $XFS_METADUMP_PROG wrapper, like we do for the other xfsprogs tools.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  common/config |    1 +
>  common/rc     |    2 +-
>  2 files changed, 2 insertions(+), 1 deletion(-)
> 
> 
> diff --git a/common/config b/common/config
> index d83dfb28..d4cf8089 100644
> --- a/common/config
> +++ b/common/config
> @@ -156,6 +156,7 @@ MKSWAP_PROG="$MKSWAP_PROG -f"
>  export XFS_LOGPRINT_PROG="$(type -P xfs_logprint)"
>  export XFS_REPAIR_PROG="$(type -P xfs_repair)"
>  export XFS_DB_PROG="$(type -P xfs_db)"
> +export XFS_METADUMP_PROG="$(type -P xfs_metadump)"
>  export XFS_ADMIN_PROG="$(type -P xfs_admin)"
>  export XFS_GROWFS_PROG=$(type -P xfs_growfs)
>  export XFS_SPACEMAN_PROG="$(type -P xfs_spaceman)"
> diff --git a/common/rc b/common/rc
> index 649b1cfd..ad54b3de 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -509,7 +509,7 @@ _scratch_metadump()
>  	[ "$USE_EXTERNAL" = yes -a ! -z "$SCRATCH_LOGDEV" ] && \
>  		options="-l $SCRATCH_LOGDEV"
>  
> -	xfs_metadump $options "$@" $SCRATCH_DEV $dumpfile
> +	$XFS_METADUMP_PROG $options "$@" $SCRATCH_DEV $dumpfile
>  }
>  
>  _setup_large_ext4_fs()
> 

