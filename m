Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C092CC19F29
	for <linux-xfs@archiver.kernel.org>; Wed, 27 Jul 2022 12:21:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232829AbiG0MVw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 27 Jul 2022 08:21:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232346AbiG0MVv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 27 Jul 2022 08:21:51 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CC8843E75E
        for <linux-xfs@vger.kernel.org>; Wed, 27 Jul 2022 05:21:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658924510;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=OnEraViqlPc7pBrLeCU4ypHt6OIMM9xxzQMmVQ4Aw90=;
        b=QOQFjgW/SLbantW2IiCQGfDmvp5usX2XjiKj7VhRqPBT/MIPhaSSR/eV9PWRAbsdgFrjZ8
        tuY5l/IZ7O+TxLBC5bHLszq362/YcaJPnmHos9pztv6ebZBQE8Dfk/i9/aBMNoBH398Y3d
        E1jiqComInRTmzjCe43z4EATAP0Cqvo=
Received: from mail-oo1-f72.google.com (mail-oo1-f72.google.com
 [209.85.161.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-606-twHjVQFmPiW7PpwnI5G4hA-1; Wed, 27 Jul 2022 08:21:48 -0400
X-MC-Unique: twHjVQFmPiW7PpwnI5G4hA-1
Received: by mail-oo1-f72.google.com with SMTP id n24-20020a4a3458000000b00435731c3a2cso1512001oof.0
        for <linux-xfs@vger.kernel.org>; Wed, 27 Jul 2022 05:21:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=OnEraViqlPc7pBrLeCU4ypHt6OIMM9xxzQMmVQ4Aw90=;
        b=FfKivRCxAxQs44cmtIhLawMuL+D8xb3vXVe99uWch7WY4XdGvJJKFiRdwEx4CFabkM
         EOkYUd+dM3StK+QNqSPZs4HmCPLkmRW1eXSjZAzda9QM1kGD3kMuZR4JR2wkiy4CZ8ps
         MNi2vxiJ1eqyguqJcRFV8A4cuCtJ6z+cLBe/J84ohdFRV27DPxYfEkIDCi8n2vyPZ55x
         zBpj2NQptRScI+I98iZKZ5qvkWXtHmXS6PiiSCvQ0jXbcPjf6K52CwRcM3zsstPIQF3i
         t17cq+hDyyYqhDd8Yvx6EBY52SbPKDI7+WWoluVx8ZuR0zKJ1LTMTtnHxgnu8a0GXURp
         DeMQ==
X-Gm-Message-State: AJIora+4q2k+YnK6g97xqYczmumyDj/dSlcrgfI0qQRgR0hQXZSpi8et
        yFuK2v6KU5Ri6ymfIzBD0XP8jROJbFlNkbruD0XKZNKvzgzT5B56ZNAHDlyXrA16CKBkH9lfqDp
        uQq7BcPOc4JAZT35A+il9
X-Received: by 2002:a05:6808:3ca:b0:33a:6eb4:5f76 with SMTP id o10-20020a05680803ca00b0033a6eb45f76mr1619904oie.249.1658924507910;
        Wed, 27 Jul 2022 05:21:47 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1t/NlF1CCVRhqJ2/9CV/j/OK/1ArDVpHfCrh5U3kWfmPWVd3/oiHxYZ7amu+z6LHOChsNSnEg==
X-Received: by 2002:a05:6808:3ca:b0:33a:6eb4:5f76 with SMTP id o10-20020a05680803ca00b0033a6eb45f76mr1619897oie.249.1658924507658;
        Wed, 27 Jul 2022 05:21:47 -0700 (PDT)
Received: from zlang-mailbox ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id s25-20020a4ac819000000b0042300765d39sm7066068ooq.46.2022.07.27.05.21.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Jul 2022 05:21:47 -0700 (PDT)
Date:   Wed, 27 Jul 2022 20:21:42 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH] xfs/432: fix this test when external devices are in use
Message-ID: <20220727122142.ktp5loclqazchncw@zlang-mailbox>
References: <YuBFw4dheeSRHVQd@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YuBFw4dheeSRHVQd@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jul 26, 2022 at 12:51:31PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> This program exercises metadump and mdrestore being run against the
> scratch device.  Therefore, the test must pass external log / rt device
> arguments to xfs_repair -n to check the "restored" filesystem.  Fix the
> incorrect usage, and report repair failures, since this test has been
> silently failing for a while now.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  tests/xfs/432 |   11 ++++++++++-
>  1 file changed, 10 insertions(+), 1 deletion(-)
> 
> diff --git a/tests/xfs/432 b/tests/xfs/432
> index 86012f0b..5c6744ce 100755
> --- a/tests/xfs/432
> +++ b/tests/xfs/432
> @@ -89,7 +89,16 @@ _scratch_xfs_metadump $metadump_file -w
>  xfs_mdrestore $metadump_file $metadump_img
>  
>  echo "Check restored metadump image"
> -$XFS_REPAIR_PROG -n $metadump_img >> $seqres.full 2>&1
> +repair_args=('-n')
> +[ "$USE_EXTERNAL" = yes -a ! -z "$SCRATCH_LOGDEV" ] && \
> +	repair_args+=('-l' "$SCRATCH_LOGDEV")
> +
> +[ "$USE_EXTERNAL" = yes -a ! -z "$SCRATCH_RTDEV" ] && \
> +	repair_args+=('-r' "$SCRATCH_RTDEV")
> +
> +$XFS_REPAIR_PROG "${repair_args[@]}" $metadump_img >> $seqres.full 2>&1
> +res=$?
> +test $res -ne 0 && echo "xfs_repair on restored fs returned $res?"

Make sense to me, I don't have better idea. One question, is xfs_metadump
and xfs_mdrestore support rtdev? Due to I didn't find xfs_metadump have
a "-r" option, although it has "-l logdev" :)

About the "$res", I don't know why we need this extra variable, as it's
not used in other place.

Thanks,
Zorro

>  
>  # success, all done
>  status=0
> 

