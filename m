Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E53BC0015E
	for <linux-xfs@archiver.kernel.org>; Tue, 11 Jul 2023 20:33:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230195AbjGKUde (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 11 Jul 2023 16:33:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229770AbjGKUdd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 11 Jul 2023 16:33:33 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CD661AE
        for <linux-xfs@vger.kernel.org>; Tue, 11 Jul 2023 13:33:31 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id d2e1a72fcca58-6748a616e17so1600989b3a.1
        for <linux-xfs@vger.kernel.org>; Tue, 11 Jul 2023 13:33:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1689107610; x=1689712410;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=fB1PyYCxgU5LJD718Rda1NmZRnJIbaAlvaPfM1WjEFU=;
        b=2W+4k/Mbz+/Ejli+Sh2T8GoOlhS8dBQUz+RHgtmGTQbho6bnbjLYPtxHh9A04HEM64
         151wLDTklrE8zIC5U1R7P5FJRYaCGbaUHwpkpueZHDbz3KNUIWTVfuD4uB7TPOF/q57p
         OYfNqBo1/DO+2A3HsKsHEMNdpgbtjuC6Bm2qFNwsjpGDSWDMIeQSA09ANhwqhxiXgs0g
         sI1qGSkqxKSMaX/NdTnKsI6rYrmF9TkrJmjNLHkXtX0hz1BbnIk1BTMUaCXZLR7ppmgD
         44NFdknLm41AodSkZlSfkvxCE4gKlFKgvxXyF1IlHiU+bvmfoaOSMB3IZWF0ORn1gzY6
         gmxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689107610; x=1689712410;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fB1PyYCxgU5LJD718Rda1NmZRnJIbaAlvaPfM1WjEFU=;
        b=ZDHpHwj4V5VsnOXEXA2xZ2SEvYA6yRGYFSPDHlEAz0P0HR6xbnDI9Pkhax+sv0QMU2
         Z7hBVXY6gqAzGSVJLPTo7vulbZXmzjZqaH7J2LhAqkk8npgUXMqqBV1ng8xi50ppUNys
         hbJtJpFPhT24JWKWOZ5hRyxuW7b+hxGOGlniNyKDeXhtJxgkFPR8KdqxzLkLamZ3tmk3
         I7WwyOhcm6VyECgCISidSNO6aB9MsPQLOYun/NpFp/mLN8Q8m2fFLS/mg5MHb4deKLmp
         tBynycTZNzVXiY2VwI96ZjuyUFlnLGYOUdD8PMY0hbRCGdvoDJIoB1rD/V7IJb78LjUm
         jpJQ==
X-Gm-Message-State: ABy/qLZbM50l3yoco9+xxNHF4U982lzb0RRCMgANwdl26l8aCfzNZM7Q
        2KhCSlgGL9jv9LBqckxu0q34JU3VWUPQ+hQVEmc=
X-Google-Smtp-Source: APBJJlGYJHT1bV9rcREpfHmzdKKia792LdurTQPJZfomC7WrG2OLVvmGmz/KByIj+IZeHildskNm2Q==
X-Received: by 2002:a05:6a00:1ca0:b0:681:9fe0:b543 with SMTP id y32-20020a056a001ca000b006819fe0b543mr17672996pfw.2.1689107610440;
        Tue, 11 Jul 2023 13:33:30 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id fk13-20020a056a003a8d00b0067903510abbsm2108081pfb.163.2023.07.11.13.33.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Jul 2023 13:33:29 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, linux-xfs@vger.kernel.org
Cc:     hch@lst.de, andres@anarazel.de
Subject: [PATCHSET 0/5] Improve async iomap DIO performance
Date:   Tue, 11 Jul 2023 14:33:20 -0600
Message-Id: <20230711203325.208957-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.40.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi,

iomap always punts async dio completions to a workqueue, which has a
cost in terms of efficiency (now you need an unrelated worker to process
it) and latency (now you're bouncing a completion through an async
worker, which is a classic slowdown scenario).

This patchset intends to improve that situation. For polled IO, we
always have a task reaping completions. Those do, by definition, not
need to be punted through a workqueue. This is patch 1, and is good
for up to an 11% improvement in my testing. Details in that patch
commit message.

For IRQ driven IO, it's a bit more tricky. The iomap dio completion
will happen in hard/soft irq context, and we need a saner context to
process these completions. IOCB_DIO_DEFER is added, which can be set
in a struct kiocb->ki_flags by the issuer. If the completion side of
the iocb handling understands this flag, it can choose to set a
kiocb->dio_complete() handler and just call ki_complete from IRQ
context. The issuer must then ensure that this callback is processed
from a task. io_uring punts IRQ completions to task_work already, so
it's trivial wire it up to run more of the completion before posting
a CQE. Patches 2 and 3 add the necessary flag and io_uring support,
and patches 4 and 5 add iomap support for it. This is good for up
to a 37% improvement in throughput/latency for low queue depth IO,
patch 5 has the details.

This work came about when Andres tested low queue depth dio writes
for postgres and compared it to doing sync dio writes, showing that the
async processing slows us down a lot.

 fs/iomap/direct-io.c | 39 +++++++++++++++++++++++++++++++++------
 include/linux/fs.h   | 30 ++++++++++++++++++++++++++++--
 io_uring/rw.c        | 24 ++++++++++++++++++++----
 3 files changed, 81 insertions(+), 12 deletions(-)

Can also be found in a git branch here:

https://git.kernel.dk/cgit/linux/log/?h=xfs-async-dio

-- 
Jens Axboe



