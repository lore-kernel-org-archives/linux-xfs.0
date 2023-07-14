Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6EB74EB64DC
	for <linux-xfs@archiver.kernel.org>; Fri, 14 Jul 2023 06:46:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235197AbjGNGqT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 14 Jul 2023 02:46:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232577AbjGNGqA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 14 Jul 2023 02:46:00 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C8FA3AA3
        for <linux-xfs@vger.kernel.org>; Thu, 13 Jul 2023 23:45:17 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id 5b1f17b1804b1-3fbd33a57b6so15141435e9.2
        for <linux-xfs@vger.kernel.org>; Thu, 13 Jul 2023 23:45:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1689317115; x=1691909115;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=uaiH2QnubJRuTr1PyNaDFoqm/n0jJlVA8zqv+dctrMI=;
        b=LWMl5vp7SGHNs29qQIw33kwLBuT89PxKbDjo0xZ+CoKL1fUdXchSbGbdyTQO+YIGIN
         StC7rIb15LHVFnX5+J1TZFSYS+BJ+D1U9g23bL/uZeVJ+YJryDZpugQJdvQG6R48KqwS
         oj1nbEX4gMcDjSChBniXQMyUHLT5ay4z2iRMqw/o1auvwKVFnqV05/sPVBNIIW0Niz62
         hcH1m4NroYczpFCF3bhKMImNmv+X1K8YGEfSNLLgB6q24zkm35mFRgctW/u2v8FWhjSn
         f+5OxIMfVLDU5ZHvYHI14dgVwIfto3FYUs7Vres3sSno2V36IDxtkW6TLucUPaGRHQP+
         qXeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689317115; x=1691909115;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=uaiH2QnubJRuTr1PyNaDFoqm/n0jJlVA8zqv+dctrMI=;
        b=iua7wMHAadpnJH5aM5tOZijZyiA/ejeps10vPcE3ufF0zAQu6hEjTBCQaKlo1svZfq
         5DYfVfy28dV8NVu+0uh7CEPUwJ22q49nNWPBKfAYzYhGKyFJAJzzr4sDjvPUWCgc/FNo
         QlnxNxm5XhQHXPblnvZjphj3XCIwwnHCnnzpnn/3eTjn46zGgl3owvtO2IVg+meriFqV
         G1/s2h88ACDHjRe8wIBjNfXkrkFrJfHxvB91BlWv522XqMiXZJRbs3e4pWOZOYScMk78
         zADyjR5wDcQUypGKGmCxktGqQNpBvLfKWOpH+jxk89pOLaJ1YCFDd+7AlrEWd0WYV3i2
         HALg==
X-Gm-Message-State: ABy/qLZ0hGLGb/tnPgb4zbOl4eUecLPrqCW6Qy2SWHtNKgSS9RhLaNcm
        +fwpi85evA0jgbmo1SFXUeA=
X-Google-Smtp-Source: APBJJlHebPPxJdWykBIy232+orTwgeSDx/0kdxcNUFDYaP5kqHsorfBM6C6iTOgirv/iCwY1/ouaXA==
X-Received: by 2002:a7b:ce08:0:b0:3f6:1474:905 with SMTP id m8-20020a7bce08000000b003f614740905mr4095956wmc.29.1689317115416;
        Thu, 13 Jul 2023 23:45:15 -0700 (PDT)
Received: from amir-ThinkPad-T480.lan ([5.29.249.86])
        by smtp.gmail.com with ESMTPSA id 3-20020a05600c234300b003fc04d13242sm709574wmq.0.2023.07.13.23.45.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Jul 2023 23:45:15 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     "Darrick J . Wong" <djwong@kernel.org>
Cc:     Chandan Babu R <chandan.babu@oracle.com>,
        Leah Rumancik <leah.rumancik@gmail.com>,
        Dave Chinner <david@fromorbit.com>,
        Chris Dunlop <chris@onthe.net.au>, linux-xfs@vger.kernel.org
Subject: [PATCH 6.1 CANDIDATE v2 0/4] xfs inodegc fixes for 6.1.y (from v6.4)
Date:   Fri, 14 Jul 2023 09:45:05 +0300
Message-Id: <20230714064509.1451122-1-amir73il@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Darrick,

These are the patches we discussed that Leah requested for the 5.15.y
backport of non-blocking inodegc pushes series [1].

They may or may not help the 5.15.y -> 6.1.y regression that was
reported by Chris [2].

This v2 series has gone through 3 rounds of kdevops loop on top
of the testing already run on v1.

Please ACK.

Thanks,
Amir.

Changed since v1:
- include: 2d5f38a31980 ("xfs: disable reaping in fscounters scrub")

[1] https://www.spinics.net/lists/linux-xfs/msg61813.html
[2] https://lore.kernel.org/all/ZK4E%2FgGuaBu+qvKL@dread.disaster.area/

Darrick J. Wong (4):
  xfs: explicitly specify cpu when forcing inodegc delayed work to run
    immediately
  xfs: check that per-cpu inodegc workers actually run on that cpu
  xfs: disable reaping in fscounters scrub
  xfs: fix xfs_inodegc_stop racing with mod_delayed_work

 fs/xfs/scrub/common.c     | 26 -------------------------
 fs/xfs/scrub/common.h     |  2 --
 fs/xfs/scrub/fscounters.c | 13 ++++++-------
 fs/xfs/scrub/scrub.c      |  2 --
 fs/xfs/scrub/scrub.h      |  1 -
 fs/xfs/xfs_icache.c       | 40 ++++++++++++++++++++++++++++++++-------
 fs/xfs/xfs_mount.h        |  3 +++
 fs/xfs/xfs_super.c        |  3 +++
 8 files changed, 45 insertions(+), 45 deletions(-)

-- 
2.34.1

