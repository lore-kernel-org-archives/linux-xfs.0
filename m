Return-Path: <SRS0=wjSb=4L=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE52AC35671
	for <linux-xfs@archiver.kernel.org>; Sun, 23 Feb 2020 07:56:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AA8F3208C3
	for <linux-xfs@archiver.kernel.org>; Sun, 23 Feb 2020 07:56:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kgtYkn94"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726208AbgBWH4A (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 23 Feb 2020 02:56:00 -0500
Received: from mail-il1-f195.google.com ([209.85.166.195]:45707 "EHLO
        mail-il1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725980AbgBWHz7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 23 Feb 2020 02:55:59 -0500
Received: by mail-il1-f195.google.com with SMTP id p8so5172218iln.12
        for <linux-xfs@vger.kernel.org>; Sat, 22 Feb 2020 23:55:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=as/yabrw4Ok18R+krePUVDy/5vwNbSqyko7MYoNdd5o=;
        b=kgtYkn94Uy99SyF254C/vNN30jVtzq+MbzfyyHT8j7HdPP7pfoyquDb/CnUxICcKCh
         ahVF5mf5V2fcvgcWdFQHlAgIqxpaTRcevtzm/vJYIZNWeMpLaiMOt4gUEW3gXma/geq7
         SHMxkKjNGe931FLXjbXoAYi/z43VmQ9g5b1VTqKsQ35n07T9TcoLZe2vqMlbUNpX7vYH
         JtLYwSYrv3i7TnRLEntjjhYe+CwaOwAVoNqhP4T2SqeVPlFbImwjoiBUmHvtVYEWjt1C
         UZ2VH2NlEvbCuxFZuQXiJjq/OELuHji2w6VUym+Q75MHP9wJGA+vWru148bTsZsvfTga
         +Snw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=as/yabrw4Ok18R+krePUVDy/5vwNbSqyko7MYoNdd5o=;
        b=WYMGMboZ1I/4P7E2DFd0IIokulNlu/4BClSwl8+dOsCAohYUDUJOMFNkbtrEMCs3Wj
         c05iPrN7+T3h6Ugjzv/v1r/LuiHUjWlggUiQ8XJsvmAN8Ym1Vauv68eZiGim+29rQnrW
         0Rh5Z/eCCTNXI57HUTF4IHowihQM7Hd2s0aGIBe49WnLutX5D95YgqvT1FUpeDSfA5Jh
         6lIouYXZnsClvEtsWyiO3Fe42dDJSLcbOqI+mkK7ViVVKuRxNyJ/QakNApIA1qYNV4VP
         KzSd5Mo/g7PDiQ+5I2Gwyvl2pZ4GK316bIH8zceQXNpT6g5elVaRqN8JuAdbdwZab2+/
         klpQ==
X-Gm-Message-State: APjAAAVR+Bk6xhXcbg5YEn+NOF8EFP17NZmbkjxX/W+2rnqjwSTTPT2r
        xgNul6sVCYNJJUMUdfuGinwVxIeykcYHwQ5jsSwRHg==
X-Google-Smtp-Source: APXvYqwHCGFCgYx075m7qe+L4sR1Tt0f2GZAdeeXx3cbgv8mMiSo1eXFGbns1EGe34PwnUexuei/B4SeHkHHZjG9fGU=
X-Received: by 2002:a92:8656:: with SMTP id g83mr51829280ild.9.1582444559201;
 Sat, 22 Feb 2020 23:55:59 -0800 (PST)
MIME-Version: 1.0
References: <20200223020611.1802-1-allison.henderson@oracle.com>
In-Reply-To: <20200223020611.1802-1-allison.henderson@oracle.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Sun, 23 Feb 2020 09:55:48 +0200
Message-ID: <CAOQ4uxgvJOF6+jd9BuJfxxGQbiit6J7zVOVnigwLb-RWizRqfg@mail.gmail.com>
Subject: Re: [PATCH v7 00/19] xfs: Delayed Ready Attrs
To:     Allison Collins <allison.henderson@oracle.com>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Feb 23, 2020 at 4:06 AM Allison Collins
<allison.henderson@oracle.com> wrote:
>
> Hi all,
>
> This set is a subset of a larger series for delayed attributes. Which is
> a subset of an even larger series, parent pointers. Delayed attributes
> allow attribute operations (set and remove) to be logged and committed
> in the same way that other delayed operations do. This allows more
> complex operations (like parent pointers) to be broken up into multiple
> smaller transactions. To do this, the existing attr operations must be
> modified to operate as either a delayed operation or a inline operation
> since older filesystems will not be able to use the new log entries.

High level question, before I dive into the series:

Which other "delayed operations" already exist?
I think delayed operations were added by Darrick to handle the growth of
translation size due to reflink. Right? So I assume the existing delayed
operations deal with block accounting.
When speaking of parent pointers, without having looked into the details yet,
it seem the delayed operations we would want to log are operations that deal
with namespace changes, i.e.: link,unlink,rename.
The information needed to be logged for these ops is minimal.
Why do we need a general infrastructure for delayed attr operations?

Thanks,
Amir.
