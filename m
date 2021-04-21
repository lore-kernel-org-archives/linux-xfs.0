Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57EA1C43460
	for <linux-xfs@archiver.kernel.org>; Wed, 21 Apr 2021 17:26:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 319106145A
	for <linux-xfs@archiver.kernel.org>; Wed, 21 Apr 2021 17:26:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240604AbhDUR1b (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 21 Apr 2021 13:27:31 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:44620 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240745AbhDUR1b (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 21 Apr 2021 13:27:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619026017;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=nW7mxTbyLYpevtvBqFbyCqqy2cCUhlHXQJa6CsrGQ/Q=;
        b=R49klTGHtUv9CEKN5kZUHu5YFLU4J/B/hD3Ixm+UFn21mZECf1HH4pIuWGHX8iZcNWmnVY
        HVoxlGwJZ51GXyUUaRjCEZVdskOwWmhvP44G3O2CxPE0SxU7vKyrEGDf5rNvEKPOvDxxKB
        iGWvIcMbqmpc/I5jfRYpkcRMXXzF1g4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-471-eyo9OQkGOUWo_y1KMGi_5A-1; Wed, 21 Apr 2021 13:26:53 -0400
X-MC-Unique: eyo9OQkGOUWo_y1KMGi_5A-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 70FDA81746A;
        Wed, 21 Apr 2021 17:26:52 +0000 (UTC)
Received: from bfoster (ovpn-112-25.rdu2.redhat.com [10.10.112.25])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id AB59F5C1B4;
        Wed, 21 Apr 2021 17:26:51 +0000 (UTC)
Date:   Wed, 21 Apr 2021 13:26:49 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, guan@eryu.me
Subject: Re: [PATCH 2/2] common/dmthin: make this work with external log
 devices
Message-ID: <YIBgWUs/OTmROPio@bfoster>
References: <161896453944.776190.2831340458112794975.stgit@magnolia>
 <161896455168.776190.4208955976933964610.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161896455168.776190.4208955976933964610.stgit@magnolia>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Apr 20, 2021 at 05:22:31PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Provide a mkfs helper to format the dm thin device when external devices
> are in use, and fix the dmthin mount helper to support them.  This fixes
> regressions in generic/347 and generic/500 when external logs are in
> use.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  common/dmthin     |    9 ++++++++-
>  tests/generic/347 |    2 +-
>  tests/generic/500 |    2 +-
>  3 files changed, 10 insertions(+), 3 deletions(-)
> 
> 
> diff --git a/common/dmthin b/common/dmthin
> index c58c3948..3b1c7d45 100644
> --- a/common/dmthin
> +++ b/common/dmthin
> @@ -218,10 +218,17 @@ _dmthin_set_fail()
>  
>  _dmthin_mount_options()
>  {
> -	echo `_common_dev_mount_options $*` $DMTHIN_VOL_DEV $SCRATCH_MNT
> +	_scratch_options mount
> +	echo `_common_dev_mount_options $*` $SCRATCH_OPTIONS $DMTHIN_VOL_DEV $SCRATCH_MNT
>  }
>  
>  _dmthin_mount()
>  {
>  	_mount -t $FSTYP `_dmthin_mount_options $*`
>  }
> +
> +_dmthin_mkfs()
> +{
> +	_scratch_options mkfs
> +	_mkfs_dev $SCRATCH_OPTIONS $@ $DMTHIN_VOL_DEV
> +}
> diff --git a/tests/generic/347 b/tests/generic/347
> index cbc5150a..e970ac10 100755
> --- a/tests/generic/347
> +++ b/tests/generic/347
> @@ -31,7 +31,7 @@ _setup_thin()
>  {
>  	_dmthin_init $BACKING_SIZE $VIRTUAL_SIZE
>  	_dmthin_set_queue
> -	_mkfs_dev $DMTHIN_VOL_DEV
> +	_dmthin_mkfs
>  	_dmthin_mount
>  }
>  
> diff --git a/tests/generic/500 b/tests/generic/500
> index 085ddbf3..5ab2f78c 100755
> --- a/tests/generic/500
> +++ b/tests/generic/500
> @@ -68,7 +68,7 @@ CLUSTER_SIZE=$((64 * 1024 / 512))		# 64K
>  
>  _dmthin_init $BACKING_SIZE $VIRTUAL_SIZE $CLUSTER_SIZE 0
>  _dmthin_set_fail
> -_mkfs_dev $DMTHIN_VOL_DEV
> +_dmthin_mkfs
>  _dmthin_mount
>  
>  # There're two bugs at here, one is dm-thin bug, the other is filesystem
> 

