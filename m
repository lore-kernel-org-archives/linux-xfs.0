Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3536ECAAD5
	for <linux-xfs@archiver.kernel.org>; Sun, 28 Aug 2022 12:46:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229533AbiH1Mqb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 28 Aug 2022 08:46:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbiH1Mqa (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 28 Aug 2022 08:46:30 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0617D39BAC;
        Sun, 28 Aug 2022 05:46:29 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id bs25so7057009wrb.2;
        Sun, 28 Aug 2022 05:46:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc;
        bh=+LfkNYJ2H9zp6tL3WOMBOTlGLiCB9JmtiuK3YkFIZUU=;
        b=I99ZZmvamOqqUWvWIxZ7Sr/Uo7jKedt3udaLsCt+ZxMyjDV6fSmzRmFdHZhSmDe4JG
         1sURLO97YWmSGyA7XGY6jd+AUIlE4+NKG1aqQBhV7VOtIwg/xP41LA4n3n0tzd/RDIv/
         ptevypUQ0tDEWV8d0OKCNQwceojk0LFx4CCmBnPZ+Lelq2dylbVFBnAiO0AhKETUarfh
         vqIF4j/3XymBIdw3uoqGtXQn57JsOJqRlA6SPBpmF/Ng3lEHYVAYX6F0mkzufBJXa4JH
         X+tgkSCo2eYlQGEBkQiP6SQsqe3crrjn+bhmrVV1dg9BNLzKIR7kFF9vrVY+lvRkZvLL
         GwHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=+LfkNYJ2H9zp6tL3WOMBOTlGLiCB9JmtiuK3YkFIZUU=;
        b=1qw63M9hZP0kUv2gQbqroQZ54rGtQmRdBHQQDcEi26wiH7FLz1iZaGvyd7hmW5+hxq
         ccGojJXfbcreukfzpK0w9YKQYoZ0qvcfhIYgIIdnWGCIUGz4ALfHfw2Gi2s+T56BL8Oj
         /a4HEYWCeiRhVe23YgTKZe4SEPyLynaVC4vd/IAAc9MmEq87QEaOB0AzHjcTLxeKXCcd
         lMmKnSn+z2PzVejOE1qiPUJkyixc9UUokDFoQMMRk4RQYEiaiRGr6opddpDf9Bs2q8a/
         coZ53+7RjBssr5cvfeCk4NdxJmqHrrOqkqbdngEb+XbrGLx4OufnZdxBY81AvZBlRiOj
         4rSQ==
X-Gm-Message-State: ACgBeo1E6RipOJ8bh34gFzMtLY2RES3dd4v0Wlr76D1eORZf1UKhmAag
        OZsnvA8se8ikl0nKo/Ypkd94CX93VCM=
X-Google-Smtp-Source: AA6agR7Vmy/9VKoH9TrCjdH42NGlsicP3jz0RhjsGy9i613mumeLqBUvRe3RbX9IdzDsuRykyS7o9w==
X-Received: by 2002:adf:fd46:0:b0:226:d31c:a249 with SMTP id h6-20020adffd46000000b00226d31ca249mr2930750wrs.429.1661690787400;
        Sun, 28 Aug 2022 05:46:27 -0700 (PDT)
Received: from amir-ThinkPad-T480.lan ([2a0d:6fc2:4b00:1500:ecf5:e90e:2ba2:1534])
        by smtp.gmail.com with ESMTPSA id k25-20020adfd239000000b0021e43b4edf0sm4443414wrh.20.2022.08.28.05.46.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Aug 2022 05:46:26 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     "Darrick J . Wong" <djwong@kernel.org>
Cc:     Leah Rumancik <leah.rumancik@gmail.com>,
        Chandan Babu R <chandan.babu@oracle.com>,
        linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: [PATCH 5.10 CANDIDATE 0/7] xfs stable candidate patches for 5.10.y (from v5.18+)
Date:   Sun, 28 Aug 2022 15:46:07 +0300
Message-Id: <20220828124614.2190592-1-amir73il@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Darrick,

This 5.10.y backport series contains fixes from v5.18 and v5.19 releases.

Patches 1-5 in this series have already been applied to 5.15.y in Leah's
latest update [1], so this 5.10.y is is mostly catching up with 5.15.y.

Patches 2-3 from the last 5.15.y update have not been picked for 5.10.y,
because they were not trivial to backport as the quota code is quite
different betrween 5.10.y and upstream.
This omission leave fstests generic/681,682 broken on 5.10.y.

Patches 6-7 in this 5.10.y update have not been applied to 5.15.y yet.
I pointed Leah's attention to these patches and she said she will
include them in a following 5.15.y update.

In particular, Darrick has pointed me at the fix in patch 6 a long time
ago, but I was waiting to apply fixes to 5.10.y in chronoligal order.

Please note that the upstream fix 6f5097e3367a ("xfs: fix xfs_ifree()
error handling to not leak perag ref") Which Fixes: 9a5280b312e2e
("xfs: reorder iunlink remove operation in xfs_ifree")
is not relevant for the 5.10.y backport.

These patches has gone through the usual 30 auto group runs x 5 configs
on kdevops.

Thanks,
Amir.


[1] https://lore.kernel.org/linux-xfs/20220819181431.4113819-1-leah.rumancik@gmail.com/

Amir Goldstein (1):
  xfs: remove infinite loop when reserving free block pool

Brian Foster (1):
  xfs: fix soft lockup via spinning in filestream ag selection loop

Darrick J. Wong (2):
  xfs: always succeed at setting the reserve pool size
  xfs: fix overfilling of reserve pool

Dave Chinner (2):
  xfs: reorder iunlink remove operation in xfs_ifree
  xfs: validate inode fork size against fork format

Eric Sandeen (1):
  xfs: revert "xfs: actually bump warning counts when we send warnings"

 fs/xfs/libxfs/xfs_inode_buf.c | 35 +++++++++++++++++------
 fs/xfs/xfs_filestream.c       |  7 +++--
 fs/xfs/xfs_fsops.c            | 52 ++++++++++++++---------------------
 fs/xfs/xfs_inode.c            | 22 ++++++++-------
 fs/xfs/xfs_mount.h            |  8 ++++++
 fs/xfs/xfs_trans_dquot.c      |  1 -
 6 files changed, 71 insertions(+), 54 deletions(-)

-- 
2.25.1

