Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16C39C43334
	for <linux-xfs@archiver.kernel.org>; Thu, 30 Jun 2022 05:31:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231650AbiF3FbS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 30 Jun 2022 01:31:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbiF3FbR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 30 Jun 2022 01:31:17 -0400
Received: from mail-vs1-xe29.google.com (mail-vs1-xe29.google.com [IPv6:2607:f8b0:4864:20::e29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEC56D13E
        for <linux-xfs@vger.kernel.org>; Wed, 29 Jun 2022 22:31:15 -0700 (PDT)
Received: by mail-vs1-xe29.google.com with SMTP id o13so17220822vsn.4
        for <linux-xfs@vger.kernel.org>; Wed, 29 Jun 2022 22:31:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bSnVICLFvoENe6aQA8wk2B3YE0y1LsZnu/gRj1tsXfQ=;
        b=HBozIRSas1EsmD1WqJ9nZa63ljz2DQHkIysYupsEkq9WZm6OTuXS8ahW83l6v5133h
         4K/SGUAMDwUCGzkcGovvj0yv1oW+JUTHCGOOCk2qe4++z6oP2CRdQU/qhlefP5XD3aFq
         7QYaA4fCktORSSAAs1PVQEyZl9KeDoYupRMNWSRDxTrdhSgMyjTrY3anMQTRu4EusUT1
         kfvN2W31I6VGQZflfwhP27dd1QZkmIrvtqBFjtrpKPQQG6UqZr/frOb03/HhvMYLQAJ2
         I1Xxvy/VA3A/BMkUC9it3aINKPmBRjwcx9rWEDUKe4wPS++9icxueDsuIYFVM70tHBPf
         tybw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bSnVICLFvoENe6aQA8wk2B3YE0y1LsZnu/gRj1tsXfQ=;
        b=IrkbgFTId//JyRzJLQ0uzHWnwG6zYaR3s4HmCj2LB4i9S75vFqFoqZeA3LxRG+vUkC
         AUiSkRmxDuYEWJH9kkdyDf6/F8EODgUPuT2OmI+sqdLcR09Z0uBYX5Mxo7j/Q31MTL9I
         J7q23gR4Rh+RrMDIK8mloyd7jM7gxYNhtlSzKbCb8hoUMSoxJAG1WY+qSwRrvGEEqk2V
         IdN3Mvu0NjoteTP5vl7H7FQu5jsXZSthBbuz3+NomxrPTej1CQ5EJtBGKVJyZBBgpTmP
         oteq5BDvgY/G4bKO4ap+vWJDXmCU7kWpmclGQ8p/tH5fo5YWNEQr2fHKtbzXrCamFPW2
         uocg==
X-Gm-Message-State: AJIora/l1Lq+8II5E7upF16R35JOPXyk3oQtsrH3VaqlhtMtjqNlmMX7
        3j+HhnlWh+HGaGfhkRh/XoCHV2ey4FzzSmUaNUw=
X-Google-Smtp-Source: AGRyM1vQHfA9lD/pkQ47QpG3669DOpnaFGO0bmoAg5qEI6uy3u5UbkWG+guD4bg3WwLFEeSUgmVZmC3KloAgI9YRuJo=
X-Received: by 2002:a05:6102:38c7:b0:356:4e2f:ae5b with SMTP id
 k7-20020a05610238c700b003564e2fae5bmr6848753vst.71.1656567075036; Wed, 29 Jun
 2022 22:31:15 -0700 (PDT)
MIME-Version: 1.0
References: <20220629235546.3843096-1-leah.rumancik@gmail.com>
In-Reply-To: <20220629235546.3843096-1-leah.rumancik@gmail.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Thu, 30 Jun 2022 08:31:03 +0300
Message-ID: <CAOQ4uxh-2c0Sp=nUN-brB3ySb_rhYPLPa-VxJW9WOzSXOLUCww@mail.gmail.com>
Subject: Re: [5.15] MAINTAINERS: add Leah as xfs maintainer for 5.15.y
To:     Leah Rumancik <leah.rumancik@gmail.com>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>,
        "Darrick J. Wong" <djwong@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jun 30, 2022 at 3:11 AM Leah Rumancik <leah.rumancik@gmail.com> wrote:
>
> Update MAINTAINERS for xfs in an effort to help direct bots/questions
> about xfs in 5.15.y.
>
> Note: 5.10.y [1] and 5.4.y will have different updates to their
> respective MAINTAINERS files for this effort.
>
> Suggested-by: Darrick J. Wong <djwong@kernel.org>
> Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
>
> [1] https://lore.kernel.org/linux-xfs/20220629213236.495647-1-amir73il@gmail.com/

It is not good practice to put stuff after the commit message trailer.
Greg's signature is going to be after that line.
In this case, I think you could simply drop the [1] reference
it's not important in git historic perspective.

You could add the references after --- if you like.

Thanks,
Amir.

> ---
>  MAINTAINERS | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 393706e85ba2..a60d7e0466af 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -20579,6 +20579,7 @@ F:      drivers/xen/*swiotlb*
>
>  XFS FILESYSTEM
>  C:     irc://irc.oftc.net/xfs
> +M:     Leah Rumancik <leah.rumancik@gmail.com>
>  M:     Darrick J. Wong <djwong@kernel.org>
>  M:     linux-xfs@vger.kernel.org
>  L:     linux-xfs@vger.kernel.org
> --
> 2.37.0.rc0.161.g10f37bed90-goog
>
