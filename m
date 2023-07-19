Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF0D2C001DE
	for <linux-xfs@archiver.kernel.org>; Wed, 19 Jul 2023 19:54:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230245AbjGSTyZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 Jul 2023 15:54:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230041AbjGSTyZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Jul 2023 15:54:25 -0400
Received: from mail-il1-x134.google.com (mail-il1-x134.google.com [IPv6:2607:f8b0:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B932B92
        for <linux-xfs@vger.kernel.org>; Wed, 19 Jul 2023 12:54:23 -0700 (PDT)
Received: by mail-il1-x134.google.com with SMTP id e9e14a558f8ab-346434c7793so170635ab.0
        for <linux-xfs@vger.kernel.org>; Wed, 19 Jul 2023 12:54:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1689796463; x=1692388463;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=dL8sAtLF0gHL6A2T5a+rYAyvDC5eCf4reZq67KGRIjs=;
        b=I5gYA5OStWbMtMlawxwE6vtT7T9XOtLFjvNaW2ePx2NXW/yVE1lk8y7qB1Ap/mQggr
         Uxyxh/vY7pCw8J5neMvBhJcPNwOAfBmjZrHRZKp3+Q0h4E8/H+8uGz/8El8wkMlp3NHt
         vDuXGYW+fvWBOofMCTc6h8cA/XnuUvUD+Ab3OHFi31MJz19gdoO7szMU/wVUvU+e5UWo
         5GYdVBxZYDw/B/oBq6Eu2MSrtTc5aHfTYaKbsBISG1ktpHyyLizfvmhaSLbKOCaAvfKc
         e23/1rkcygVhhImemrqs9rB2ll1ave+3NZnJa/ZIql7Nd+aL2tpkMfmZ3FpIthNoWAAM
         9LXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689796463; x=1692388463;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dL8sAtLF0gHL6A2T5a+rYAyvDC5eCf4reZq67KGRIjs=;
        b=jwlHOJTUtntW37+SEEr02iO90bpEJHkD3E3mJ129J3ViE8+gc5ib0BuaQG6WGSZjhg
         5GpfWxLt8KtG1VY/Q/+pgSFFNzzTe4CeYTU7pzfpSuQmvbAy/XbHQS+k9Aull4yel8NX
         x1vcK92x8Ocg4e6nkb5FIBROC27obfUA4p4hgYDJwJm1QXs6uuMKeeCGmsNIrLdvtnZb
         XrxJeATJUriKzes6wLxl5yNqg5NLM7euX4zq8eZF2c9qEo2uooVqeREiDP4xdPfV0MTb
         Zj+5mroje97SHIppV6tFUcF3FGGlJNUlg5nghxsSiy0TZnYpj5+9EGn1N/AIqsqfpqQT
         ud8w==
X-Gm-Message-State: ABy/qLYVg6JDzLBwiQA1qblVPzXMGG1LiaRLSOCqp0uPMSug5/2R0YcS
        ly4FnrbRUTJTtXsYYmxF6naFTzkddbTsEUFFNEA=
X-Google-Smtp-Source: APBJJlGq3AXxVKqL1sRCxAIyqYIW1NWQViHXMP647/W1v886hvnKXIXYLCa59CtQEdPFLlxzxOoFWQ==
X-Received: by 2002:a92:d985:0:b0:345:ad39:ff3 with SMTP id r5-20020a92d985000000b00345ad390ff3mr640437iln.3.1689796463015;
        Wed, 19 Jul 2023 12:54:23 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id j21-20020a02a695000000b0042bb13cb80fsm1471893jam.120.2023.07.19.12.54.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Jul 2023 12:54:22 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, linux-xfs@vger.kernel.org
Cc:     hch@lst.de, andres@anarazel.de, david@fromorbit.com
Subject: [PATCHSET v3 0/6] Improve async iomap DIO performance
Date:   Wed, 19 Jul 2023 13:54:11 -0600
Message-Id: <20230719195417.1704513-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.40.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi,

iomap always punts async dio write completions to a workqueue, which has
a cost in terms of efficiency (now you need an unrelated worker to
process it) and latency (now you're bouncing a completion through an
async worker, which is a classic slowdown scenario).

Even for writes that should, in theory, be able to complete inline,
if we race with truncate or need to invalidate pages post completion,
we cannot sanely be in IRQ context as the locking types don't allow
for that.

io_uring handles IRQ completions via task_work, and for writes that
don't need to do extra IO at completion time, we can safely complete
them inline from that. This patchset adds IOCB_DEFER, which an IO
issuer can set to inform the completion side that any extra work that
needs doing for that completion can be punted to a safe task context.

The iomap dio completion will happen in hard/soft irq context, and we
need a saner context to process these completions. IOCB_DIO_DEFER is
added, which can be set in a struct kiocb->ki_flags by the issuer. If
the completion side of the iocb handling understands this flag, it can
choose to set a kiocb->dio_complete() handler and just call ki_complete
from IRQ context. The issuer must then ensure that this callback is
processed from a task. io_uring punts IRQ completions to task_work
already, so it's trivial wire it up to run more of the completion before
posting a CQE. This is good for up to a 37% improvement in
throughput/latency for low queue depth IO, patch 5 has the details.

If we need to do real work at completion time, iomap will clear the
IOMAP_DIO_DEFER_COMP flag.

This work came about when Andres tested low queue depth dio writes
for postgres and compared it to doing sync dio writes, showing that the
async processing slows us down a lot.

Dave, would appreciate your input on if the logic is right now in
terms of when we can inline complete when DEFER is set!

 fs/iomap/direct-io.c | 102 +++++++++++++++++++++++++++++++++++--------
 include/linux/fs.h   |  30 ++++++++++++-
 io_uring/rw.c        |  27 ++++++++++--
 3 files changed, 136 insertions(+), 23 deletions(-)

Can also be found in a git branch here:

https://git.kernel.dk/cgit/linux/log/?h=xfs-async-dio.3

Since v2:
- Drop the poll specific bits. They end up folding under the last patch
  now anyway, and this avoids needing a weird "is bio still polled" or
  in_task() check.
- Keep non-IOCB_DEFER writes in the workqueue.
- Cleanup the iomap completion path first.
- Add patch treating fua && has_fua the same as fua && !write_cache
- Add explicit IOMAP_DIO_DEFER_COMP flag
- Add comments

-- 
Jens Axboe



