Return-Path: <SRS0=WxS8=ZX=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70404C432C0
	for <linux-xfs@archiver.kernel.org>; Sun,  1 Dec 2019 03:35:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4056820880
	for <linux-xfs@archiver.kernel.org>; Sun,  1 Dec 2019 03:35:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Isa4VLXK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727169AbfLADfH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 30 Nov 2019 22:35:07 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:38646 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727095AbfLADfH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 30 Nov 2019 22:35:07 -0500
Received: by mail-pf1-f194.google.com with SMTP id x185so3950734pfc.5;
        Sat, 30 Nov 2019 19:35:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=t8fp6/hStw8m2jDmz0614Xn1uqL/H8ze3iIp5Qj4Q+E=;
        b=Isa4VLXKCvQEzCKrXC6stjs1GdixJKpGrDtIDBDJmYJjjSarIzV0Heom5N+JKwSwds
         g6+xUVaShxQc0sGn8WHVeFtL6hEcrH0FYLMghJwzB6n1rqjde6XSzSa7hyFYISewm5dD
         XcPUyA7XIBl37tt4e+0/d2IT+Hv1slsE+8pnZyXue6Sv7Hibo83WPZD6n0jWHjxFIlcU
         2yCNIfJxYy+jMTy7+5xd47C4FIU0zCI0i7L+J7RuRa04A8z5A3ri0Zcett7/kus8ngNt
         srJKPohHzcgTieuE83tlWanf/ABYWTkPmHZQE9ar93j3uBs+rQwy7i6WXs25/cGMQbTq
         GVWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=t8fp6/hStw8m2jDmz0614Xn1uqL/H8ze3iIp5Qj4Q+E=;
        b=nXHQN6eilbQ1Y/XVoTF18twk9MPsGMNplMMXp0SIxpBDaI+yD6nyhtPcB4BSdsbRVB
         XYxj8RvkneehqXhgAZAWHrJfuzm9AWfgZ1xkEBk/VQyF4H3+sofOtIDLfJuML8KssJ4F
         zFPnBC1Z2HP3hvnHQO/Nbxy1mvel65CkxEedx0UUZfJz8NYcG49TSnl9c0h7uPu4IBYw
         sudTUucplhBSPK+VJH8Fx/CwfXnHQha2tQY3eujbZgYIHH2Dp97vGnhy7mfwZUrF2g1c
         7Kb+oGz5uEeIH6pLUcPP23Qz00F+FpZ7p7DTBN+lA0B8KN9CVB4VMc2eesB8J3m4wn1H
         /qEg==
X-Gm-Message-State: APjAAAUyILtc3y9jpT77kPM50B6DqoQb7evKlrRSMutfGhyQhmDXYstH
        BPlbOX529KLYw2bI41Hl5tU=
X-Google-Smtp-Source: APXvYqyjF6aEvb4y6lxi+Oz0pbhO+ApPDcD/uSwEAMaujCIAxhhTWc4ZOXFAmX9MNxS5UR3d52dD+Q==
X-Received: by 2002:a63:4246:: with SMTP id p67mr24282923pga.243.1575171306443;
        Sat, 30 Nov 2019 19:35:06 -0800 (PST)
Received: from localhost ([178.128.102.47])
        by smtp.gmail.com with ESMTPSA id d23sm6939680pfo.176.2019.11.30.19.35.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 30 Nov 2019 19:35:05 -0800 (PST)
Date:   Sun, 1 Dec 2019 11:35:00 +0800
From:   Eryu Guan <guaneryu@gmail.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     fstests <fstests@vger.kernel.org>, xfs <linux-xfs@vger.kernel.org>,
        Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v2] generic/050: fix xfsquota configuration failures
Message-ID: <20191201033458.GH8664@desktop>
References: <20191127163457.GL6212@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191127163457.GL6212@magnolia>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Nov 27, 2019 at 08:34:57AM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> The new 'xfsquota' configuration for generic/050 doesn't filter out
> SCRATCH_MNT properly and seems to be missing an error message in the
> golden output.  Fix both of these problems.
> 
> Fixes: e088479871 ("generic/050: Handle xfs quota special case with different output")
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Thanks for the fix! And sorry for not noticing such test failure. I did
test xfs/050 but apparently I forget to enable xfsquota..

Thanks!
Eryu
> ---
> v2: don't try the touch if the mount fails
> ---
>  tests/generic/050              |   12 +++++++-----
>  tests/generic/050.out.xfsquota |    5 ++---
>  2 files changed, 9 insertions(+), 8 deletions(-)
> 
> diff --git a/tests/generic/050 b/tests/generic/050
> index cf2b9381..7eabc7a7 100755
> --- a/tests/generic/050
> +++ b/tests/generic/050
> @@ -58,9 +58,11 @@ blockdev --setro $SCRATCH_DEV
>  # Mount it, and make sure we can't write to it, and we can unmount it again
>  #
>  echo "mounting read-only block device:"
> -_try_scratch_mount 2>&1 | _filter_ro_mount
> -echo "touching file on read-only filesystem (should fail)"
> -touch $SCRATCH_MNT/foo 2>&1 | _filter_scratch
> +_try_scratch_mount 2>&1 | _filter_ro_mount | _filter_scratch
> +if [ "${PIPESTATUS[0]}" -eq 0 ]; then
> +	echo "touching file on read-only filesystem (should fail)"
> +	touch $SCRATCH_MNT/foo 2>&1 | _filter_scratch
> +fi
>  
>  #
>  # Apparently this used to be broken at some point:
> @@ -92,7 +94,7 @@ blockdev --setro $SCRATCH_DEV
>  # -o norecovery is used.
>  #
>  echo "mounting filesystem that needs recovery on a read-only device:"
> -_try_scratch_mount 2>&1 | _filter_ro_mount
> +_try_scratch_mount 2>&1 | _filter_ro_mount | _filter_scratch
>  
>  echo "unmounting read-only filesystem"
>  _scratch_unmount 2>&1 | _filter_scratch | _filter_ending_dot
> @@ -103,7 +105,7 @@ _scratch_unmount 2>&1 | _filter_scratch | _filter_ending_dot
>  # data recovery hack.
>  #
>  echo "mounting filesystem with -o norecovery on a read-only device:"
> -_try_scratch_mount -o norecovery 2>&1 | _filter_ro_mount
> +_try_scratch_mount -o norecovery 2>&1 | _filter_ro_mount | _filter_scratch
>  echo "unmounting read-only filesystem"
>  _scratch_unmount 2>&1 | _filter_scratch | _filter_ending_dot
>  
> diff --git a/tests/generic/050.out.xfsquota b/tests/generic/050.out.xfsquota
> index f204bd2f..35d7bd68 100644
> --- a/tests/generic/050.out.xfsquota
> +++ b/tests/generic/050.out.xfsquota
> @@ -1,8 +1,7 @@
>  QA output created by 050
>  setting device read-only
>  mounting read-only block device:
> -mount: /mnt-scratch: permission denied
> -touching file on read-only filesystem (should fail)
> +mount: SCRATCH_MNT: permission denied
>  unmounting read-only filesystem
>  umount: SCRATCH_DEV: not mounted
>  setting device read-write
> @@ -17,7 +16,7 @@ mount: cannot mount device read-only
>  unmounting read-only filesystem
>  umount: SCRATCH_DEV: not mounted
>  mounting filesystem with -o norecovery on a read-only device:
> -mount: /mnt-scratch: permission denied
> +mount: SCRATCH_MNT: permission denied
>  unmounting read-only filesystem
>  umount: SCRATCH_DEV: not mounted
>  setting device read-write
