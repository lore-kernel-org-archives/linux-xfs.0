Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10F95C433B4
	for <linux-xfs@archiver.kernel.org>; Fri,  2 Apr 2021 09:50:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DA2BD610D2
	for <linux-xfs@archiver.kernel.org>; Fri,  2 Apr 2021 09:50:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229722AbhDBJu1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 2 Apr 2021 05:50:27 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:21671 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234316AbhDBJu0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 2 Apr 2021 05:50:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617357025;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=W1gnDuSWtaItBPYK/lYoBQiOnroFW6TW5F5S78ArK8U=;
        b=g2I1PJiUDv5LE9ACVL3+IrMXmg9wtbdFfw+ILB72+dGNoCLHBfkmBin/51FHw496fdrT2Y
        dtXds81p2A6q3mnICV1dWDmBG53HR5/4p2CooWXTfzK6IPzHD2DigIDmxBwqdz7+pN2uUa
        g6L2waafhGFWRSTpElxjYB+zU68EYg0=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-470-GofCeDtlM22uPeQOPhPXZQ-1; Fri, 02 Apr 2021 05:50:23 -0400
X-MC-Unique: GofCeDtlM22uPeQOPhPXZQ-1
Received: by mail-pj1-f69.google.com with SMTP id mp5so1261102pjb.4
        for <linux-xfs@vger.kernel.org>; Fri, 02 Apr 2021 02:50:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=W1gnDuSWtaItBPYK/lYoBQiOnroFW6TW5F5S78ArK8U=;
        b=UllJy/+1+UMhw+1WFXH0NT6M614Yq6pufo1G5ORyKbvB97Qs/3yCcOlAPaePxlmkv8
         W1VseLeHHfsagU5iME0RxpwX9ecdoRa2v/re+tPYkhgVYCg10bwnHWDysc9Kaxj2V/Tq
         wKCSEx8L7cVU5PCdQ2BicFEnIv/HF/JGG7G8oJs2J6K1Et8mhbEg1SoK4JH1zQwLxF+5
         eJ1xzbm2hQqumQmyZkIWH7VFGNVKGx7cbiN8+UMLVa81xFgQd7e/tett9dw/BeEIDwuX
         nl7IoZI9hsODU3ATFuu9qk4XdlxJjvglub+RsUWIwCdohXMUUyQ9XFp7klA52Yk105Vu
         q/QQ==
X-Gm-Message-State: AOAM5300R4KbyI921efUP+2XMSQXvbZwuu6Da3TGRI32uYx5o4KF6zPJ
        lngdGQ1KaSsoHcK3w2mUu/VZCAibLTtoSPtBNY9CthDPqYUjpuuOijc/21BCHytBslvQCROoylB
        BQdSci2demkhMOlQWk7ZyqW9orXr3WtxYJilU+6TG2uz23mU3mhH83tjRlrqF43Ek+K/SNxFuKQ
        ==
X-Received: by 2002:a17:902:ecce:b029:e8:b810:1c1a with SMTP id a14-20020a170902ecceb02900e8b8101c1amr3335942plh.51.1617357022387;
        Fri, 02 Apr 2021 02:50:22 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxx138pKliGCP9LFrOBYEeLMUe0eWTEV5gUB9oTvtFKoaDyTOZdEwr+s/xtlnqoDD7xZV5KRg==
X-Received: by 2002:a17:902:ecce:b029:e8:b810:1c1a with SMTP id a14-20020a170902ecceb02900e8b8101c1amr3335924plh.51.1617357022057;
        Fri, 02 Apr 2021 02:50:22 -0700 (PDT)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id l124sm7730354pfl.195.2021.04.02.02.50.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Apr 2021 02:50:21 -0700 (PDT)
From:   Gao Xiang <hsiangkao@redhat.com>
To:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Cc:     "Darrick J. Wong" <djwong@kernel.org>,
        Zorro Lang <zlang@redhat.com>, Eryu Guan <guan@eryu.me>,
        Gao Xiang <hsiangkao@redhat.com>
Subject: [PATCH v4 0/3] xfs: testcases for shrinking free space in the last AG
Date:   Fri,  2 Apr 2021 17:49:34 +0800
Message-Id: <20210402094937.4072606-1-hsiangkao@redhat.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi,

Sorry for little delay (yet since xfsprogs side isn't merged, and no
major changes compared with the previous version...)

This version matches
kernel: for-next
xfsprogs: https://lore.kernel.org/r/20210326024631.12921-1-hsiangkao@aol.com

and mainly addresses comments for the previous version (but note I don't
tend to dump shrink information but rather confirm the final state runtimely,
since blocksize needs to be fixed and output could change by time, so just
need to confirm xfs_repair can pass and final dblocks is what we want.)

Thanks,
Gao Xinag

changes since RFC v3 (Eryu):
 - [1/3] rename to _require_xfs_scratch_shrink;
 - [1/3] add growfs command check;
 - [1/3] try to shrink 1 dblock to check kernel support instead;
 - [2/3] use _check_scratch_fs instead;
 - [2/3] add comment on why agcount=3;
 - [2/3] add shrinkfs group;
 - [3/3] use _scratch_mount;
 - [3/3] Declare variables in stress_scratch() as local;
 - [3/3] run stress_scratch() in background;

Gao Xiang (3):
  common/xfs: add _require_xfs_scratch_shrink helper
  xfs: basic functionality test for shrinking free space in the last AG
  xfs: stress test for shrinking free space in the last AG

 common/xfs        |  14 ++++++
 tests/xfs/990     |  73 ++++++++++++++++++++++++++++
 tests/xfs/990.out |  12 +++++
 tests/xfs/991     | 118 ++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/991.out |   8 ++++
 tests/xfs/group   |   2 +
 6 files changed, 227 insertions(+)
 create mode 100755 tests/xfs/990
 create mode 100644 tests/xfs/990.out
 create mode 100755 tests/xfs/991
 create mode 100644 tests/xfs/991.out

-- 
2.27.0

