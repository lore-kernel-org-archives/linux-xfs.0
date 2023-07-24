Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 660DBC0015E
	for <linux-xfs@archiver.kernel.org>; Mon, 24 Jul 2023 15:35:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229544AbjGXPf5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 24 Jul 2023 11:35:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231176AbjGXPfz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Jul 2023 11:35:55 -0400
Received: from mail-oi1-x22e.google.com (mail-oi1-x22e.google.com [IPv6:2607:f8b0:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15119BC
        for <linux-xfs@vger.kernel.org>; Mon, 24 Jul 2023 08:35:54 -0700 (PDT)
Received: by mail-oi1-x22e.google.com with SMTP id 5614622812f47-3a3fbfb616dso2684481b6e.3
        for <linux-xfs@vger.kernel.org>; Mon, 24 Jul 2023 08:35:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=raspberrypi.com; s=google; t=1690212953; x=1690817753;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=oKZv/rBmUS8jYpb20v0bLOMjZtXNWMA7dW9EuTAoCFk=;
        b=kXfW6CLF0OSdXza+/b10cNHYYi7dagRWPLZb23nfItK9QmOO0FcMPU1H66eUvcqi5m
         bVsNXcfUT4MsQ6YXPWMS+dUmtY8E8GTiNz5KEBVJZMIF3LF/ruzurtduAsbiDsowpTGP
         2d/VlfNHqamUE4ayamTMkT/jzy39DAKXe0idnmfQ8OhhqCRYoI8CQNDMtO2QY57bHYDb
         RQ26AYVeyU+meLr02jrmMkgcpae0j3wVXw5OEriXC4X5Mz46RTCz+KAAWauCYacpIh0y
         iHZe1DrQRBC9GJT8z2t89iuj1ihdutxQUec4Hqi4y1stF472GRok/pziJAu7mjqljp1T
         FJLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690212953; x=1690817753;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=oKZv/rBmUS8jYpb20v0bLOMjZtXNWMA7dW9EuTAoCFk=;
        b=VuRXkGnpyaa5E6yOmZUc0KW+AsUUxCwYlmhskbNEb9bCWqOPHmr3W4vMSDlJPOiV1F
         tynt/FbW+zeck2J3e+tnDPSfIN6AldgClWC4wbg+s+sg6g++HLLa6/MWTtrHf9EKCBwW
         WaaGvmCowNKDrK/a4dH1vZzUnTYMe7fX12G7xu0cAXnklGg5x4fAd6GKPU1VvuCMblrD
         ejXmEZULm687xCfRr1NbuEEMv+YLlJ4bGnUIrscX693/0CnmobqDYMqlFO6sPiojWpLb
         9fKjoRxcj+rDN8xUxPGA3m/u3P7oMi2xlRPpPAwbBs2lCitedzVowqOFg+AFiEUdAJcB
         O31Q==
X-Gm-Message-State: ABy/qLa83Rxj6YWsj8IKZX1Xlp19XgVGXdIh9+NzJMSxJOe1uKnpdGGX
        11DG0KT95LWDcY5/gDT/+fQRROjMQ0SPF845b2ld+yaLSxrfHRwRGYQ=
X-Google-Smtp-Source: APBJJlFC27Fs2FQEX6/uDWYX3uVjauBNtGtTmosdOo0LpcFraWNWeDabeLTKObjIMXvb/cfgKzxEeXkoh90w1rflBig=
X-Received: by 2002:a05:6808:f01:b0:398:34da:daad with SMTP id
 m1-20020a0568080f0100b0039834dadaadmr13502844oiw.51.1690212953373; Mon, 24
 Jul 2023 08:35:53 -0700 (PDT)
MIME-Version: 1.0
From:   Phil Elwell <phil@raspberrypi.com>
Date:   Mon, 24 Jul 2023 16:35:43 +0100
Message-ID: <CAMEGJJ2RxopfNQ7GNLhr7X9=bHXKo+G5OOe0LUq=+UgLXsv1Xg@mail.gmail.com>
Subject: Re: [PATCH] io_uring: Use io_schedule* in cqring wait
To:     axboe@kernel.dk
Cc:     andres@anarazel.de, asml.silence@gmail.com, david@fromorbit.com,
        hch@lst.de, io-uring@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, linux-xfs@vger.kernel.org,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Andres,

With this commit applied to the 6.1 and later kernels (others not
tested) the iowait time ("wa" field in top) in an ARM64 build running
on a 4 core CPU (a Raspberry Pi 4 B) increases to 25%, as if one core
is permanently blocked on I/O. The change can be observed after
installing mariadb-server (no configuration or use is required). After
reverting just this commit, "wa" drops to zero again.

I can believe that this change hasn't negatively affected performance,
but the result is misleading. I also think it's pushing the boundaries
of what a back-port to stable should do.

Phil
