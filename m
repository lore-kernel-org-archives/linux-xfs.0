Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC189C433EF
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jun 2022 12:34:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352914AbiFAMeX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 1 Jun 2022 08:34:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348177AbiFAMeW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 1 Jun 2022 08:34:22 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18A8F9BAC3;
        Wed,  1 Jun 2022 05:34:21 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id u3so2168519wrg.3;
        Wed, 01 Jun 2022 05:34:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=gISDPF1V5a3NWXBvppkjujgtPAJ0uyftRP2lWslVlMM=;
        b=pgQmxFsBdKekVsfAjDuzsYI56xDt4BcX++J86mHFsRBGzLuQkymEYCJUnv5KB18ijY
         R1KLQEF+OLHXLu8TfDVMk5F+m7IcyLtQVvjWdJnKn5//XzZFV0vp8lfBrdwgLb4/97rn
         dUYhZNUcnuwifBq4hZwmpNFiw6pp0x8s6M8QSzPrEbjIbz8S8ZY1rbeFM/XMni9yx8L/
         mSJc1Ag0PmR/ISpi/qg3a278moRE+zFRaAVtvt6FnqRw38rl/Ullp3EkTBuOEyLht1ct
         yHUTEbcCSzxkmBUpNUGECRu7duDC0BTD0gAARUIkUM2XO2n6MBzuTFQoApdN7F/QI9iN
         //zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=gISDPF1V5a3NWXBvppkjujgtPAJ0uyftRP2lWslVlMM=;
        b=l/M8j/10eAkI4jJV1fw+NJQ4iDISfIF9JEzj1gMjTXM6UpRqLEvhD1T7Teqimz8eRL
         7hbY3sTDfaFj5MXtQlulnTgiGCvrdWzjZYqdHSmiBwKeL2OJdSPVsguZh/G4nx0cBh7g
         gO02MgSWfkThLLIxQKyTkm5WEUfBfPcNL2JlwIPHYFHApQoLDZTDrOzJNakMAHoGCvXR
         9Kre3yxyTEJii0aI8GPSvEN8cn6AJm4ShYr6kBPGvio4nDoGU0hHmsDGIzcniyI2Y5dF
         v0Ex2UtBBrw5FRnxqxftVM3stFpyaq5iptaF0qInhsdHlFsAk9f+l7caiGg8G5dU8ThM
         bgDg==
X-Gm-Message-State: AOAM5300l/6yVSlnCgF25NeaFTmNyuh3z4899Ew5sbZOWYyIUlKfqQB+
        2tj+e95zHrM4nRdhwv9bEtc=
X-Google-Smtp-Source: ABdhPJzJeuKk57i0PH40YI4dQ97/YZc+yV7okvFt07Gr+P5/D8Q8eTFRBpUfx4iFuRyUb/ymp3vu1Q==
X-Received: by 2002:a05:6000:1b03:b0:210:3372:2bd9 with SMTP id f3-20020a0560001b0300b0021033722bd9mr13111196wrz.704.1654086859489;
        Wed, 01 Jun 2022 05:34:19 -0700 (PDT)
Received: from localhost.localdomain ([77.137.79.96])
        by smtp.gmail.com with ESMTPSA id i6-20020a05600c290600b00397470a8226sm1819887wmd.15.2022.06.01.05.34.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Jun 2022 05:34:19 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Zorro Lang <zlang@redhat.com>
Cc:     Brian Foster <bfoster@redhat.com>,
        Dave Chinner <david@fromorbit.com>, fstests@vger.kernel.org,
        linux-xfs@vger.kernel.org
Subject: [PATCH v2] generic/623: fix test for runing on overlayfs
Date:   Wed,  1 Jun 2022 15:34:06 +0300
Message-Id: <20220601123406.265475-1-amir73il@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

For this test to run on overlayfs we open a different file to perform
shutdown while keeping the writeback target file open.

xfs_io -c fsync perform fsync also on the writeback target file, which
is needed for triggering the write fault.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---

Zorro,

Following your comment on v1, this version does not change the
behavior of the test when running on non-overlayfs.

I tested that this test passes for both xfs and overlayfs+xfs on v5.18
and tested that both configs fail with the same warning on v5.10.109.

Thanks,
Amir.

 tests/generic/623 | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/tests/generic/623 b/tests/generic/623
index ea016d91..5971717c 100755
--- a/tests/generic/623
+++ b/tests/generic/623
@@ -24,10 +24,22 @@ _scratch_mount
 # XFS had a regression where it failed to check shutdown status in the fault
 # path. This produced an iomap warning because writeback failure clears Uptodate
 # status on the page.
+
+# For this test to run on overlayfs we open a different file to perform
+# shutdown while keeping the writeback target file open.
+# xfs_io -c fsync post-shutdown performs fsync also on the writeback target file,
+# which is critical for trigerring the writeback failure.
+shutdown_cmd=()
+shutdown_handle="$(_scratch_shutdown_handle)"
+if [ "$shutdown_handle" != "$SCRATCH_MNT" ];then
+	shutdown_cmd+=("-c" "open $shutdown_handle")
+fi
+shutdown_cmd+=("-c" "shutdown")
+
 file=$SCRATCH_MNT/file
 $XFS_IO_PROG -fc "pwrite 0 4k" -c fsync $file | _filter_xfs_io
 ulimit -c 0
-$XFS_IO_PROG -x -c "mmap 0 4k" -c "mwrite 0 4k" -c shutdown -c fsync \
+$XFS_IO_PROG -x -c "mmap 0 4k" -c "mwrite 0 4k" "${shutdown_cmd[@]}" -c fsync \
 	-c "mwrite 0 4k" $file | _filter_xfs_io
 
 # success, all done
-- 
2.25.1

