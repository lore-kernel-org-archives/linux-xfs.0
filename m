Return-Path: <SRS0=lRpT=32=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3B53C2D0B1
	for <linux-xfs@archiver.kernel.org>; Thu,  6 Feb 2020 04:58:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C944D20838
	for <linux-xfs@archiver.kernel.org>; Thu,  6 Feb 2020 04:58:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NNcdpmVo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727474AbgBFE6f (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 5 Feb 2020 23:58:35 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:57792 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726687AbgBFE6f (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 5 Feb 2020 23:58:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580965114;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=FJf/st9ZGOuSXw0Xz/S+bzgTIjmR2x4AyGsPaqsDU60=;
        b=NNcdpmVoeKt+kkbh7Yd+zWRr+AU18ASjzs2L96Cev/0/AVgH4WYoO/MAd/xUq/q7pM4uhG
        hN9GmiHIOq2I4ZSCt9vCaNB0HKg1VDoNjPLjdRkQ9J34QB+PunjVIEORAN1yw4qcDL8N9Z
        zaoKOIe3ZRIz5dUhqZ4sd+MGyFAEOso=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-135-Hdub-bBfNdCJA7ZUxkKOcA-1; Wed, 05 Feb 2020 23:58:29 -0500
X-MC-Unique: Hdub-bBfNdCJA7ZUxkKOcA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CA3DE800EB2;
        Thu,  6 Feb 2020 04:58:28 +0000 (UTC)
Received: from localhost (dhcp-12-102.nay.redhat.com [10.66.12.102])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 41CAB89E81;
        Thu,  6 Feb 2020 04:58:28 +0000 (UTC)
Date:   Thu, 6 Feb 2020 13:08:21 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     Jeff Moyer <jmoyer@redhat.com>
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 1/3] dax/dm: disable testing on devices that don't
 support dax
Message-ID: <20200206050821.GT14282@dhcp-12-102.nay.redhat.com>
Mail-Followup-To: Jeff Moyer <jmoyer@redhat.com>, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org
References: <20200205224818.18707-1-jmoyer@redhat.com>
 <20200205224818.18707-2-jmoyer@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200205224818.18707-2-jmoyer@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Feb 05, 2020 at 05:48:16PM -0500, Jeff Moyer wrote:
> Move the hack out of dmflakey and put it into _require_dm_target.  This
> fixes up a lot of missed tests that are failing due to the lack of dax
> support (such as tests on dm-thin, snapshot, etc).
> 
> Signed-off-by: Jeff Moyer <jmoyer@redhat.com>
> ---
>  common/dmflakey |  5 -----
>  common/rc       | 11 +++++++++++
>  2 files changed, 11 insertions(+), 5 deletions(-)
> 
> diff --git a/common/dmflakey b/common/dmflakey
> index 2af3924d..b4e11ae9 100644
> --- a/common/dmflakey
> +++ b/common/dmflakey
> @@ -8,11 +8,6 @@ FLAKEY_ALLOW_WRITES=0
>  FLAKEY_DROP_WRITES=1
>  FLAKEY_ERROR_WRITES=2
>  
> -echo $MOUNT_OPTIONS | grep -q dax
> -if [ $? -eq 0 ]; then
> -	_notrun "Cannot run tests with DAX on dmflakey devices"
> -fi

If we need to remove this for common/dmflakey, why not do the same thing
in common/dmthin and common/dmdelay etc ?

> -
>  _init_flakey()
>  {
>  	local BLK_DEV_SIZE=`blockdev --getsz $SCRATCH_DEV`
> diff --git a/common/rc b/common/rc
> index eeac1355..785f34c6 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -1874,6 +1874,17 @@ _require_dm_target()
>  	_require_sane_bdev_flush $SCRATCH_DEV
>  	_require_command "$DMSETUP_PROG" dmsetup
>  
> +	echo $MOUNT_OPTIONS | grep -q dax
> +	if [ $? -eq 0 ]; then
> +		case $target in
> +		stripe|linear|error)
> +			;;
> +		*)
> +			_notrun "Cannot run tests with DAX on $target devices."
> +			;;
> +		esac
> +	fi
> +
>  	modprobe dm-$target >/dev/null 2>&1
>  
>  	$DMSETUP_PROG targets 2>&1 | grep -q ^$target
> -- 
> 2.19.1
> 

