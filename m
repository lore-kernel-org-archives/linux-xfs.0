Return-Path: <SRS0=3Xx9=C6=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF8E1C43465
	for <linux-xfs@archiver.kernel.org>; Mon, 21 Sep 2020 03:13:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8A96720723
	for <linux-xfs@archiver.kernel.org>; Mon, 21 Sep 2020 03:13:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Od6go+Ag"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726104AbgIUDNI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 20 Sep 2020 23:13:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726011AbgIUDNI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 20 Sep 2020 23:13:08 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E4C9C061755
        for <linux-xfs@vger.kernel.org>; Sun, 20 Sep 2020 20:13:07 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id o8so15605078ejb.10
        for <linux-xfs@vger.kernel.org>; Sun, 20 Sep 2020 20:13:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=xXw9rsvjUhKaYVTl3fcKgUe1QE2MPWX4MHKe0Nt6K0A=;
        b=Od6go+AgnRtz/OpxWu+SwptDP+AXWL/5eS2HYYomn7bM6LlJg/bd8WTuUxPfCDNO+a
         4erniYvlVynXIp0q3alw837V87Ny8MWiUCb1eLCoVVGmk2iA2Rtk8krWfjU6rgM/x5rq
         TFlIZP8Jig7ebUJGkSk2ZXVtLPwBa3QkeuX7hx9x2PF+3u6+Ihe3yxUocdpXLIukcyzw
         SwGb7MgS876Em3j0hVlU6T+ORZR56FWGLXbUoCJ6XzpRu3uvMMWC+ZA+Rci+TWREJtMu
         p5dUG2kmdDfblbYm6/b1i8O56Om4uFvpPMAMN3t0L+FSyCG9sM+Q+DUUZbLrb1vApWLL
         Ww0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=xXw9rsvjUhKaYVTl3fcKgUe1QE2MPWX4MHKe0Nt6K0A=;
        b=O3KNZ7W+AwSFJvK7ryUQDLPH4sTWbIbszBVxyFY8LE7fLwEX8Ii6wGIg+ng8EMS7MY
         hMCK974D8tmaM73Ix0glaz6tEY0vZ48A1LkSPuHKwjlcpjfmrXJv3XRAh0DdAUkH1cOX
         Ng42ZRN5cf8jWNWsMG4L2j+AKwQ0gghewC9cQRzocw1YH+a3qn98outTOjwSZhdOUQ+P
         NW2tNGTTAul5aSapZpxjYzz3AK+qO4UUqKq1AByiQXOyqy6ozaADFSedXn6A+CYTLufJ
         EnihtJWlNenMsyLbJHOEClcAuyae89jPwFzbEHfshj9cqqk0JehSeRrtFViil5cSG0bL
         ln0g==
X-Gm-Message-State: AOAM5336/BQrWHZlAo88SHDhfDv98c8PIpE+u2e5Ouxk8fOH/wTF8Fsh
        sBq1H3nf142sqCAOjtlouNnFby6yelNNOPy6EwfQZ5dcK0E=
X-Google-Smtp-Source: ABdhPJw7UG7bl1mP7TyQF1agPaAOh8nnRipLTo1QZZERunn4H6S90tHekSdOS1mabODRPmJAZoOyHGlwFcHFmGBESTQ=
X-Received: by 2002:a17:906:c2c5:: with SMTP id ch5mr49085032ejb.183.1600657985895;
 Sun, 20 Sep 2020 20:13:05 -0700 (PDT)
MIME-Version: 1.0
From:   Zheng Wu <zhengwu0330@gmail.com>
Date:   Mon, 21 Sep 2020 11:12:54 +0800
Message-ID: <CADQqeeS9SWv_R5XNsNRq=pLiP-9r56-YyhCw7JP32-aR=jsK+w@mail.gmail.com>
Subject: The feature of Block size > PAGE_SIZE support
To:     linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi experts,

We know that the feature of Block size > PAGE_SIZE will be supported in XFS.
Just, I can't test successfully in the last version of Linux.

When is this feature of  Block size > PAGE_SIZE available in upstream?

Thanks.

Best Regards
Zheng Wu
