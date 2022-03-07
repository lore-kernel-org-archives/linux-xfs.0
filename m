Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5F0CC433F5
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Mar 2022 12:19:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233832AbiCGMUi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 7 Mar 2022 07:20:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233829AbiCGMUe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 7 Mar 2022 07:20:34 -0500
Received: from mail-io1-xd2d.google.com (mail-io1-xd2d.google.com [IPv6:2607:f8b0:4864:20::d2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABEC43EB82
        for <linux-xfs@vger.kernel.org>; Mon,  7 Mar 2022 04:19:40 -0800 (PST)
Received: by mail-io1-xd2d.google.com with SMTP id d62so16674303iog.13
        for <linux-xfs@vger.kernel.org>; Mon, 07 Mar 2022 04:19:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=E1PaBtIH9IoBjv/6XtWov0wjzKqR6IQiZnOtFjYBlsw=;
        b=cD9E5gAsMvpKvA3lGIhr7/qnMR4I/LMvO6R5EsNQGcBErjMHWRn1L1jOw8YiPAX5FO
         83QIha/wtpmUbTUfIt5EDDIl6T/cPjHPhgPdo9wz0lXW2TzgI5cPL380PSeXgO2ipGyV
         BhpDNPCuyWwsvIWoXTnPmYRSVXAiR+tvPqkin6iKArldm4t2r+BsSXg12HG4vxoHhoFT
         N8i+08H9pqoIBOW5DILr1ZXWjIi3QEiZ4Umn1xzGy/4BTDqunZQk8EYE0Ofelme4DxpL
         wNu7CpubC7gicFeFsbf2J069MVgpYlS4KaDOe1jF+1OH/2e0J+s8KDGS5fuGhuQ3nqhO
         njHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=E1PaBtIH9IoBjv/6XtWov0wjzKqR6IQiZnOtFjYBlsw=;
        b=hRA8vWXIUy8CHbEX7XrWnVWGQRUBF2Msu7MnQap+ewYy3FU8mpIJpcwj5faerm3LJm
         FOmoJ7sks8aL4Oubwut8ZUcQrWPrjNj9WWIiUfL4cLqHaLYF4h62+Ee1JxEx1jFXxjaO
         6EgvFMVVgVBGd2SXgWRcrLOnWUQPRBON0IxHVfGs/HXCuYwOs8wgSOznE1W5cWJcyNQK
         n8wETT021+cCTN5Y7fT1cjHK8veLAzZHLw0pI5rghIxyHnTtCs+qrvWIWW9efDPfjHTH
         Obg5uHjlWsKNNvPb2kb1njBkHF2e3NbrYgt4tU1CMtOO0lvm0wCVm7RfUr3WcgrMaKrC
         xpyg==
X-Gm-Message-State: AOAM531etH16UlZ/SQoY2zzZRYObkKWdum3e28Ued1ujZtM2Uc2XEtiT
        01KyTavKsvrkLHDXmLX6/Uqq33JwjrM9fXq3shVcahF0Pg8=
X-Google-Smtp-Source: ABdhPJw3K5QNOTphm0zWeF2/yFpiJdxZer4whOV/SShkqlwPNtqc7bZaQkgStIQm8LAm9UQLudbfEsK/ZgH8CbJoGFk=
X-Received: by 2002:a05:6638:d83:b0:317:8010:cf07 with SMTP id
 l3-20020a0566380d8300b003178010cf07mr11026510jaj.152.1646655579749; Mon, 07
 Mar 2022 04:19:39 -0800 (PST)
MIME-Version: 1.0
References: <CALwRca2+UsEZMPwiCtecM87HVVMs27SdawdWXns+PU7+S-DFaQ@mail.gmail.com>
In-Reply-To: <CALwRca2+UsEZMPwiCtecM87HVVMs27SdawdWXns+PU7+S-DFaQ@mail.gmail.com>
From:   David Dal Ben <dalben@gmail.com>
Date:   Mon, 7 Mar 2022 20:19:11 +0800
Message-ID: <CALwRca3yS2q4XYr5aFaPWxNcGsYRFDWeU9je1q31KGguTeX6Rw@mail.gmail.com>
Subject: Re: Inconsistent "EXPERIMENTAL online shrink feature in use. Use at
 your own risk" alert
To:     linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The "XFS (md1): EXPERIMENTAL online shrink feature in use. Use at your
own risk!" alert is appearing in my syslog/on my console.  It started
after I upgraded a couple of drives to Toshiba MG09ACA18TE 18Tb
drives.

Strangely the alert appears for one drive and not the other.  There
was no configuring or setting anything up wrt the disks, just
installed them straight out of the box.

Is there a real risk?  If so, is there a way to disable the feature?

Kernel used: Linux version 5.14.15-Unraid

Syslog snippet:

Mar  6 19:59:21 tdm emhttpd: shcmd (81): mkdir -p /mnt/disk1
Mar  6 19:59:21 tdm emhttpd: shcmd (82): mount -t xfs -o noatime
/dev/md1 /mnt/disk1
Mar  6 19:59:21 tdm kernel: SGI XFS with ACLs, security attributes, no
debug enabled
Mar  6 19:59:21 tdm kernel: XFS (md1): Mounting V5 Filesystem
Mar  6 19:59:21 tdm kernel: XFS (md1): Ending clean mount
Mar  6 19:59:21 tdm emhttpd: shcmd (83): xfs_growfs /mnt/disk1
Mar  6 19:59:21 tdm kernel: xfs filesystem being mounted at /mnt/disk1
supports timestamps until 2038 (0x7fffffff)
Mar  6 19:59:21 tdm root: xfs_growfs: XFS_IOC_FSGROWFSDATA xfsctl
failed: No space left on device
Mar  6 19:59:21 tdm root: meta-data=/dev/md1               isize=512
 agcount=32, agsize=137330687 blks
Mar  6 19:59:21 tdm root:          =                       sectsz=512
 attr=2, projid32bit=1
Mar  6 19:59:21 tdm root:          =                       crc=1
 finobt=1, sparse=1, rmapbt=0
Mar  6 19:59:21 tdm root:          =                       reflink=1
 bigtime=0 inobtcount=0
Mar  6 19:59:21 tdm root: data     =                       bsize=4096
 blocks=4394581984, imaxpct=5
Mar  6 19:59:21 tdm root:          =                       sunit=1
 swidth=32 blks
Mar  6 19:59:21 tdm root: naming   =version 2              bsize=4096
 ascii-ci=0, ftype=1
Mar  6 19:59:21 tdm root: log      =internal log           bsize=4096
 blocks=521728, version=2
Mar  6 19:59:21 tdm root:          =                       sectsz=512
 sunit=1 blks, lazy-count=1
Mar  6 19:59:21 tdm root: realtime =none                   extsz=4096
 blocks=0, rtextents=0
Mar  6 19:59:21 tdm emhttpd: shcmd (83): exit status: 1
Mar  6 19:59:21 tdm emhttpd: shcmd (84): mkdir -p /mnt/disk2
Mar  6 19:59:21 tdm kernel: XFS (md1): EXPERIMENTAL online shrink
feature in use. Use at your own risk!
Mar  6 19:59:21 tdm emhttpd: shcmd (85): mount -t xfs -o noatime
/dev/md2 /mnt/disk2
Mar  6 19:59:21 tdm kernel: XFS (md2): Mounting V5 Filesystem
Mar  6 19:59:22 tdm kernel: XFS (md2): Ending clean mount
Mar  6 19:59:22 tdm kernel: xfs filesystem being mounted at /mnt/disk2
supports timestamps until 2038 (0x7fffffff)
Mar  6 19:59:22 tdm emhttpd: shcmd (86): xfs_growfs /mnt/disk2
Mar  6 19:59:22 tdm root: xfs_growfs: XFS_IOC_FSGROWFSDATA xfsctl
failed: No space left on device
Mar  6 19:59:22 tdm root: meta-data=/dev/md2               isize=512
 agcount=32, agsize=137330687 blks
Mar  6 19:59:22 tdm root:          =                       sectsz=512
 attr=2, projid32bit=1
Mar  6 19:59:22 tdm root:          =                       crc=1
 finobt=1, sparse=1, rmapbt=0
Mar  6 19:59:22 tdm root:          =                       reflink=1
 bigtime=0 inobtcount=0
Mar  6 19:59:22 tdm root: data     =                       bsize=4096
 blocks=4394581984, imaxpct=5
Mar  6 19:59:22 tdm root:          =                       sunit=1
 swidth=32 blks
Mar  6 19:59:22 tdm root: naming   =version 2              bsize=4096
 ascii-ci=0, ftype=1
Mar  6 19:59:22 tdm root: log      =internal log           bsize=4096
 blocks=521728, version=2
Mar  6 19:59:22 tdm root:          =                       sectsz=512
 sunit=1 blks, lazy-count=1
Mar  6 19:59:22 tdm root: realtime =none                   extsz=4096
 blocks=0, rtextents=0
Mar  6 19:59:22 tdm emhttpd: shcmd (86): exit status: 1
