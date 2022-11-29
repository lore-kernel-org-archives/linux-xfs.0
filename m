Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC4DEC4332F
	for <linux-xfs@archiver.kernel.org>; Tue, 29 Nov 2022 19:22:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236935AbiK2TWp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 29 Nov 2022 14:22:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236910AbiK2TW1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Nov 2022 14:22:27 -0500
Received: from mail-io1-xd31.google.com (mail-io1-xd31.google.com [IPv6:2607:f8b0:4864:20::d31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 887E365E60
        for <linux-xfs@vger.kernel.org>; Tue, 29 Nov 2022 11:20:42 -0800 (PST)
Received: by mail-io1-xd31.google.com with SMTP id z131so185862iof.3
        for <linux-xfs@vger.kernel.org>; Tue, 29 Nov 2022 11:20:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=UuVWCUELurQ1VN/4A6l13rzQEVNrNkL5t5DNTsFuaRg=;
        b=JqZUAbtpkLWMWxfrIZPMdmeZovaHngYH2Sfex9vWNo8Hl7W3PcnUxhkv/R0TSJXD+x
         WXnXvhs1R+RBPikGYPnjKU28iMQn5W9ZVJMNTtXiT0OQluXF/fN89ZfHqo64c/B2nzqz
         iRb/e0IQwdyiDYjnyLG3aBJRaMoq6updxh8YW8bF9fD2IuhdmfuXSd9hwm4EJfDoeu6J
         yeR5juegjxl+bMCzjcUxcv4vyqcM9A65Vdo5xSA9v73jnnml99OAHqRc6IxrJYUyO86F
         RhjTuFQ2eXXdR5CGifcORTM4rtcwxvg62CaR8ivmG+tZIflVRMQK8dCcfis/iIJwXHCE
         R6ZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=UuVWCUELurQ1VN/4A6l13rzQEVNrNkL5t5DNTsFuaRg=;
        b=y9KxU3pJvffnzZ2yUbol6xoXtlY2FH7Mm7ifpE+FtDSREJzV54lSTTxDMI5wDYiyny
         wYeIhcOE99sHtGanEAKp3YuLulKIRmlbA5qlZACNCUHfeU5vRtH117iuahLN2Kb3+I34
         AKfP+EV3eXT90NankZVEsNMmuqtjikNzG3oGjmp1pVelNdXTyKNDEZLBfQRK/hXd65CB
         6cmU13I9dXkBpqVNPKBO7ySJa7zorO3Bb5TnUt5E2kozN6W6rDpa1oBwPaOg64S9/I3Q
         2WAy5cXJpDRsBh4fp1bfjs14xe7cA6HpKK1qYruBYPcfBEfTv1YE77CN30p5FRMMDrLW
         Nokw==
X-Gm-Message-State: ANoB5pmkKp01diyz8epKLF93F8cXh1GXlKy8Z45AXedTdWGS9HPLZt7K
        BrzQi8vCYAWV1wx2SL3xppJOgXUuCvqoWZsF9KiBOwymT7s=
X-Google-Smtp-Source: AA0mqf69XUo8tIfE5GI40U8IIql3W7g33v2OA7RHqDvrhFwnhb6ZEUkqqp0WFV4SXcUGI43dZEQfjD3dlNJXLNc73sg=
X-Received: by 2002:a5d:9446:0:b0:6d3:5145:937c with SMTP id
 x6-20020a5d9446000000b006d35145937cmr26797988ior.67.1669749641544; Tue, 29
 Nov 2022 11:20:41 -0800 (PST)
MIME-Version: 1.0
From:   Shawn <neutronsharc@gmail.com>
Date:   Tue, 29 Nov 2022 11:20:05 -0800
Message-ID: <CAB-bdyQVJdTcaaDLWmm+rsW_U6FLF3qCTqLEKLkM6hOgk09uZQ@mail.gmail.com>
Subject: Do I have to fsync after aio_write finishes (with fallocate
 preallocation) ?
To:     linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hello all,
I implemented a write workload by sequentially appending to the file
end using libaio aio_write in O_DIRECT mode (with proper offset and
buffer address alignment).  When I reach a 1MB boundary I call
fallocate() to extend the file.

I need to protect the write from various failures such as disk unplug
/ power failure.  The bottom line is,  once I ack a write-complete,
the user must be able to read it back later after a disk/power failure
and recovery.

In my understanding,  fallocate() will preallocate disk space for the
file,  and I can call fsync to make sure the file metadata about this
new space is persisted when fallocate returns.  Once aio_write returns
the data is in the disk.  So it seems I don't need fsync after
aio-write completion, because (1) the data is in disk,  and (2) the
file metadata to address the disk blocks is in disk.

On the other hand, it seems XFS always does a delayed allocation
which might break my assumption that file=>disk space mapping is
persisted by fallocate.

I can improve the data-in-disk format to carry proper header/footer to
detect a broken write when scanning the file after a disk/power
failure.

Given all those above,  do I still need a fsync() after aio_write
completion in XFS to protect data persistence?

Thanks all for your input!

regards,
Shawn
