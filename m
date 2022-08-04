Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9853C19F2A
	for <linux-xfs@archiver.kernel.org>; Thu,  4 Aug 2022 15:55:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236923AbiHDPzq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 4 Aug 2022 11:55:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237097AbiHDPzo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 4 Aug 2022 11:55:44 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1AC075A3E0
        for <linux-xfs@vger.kernel.org>; Thu,  4 Aug 2022 08:55:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1659628543;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=9pNL0egjBkG+BP0MH7GdjTEPH9+6j5n3QqKqr1VdtFY=;
        b=Cc4arEMd6pvafeNpi0IlaobPJZZYimpl8Mn0wrM9xmxJ3/VSJSJ/337FduSjlKU0Z5xQG/
        EyGfHFDh3fG6NJz15KRx/aPW1eektc4CMekbSXwdAxkroCJWeuKsMHKV3fu/FRj3NxdIoZ
        7rKdSnQIrkSLtka1UuNYJiumU1peYCA=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-630-ASvhVvoyMRaYNZKJaYxS3w-1; Thu, 04 Aug 2022 11:55:41 -0400
X-MC-Unique: ASvhVvoyMRaYNZKJaYxS3w-1
Received: by mail-qt1-f199.google.com with SMTP id a6-20020ac86106000000b0033f73d965acso85503qtm.7
        for <linux-xfs@vger.kernel.org>; Thu, 04 Aug 2022 08:55:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=9pNL0egjBkG+BP0MH7GdjTEPH9+6j5n3QqKqr1VdtFY=;
        b=KwTeu0pcy8YZLmjwAjEkp5uFVjbyyfODPI+rsIW7EYG6fC2/a1afOj8i7yAqskJHSV
         oO1pYUS/rLkcjRnGg4tEcSoTrtKr969b+WWrpzxLh5Kzaf0wu677z/fxN+kLf6gPygyG
         AeoelM6qlvuicQYx/UBGgWLiSKXofbVCJv4gE7PTSd5QzGWphPzdyyGrFXvZXwuJNMdR
         RlZTd2AoRavGGNeG+JMrwF/fyAXt1itWNulYhjmOE6Tc47P46o4/AYkA+5xHRhxJ/kNp
         5zOnDXtCKGZ3W9n9BINLDQuZ0JSjKQRPYYMDm3JSiOUnm+5i/9JVFB2+r83tq0H2G9Br
         ba0A==
X-Gm-Message-State: ACgBeo2mBLt6xXnetadxCiUE2AbTe36VLwRhnsLrnM0PQ3lRjIQC3tX2
        eTeeKp2C55v0HHQGrCoYwmBmdPddaY0uDCMpNLWw3v9sa7xITWpB8DD4nnw8qTp0EPJHdCmykwd
        /HfcI9zqdiE0P6yB2l0W9
X-Received: by 2002:ad4:5cc3:0:b0:474:8dda:dfb6 with SMTP id iu3-20020ad45cc3000000b004748ddadfb6mr2109304qvb.82.1659628541311;
        Thu, 04 Aug 2022 08:55:41 -0700 (PDT)
X-Google-Smtp-Source: AA6agR75zDCx6FVm3tLPC/OCoRSc3pRW7lEVS2d517s4KefL55ZAY/HaYI3HImU+eGD6M57LELKogw==
X-Received: by 2002:ad4:5cc3:0:b0:474:8dda:dfb6 with SMTP id iu3-20020ad45cc3000000b004748ddadfb6mr2109281qvb.82.1659628540998;
        Thu, 04 Aug 2022 08:55:40 -0700 (PDT)
Received: from zlang-mailbox ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id a187-20020ae9e8c4000000b006b893d135besm858350qkg.108.2022.08.04.08.55.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Aug 2022 08:55:40 -0700 (PDT)
Date:   Thu, 4 Aug 2022 23:55:34 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 1/3] xfs/432: fix this test when external devices are in
 use
Message-ID: <20220804155534.7jnplh6e3tuz6sua@zlang-mailbox>
References: <165950048029.198815.11843926234080013062.stgit@magnolia>
 <165950048600.198815.10416873619760657341.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <165950048600.198815.10416873619760657341.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Aug 02, 2022 at 09:21:26PM -0700, Darrick J. Wong wrote:
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
>  tests/xfs/432 |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> 
> diff --git a/tests/xfs/432 b/tests/xfs/432
> index 86012f0b..e1e610d0 100755
> --- a/tests/xfs/432
> +++ b/tests/xfs/432
> @@ -89,7 +89,8 @@ _scratch_xfs_metadump $metadump_file -w
>  xfs_mdrestore $metadump_file $metadump_img
>  
>  echo "Check restored metadump image"
> -$XFS_REPAIR_PROG -n $metadump_img >> $seqres.full 2>&1
> +SCRATCH_DEV=$metadump_img _scratch_xfs_repair -n &>> $seqres.full || \
> +	echo "xfs_repair on restored fs returned $?"

It's good to me,

Reviewed-by: Zorro Lang <zlang@redhat.com>

If anyone has more review points, please feel free to tell us :)

>  
>  # success, all done
>  status=0
> 

