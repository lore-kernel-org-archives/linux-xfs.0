Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 105B8C433EF
	for <linux-xfs@archiver.kernel.org>; Tue,  7 Dec 2021 13:26:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229815AbhLGN3s (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 7 Dec 2021 08:29:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230374AbhLGN3s (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 7 Dec 2021 08:29:48 -0500
Received: from mail-ua1-x935.google.com (mail-ua1-x935.google.com [IPv6:2607:f8b0:4864:20::935])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05D24C061574
        for <linux-xfs@vger.kernel.org>; Tue,  7 Dec 2021 05:26:18 -0800 (PST)
Received: by mail-ua1-x935.google.com with SMTP id j14so26408799uan.10
        for <linux-xfs@vger.kernel.org>; Tue, 07 Dec 2021 05:26:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to;
        bh=Fb6VKJy87SAnSS5qugiCgwfRBDIqEu6cr8Crb4Jq8z8=;
        b=SH4Xkzk+CgNcCMTQOqJN6tQ/839tVvcDhVWYsHBVsE6ZvKDX1IWo6vsgiNLjNtElQ9
         mgBrbiqpTc0eE4Iry+SWfh+7+oX6J2nE7aw/5DoVzOyeE89ed6OgYK8jbjvnyWXqzFqe
         1I/y8ggc4GMV6QZtztHruAIsmSD68k0lUZqJ90xp0/mVIQxjMl8FDoNAwE1/sazR9vhL
         Qcmovrlf7hS5/Yn9WYQ9B88mOCLIC8xi5BuiLkTF5ShueDAWrG/8qGFp+5mUXyP/wy1x
         nsqQ+to7CvQ4haEA4GyJD1zjCmxnI0OAV5+e9neBOG0ZP0KbnoqmL7U74HdhPxVpNxDX
         YXbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=Fb6VKJy87SAnSS5qugiCgwfRBDIqEu6cr8Crb4Jq8z8=;
        b=BEXTYpunb9cz/ssc6mf3l5Ea6jhi53EYoKJjIE7zg7R88ReI0og+Cnn63I42vV494m
         LgYCr72C2kwr7AtFNjJy29YTfJk/r6bHdFIZoInSpa0mpcejUq0xwFvWhlJDb1ybytVq
         /8FTAg7GZV83hc54FL8o5kGnJnTT9kG86fI5V3EnpBMwN+XCH/74CvjS9ZnpiJJGvqz3
         WEGs9/jiZge33V9jQoANvqHoKH+LvtTrjK5cG8zwNgaU7G2L2Mqf8b8G6Sjv5nvw4G+f
         wsyzjDelZ9QU/CZpA/jznK7IOtPNGSrMEKxIF81KxD6gh4GPXBFGVtNaNvbdu6/0Jenh
         xq5Q==
X-Gm-Message-State: AOAM530LZSjgbiFiHZh0sOIv+8ExzbXJ+OElQcyTXy8XMx8TbsxRpPsZ
        uvfdkb2CCEgx5T/LAK2oCGdyA7Ir7z2KGAmqbb5cIFe3ioA=
X-Google-Smtp-Source: ABdhPJynWyPQTZWTOrm2ksLSaDCj6fjnN4VwPwS9UgIEwVOYIG7nmrebYju449XjKs5UMdbZIKUm5c3hnl+5zzrNWV8=
X-Received: by 2002:ab0:74c1:: with SMTP id f1mr50316663uaq.109.1638883577111;
 Tue, 07 Dec 2021 05:26:17 -0800 (PST)
MIME-Version: 1.0
From:   tiandi huang <juanfengpy@gmail.com>
Date:   Tue, 7 Dec 2021 21:26:06 +0800
Message-ID: <CAPmgiULFc3w__JxXmbLdqvaC+shxwCFrwjfA9ubY8UjZjxbQQA@mail.gmail.com>
Subject: hang on shrink_dcache_sb at remount of directories inside container
To:     linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi, guys!
Recently, We have met a problem that systemd insides docker always
hang at below stack, stays inside shrink_dcache_sb as long as hours.
 __dentry_kill+0x124/0x170
shrink_dentry_list+0x64/0xb0
shrink_dcache_sb+0xb2/0x140
reconfigure_super+0x85/0x220
do_mount+0x90e/0x980
ksys_mount+0xb6/0xd0
 __x64_sys_mount+0x25/0x30
do_syscall_64+0x47/0x140
entry_SYSCALL_64_after_hwframe+0x44/0xa9

We run many containers onside /data which is a xfs file system.
Directories on /data are bind mounted inside containers, sometimes,
systemd inside containers may do remount operations with these bind
directories. Each remount would cause a reconfigure on /data and
shrink_dcache_sb is called to shrink the s_dentry_lru list, as data is
shared by all containers, processes may still produce dentries on this
list, which may cause a long time to wait shrinking ends.
So, We mailed to wonder  is it possible to skip this shrink operation
for containers as lower xfs file system is still running, or is it
possible to optimize shrink_dcache_sb function to scan only once of
the dentry lru list, do not wait the list to become empty.
We appreciate for a response, Thanks!
