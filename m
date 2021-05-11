Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7CB17C433B4
	for <linux-xfs@archiver.kernel.org>; Tue, 11 May 2021 23:32:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 44DF36191D
	for <linux-xfs@archiver.kernel.org>; Tue, 11 May 2021 23:32:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229925AbhEKXeC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 11 May 2021 19:34:02 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:45594 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229714AbhEKXeC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 11 May 2021 19:34:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620775975;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8Q7ECzdN2wLaPzs1B7mX9Ae2MBtvdyw42LZi11howts=;
        b=dnnyjGM3FV5Sf9aIx2SgNP4oGW2XNwuMIT63tQwTpTazAhyRwQHnBL92IQ7xW14XzaBUFK
        vvuF33dHe5IwdXUbLpUzwAra18jIE6bzYYKNB9DMOvJS/57wIz+FGyNfIFhliTYgmC0c7j
        f/w0RwBu15XsQIfMXFGl9pNqxtgBjYc=
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com
 [209.85.215.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-290-s4J8kzC_NQ-oS5Fzok2OdA-1; Tue, 11 May 2021 19:32:53 -0400
X-MC-Unique: s4J8kzC_NQ-oS5Fzok2OdA-1
Received: by mail-pg1-f199.google.com with SMTP id m68-20020a6326470000b029020f37ad2901so13205843pgm.7
        for <linux-xfs@vger.kernel.org>; Tue, 11 May 2021 16:32:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8Q7ECzdN2wLaPzs1B7mX9Ae2MBtvdyw42LZi11howts=;
        b=Uw1qUINxbp1eIZ48l7rw/YTaobnqRFsBwS+MABvLLShY6wQ0Caom5LvzsHIxc4HO15
         HZTVMTjy/wxPNIjklGIjdMncmGxfRb77iiY1ghy8WZNPyx5j6n6ZTfFls9R453T04w0i
         RFRckJa+YheqodiCYcYrUMk2+2zLb17YgdK8ic9iJKXYiGJT3iy6udwfx5NKd+dMDjKb
         VT47WJF38x0G9elL7FJRdpiu4V9vigXDUVcJBV0kXdgmg3efimeKdzCK/aAuVpQAvCYI
         GFo9UB/lgxeivQxxEpofDJtj+7em8QO/OQqVRJ/hwOuFvufblaGvHva7GKA/ch25aJMc
         IjJQ==
X-Gm-Message-State: AOAM530XeQnME0bb3icx0NPXK33TWPFAbdXn+ywy1L1/naY00MYuX8Hk
        gdCcjRhpBa+NVciEFVVOXMDPNaboq+M9nvavJ5Zfltcy0I/CVpW2h/ftsQPMkPlCLazby+02ZXk
        6AId3t+aA5mpWBiF/9Wlx8Z+mm25ZLghSvWvJjoNCTLY5vjU2OrX9XCK0Wf/P0C/Yilgb12mLng
        ==
X-Received: by 2002:a17:903:10d:b029:ef:11d:ffd7 with SMTP id y13-20020a170903010db02900ef011dffd7mr28213093plc.53.1620775972272;
        Tue, 11 May 2021 16:32:52 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxymIThsAUMhDve9vfgbfy/XUrO/qJgAd/Z9DNb/aEixVZge8cWaaIU3ljBAJKTrAy3Pz++tQ==
X-Received: by 2002:a17:903:10d:b029:ef:11d:ffd7 with SMTP id y13-20020a170903010db02900ef011dffd7mr28213058plc.53.1620775971861;
        Tue, 11 May 2021 16:32:51 -0700 (PDT)
Received: from xiangao.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id s3sm15828393pgs.62.2021.05.11.16.32.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 May 2021 16:32:51 -0700 (PDT)
From:   Gao Xiang <hsiangkao@redhat.com>
To:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Cc:     "Darrick J. Wong" <djwong@kernel.org>,
        Zorro Lang <zlang@redhat.com>, Eryu Guan <guan@eryu.me>,
        Gao Xiang <hsiangkao@redhat.com>
Subject: [PATCH v6 1/3] common/xfs: add _require_xfs_scratch_shrink helper
Date:   Wed, 12 May 2021 07:32:26 +0800
Message-Id: <20210511233228.1018269-2-hsiangkao@redhat.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210511233228.1018269-1-hsiangkao@redhat.com>
References: <20210511233228.1018269-1-hsiangkao@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

In order to detect whether the current kernel supports XFS shrinking.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
---
 common/xfs | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/common/xfs b/common/xfs
index 69f76d6e..a0a4032a 100644
--- a/common/xfs
+++ b/common/xfs
@@ -766,6 +766,26 @@ _require_xfs_mkfs_without_validation()
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
+	errmsg=$($XFS_GROWFS_PROG -D$((dblocks-1)) "$SCRATCH_MNT" 2>&1)
+	if [ "$?" -ne 0 ]; then
+		echo "$errmsg" | grep 'XFS_IOC_FSGROWFSDATA xfsctl failed: Invalid argument' > /dev/null && \
+			_notrun "kernel does not support shrinking"
+		echo "$errmsg" | grep 'data size .* too small, old size is ' > /dev/null && \
+			_notrun "xfsprogs does not support shrinking"
+		_fail "$XFS_GROWFS_PROG failed unexpectedly: $errmsg"
+	fi
+	_scratch_unmount
+}
+
 # XFS ability to change UUIDs on V5/CRC filesystems
 #
 _require_meta_uuid()
-- 
2.27.0

