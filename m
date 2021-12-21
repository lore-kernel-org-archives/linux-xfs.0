Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5888C433EF
	for <linux-xfs@archiver.kernel.org>; Tue, 21 Dec 2021 04:13:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231934AbhLUENF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 20 Dec 2021 23:13:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231925AbhLUENE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 20 Dec 2021 23:13:04 -0500
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8F05C06173E
        for <linux-xfs@vger.kernel.org>; Mon, 20 Dec 2021 20:13:04 -0800 (PST)
Received: by mail-pg1-x536.google.com with SMTP id g2so8607953pgo.9
        for <linux-xfs@vger.kernel.org>; Mon, 20 Dec 2021 20:13:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wKrfGiJLmo4BFy866IR6WichX7+97mPLbqHHnF9C+U0=;
        b=tXWtVTEdB1vLnxZFgNqvM6eVRbmeCYP+Q1isSNun2AINF3tkOQoPbc5mwZLgYaXm8Y
         k/KmzI1TmIAgdPYmIJR4UPLSck0t7tZqG+RpmSPUIbhqyf1ZAsG1lJWP7Q7fOQzn420V
         e0vfRHW//ZFG8A3MiMAUoxPa8wKqWM2d7MDo6ELULobAAmWxxsgSx1U1Rk9HLKh/kPcq
         FePQuH9EY0XHYGYMwMDciLuloL1ytQNqKV85cypG7RAd5k2pI4BV9C1Cwg+lLO08NMx6
         kaK9Ce2pFU8YyNtdVlJR9iBYno7Fn9unNDzVsMxmvLiDLDohH37mHsJGRfe0qh9pEupD
         5n1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wKrfGiJLmo4BFy866IR6WichX7+97mPLbqHHnF9C+U0=;
        b=QehMeu/qxsSC657gG9pXXuooD4HOtwFSEUxn2GALoWT1y2KiphwqvRJkLFcyrjqVfi
         W7RmmSE/zopHSeygQAnb+/xB+YFEH7qLHcK/FmkOSLqaZe2UbcegIWAAjerbbAoFSzEj
         mZ67zJ7CtCm5RihPZ3kr5zGsZ9f4D0VLXTOz4aINDqUxhY0VBpT2BvdPUzA38z4AEI67
         TP6TWMzIoD3ZSwmaGApBT7xGxoMHXkaVuirsMaOaD98SxxP5yY3I3+n9cq1dSkWFLmaM
         DsuAZWh0eCrR1jphVjiDw7i39am0qikxxyJi6H33mG2gOvV9zgykUiK1RJNrNz6cH3FB
         oV8Q==
X-Gm-Message-State: AOAM532R/0NLL7f1k5219f+A70iGT1194+qvipQy7TMPW/YHC+J/DcVJ
        Zi8iLVCGjrI4A+XoORo85mPGiuOU74/hIcghmAXYlA==
X-Google-Smtp-Source: ABdhPJxofkcdUiHzaUKIy+2kqqXjOLT/9cQ+sV/siMZg3Y8bfjR1kNm3ScUeEhTDEm/js2o4xLPKaPtXhCOBvTQOClU=
X-Received: by 2002:a63:824a:: with SMTP id w71mr1300001pgd.74.1640059983994;
 Mon, 20 Dec 2021 20:13:03 -0800 (PST)
MIME-Version: 1.0
References: <20211208091203.2927754-1-hch@lst.de> <YcD/WjYXg9LKydhY@casper.infradead.org>
In-Reply-To: <YcD/WjYXg9LKydhY@casper.infradead.org>
From:   Dan Williams <dan.j.williams@intel.com>
Date:   Mon, 20 Dec 2021 20:12:53 -0800
Message-ID: <CAPcyv4gfGBSWf=+WxkSPbca1BH=OeTmFoSjUBKJV-aos=YwWMA@mail.gmail.com>
Subject: Re: [PATCH] iomap: turn the byte variable in iomap_zero_iter into a ssize_t
To:     Matthew Wilcox <willy@infradead.org>
Cc:     Christoph Hellwig <hch@lst.de>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        Linux NVDIMM <nvdimm@lists.linux.dev>,
        Dan Carpenter <dan.carpenter@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Dec 20, 2021 at 2:10 PM Matthew Wilcox <willy@infradead.org> wrote:
>
> Dan, why is this erroneous commit still in your tree?
> iomap_write_end() cannot return an errno; if an error occurs, it
> returns zero.  The code in iomap_zero_iter() should be:
>
>                 bytes = iomap_write_end(iter, pos, bytes, bytes, page);
>                 if (WARN_ON_ONCE(bytes == 0))
>                         return -EIO;

Care to send a fixup? I'm away from my key at present, but can get it
pushed out later this week.
