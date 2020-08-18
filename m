Return-Path: <SRS0=PyEN=B4=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05FF4C433DF
	for <linux-xfs@archiver.kernel.org>; Tue, 18 Aug 2020 14:14:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D654B2083B
	for <linux-xfs@archiver.kernel.org>; Tue, 18 Aug 2020 14:14:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SBCcX/Xx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726716AbgHROOn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 18 Aug 2020 10:14:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726949AbgHROOj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 Aug 2020 10:14:39 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3439C061389
        for <linux-xfs@vger.kernel.org>; Tue, 18 Aug 2020 07:14:38 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id s189so21333542iod.2
        for <linux-xfs@vger.kernel.org>; Tue, 18 Aug 2020 07:14:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rKwFE5C/3nY30LT3plq4NazIAQEV0DMMnSozMMTPMb4=;
        b=SBCcX/XxTHZoG3QjeSenkkGQyTnENKvgTOUoODrBVI4IQRw6sSpPxcQfKYu4kzUQSO
         tWpNjJZ7ZQDomnkY6N7BdPHd35XgGBcptxemLnojRCId8wD/dDDtOuwjjZBf7rEXtPFp
         oJ2iCQX/EpZTevtfpR4cIa0XmS22QNOkCvF+MaSev7o4fkNQFQ3M6kZ4LnXEdnNuuQM8
         D2Y2yNHVvaMJ5FqbbCgTOoN4T3BhhoXeBKmlMp1hsHbWR20G3e1ONEi1z1RgwKz3aNGX
         RTpJm7qLOIWVSqC2kzsgCR8x+fCUwvT4VMaCrYgOTC8KmfXsX4FO2pYsltcBewUI36eQ
         o9Lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rKwFE5C/3nY30LT3plq4NazIAQEV0DMMnSozMMTPMb4=;
        b=I/JAzZ3+RnrrqK+kxnKB8SI3n3r8wwFd/bMNHZEg8ledrFfE8Mf7eS90AwqFtINC6V
         r2as8Hrc+eeW8VOaSfOxdtEauFCQx9+/TbW9Lfs7wRrpsoVi+zrIOyacoKiTHWST2eb5
         aycOnvtFvm9eTAGevU7Ip9oIYWHicD/X5hQ0uMv+2RkedLx1MWON65o4pkWDO/xU9Lxb
         xTtC138/6vDyw0md0CdzI6VAi5EF4iKlC2bs+TgNoZyB2hP17qRaJunAOEIYnqUW8HrA
         Ck9K7R9PAKbvw7oOiL/SE2eM8jbHK5lx27GEB83gXuyS/4XICW8bPCNeL6MkmW16vNMY
         HNfw==
X-Gm-Message-State: AOAM531TfV7uG5bpcEDhi/W/2wr1113NmZRQFdX4Xvxfmzk3Qd9YN9pA
        4ZGndBO3vCanJSTkMiixAQSoPpDc+yZXIdQHbkoU7VhfYUc=
X-Google-Smtp-Source: ABdhPJxhrk1/ams90t//durD+0RaQ+EIe41tpa7wnnci3nUqChN+0cx6AgvfgyxEeAQoq9xicRSrmV1wf5qIJLnu6mU=
X-Received: by 2002:a02:82c3:: with SMTP id u3mr19377904jag.81.1597760078125;
 Tue, 18 Aug 2020 07:14:38 -0700 (PDT)
MIME-Version: 1.0
References: <159770508586.3958545.417872750558976156.stgit@magnolia> <159770510435.3958545.6606540263072605314.stgit@magnolia>
In-Reply-To: <159770510435.3958545.6606540263072605314.stgit@magnolia>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Tue, 18 Aug 2020 17:14:27 +0300
Message-ID: <CAOQ4uxiL3Ja6dH9TbpQVtZfegc6jz2_pB7qE-a4Bg0XQLeLcAw@mail.gmail.com>
Subject: Re: [PATCH 3/7] xfs_db: add bigtime upgrade path
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Eric Sandeen <sandeen@sandeen.net>,
        linux-xfs <linux-xfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Aug 18, 2020 at 2:24 AM Darrick J. Wong <darrick.wong@oracle.com> wrote:
>
> From: Darrick J. Wong <darrick.wong@oracle.com>
>
> Enable users to upgrade their filesystems to bigtime support.

That was supposed to be "inobtcount" (title as well)

Thanks,
Amir.
