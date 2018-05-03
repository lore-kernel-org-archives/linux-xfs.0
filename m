Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-io0-f177.google.com ([209.85.223.177]:40401 "EHLO
        mail-io0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751132AbeECPUr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 3 May 2018 11:20:47 -0400
Received: by mail-io0-f177.google.com with SMTP id g14-v6so18391247ioc.7
        for <linux-xfs@vger.kernel.org>; Thu, 03 May 2018 08:20:46 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
Subject: [PATCHSET 0/3] Add throttling for discards
Date: Thu,  3 May 2018 09:20:40 -0600
Message-Id: <1525360843-6504-1-git-send-email-axboe@kernel.dk>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-block@vger.kernel.org, linux-xfs@vger.kernel.org
Cc: dchinner@redhat.com, hch@lst.de

I implemented support for discards in blk-wbt, so we treat them like
background writes. If we have competing foreground IO, then we may
throttle discards. Otherwise they should run at full speed.

-- 
Jens Axboe

