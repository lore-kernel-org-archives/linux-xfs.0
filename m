Return-Path: <SRS0=DzrB=EM=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=BAYES_05,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CA9DC388F2
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Nov 2020 08:14:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D2AA8208B3
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Nov 2020 08:14:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FCo9dn6a"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726248AbgKFIOq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 6 Nov 2020 03:14:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726027AbgKFIOq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 6 Nov 2020 03:14:46 -0500
Received: from mail-yb1-xb2e.google.com (mail-yb1-xb2e.google.com [IPv6:2607:f8b0:4864:20::b2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8710C0613CF
        for <linux-xfs@vger.kernel.org>; Fri,  6 Nov 2020 00:14:44 -0800 (PST)
Received: by mail-yb1-xb2e.google.com with SMTP id h196so432502ybg.4
        for <linux-xfs@vger.kernel.org>; Fri, 06 Nov 2020 00:14:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=WE/ai4a24BWKSgeuRwjz7pU8TRuzB4O1DSXDqU/NHrE=;
        b=FCo9dn6aafwx9cTmZqn56hx4ZUOWUgf3eYE7j57lT8bD+Q1SbmPXP9LTZYTfMR3JlT
         uV6BSD7HE26gBvk0d+s4aVgJpR3nD3XAjzTShdLuNpvxlp+OlM2XcBU5aoO+oWnshTCU
         rj5/OrCvlX5Sozi+nNJ0eHryuOkGZlAVDVNSgdAWov+FWnXMwHXcY3YDnmLSISepGwZA
         0hyzpl+4gYoULvwg9AGNGJPuTDC5eqwLmU0zqlmzHEvTKdk8VsNHHf6VnVB+xzPQlWm7
         1+giw2vIgBztXFSI6s4y1pZ83jlht7+G5USRm0gzdjzSCzl/Eh7VLiwXTg0ArKceVH4A
         IfUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=WE/ai4a24BWKSgeuRwjz7pU8TRuzB4O1DSXDqU/NHrE=;
        b=mDAMFhcJu+4BXsTAK6n4dJL6qI1+Pu+a6wAELVxK0PwF9dap8q0KfKffoDLRulBxVE
         bPS3QywBOcthDB5QO79YjhAZONbFkqnyoHTJpdKWfqHOOAl3sVCeRtJJ/QCGM8Me3Cr6
         M9jYDJsVXqJEX91ZzBfRwH5QVfWE6jcmgCU/bmVl0Zepy/FPh32j0UCbsh43hlCjwo0+
         ZgfKAo7lp4JrxF1/gA9HxMSE41bRaZhnMZNAXLkCfXqEn8sfNEGhM+w3uYzFryEgToQb
         /Fl0sIsqdi2zhaXCm7xAq9U9CUa03pdrdWUrk7enVsJDo5RO6abSVMApPDRKGlh1AUwG
         DU/A==
X-Gm-Message-State: AOAM530/I3yxtFgCmSx/GBjsATFXKSTQ5BSL78t+c7BWk3+/C4GOebu1
        74Lu72X3hiMm3VXtWMl94liOV++370ie7QaCOc9/NFtXJN0=
X-Google-Smtp-Source: ABdhPJyLC4vW6EIgT4Rumt0FJcMZv4ftPHKyixClD6f11bo/qLA6hXy60qldotzZFijsZn55SXNvOD1sJQXJ8qzqQKc=
X-Received: by 2002:a25:da0f:: with SMTP id n15mr1059292ybf.481.1604650483967;
 Fri, 06 Nov 2020 00:14:43 -0800 (PST)
MIME-Version: 1.0
From:   liang bai <darkagainst@gmail.com>
Date:   Fri, 6 Nov 2020 16:14:05 +0800
Message-ID: <CA+Kr39MGk=mj0Mx7idzUvkEOxw5qzwfqzWuxN0mgzTGSHLsK5Q@mail.gmail.com>
Subject: About material on old xfs wiki
To:     linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi,
I am doing some research about how SSD can better cooperate with XFS.
So I need to know much about the design of the XFS.
I find some material in new xfs wiki, but I would like to know more
about internal design and details in old xfs wiki. It's a pity that
the old one
can not work now. I'd like to know if the web will recover and if
there is a way to get the material.

Best Regards
Taylor
