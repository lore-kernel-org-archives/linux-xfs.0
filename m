Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CACA6C64991
	for <linux-xfs@archiver.kernel.org>; Tue, 30 Aug 2022 04:44:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229524AbiH3Eo6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 30 Aug 2022 00:44:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229891AbiH3Eo4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 30 Aug 2022 00:44:56 -0400
Received: from mail-qv1-xf35.google.com (mail-qv1-xf35.google.com [IPv6:2607:f8b0:4864:20::f35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08A9DE011;
        Mon, 29 Aug 2022 21:44:54 -0700 (PDT)
Received: by mail-qv1-xf35.google.com with SMTP id y17so742390qvr.5;
        Mon, 29 Aug 2022 21:44:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=BqZ/Z2WxBmb5wQWY0SkfT7v+k1AC+Li/q+dh36HkGTQ=;
        b=YZoNg5gCY/ajAk8XRXNIzox5sOlJc8ngF1FUum0PPVB6L0iOBUnKgBxSmIZUXplVtz
         v0D7j6qpCpYiELMRu631kJ5KQpajSp3yNm5WUF1fbVZFU9EYaymwF4xNYNsW6whZL16b
         MELtQNq3CdglezI3Gs1YGKWToxsNdJlyPr/4DMNBryZOZB6Av1b3HdJ66UDzlu54MhfD
         mIbUda1zLrHLKzb/f9KhSyr5f0CNX6D0pL8jx4lySYW8qt+vclGN0y/o0C1IPAgC5lUn
         ZOo36q+Wdw9DpIuEM13LmKYMpFAvfPUPNIIS3u76PnxJDDwG+PM+bRUVOO9OpPIXKJrn
         NAsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=BqZ/Z2WxBmb5wQWY0SkfT7v+k1AC+Li/q+dh36HkGTQ=;
        b=LlHJoHgcSGsD91IRMV0hpe5Vf5/X3fTpNU+uumHtFakkjcwv1RnrPVp/Fc/2NHtHr2
         U54Y6zI5P22eqOdI4C8OvljhTNjq5PtiYhIF4Mmsrn4IyqMw80IdRb6Pu1kiYcB/lfiq
         NkwxOQaqkoKYjjiMIIyj3q64/rScCRbnRnyu8AOOE43RMpS4JWkexX9TwWSLECgGPwk6
         Bw7mrlXJasl3/PrcuCpKzLAjV6ClFGBpNs65SvnxgqLCtiJt8BYqdRRa7P0Wu5rVT8CK
         bbDnnnOAxBZfEV7VWZhwKXg+EgUg4PBwcRbwxdF3rNu9Cju4HWJKYsHbMTw+0EWCsYoP
         at7w==
X-Gm-Message-State: ACgBeo0ZQUW6X3gOlJSoBX/Wo5MbkIB5mFb1mAqAVFsVYTQ3HX7n54G6
        XJ0LPFulfgmTHM+Dgs1fO2UhIy8ALkc=
X-Google-Smtp-Source: AA6agR7k7gJGYTHYlNSeB1DQCOQ10X90ejhKUGuthAVSPV9GtUZv6uP6PupiYS3oyeOXMAl3phSQNQ==
X-Received: by 2002:ad4:5c4b:0:b0:498:f714:aac6 with SMTP id a11-20020ad45c4b000000b00498f714aac6mr11433149qva.48.1661834692848;
        Mon, 29 Aug 2022 21:44:52 -0700 (PDT)
Received: from xzhouw.hosts.qa.psi.rdu2.redhat.com ([66.187.232.127])
        by smtp.gmail.com with ESMTPSA id bj11-20020a05620a190b00b006b60d5a7205sm7478585qkb.51.2022.08.29.21.44.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Aug 2022 21:44:52 -0700 (PDT)
From:   Murphy Zhou <jencce.kernel@gmail.com>
To:     fstests@vger.kernel.org
Cc:     linux-xfs@vger.kernel.org
Subject: [PATCH v3 4/4] xfs/144: remove testing root dir inode in AG 1
Date:   Tue, 30 Aug 2022 12:44:33 +0800
Message-Id: <20220830044433.1719246-5-jencce.kernel@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220830044433.1719246-1-jencce.kernel@gmail.com>
References: <20220830044433.1719246-1-jencce.kernel@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Since this xfsprogs commit
  1b580a773 mkfs: don't let internal logs bump the root dir inode chunk to AG 1
this operation is not allowed.

Signed-off-by: Murphy Zhou <jencce.kernel@gmail.com>
---
 tests/xfs/144 | 10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

diff --git a/tests/xfs/144 b/tests/xfs/144
index 706aff61..3f80d0ee 100755
--- a/tests/xfs/144
+++ b/tests/xfs/144
@@ -17,9 +17,6 @@ _begin_fstest auto mkfs
 _supported_fs xfs
 _require_test
 
-# The last testcase creates a (sparse) fs image with a 2GB log, so we need
-# 3GB to avoid failing the mkfs due to ENOSPC.
-_require_fs_space $TEST_DIR $((3 * 1048576))
 echo Silence is golden
 
 testfile=$TEST_DIR/a
@@ -36,7 +33,7 @@ test_format() {
 }
 
 # First we try various small filesystems and stripe sizes.
-for M in `seq 298 302` `seq 490 520`; do
+for M in `seq 1024 1030` ; do
 	for S in `seq 32 4 64`; do
 		test_format "M=$M S=$S" -dsu=${S}k,sw=1,size=${M}m -N
 	done
@@ -45,11 +42,6 @@ done
 # log end rounded beyond EOAG due to stripe unit
 test_format "log end beyond eoag" -d agcount=3200,size=6366g -d su=256k,sw=4 -N
 
-# Log so large it pushes the root dir into AG 1.  We can't use -N for the mkfs
-# because this check only occurs after the root directory has been allocated,
-# which mkfs -N doesn't do.
-test_format "log pushes rootdir into AG 1" -d agcount=3200,size=6366g -lagnum=0
-
 # success, all done
 status=0
 exit
-- 
2.31.1

