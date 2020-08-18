Return-Path: <SRS0=PyEN=B4=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89D82C433E1
	for <linux-xfs@archiver.kernel.org>; Tue, 18 Aug 2020 10:47:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 62DE1207DF
	for <linux-xfs@archiver.kernel.org>; Tue, 18 Aug 2020 10:47:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="L0eR2sKW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726598AbgHRKrB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 18 Aug 2020 06:47:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726203AbgHRKrA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 Aug 2020 06:47:00 -0400
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4BF3C061389
        for <linux-xfs@vger.kernel.org>; Tue, 18 Aug 2020 03:46:59 -0700 (PDT)
Received: by mail-io1-xd44.google.com with SMTP id h4so20682814ioe.5
        for <linux-xfs@vger.kernel.org>; Tue, 18 Aug 2020 03:46:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vsIXYXW2WJLM80jj2APP8YYVXigkfgnMa+SyCT29yLc=;
        b=L0eR2sKW3UtDRPEUUKRP8t/A7xkdUH6M+JNe1vIYz7UfK7wkpK7Zd5lV7m/Slp323E
         WJRrsq6bio0aRDpQn5u5dh/eCEdCQi0EJxDitQ72EWhLmTSkdTMgATCMLxdKZmap/2Sy
         MvUVyx+7btakDF5adzwJV6p0ewfa2NrdGn4E3XzZ0Oo6GztMqvq/EjHFuANkSC1FdVnA
         opuyAg2yzo5KBQOWFp0ysuZs0CwcKFivk1vAoe1etKjZF19xXdeJJDTJKe1wpewKcF3y
         lWslwCnST+yWfObIBWnuYSGgvtAfs+MKRyDL+jQ9ryLfSq+23xZktUMu2bRG5uh9WSWg
         mpYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vsIXYXW2WJLM80jj2APP8YYVXigkfgnMa+SyCT29yLc=;
        b=Wr02skdZNsFKYVTKlaDUTMpu4X9lfIauqEuO6RjoQRVtokwDxyRN6WcYioSHbEjpFX
         5xRgmUtxLgLMyY1Uw1UHyOztRTfGjlwBJ9Vh+7Sf4vQxaAhfy8u7LqLIRp2eNJjlDx8+
         KSpjP8LIrl8EJo255jatmTob60ztS7R5aoO/DEF71wjuqie4X6qq1iLg4GhsbmneBj1p
         kmyznUZe2EibQFXNWiVHJWR/JUGg6u68/C2qTJJi4ucQ4Dgd+jtG1gB8ur35n+hWjstm
         u6Q/I49CySpJUXF/au3ii4N0d7SBuhQFbHFU54W2sQHCDQ0rp6aIEyw7KH35lg8URdK5
         swVA==
X-Gm-Message-State: AOAM530YZe3bf3icFGQXNPZSFUxkzzGfC6cVjFXPbmRWKFk1alRTmgxn
        jwqem0fmVn/EeoBZTn9b917ROkyG2SyrDvHFNfhUFy7MjAc=
X-Google-Smtp-Source: ABdhPJyOG4b5eVmbER+XhqFXV9fM667QMFwLZYgVXtA7G5lfEmmCFyasDa+eUK7a3FihLpSIrdMpR/6frei9EaCVR68=
X-Received: by 2002:a05:6638:1413:: with SMTP id k19mr18093649jad.93.1597747618528;
 Tue, 18 Aug 2020 03:46:58 -0700 (PDT)
MIME-Version: 1.0
References: <159770500809.3956827.8869892960975362931.stgit@magnolia> <159770502702.3956827.5672717512043351449.stgit@magnolia>
In-Reply-To: <159770502702.3956827.5672717512043351449.stgit@magnolia>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Tue, 18 Aug 2020 13:46:47 +0300
Message-ID: <CAOQ4uxggq1oN_p61ZLqMntb5yUJYJvNHLhvtS6VV7WZhMAFM_w@mail.gmail.com>
Subject: Re: [PATCH 03/11] xfs: refactor default quota grace period setting code
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>,
        Eric Sandeen <sandeen@sandeen.net>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Aug 18, 2020 at 1:59 AM Darrick J. Wong <darrick.wong@oracle.com> wrote:
>
> From: Darrick J. Wong <darrick.wong@oracle.com>
>
> Refactor the code that sets the default quota grace period into a helper
> function so that we can override the ondisk behavior later.
>
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Reviewed-by: Amir Goldstein <amir73il@gmail.com>
