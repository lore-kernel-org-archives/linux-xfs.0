Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82E0BC433DB
	for <linux-xfs@archiver.kernel.org>; Mon, 15 Mar 2021 11:21:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3130164DDF
	for <linux-xfs@archiver.kernel.org>; Mon, 15 Mar 2021 11:21:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229873AbhCOLU1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 15 Mar 2021 07:20:27 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:39118 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229754AbhCOLUD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 15 Mar 2021 07:20:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615807203;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=HRKBuXKFN76Zoc96hpFCwct6Yly+2MT4dfP/gKbydUI=;
        b=iFZm/FQKUHd/Gt82hjGAnkpaMCQXxv/S4aW1HNN9zeTEQqtrnmmvu68LXsisMlN/2d1e5a
        n9fD+5tz2YqzMxrHYqK+iBW3sy/L1qnPvU/rB3/YE2OXin6USQXiXCs7lNmOzvbvZaTy7e
        lIpmBDjTAXW5HmKPkvP0ou/CLJ+7Rnc=
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com
 [209.85.215.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-40-EMnNQKXXMeWAn1oCrI2n2Q-1; Mon, 15 Mar 2021 07:20:01 -0400
X-MC-Unique: EMnNQKXXMeWAn1oCrI2n2Q-1
Received: by mail-pg1-f197.google.com with SMTP id j4so16899191pgs.18
        for <linux-xfs@vger.kernel.org>; Mon, 15 Mar 2021 04:20:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=HRKBuXKFN76Zoc96hpFCwct6Yly+2MT4dfP/gKbydUI=;
        b=ZZHOwyyZoStgGYdkVDId2yUkvYMPPz4MuUT/8iNTBmNj+6MlpH9Li/CfMlX0NnuidU
         42BgddTY5rsav8W4Qz8MYQLAHjL1w+jcMO0y8pNJeIqxPMGbkjSpPqvTraQTxJhvaS8j
         QC8gmNxG8vBxXjhmroFFbM+zFq2e8fPSYoKrIoHXPBVAooFdygQy2RLDwnpD2aGNeDD7
         s9EqkTdyBJAFum9KAWDODC23Uht+ook/zJIq/jUx15by8caJ0cKB5Ou2hqgCx2fnNqWD
         rgszZHrdd3ZftNBcGhcJuDXfT3z6Nw+adtxRSPaY9IoFyHZgtOUHZRnVRQvVXb8sMuzf
         3jSg==
X-Gm-Message-State: AOAM530ITmm0n6oJlArNWYIRTlX1qKBOMTIL5hx3tOUBKkSXjXfyPc8+
        HZnSW1jmb7nauiuXzMSFq3y0Zuh0UqP70ySn2/cqZXYd1xltpC2oLg4ZCAZJ98zcT4JB3n0beVD
        HgBC/Ae5hU1tDWiKo6QrvC5SP6JmQ7GQcuo2yhuojYufJn2orcHTsccEnvBZgkGzdkZIEtlheuA
        ==
X-Received: by 2002:a62:7d14:0:b029:1f6:18a1:6b98 with SMTP id y20-20020a627d140000b02901f618a16b98mr9933844pfc.15.1615807200089;
        Mon, 15 Mar 2021 04:20:00 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzJT7knaAeoW4gfZT7OeOw6acMAkh8kZnjJYd8L8xyqAG/9mfx46gsu+ys2AG1A86SSVXgEaw==
X-Received: by 2002:a62:7d14:0:b029:1f6:18a1:6b98 with SMTP id y20-20020a627d140000b02901f618a16b98mr9933809pfc.15.1615807199701;
        Mon, 15 Mar 2021 04:19:59 -0700 (PDT)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id r23sm11058448pje.38.2021.03.15.04.19.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Mar 2021 04:19:59 -0700 (PDT)
From:   Gao Xiang <hsiangkao@redhat.com>
To:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Cc:     "Darrick J. Wong" <djwong@kernel.org>,
        Zorro Lang <zlang@redhat.com>, Gao Xiang <hsiangkao@redhat.com>
Subject: [RFC PATCH v3 0/3] xfs: testcases for shrinking free space in the last AG
Date:   Mon, 15 Mar 2021 19:19:23 +0800
Message-Id: <20210315111926.837170-1-hsiangkao@redhat.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi,

This version matches
kernel v8: https://lore.kernel.org/r/20210305025703.3069469-1-hsiangkao@redhat.com
xfsprogs RFC: https://lore.kernel.org/r/20201028114010.545331-1-hsiangkao@redhat.com

and mainly addresses comments for the previous version.

Thanks,
Gao Xinag

changes since RFC v2:
 - [1/3] add _require_scratch to _require_xfs_shrink() (Zorro);
 - [1/3] drop unneeded _scratch_unmount (Zorro);
 - [2/3] add _repair_scratch_fs for each test (Zorro);
 - [2/3] check new size after shrinking (Zorro);
 - [2/3] drop unneeded _scratch_unmount (Zorro);
 - [3/3] update group as "auto growfs ioctl prealloc stress" to follow xfs/104 (Zorro);
 - [3/3] use generic falloc instead of resvsp (Darrick).

Gao Xiang:
  common/xfs: add a _require_xfs_shrink helper
  xfs: basic functionality test for shrinking free space in the last AG
  xfs: stress test for shrinking free space in the last AG

 common/xfs        |  11 +++++
 tests/xfs/990     |  70 ++++++++++++++++++++++++++
 tests/xfs/990.out |  12 +++++
 tests/xfs/991     | 122 ++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/991.out |   8 +++
 tests/xfs/group   |   2 +
 6 files changed, 225 insertions(+)
 create mode 100755 tests/xfs/990
 create mode 100644 tests/xfs/990.out
 create mode 100755 tests/xfs/991
 create mode 100644 tests/xfs/991.out

-- 
2.27.0

