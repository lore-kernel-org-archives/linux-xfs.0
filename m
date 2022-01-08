Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30632C433EF
	for <linux-xfs@archiver.kernel.org>; Sat,  8 Jan 2022 14:27:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229797AbiAHO12 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 8 Jan 2022 09:27:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229717AbiAHO12 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 8 Jan 2022 09:27:28 -0500
Received: from mail-yb1-xb29.google.com (mail-yb1-xb29.google.com [IPv6:2607:f8b0:4864:20::b29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14797C061574
        for <linux-xfs@vger.kernel.org>; Sat,  8 Jan 2022 06:27:28 -0800 (PST)
Received: by mail-yb1-xb29.google.com with SMTP id i3so25140116ybh.11
        for <linux-xfs@vger.kernel.org>; Sat, 08 Jan 2022 06:27:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to;
        bh=NbloQuDXxv9yCGm1Y+NUh3k6t+5dbCpRh/scTKQSVsY=;
        b=YgEnXLEHspI34/ObrUB56/NrdcAQ4kQHOf096/N2dzDF02nigbp/hxkANv4JIbrV57
         XggV+4rIBoBu6tHj9KooqAZhDJkwGBPhHrT7Vlf+42q6wsCvnRdjHDUgTg2c67wQwXIb
         NxsO6AIcrISJ2ZlMk7uVPIo7unsNxurfZGQMiQMFuvq83HIkcQZa1hw5GdfJeOic4lB5
         Z97RJNUO0XDmZr5cr/oUshCAJVZy6mwUsMVWCogKQE+M2XblVehLYQIs38yDLljZ28rq
         UyEarx0fc/iUkm0OsWI3oh4SxD3VZcQJuro96+mMkg6XpmcDlaGW/HJif1YmciThVVG3
         qUMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=NbloQuDXxv9yCGm1Y+NUh3k6t+5dbCpRh/scTKQSVsY=;
        b=qVtXGlMC0S+eN4G0BK8uVQsV5PNqNwi5hCqGLymA2Ee2+JAu7vJjSTTCQnk9vldxqF
         nKdMQXtnsNvPxI3n6lk+7Qv0HSCCebt5rW9W9IHA0cNcVWfWsSBxTmQPANvArqIJO2kt
         A1FJb34fF3g+pWRLQNZc5I4MD/SjFNRyFm8N9MCNpN92myPX1I1R9bBKKUYoYCw6Pd3s
         2iCzCrA5fu65Hsiw4iHuQPhSDswd9nwX2ENUv499JCXaBuvFtS9I2WQzV4KuoJxQwwTH
         HtOu7vumvO0XpQG4db4WWtJJo8oydVeNnmGcMwlqnlRJwdTDCcpBNh/aFU+1nIJ6udfn
         wHiQ==
X-Gm-Message-State: AOAM5313PxcFVP4W0d6Ad1F1BPkeyYn3tXMGcIUi/nXWTs2AWA0C2BVl
        ITM5BJBiFDZXw+zmbT1N/anpad2BBsZwNWV3HePTxBBjH/E=
X-Google-Smtp-Source: ABdhPJyDdWMgFqUjYdKHIDxQMZWFA8Dg/gDnBBniniodYE/ERpJxy66TeuVNKa9yBiPXE4oVA7cOPs4BBFyvmrEwI6Y=
X-Received: by 2002:a25:c50a:: with SMTP id v10mr62180678ybe.659.1641652047116;
 Sat, 08 Jan 2022 06:27:27 -0800 (PST)
MIME-Version: 1.0
From:   =?UTF-8?Q?Juan_Sim=C3=B3n?= <decedion@gmail.com>
Date:   Sat, 8 Jan 2022 15:26:51 +0100
Message-ID: <CAMQzBqDkrnvdDZOULB1u_327W1ZDERaHN+kxBXSSLZHyQH=upw@mail.gmail.com>
Subject: recommended scheduler for HDD drive and Linux kernel 5
To:     linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi,
I'm going to install a WD Ultrastar DC HC550 18 TB in a desktop PC
with Arch Linux and kernel 5.15.13. It will primarily store big HD
video files (1080p/4K) and it will be used for streaming.
In the FAQ the question on this topic
(https://xfs.org/index.php/XFS_FAQ#Q:_Which_I.2FO_scheduler_for_XFS.3F)
is not valid for recent versions of the Linux kernel:
--------------------------------------------------------------------------------------
.....
Q: Which I/O scheduler for XFS?
On rotational disks without hardware raid
CFQ: not great for XFS parallelism
....
deadline: good option, doesn't have such problem
Note that some kernels have block multiqueue enabled which (currently
- 08/2016) doesn't support I/O schedulers at all thus there is no
optimisation and reordering IO for best seek order, so disable blk-mq
for rotational disks (see CONFIG_SCSI_MQ_DEFAULT, CONFIG_DM_MQ_DEFAULT
options and use_blk_mq parameter for scsi-mod/dm-mod kernel modules).
....
--------------------------------------------------------------------------------------

Single-queue schedulers were removed from kernel since Linux 5.0.
Which would be the best MQ I/O Scheduler to use: mq-deadline, bfq or none?
Thanks in advance. Regards.
