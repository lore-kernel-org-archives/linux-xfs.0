Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 882C3CCA483
	for <linux-xfs@archiver.kernel.org>; Tue, 28 Jun 2022 20:25:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232849AbiF1UZB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 28 Jun 2022 16:25:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229521AbiF1UYX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 28 Jun 2022 16:24:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2AB3280;
        Tue, 28 Jun 2022 13:21:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5EDC661709;
        Tue, 28 Jun 2022 20:21:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAEBFC3411D;
        Tue, 28 Jun 2022 20:21:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656447711;
        bh=l3he3Ym32oYQYPvckfK/RcZZHkq03B/5/Pb58aucCps=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=fWw+6xmpZwTypXg3ev7lUcujEhjUwZ3+Ha0mG8yxcxx6uDbkFuoA8Z2Ah1kkID6vF
         4YrgZI9H3x5tgH8x2rjQ+F0zwlkozY0TaYiD2owK3YCHaPsp3zJZ9gOIwwlDJ7Lq6f
         StWFM6Yv7Lzm9b+HUTFQT8REqBnpM+alCtK7+JZEehw3gLUCxtDAmQlNWgSbfT1F96
         9Rd5Qe61LfCZKepEXb1w3JHxN3k14nZkNWc8H20bfWjc5QawAVhmcDpQYSijtPQw15
         kvcplfJQcalVcb8fEKlbLzEvAfiDFMS5CuaHuCDh9qA+XM+MH10TUW0+L9x6SdGtdv
         3UuuItA25U6TA==
Subject: [PATCH 6/9] xfs/109: handle larger minimum filesystem size
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com, zlang@redhat.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Tue, 28 Jun 2022 13:21:51 -0700
Message-ID: <165644771132.1045534.358827009181930377.stgit@magnolia>
In-Reply-To: <165644767753.1045534.18231838177395571946.stgit@magnolia>
References: <165644767753.1045534.18231838177395571946.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

mkfs will soon refuse to format a filesystem smaller than 300MB, so
increase the size of the filesystem to keep this test scenario
realistic.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/xfs/109 |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/tests/xfs/109 b/tests/xfs/109
index 6cb6917a..e3e491f1 100755
--- a/tests/xfs/109
+++ b/tests/xfs/109
@@ -78,7 +78,7 @@ if [ -n "$FASTSTART" -a -f $SCRATCH_MNT/f0 ]; then
 fi
 _scratch_unmount
 
-_scratch_mkfs_xfs -dsize=160m,agcount=4 $faststart | _filter_mkfs 2>$tmp.mkfs
+_scratch_mkfs_xfs -dsize=320m,agcount=4 $faststart | _filter_mkfs 2>$tmp.mkfs
 cat $tmp.mkfs >>$seqres.full
 _scratch_mount
 

