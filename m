Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDEB0C04A68
	for <linux-xfs@archiver.kernel.org>; Thu, 28 Jul 2022 17:53:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229490AbiG1RxB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 28 Jul 2022 13:53:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230505AbiG1Rwt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 28 Jul 2022 13:52:49 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id BA0CF74CDC
        for <linux-xfs@vger.kernel.org>; Thu, 28 Jul 2022 10:52:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1659030767;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=qVc1p7dR/9rRNrTIfQhEuzYkn3fVsDqFu1G8Zdk4jvE=;
        b=GVYIoi3ETTCojrzsqKpUQ7rJ7hBFJ+69Umr+Ip8naXWrKoah4ji3AyZgMZRgG/9o3nZaJI
        4eAr3BMsIp1aPZumAp6YpdWtf4/8Mp6sNMPpgWksuVF4wRgERlZk7tYmEm45XnXXNozthE
        0Fa1szey2zYTJfGGCwZERKsv4c22fHk=
Received: from mail-oo1-f69.google.com (mail-oo1-f69.google.com
 [209.85.161.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-21-kH5gA11PMGaNj_uSFYUh1g-1; Thu, 28 Jul 2022 13:52:46 -0400
X-MC-Unique: kH5gA11PMGaNj_uSFYUh1g-1
Received: by mail-oo1-f69.google.com with SMTP id d22-20020a4a9196000000b00435761169daso932810ooh.10
        for <linux-xfs@vger.kernel.org>; Thu, 28 Jul 2022 10:52:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=qVc1p7dR/9rRNrTIfQhEuzYkn3fVsDqFu1G8Zdk4jvE=;
        b=PtPa1NQK5+YNf/yhFWYw+9ppwgMVWGpSTNmt7jtwx1VRPOTbOBUC7U58bKZE+KOTKQ
         ihcR55pIa0ZWYvRtULGtqgT9bdx9dvQmqfam/G5i+xFT+qLcy3y3D5t9k8mSLAmwjKz2
         aHS3tp5/EL45iy1qnlGQU+OnjvlAufMAKZD2i8snjSGsg/b3H0Ke/RJwrD2DPoQmSN0z
         uF4XxyKM1QEvYWS2r8Fjxt4tuGPL+4QUcDTY/ac6hk2zH9PK89qRCinnrBzfrn6wwq/g
         rMxhKQGhO0GCtkhfwh1EbRvExqXlVw7j4uUUxkHdlvf+6BdDcSonl02FX/VQ8SCSBEma
         z51w==
X-Gm-Message-State: AJIora9Cay6IAKt7mtvjwtQmH9L6g/aS8DWaKwyPIfAWnowh4lB23BSt
        GQqWsMoK0oQVGIa6m9+asCzS3vZrMTeA0DQ/mTwHeJ8Ve2JvRx0ZESMA3mZjMb6p2lSH+0okjsi
        2+xZBudq6+8QUrY8uGrFJ
X-Received: by 2002:a05:6830:d0d:b0:616:99da:1fb0 with SMTP id bu13-20020a0568300d0d00b0061699da1fb0mr28244otb.109.1659030765173;
        Thu, 28 Jul 2022 10:52:45 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1t3r1s0d3oGOLePqvswsAoDO0VtzJ+DwVJ8SLTFcx4GtI0/6/pkk3BSvdc9CcesVlDonUmYXQ==
X-Received: by 2002:a05:6830:d0d:b0:616:99da:1fb0 with SMTP id bu13-20020a0568300d0d00b0061699da1fb0mr28235otb.109.1659030764899;
        Thu, 28 Jul 2022 10:52:44 -0700 (PDT)
Received: from zlang-mailbox ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id bu23-20020a0568300d1700b0061cc1ba78e5sm528831otb.3.2022.07.28.10.52.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Jul 2022 10:52:44 -0700 (PDT)
Date:   Fri, 29 Jul 2022 01:52:38 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, tytso@mit.edu,
        leah.rumancik@gmail.com
Subject: Re: [PATCH 1/2] common/rc: wait for udev before creating dm targets
Message-ID: <20220728175238.irv435n46bfet64b@zlang-mailbox>
References: <165886491119.1585061.14285332087646848837.stgit@magnolia>
 <165886491692.1585061.2529733779998396096.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <165886491692.1585061.2529733779998396096.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jul 26, 2022 at 12:48:36PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Every now and then I see a failure when running generic/322 on btrfs:
> 
> QA output created by 322
> failed to create flakey device
> 
> Looking in the 322.full file, I see:
> 
> device-mapper: reload ioctl on flakey-test (253:0) failed: Device or resource busy
> Command failed.
> 
> And looking in dmesg, I see:
> 
> device-mapper: table: 8:3: linear: Device lookup failed (-16)
> device-mapper: ioctl: error adding target to table
> 
> /dev/block/8:3 corresponds to the SCRATCH_DEV on this system.  Given the
> failures in 322.out, I think this is caused by generic/322 calling
> _init_flakey -> _dmsetup_create -> $DMSETUP_PROG create being unable to
> open SCRATCH_DEV exclusively.  Add a call to $UDEV_SETTLE_PROG prior to
> the creation of the target to try to calm the system down sufficiently
> that the test can proceed.
> 
> Note that I don't have any hard evidence that it's udev at fault here --
> the few times I've caught this thing, udev *has* been active spraying
> error messages for nonexistent sysfs paths to journald and adding a
> 'udevadm settle' seems to fix it... but that's still only
> circumstantial.  Regardless, it seems to have fixed the test failure.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  common/rc |    5 +++++
>  1 file changed, 5 insertions(+)
> 
> 
> diff --git a/common/rc b/common/rc
> index f4469464..60a9bacd 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -4815,6 +4815,11 @@ _dmsetup_remove()
>  
>  _dmsetup_create()
>  {
> +	# Wait for udev to settle so that the dm creation doesn't fail because
> +	# some udev subprogram opened one of the block devices mentioned in the
> +	# table string w/ O_EXCL.  Do it again at the end so that an immediate
> +	# device open won't also fail.
> +	$UDEV_SETTLE_PROG >/dev/null 2>&1

No objection from me, as you've proved it works for your issue:)

Reviewed-by: Zorro Lang <zlang@redhat.com>

>  	$DMSETUP_PROG create "$@" >>$seqres.full 2>&1 || return 1
>  	$DMSETUP_PROG mknodes >/dev/null 2>&1
>  	$UDEV_SETTLE_PROG >/dev/null 2>&1
> 

