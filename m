Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1DBDC433B4
	for <linux-xfs@archiver.kernel.org>; Fri,  2 Apr 2021 09:50:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 756EE6113C
	for <linux-xfs@archiver.kernel.org>; Fri,  2 Apr 2021 09:50:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234316AbhDBJut (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 2 Apr 2021 05:50:49 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:56987 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234207AbhDBJus (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 2 Apr 2021 05:50:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617357041;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GHNLrzKRlSUzRpqRt/9jxpQOdhK2KzUvPJCm1diBE/o=;
        b=TV93pfLJ0RUug+Mm+QyT67PqXtunLDA8kFu2uKd1CeIREhr8g09ceS7B2RL4E08D00O0/E
        AIAsRrk3lFNB3mvhFUG5oRkrVfZKRTyTd670TDPzG00qRcQjyewAsUzLKFCZJa/cfWVYtP
        KxzEd1RkPvbCRr+q7JblLsBqzKhyxZ8=
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com
 [209.85.210.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-553-iKpt25RkOCmdKa_Eqm0vew-1; Fri, 02 Apr 2021 05:50:40 -0400
X-MC-Unique: iKpt25RkOCmdKa_Eqm0vew-1
Received: by mail-pf1-f198.google.com with SMTP id b21so5057598pfo.0
        for <linux-xfs@vger.kernel.org>; Fri, 02 Apr 2021 02:50:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=GHNLrzKRlSUzRpqRt/9jxpQOdhK2KzUvPJCm1diBE/o=;
        b=O++Ix6gesBdJiLv3Jqsx9Wqr5XElz9hu/irYXXbJS/SpQf1hDZdnAzdduhTn20LMuJ
         eeRBxdU9QOqhRXOhfsCOd6Ul4UouqHl1uW9xhQ3U7XbcL0qCECcLYhB8gFUXIUwHvOQj
         cKBY7dUE50t9+5YqMti6JeMZRVJM1nrnx7IgGs+8rVMqSXHxBbjkebLIhbP559TGX5Oe
         kpbuwr5tD43Ew3JGKKr6vfxS+7hnizNbxS+2E9QoqrkWfcCxAizDDWjSijvlkD4oj+Z1
         IrTxwNFg3i9I5/kj2rfnokYQQZmyJhTaO57f2gHWNWIQ1fPPeA1KrpQXr1LjQwQXstMI
         h51g==
X-Gm-Message-State: AOAM532yGxl/kHRjvk+Esk51r502/IngMrfHuyhUbP7IUPaE7Z2TwhOb
        c5Kwr/QMV8l4AMNdT/79uUDZOgQ34g3ZJmtZC4iUhadNSKYHC3XAcubHfof73W6OMzDB2qa9CHX
        QsazTY2hy4pUCFS5fiIv8vhOuM25ls/dY7RV9FXCg3Ape4dt76Ap223oJIauEp/EdBPJSQtw1fQ
        ==
X-Received: by 2002:a17:902:8482:b029:e6:325b:5542 with SMTP id c2-20020a1709028482b02900e6325b5542mr11952716plo.70.1617357039338;
        Fri, 02 Apr 2021 02:50:39 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw8z+lf3yRPeiUgxRxSBJvTMyqXeOwIomuiph+/z3mpW/hdBxgNNgipsUyauSYEwH62GEV8vg==
X-Received: by 2002:a17:902:8482:b029:e6:325b:5542 with SMTP id c2-20020a1709028482b02900e6325b5542mr11952700plo.70.1617357039081;
        Fri, 02 Apr 2021 02:50:39 -0700 (PDT)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id l124sm7730354pfl.195.2021.04.02.02.50.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Apr 2021 02:50:38 -0700 (PDT)
From:   Gao Xiang <hsiangkao@redhat.com>
To:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Cc:     "Darrick J. Wong" <djwong@kernel.org>,
        Zorro Lang <zlang@redhat.com>, Eryu Guan <guan@eryu.me>,
        Gao Xiang <hsiangkao@redhat.com>
Subject: [PATCH v4 1/3] common/xfs: add _require_xfs_scratch_shrink helper
Date:   Fri,  2 Apr 2021 17:49:35 +0800
Message-Id: <20210402094937.4072606-2-hsiangkao@redhat.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210402094937.4072606-1-hsiangkao@redhat.com>
References: <20210402094937.4072606-1-hsiangkao@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

In order to detect whether the current kernel supports XFS shrinking.

Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
---
 common/xfs | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/common/xfs b/common/xfs
index 69f76d6e..c6c2e3f5 100644
--- a/common/xfs
+++ b/common/xfs
@@ -766,6 +766,20 @@ _require_xfs_mkfs_without_validation()
 	fi
 }
 
+_require_xfs_scratch_shrink()
+{
+	_require_scratch
+	_require_command "$XFS_GROWFS_PROG" xfs_growfs
+
+	_scratch_mkfs_xfs | _filter_mkfs 2>$tmp.mkfs >/dev/null
+	. $tmp.mkfs
+	_scratch_mount
+	# here just to check if kernel supports, no need do more extra work
+	$XFS_GROWFS_PROG -D$((dblocks-1)) "$SCRATCH_MNT" > /dev/null 2>&1 || \
+		_notrun "kernel does not support shrinking"
+	_scratch_unmount
+}
+
 # XFS ability to change UUIDs on V5/CRC filesystems
 #
 _require_meta_uuid()
-- 
2.27.0

