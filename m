Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-io0-f172.google.com ([209.85.223.172]:40399 "EHLO
        mail-io0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754639AbeD3Pc5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 30 Apr 2018 11:32:57 -0400
Received: by mail-io0-f172.google.com with SMTP id g14-v6so6932748ioc.7
        for <linux-xfs@vger.kernel.org>; Mon, 30 Apr 2018 08:32:57 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
Subject: [PATCHSET 0/2] sync discard
Date: Mon, 30 Apr 2018 09:32:50 -0600
Message-Id: <1525102372-8430-1-git-send-email-axboe@kernel.dk>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org, linux-block@vger.kernel.org
Cc: hch@lst.de

We recently had a pretty severe perf regression with the XFS async
discard. This small series add a SYNC issue discard flag, and also
limits the chain size for sync discards. Patch 2 adds support for
reverting XFS back to doign sync discards.

-- 
Jens Axboe

