Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CEEB0C433DB
	for <linux-xfs@archiver.kernel.org>; Wed, 23 Dec 2020 08:47:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8E74F2067C
	for <linux-xfs@archiver.kernel.org>; Wed, 23 Dec 2020 08:47:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727880AbgLWIrA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 23 Dec 2020 03:47:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727050AbgLWIq7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 23 Dec 2020 03:46:59 -0500
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B533C0613D6
        for <linux-xfs@vger.kernel.org>; Wed, 23 Dec 2020 00:46:19 -0800 (PST)
Received: by mail-wr1-x429.google.com with SMTP id q18so17821707wrn.1
        for <linux-xfs@vger.kernel.org>; Wed, 23 Dec 2020 00:46:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kumoSmeRPiAQwJCFk+k+5XNW9leT32eSF9y1wTUfmZw=;
        b=YBSZTOJ+FUq+MRIsqv63haRHrT+86M9Ala4yoGuiYZLkhJLQBSP6tqLZAVxjEQMq+y
         jM/sgIPKN7vdtB5O8YFKi8b08ft8/JUndyF9FwYQ5tblW2g6kvGze3utBxwbdAHK3UVY
         /wpbwhTTCvEDq4gX/yL2vstY+qp7Aq7uGNBB0GfzC3taPFfQrJq/kCI4Ae6nR/FDD550
         a7jBnVwPoyjiaYFM+LBcVr7UliWzCslEyy9aGcF1gfArz+OOUtOr5fd5PArb2xrnlZZ3
         uz3OJAr6pQEV1qVAAm53C269t97PtABh53FhLBUK5rdfHFjinmJtH6n6En0GxRir0wzR
         iEjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kumoSmeRPiAQwJCFk+k+5XNW9leT32eSF9y1wTUfmZw=;
        b=qOv0/zU4KBQ40VC5GTkEOjGYYMR006kQPFQ6qXPuqle0jv+6Cw8bq0eQzuB9TLH6og
         aK3z2PZkiR6FaSOjPJP1hrSHuwBTej+X1ZPPOub76BGnNoSgLDLSwelEvgyZIGQXXBim
         VvqsPZ7b6DDFQX2T3oHL7HlaAL8XhidClxndC0yx7b+bSivutu8ozxe55Cy7TKH6FgDf
         /nNH9eFafqmj7xpcVNeC1P5aiUHv+Gxjuc5vbP7TRQA+IJYCGp5w3dCJYgR6JmYGgZK5
         4/IsbXC1TJTv/aWUSFpKyGG0n9Jcnu20zPl6ReBtVE/KTNQd7VNfkQJ5wHHsdWpUDg6+
         kr4w==
X-Gm-Message-State: AOAM532gKCeRZnujaPr6bWaRoa1OJ+MyGgZPTJbIY/KI4xNkvlUZ8bpb
        bLeHI1RcnVwN4wXXewnTY6hWX4DVylmiTcR1uSOjKhpN
X-Google-Smtp-Source: ABdhPJyMevuCAQO2h8IUQxkg0MAHEu4JFmoMLU8d3LbiYPRN+LkCWDnINt+SkcZ5DIZ611as9pV08rxwscVinlmeCbM=
X-Received: by 2002:adf:f88d:: with SMTP id u13mr28965549wrp.161.1608713177936;
 Wed, 23 Dec 2020 00:46:17 -0800 (PST)
MIME-Version: 1.0
References: <CALjAwxiuTYAVvGGUXLx6Bo-zNuW5+WXL=A8DqR5oD6D5tsKwng@mail.gmail.com>
 <20191105085446.abx27ahchg2k7d2w@orion> <CALjAwxiNExFd_eeMAFNLrMU8EKn0FNWrRrgeMWj-CCT4s7DRjA@mail.gmail.com>
 <20191105103652.n5zwf6ty3wvhti5f@orion> <CALjAwxhK1OSioY1xChRRb6ruk7bGSJXMtMDRcCn=XgSmtOdFKg@mail.gmail.com>
In-Reply-To: <CALjAwxhK1OSioY1xChRRb6ruk7bGSJXMtMDRcCn=XgSmtOdFKg@mail.gmail.com>
From:   Sitsofe Wheeler <sitsofe@gmail.com>
Date:   Wed, 23 Dec 2020 08:45:52 +0000
Message-ID: <CALjAwxjfTTacvGCi86atT_2SQjjKXRCNC2ta_TqxzLZ3YEstBg@mail.gmail.com>
Subject: Re: Tasks blocking forever with XFS stack traces
To:     linux-xfs@vger.kernel.org
Cc:     Carlos Maiolino <cmaiolino@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, 13 Nov 2019 at 10:04, Sitsofe Wheeler <sitsofe@gmail.com> wrote:
>
> Nov 12 16:45:02 <host> kernel: [27678.931551] INFO: task
> kworker/50:0:20430 blocked for more than 120 seconds.
> Nov 12 16:45:02 <host> kernel: [27678.931613]       Tainted: G
>   OE     5.0.0-32-generic #34~18.04.2-Ubuntu
> Nov 12 16:45:02 <host> kernel: [27678.931667] "echo 0 >
> /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> Nov 12 16:45:02 <host> kernel: [27678.931723] kworker/50:0    D    0
> 20430      2 0x80000080
> Nov 12 16:45:02 <host> kernel: [27678.931801] Workqueue:
> xfs-sync/md126 xfs_log_worker [xfs]
> Nov 12 16:45:02 <host> kernel: [27678.931804] Call Trace:
> Nov 12 16:45:02 <host> kernel: [27678.931814]  __schedule+0x2c0/0x870
> Nov 12 16:45:02 <host> kernel: [27678.931819]  schedule+0x2c/0x70
> Nov 12 16:45:02 <host> kernel: [27678.931823]  schedule_timeout+0x1db/0x360
> Nov 12 16:45:02 <host> kernel: [27678.931829]  ? ttwu_do_activate+0x77/0x80
> Nov 12 16:45:02 <host> kernel: [27678.931833]  wait_for_completion+0xba/0x140
> Nov 12 16:45:02 <host> kernel: [27678.931837]  ? wake_up_q+0x80/0x80
> Nov 12 16:45:02 <host> kernel: [27678.931843]  __flush_work+0x15c/0x210

(Quite some time later) This issue went away after switching to an
Ubuntu 18.04 5.3 LTS kernel. Later kernels (e.g. 5.4) have not
manifested the issue either.

-- 
Sitsofe
