Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F8D4C433EF
	for <linux-xfs@archiver.kernel.org>; Mon,  9 May 2022 08:08:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229751AbiEIIMN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 9 May 2022 04:12:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236906AbiEIHyc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 9 May 2022 03:54:32 -0400
Received: from mail-qt1-x82a.google.com (mail-qt1-x82a.google.com [IPv6:2607:f8b0:4864:20::82a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05F501C5E2D
        for <linux-xfs@vger.kernel.org>; Mon,  9 May 2022 00:50:33 -0700 (PDT)
Received: by mail-qt1-x82a.google.com with SMTP id y3so10414499qtn.8
        for <linux-xfs@vger.kernel.org>; Mon, 09 May 2022 00:50:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=PcRhePoH3gSb4wR7XboLUzwlGhfbRsR8T4rYYwFdS1g=;
        b=fxQc4HvGsrEGNF8d6TfAlE+2ATR/sFi1wTwUmyudfVamDyHNadVHXbSz4zDfjKc2oA
         hXhmmBF2ws7JLulMVdZ0k1jkN5xmi/86vWFmv238L7tNg1zEzSkyoWpgLF0qfxNgY976
         lS+gMstcqFtTPg7lc0dvtYsTKBvQxC71aF4CqSwUsshB3WLbwA/YFbjW27gQ5eZCICHG
         r61nto6iqCvCgnSXezkZqpu+a80wjnW8FqkRqX8jtztwtZDKe7l+HVUUDxKw3hOzr17i
         ouOThQ8/lYq3Srjtbixz4ND8sRTyBwDoulkRlTIeym5vNYWcsLdVvMqW2OQq1Rter4FV
         TKJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=PcRhePoH3gSb4wR7XboLUzwlGhfbRsR8T4rYYwFdS1g=;
        b=sPk84yH5suOUDAb53lnClHKJa+yrFyQKf8rDcFBe6f0WpDtejPyQA1CLZB5ASEcjLI
         KCg/ZfO4dxcYXIamqyjPOdZHYB7ESG0C0Pk5geRcOP+etjabpSP1khF+b7n9G9nnUgfk
         d9wC+Cbz6n7icYfe1CDHduy2GtnZCi+bfuc7ESiXnvX4AwpO1EG2ginPrytU7My9CX8d
         ax6/g4Qeqf2naBGJpxZ/y8V2A5Jkr49RZiYd0tFK1hqqpRNk1HjEtI1aFPbYX237vDeC
         +vcHTnTs2sLtgjEUNYgiV5t9PLRr2TvnLXKCThLwUhe3lQdubPZoEj7xJHaVA04AOXay
         6v0w==
X-Gm-Message-State: AOAM530Rfy1KRDJ0j5uZNyOfWzbMFOin3PKAgr4c9nk3tRxdvIgHVk3G
        wNFLDvWXBIPO16zQf0XxUb4OTIjmn2E57M1Oy/A=
X-Google-Smtp-Source: ABdhPJyuSGQ52/sk97vmC9yXgfy7eN9QwiAjqe29/iWhdr2HkKW/Ys7BEj49MahQkeg7Rfqhae0hUASPiyl8X8svOiU=
X-Received: by 2002:ac8:7fc2:0:b0:2f3:d47d:487c with SMTP id
 b2-20020ac87fc2000000b002f3d47d487cmr6284749qtk.157.1652082632129; Mon, 09
 May 2022 00:50:32 -0700 (PDT)
MIME-Version: 1.0
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Mon, 9 May 2022 10:50:20 +0300
Message-ID: <CAOQ4uxjBR_Z-j_g8teFBih7XPiUCtELgf=k8=_ye84J00ro+RA@mail.gmail.com>
Subject: [QUESTION] Upgrade xfs filesystem to reflink support?
To:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Darrick and Dave,

I might have asked this back when reflink was introduced, but cannot
find the question nor answer.

Is there any a priori NACK or exceptional challenges w.r.t implementing
upgrade of xfs to reflink support?

We have several customers with xfs formatted pre reflink that we would
like to consider
upgrading.

Back in the time of reflink circa v4.9 there were few xfs features
that could be
upgraded, but nowadays, there are several features that could be upgraded.

If I am not mistaken, the target audience for this upgrade would be
xfs formatted
with xfsprogs 4.17 (defaults).
I realize that journal size may have been smaller at that time (I need to check)
which may be a source of additional problems, but hopefully, some of your work
to do a diet for journal credits for reflink could perhaps mitigate
that issue(?).

Shall I take a swing at it?

Thanks,
Amir.
