Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92C9EC433F5
	for <linux-xfs@archiver.kernel.org>; Sat,  8 Jan 2022 12:43:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234221AbiAHMnH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 8 Jan 2022 07:43:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234193AbiAHMnG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 8 Jan 2022 07:43:06 -0500
Received: from mail-yb1-xb2a.google.com (mail-yb1-xb2a.google.com [IPv6:2607:f8b0:4864:20::b2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67E91C061574
        for <linux-xfs@vger.kernel.org>; Sat,  8 Jan 2022 04:43:06 -0800 (PST)
Received: by mail-yb1-xb2a.google.com with SMTP id y130so24612631ybe.8
        for <linux-xfs@vger.kernel.org>; Sat, 08 Jan 2022 04:43:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to;
        bh=NbloQuDXxv9yCGm1Y+NUh3k6t+5dbCpRh/scTKQSVsY=;
        b=IM574gMqUzNZjLzPEezNtmZEicgqddZmzPaCa3O+aqXdeaHMpX6e1lP+/0g/Grypw7
         hdn6IK/szPmfBEjjM5ec9Epz25uAgnkVaw/lrEgiJUdI94bcHvEiotD5jCE+oxNNERLi
         v5gtrm4nVQmC7jiDesUwAy+hSFVzWV7JcqJ+kTHMy5MWlimoRmOnUW607DiPD+gHCsHu
         QwvKe4Zt9sTWzkVCIEgXvn1XHrarnsalhbNRWV+ZwCyps7dr6aZodfsh1eq1WmLhQew4
         32xZmhcHnRjvdDf+seYIrMrNv37nqt1XmuLz7HLvZN/bXfDjB2cELx/LI08hwkQLPiE2
         Z2AQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=NbloQuDXxv9yCGm1Y+NUh3k6t+5dbCpRh/scTKQSVsY=;
        b=zsAk5iD6yX41mzNNDNPEzbY+4uC2CgoOLB3EKovK2JxGMVvJcjmN++GKvQVaYOTrGv
         awYHSm3ueH8fLWCVmrEwd+V+rs6Dttsxmw/LqbLbc9AvmVxud0oLLHQpGCNi7lpdJHPC
         sgsaNCX24sTzijl/3oIdmZI4zts/PeTEh7MMQV2TGG+2qyTDqdLpwIKKOYQn8ag/DTJH
         0ZcKpkgwgmI1wZnEjbZHyPB43x1VvqLF4A4HW80QNmV2trWRS82TXpl1YzrK1jQa60JN
         Myh5W253SlcgK/SOoD+KImLRgwJcYdXQEkol5nVXahXM/v5892mMu0LNea1R6ZCp4MBb
         NIYA==
X-Gm-Message-State: AOAM530GXP6sZpFa0me66P3zlP6m/rDL9G6SGVo8LaOuNch3J0/Iv79w
        J8qY2gBwyrWFrdnVGMhbJoHb5/wT8TjLn5BI4l1WTfjHbOQ=
X-Google-Smtp-Source: ABdhPJzxivDMXJONzp+CUUkZ6u6BBMr9ASkxiSneWCEtX/NHbyFOHfqOOai+RWwpQBtLzqRgoLABaxBSKFXN7V7sHrU=
X-Received: by 2002:a25:9347:: with SMTP id g7mr72681023ybo.255.1641645784854;
 Sat, 08 Jan 2022 04:43:04 -0800 (PST)
MIME-Version: 1.0
From:   =?UTF-8?Q?Juan_Sim=C3=B3n?= <decedion@gmail.com>
Date:   Sat, 8 Jan 2022 13:42:29 +0100
Message-ID: <CAMQzBqCGTw8+Fg7ErAOeC7t_vjAhBVjUzk_eB9qTnAL_xzykOg@mail.gmail.com>
Subject: recommended scheduler for HDD drives
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
