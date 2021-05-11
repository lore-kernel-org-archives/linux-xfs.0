Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 614AAC433B4
	for <linux-xfs@archiver.kernel.org>; Tue, 11 May 2021 07:40:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2F73761926
	for <linux-xfs@archiver.kernel.org>; Tue, 11 May 2021 07:40:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230285AbhEKHlQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 11 May 2021 03:41:16 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:34619 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230305AbhEKHlP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 11 May 2021 03:41:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620718809;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=ZXNk4UD8OF1oBZnt5Z+7zrrv4N8KpySOEMngJz/TGw4=;
        b=XmvloFl0EdJn7kB9/bF7dPe+4DfImW4+6pDnnfxslczK+N83kQixW/+KRH2VGsyaj1G03I
        ohiq93KemPFNByC45UnFx8imTZbokpu6nIK8R4ArCMSdWYK//0qSr3g3T1RTTFOCtTxAv9
        Qbv70OOCKHpO328PTT4u6DYyF1jnk6o=
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com
 [209.85.215.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-199-mXoYlUKCNXCrrnCp5A6suQ-1; Tue, 11 May 2021 03:40:07 -0400
X-MC-Unique: mXoYlUKCNXCrrnCp5A6suQ-1
Received: by mail-pg1-f198.google.com with SMTP id d64-20020a6368430000b02902104a07607cso11848152pgc.1
        for <linux-xfs@vger.kernel.org>; Tue, 11 May 2021 00:40:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ZXNk4UD8OF1oBZnt5Z+7zrrv4N8KpySOEMngJz/TGw4=;
        b=eaW/z8H34G/bZkro0B6nDIePNuEj71WfqyvSWTOLKNPL/Z8Ujv1v3LrgwrdvdZP9bt
         p7WAUZOTI6F5wkmR23gITT4rJcu7kh62HoEGnOQcFpECt4mjO4SRRnHT4fMk+k5PO6qH
         ram/RbhJdU1mR7mwY54rM7jjzHVIDn/MEvhn5P8fCKcfWrm3Ldw0f5XEC6klXKJPMUVT
         +w7h3F1Eg9HrlGT2FFwDcrNF8JK1IdANALGX82YadyklDUuVkSF17NPz2m1d+OFsi6n9
         lU+afutPsPmRhreYLTgCRGaeWl1xa/a389+8fwqwsG1JJe5DTNcv0vnmLpZtMrTUFTjz
         WLcA==
X-Gm-Message-State: AOAM530SRkckxEILcSsFUE493hQWqZ5416sxATEpvjysDZ/xyv67jPRh
        DBZPsIQsiToNsXmXkTGWXRswMw+vhse6aZQ0TwFeqUVvjRsgJWGFE/6yekAX+92d2MHkuVnom4H
        s5v7ozVN8Frey5xc+64hnfMfYYiXA7u9xWlrvvs4DmGiXNMPbL7tz+pi8oQCETRhZDVsB3B9o8g
        ==
X-Received: by 2002:a63:ae01:: with SMTP id q1mr4609646pgf.216.1620718806413;
        Tue, 11 May 2021 00:40:06 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw2Txv5EO0XfxBz9bGiXrmrJ6QRMZ3B+YrxMhgItmHjB91y6WDxZmhu3rQRwQ7bP9xR+SjQ8Q==
X-Received: by 2002:a63:ae01:: with SMTP id q1mr4609605pgf.216.1620718805997;
        Tue, 11 May 2021 00:40:05 -0700 (PDT)
Received: from xiangao.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id y3sm10820865pfl.153.2021.05.11.00.40.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 May 2021 00:40:05 -0700 (PDT)
From:   Gao Xiang <hsiangkao@redhat.com>
To:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Cc:     "Darrick J. Wong" <djwong@kernel.org>,
        Zorro Lang <zlang@redhat.com>, Eryu Guan <guan@eryu.me>,
        Gao Xiang <hsiangkao@redhat.com>
Subject: [PATCH v5 0/3] xfs: testcases for shrinking free space in the last AG
Date:   Tue, 11 May 2021 15:39:42 +0800
Message-Id: <20210511073945.906127-1-hsiangkao@redhat.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi,

This adds testcases for shrinking free space in the last AG in the upstream.
This version mainly addresses Darrick's previous comments.
(and I've checked with "512m logdev with USE_EXTERNAL and SCRATCH_LOGDEV
 without issues)

changes since v4 (Darrick):
 - [1/3] check xfs_growfs output instead;
 - [2/3] fix a typo;
 - [2/3] echo statements rather than fail out;
 - [3/3] avoid unncessary scale due to _scale_fsstress_args;
 - [3/3] inject a bit randomness to decsize;
 - [3/3] use '_scratch_xfs_repair -n' instead.

Thanks,
Gao Xiang

Gao Xiang (3):
  common/xfs: add _require_xfs_scratch_shrink helper
  xfs: basic functionality test for shrinking free space in the last AG
  xfs: stress test for shrinking free space in the last AG

 common/xfs        |  20 ++++++++
 tests/xfs/990     |  73 ++++++++++++++++++++++++++++
 tests/xfs/990.out |  12 +++++
 tests/xfs/991     | 120 ++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/991.out |   8 ++++
 tests/xfs/group   |   2 +
 6 files changed, 235 insertions(+)
 create mode 100755 tests/xfs/990
 create mode 100644 tests/xfs/990.out
 create mode 100755 tests/xfs/991
 create mode 100644 tests/xfs/991.out

-- 
2.27.0

