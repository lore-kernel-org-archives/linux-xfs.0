Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4FD73C433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 30 Jun 2022 17:42:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235297AbiF3RmT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 30 Jun 2022 13:42:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233809AbiF3RmS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 30 Jun 2022 13:42:18 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 320A71107
        for <linux-xfs@vger.kernel.org>; Thu, 30 Jun 2022 10:42:16 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id z14so59812pgh.0
        for <linux-xfs@vger.kernel.org>; Thu, 30 Jun 2022 10:42:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=xhce7Rw3Bef2s/or3lTjJlhmRkoUo5/dIpve6/Y3NWM=;
        b=FuQ3+SfLd9v0BFwIn6EUnpkwwq2ORe5VYAO9Jen2yxFX9k9bzzPmIFhXMrWBDyTCqS
         82ngQFNnURZxwk3yqAihnhYayj/aLojFWcHMPmvnWEKSP8OMJNi4wJAQShWv1SRJF4XJ
         hT/i4mzexsctjma12Lqgy1UwiWmqFnmcDMC2/3cTU3mD+s4lRRUUVLdmkqzRZ2sQrCrd
         hqYA19gjEKyxElhtybCm/aerlp8PmQk+HP9b/4QiTM2S3oXx/cJf9GSGbC1atuabRFlz
         O5GIowXtDgc1/DMNsFxHirKFY3/UK6cT5FUnUbnd9mF1LhMTq9HkO/VH2uB/R8zWLyc6
         xFeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=xhce7Rw3Bef2s/or3lTjJlhmRkoUo5/dIpve6/Y3NWM=;
        b=xvc2Q+U/Eyr4Rj0pdCRQmsOenpdfi3+tewT61K9/nW5cN8/2RBHSh97e1/WI9v1Qog
         iGnGgzZtJpslo7MV8NuWxo2O86dO5fgjaOcx77CDndiVASOVCqNDR0KfYKfW65KvW61y
         mgDm9wrS0bpUIvlojBZIb1ABrHEvs8QsIrGGCkqFY3FHZ5c3t6RIuGMTRFawyAsa2O0H
         34a2wrJ9jGVEVTTOi7Y4yXXFUofU91j9XZJf9FmEVlNWyzumkWsh+fo2p98Ur5/iUWpQ
         dKrKt+RhIOB6qvW7MunWp+9GtgMfxzkYoTUEVm1xEoK78h2ZO2TI0OOU2fdQwAewkgol
         jBag==
X-Gm-Message-State: AJIora8gxA4Z4/GA1TF7yfzjBfkk4vaDTg1C3uD1i+fVINT1g9/ac4VP
        qEmqW+1XR0JbRwZjlzjTDKY=
X-Google-Smtp-Source: AGRyM1vQfnA+jHQAslvlcfnj03JM4MrKm/jR1ZRUF8uINsjOYBtsxqAECpAEtSlSxHBIfdTm3hhjBA==
X-Received: by 2002:a63:6bc1:0:b0:40d:ffa8:2605 with SMTP id g184-20020a636bc1000000b0040dffa82605mr8841923pgc.299.1656610935628;
        Thu, 30 Jun 2022 10:42:15 -0700 (PDT)
Received: from google.com ([2601:647:4701:18d0:325e:5003:a7e2:25d7])
        by smtp.gmail.com with ESMTPSA id bg2-20020a056a001f8200b00524e2f81727sm13693095pfb.74.2022.06.30.10.42.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jun 2022 10:42:15 -0700 (PDT)
Date:   Thu, 30 Jun 2022 10:42:12 -0700
From:   Leah Rumancik <leah.rumancik@gmail.com>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>,
        "Darrick J. Wong" <djwong@kernel.org>
Subject: Re: [5.15] MAINTAINERS: add Leah as xfs maintainer for 5.15.y
Message-ID: <Yr3gdLPU2SDJzPtf@google.com>
References: <20220629235546.3843096-1-leah.rumancik@gmail.com>
 <CAOQ4uxh-2c0Sp=nUN-brB3ySb_rhYPLPa-VxJW9WOzSXOLUCww@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxh-2c0Sp=nUN-brB3ySb_rhYPLPa-VxJW9WOzSXOLUCww@mail.gmail.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jun 30, 2022 at 08:31:03AM +0300, Amir Goldstein wrote:
> On Thu, Jun 30, 2022 at 3:11 AM Leah Rumancik <leah.rumancik@gmail.com> wrote:
> >
> > Update MAINTAINERS for xfs in an effort to help direct bots/questions
> > about xfs in 5.15.y.
> >
> > Note: 5.10.y [1] and 5.4.y will have different updates to their
> > respective MAINTAINERS files for this effort.
> >
> > Suggested-by: Darrick J. Wong <djwong@kernel.org>
> > Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
> >
> > [1] https://lore.kernel.org/linux-xfs/20220629213236.495647-1-amir73il@gmail.com/
> 
> It is not good practice to put stuff after the commit message trailer.
> Greg's signature is going to be after that line.
> In this case, I think you could simply drop the [1] reference
> it's not important in git historic perspective.
> 
> You could add the references after --- if you like.

Sure, that makes sense. Thanks for pointing this out.

- Leah

> 
> Thanks,
> Amir.
> 
> > ---
> >  MAINTAINERS | 1 +
> >  1 file changed, 1 insertion(+)
> >
> > diff --git a/MAINTAINERS b/MAINTAINERS
> > index 393706e85ba2..a60d7e0466af 100644
> > --- a/MAINTAINERS
> > +++ b/MAINTAINERS
> > @@ -20579,6 +20579,7 @@ F:      drivers/xen/*swiotlb*
> >
> >  XFS FILESYSTEM
> >  C:     irc://irc.oftc.net/xfs
> > +M:     Leah Rumancik <leah.rumancik@gmail.com>
> >  M:     Darrick J. Wong <djwong@kernel.org>
> >  M:     linux-xfs@vger.kernel.org
> >  L:     linux-xfs@vger.kernel.org
> > --
> > 2.37.0.rc0.161.g10f37bed90-goog
> >
