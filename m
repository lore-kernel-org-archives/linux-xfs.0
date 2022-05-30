Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27E73C433EF
	for <linux-xfs@archiver.kernel.org>; Mon, 30 May 2022 11:29:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235358AbiE3L3N (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 30 May 2022 07:29:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235735AbiE3L3M (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 30 May 2022 07:29:12 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31F68562C1;
        Mon, 30 May 2022 04:29:11 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id k19so6055348wrd.8;
        Mon, 30 May 2022 04:29:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=VJHxOjT3k3dHpSQMqJmJA15RIZab6xALDLo9z7xNOkU=;
        b=N70yKKgDttqyfeUT2A8CHSeOhth2/ltR5tlOT0EysOnFWb9ZDNzP/k+T5sOxV99j4J
         rLVg+7vqSFhAKNlMFLlG/3NfpyHcuahn6Mw0+YVcRcebXkJqJfKoxD4LfFG88HFWEd3b
         /AX9WloEjDLUs72MnMO2p7p74/aE2UyOtNDQvc8Y6nzfCk7Psn9SmxSyhXXvnPkM92+x
         lPvvZCXEcIL8U/oXmJH6puygP1lOFqw2Z9f92QOTaxlyQ5vhUOte6EtayTGQp+KKpjqB
         zmfn/RLgNgqJIVCNf33WUqCYpUuTycaIiDLi2ftr+l5iKAFUyrENa9JfaQfYi/aXMB8l
         2APQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=VJHxOjT3k3dHpSQMqJmJA15RIZab6xALDLo9z7xNOkU=;
        b=wNBZVfGNddlJvGFn6ggbbMH3wYXT9eYGba86wfsa6g9r6mGacZM5wU9HF9tJNxyhn8
         MNtqakF2ZJKNSdRr9K3iiR/+NG2HZ//Y2kTfTbqaoCFyXEjf22entv3tNLaGpCxm0mYM
         7JmXlIdmSqbx2kpUBg+XPHLlApF5etGJeamQvPD3UMnv+1MbY2Xg7GjACIMVf5zUFXaX
         Hy0NOxItExDDhvsDjBHRTmzWfSUJbP2zL07mmM83M5LUCobjZyNSkhYsgI55Ptx8Zw8+
         q301riAL+OrcEweN4HzbPn576TI/Y98dJw17zXowPH17xq0BV97nujKE7CQD7e+zhDl/
         eteg==
X-Gm-Message-State: AOAM5320ni9USqmVOERDV7lTVKPDWg34pZ+5T6UwVQxu6RR4eeN2UxVB
        GEjDelGdGE+Pmo3fcEuSsyL6afBuCMKkHw==
X-Google-Smtp-Source: ABdhPJxyVCQzv5j8p5Ibk4D9PFA1utpIIQyxRZ+etMXcRl7wHsuDNUdgsoZO/qhJnvX/LGoSGv7quQ==
X-Received: by 2002:a05:6000:34f:b0:210:33ec:fd69 with SMTP id e15-20020a056000034f00b0021033ecfd69mr3987584wre.184.1653910149600;
        Mon, 30 May 2022 04:29:09 -0700 (PDT)
Received: from amir-ThinkPad-T480.ctera.local (bzq-166-168-31-246.red.bezeqint.net. [31.168.166.246])
        by smtp.gmail.com with ESMTPSA id c26-20020a05600c0ada00b0039750c39fc5sm20929930wmr.3.2022.05.30.04.29.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 May 2022 04:29:09 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Zorro Lang <zlang@redhat.com>
Cc:     Brian Foster <bfoster@redhat.com>, fstests@vger.kernel.org,
        linux-xfs@vger.kernel.org
Subject: [PATCH] generic/623: fix test for runing on overlayfs
Date:   Mon, 30 May 2022 14:29:05 +0300
Message-Id: <20220530112905.79602-1-amir73il@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

For this test to run on overlayfs we open a different file to perform
shutdown+fsync while keeping the writeback target file open.

We should probably perform fsync on the writeback target file, but
the bug is reproduced on xfs and overlayfs+xfs also as is.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---

Zorro,

I tested that this test passes for both xfs and overlayfs+xfs on v5.18
and tested that both configs fail with the same warning on v5.10.109.

I tried changing fsync to syncfs for the test to be more correct in the
overlayfs case, but then golden output of xfs and overlayfs+xfs differ
and that would need some more output filtering (or disregarding output
completely).

Since this minimal change does the job and does not change test behavior
on xfs on any of the tested kernels, I thought it might be good enough.

Thanks,
Amir.

 tests/generic/623 | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/tests/generic/623 b/tests/generic/623
index ea016d91..bb36ad25 100755
--- a/tests/generic/623
+++ b/tests/generic/623
@@ -24,10 +24,13 @@ _scratch_mount
 # XFS had a regression where it failed to check shutdown status in the fault
 # path. This produced an iomap warning because writeback failure clears Uptodate
 # status on the page.
+# For this test to run on overlayfs we open a different file to perform
+# shutdown+fsync while keeping the writeback target file open.
 file=$SCRATCH_MNT/file
 $XFS_IO_PROG -fc "pwrite 0 4k" -c fsync $file | _filter_xfs_io
 ulimit -c 0
-$XFS_IO_PROG -x -c "mmap 0 4k" -c "mwrite 0 4k" -c shutdown -c fsync \
+$XFS_IO_PROG -x -c "mmap 0 4k" -c "mwrite 0 4k" \
+	-c "open $(_scratch_shutdown_handle)" -c shutdown -c fsync \
 	-c "mwrite 0 4k" $file | _filter_xfs_io
 
 # success, all done
-- 
2.25.1

