Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24A4DC43460
	for <linux-xfs@archiver.kernel.org>; Tue, 11 May 2021 07:40:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EE83461360
	for <linux-xfs@archiver.kernel.org>; Tue, 11 May 2021 07:40:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230373AbhEKHl0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 11 May 2021 03:41:26 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:59803 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229917AbhEKHl0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 11 May 2021 03:41:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620718819;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=h3Ws3HwNieNbVwNAbp6WqD38GgvpcC5ZmxDWRT71MXI=;
        b=XrBjNr6Xb30Liz9FTuUvCJz429UgBhggdo+0NuJE2T2oakHtNR/wa4EaAM8F56M09xVU/Z
        MFvLPcXqsd6qvPAoCwk81aufVp5vpKS23I2o0ygeW5fVcrWwB1XumoJODPHLDdIVohAhGu
        CJnMZKrMcrdAy0MgpP27RZjJidNsIeU=
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com
 [209.85.210.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-564-KGy5M98OM9ODaOEO8FV3kA-1; Tue, 11 May 2021 03:40:18 -0400
X-MC-Unique: KGy5M98OM9ODaOEO8FV3kA-1
Received: by mail-pf1-f199.google.com with SMTP id a8-20020a62d4080000b029028db7db58adso12374689pfh.22
        for <linux-xfs@vger.kernel.org>; Tue, 11 May 2021 00:40:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=h3Ws3HwNieNbVwNAbp6WqD38GgvpcC5ZmxDWRT71MXI=;
        b=J/XKInLZn0Xwy/K5097QiDO1IAUej1FHJtNVxh12FaqcR9v4Vf5WEMyn5OFc4/N7LM
         o7RpoMSp0+MrUs5p9v5hZKNmfWAolG2/ByIRMPMF/9lHAZ4vRXaqYsVmvLgkGNZH/cwF
         xTxUAtBQR1k70Q8lKo78taGvlfW3kjseTIeGE05KIFI7jLFPvMTW3cxmLl10fYxGMhAG
         KUxXRcfL91XQOggKfIRcAV1vBEIZlqyvXKx/ukl3SEw2cb+6gwfth/zJhK39kD1CBVGw
         /IGfcb819xlZnLC889lLjqdnL/VIkA2dkcsOOwu44efMVw0Igt7jkponYuyL3V6Ns59t
         Y7MA==
X-Gm-Message-State: AOAM5335G5E544cADfKOdYd/s5+c5JjTHaEfkYOfSBRDxLwD1jubYqOy
        S/Od2jnjnrSPsCsAwrK/JW1b1oNZKW8R+PpCVCkOV6AWaMSCi1zUzCLGrh6iHG28ZENyIsySH1W
        FIQv6D/ACfcMbeKfHLlHVCj+B1FWl6ShFLR0orwlfLqG7m87//bb61jHWNhjsAdE5Nrd825BOsg
        ==
X-Received: by 2002:a17:902:9001:b029:ee:f24a:7e7d with SMTP id a1-20020a1709029001b02900eef24a7e7dmr28849709plp.42.1620718817048;
        Tue, 11 May 2021 00:40:17 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxWHW0M0iDIbPVIfxeg9V2L36NlypuHICYtUOzTonpHwTusV3vf6o2HeNXbuSB5LF/4oYefug==
X-Received: by 2002:a17:902:9001:b029:ee:f24a:7e7d with SMTP id a1-20020a1709029001b02900eef24a7e7dmr28849685plp.42.1620718816748;
        Tue, 11 May 2021 00:40:16 -0700 (PDT)
Received: from xiangao.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id y3sm10820865pfl.153.2021.05.11.00.40.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 May 2021 00:40:16 -0700 (PDT)
From:   Gao Xiang <hsiangkao@redhat.com>
To:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Cc:     "Darrick J. Wong" <djwong@kernel.org>,
        Zorro Lang <zlang@redhat.com>, Eryu Guan <guan@eryu.me>,
        Gao Xiang <hsiangkao@redhat.com>
Subject: [PATCH v5 1/3] common/xfs: add _require_xfs_scratch_shrink helper
Date:   Tue, 11 May 2021 15:39:43 +0800
Message-Id: <20210511073945.906127-2-hsiangkao@redhat.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210511073945.906127-1-hsiangkao@redhat.com>
References: <20210511073945.906127-1-hsiangkao@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

In order to detect whether the current kernel supports XFS shrinking.

Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
---
 common/xfs | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/common/xfs b/common/xfs
index 69f76d6e..184aa01e 100644
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
+		echo "$errmsg" | grep 'XFS_IOC_FSGROWFSDATA xfsctl failed: Invalid argument' && \
+			_notrun "kernel does not support shrinking"
+		echo "$errmsg" | grep 'data size .* too small, old size is ' && \
+			_notrun "xfsprogs does not support shrinking"
+		_fail "$XFS_GROWFS_PROG failed unexpectedly"
+	fi
+	_scratch_unmount
+}
+
 # XFS ability to change UUIDs on V5/CRC filesystems
 #
 _require_meta_uuid()
-- 
2.27.0

