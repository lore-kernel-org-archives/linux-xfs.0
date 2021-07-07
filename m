Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E416C07E9B
	for <linux-xfs@archiver.kernel.org>; Wed,  7 Jul 2021 00:21:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2B9B861CB8
	for <linux-xfs@archiver.kernel.org>; Wed,  7 Jul 2021 00:21:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230015AbhGGAYT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 6 Jul 2021 20:24:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:52910 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229919AbhGGAYT (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 6 Jul 2021 20:24:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 47BF161C91;
        Wed,  7 Jul 2021 00:21:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625617300;
        bh=c785Xk/13yhAfMGqHE1CXfFeAX/U1nwgbLROr3HhVjU=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=JHO7iy5GhGW2kYtWDMqWLFuemIQytBk3c1nnRCtZpoDIvuls0zbQRzblYyNyimxyo
         aE34P+ny7NHymmH7bscw/aq6199tgHzcmXG+lKNcVcGv25jk59m46nmO/flgv4cKTr
         RvNQtKXANWcZ1SrW//fA4xegD1FBXs0AEubHpdJYGheQci2TdQ4SdvQ2apULfeFIyx
         ZxTstdn1bZK1AGoNNInVA4wLvkJ2lQdzwXGc38nCi75DjKBF2g8RUtwmTAoU3jwE6k
         pImI00OZEYusHj8MyCfGt+/QT3gJvJqi7x6bl/S+p6DSKKkA1vE+BHjFgr38/aLiQz
         jdeBCIZ9zk2Bw==
Subject: [PATCH 6/8] xfs/084: fix test program status collection and
 processing
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Tue, 06 Jul 2021 17:21:39 -0700
Message-ID: <162561729997.543423.18037428142167687667.stgit@locust>
In-Reply-To: <162561726690.543423.15033740972304281407.stgit@locust>
References: <162561726690.543423.15033740972304281407.stgit@locust>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

On a test VM with 1.2GB memory, I noticed that the test will sometimes
fail because resvtest leaks too much memory and gets OOM killed.  It
would be useful to _notrun the test when this happens so that it doesn't
appear as an intermittent regression.

The exit code processing in this test is incorrect, since "$?" will get
us the exit status of _filter_resv, not $here/src/resvtest.  Fix that
as part of learning to detect a SIGKILL and skip the test.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/xfs/084 |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)


diff --git a/tests/xfs/084 b/tests/xfs/084
index 5967fe12..e796fec4 100755
--- a/tests/xfs/084
+++ b/tests/xfs/084
@@ -33,13 +33,17 @@ _require_test
 echo
 echo "*** First case - I/O blocksize same as pagesize"
 $here/src/resvtest -i 20 -b $pgsize "$TEST_DIR/resv" | _filter_resv
-[ $? -eq 0 ] && echo done
+res=${PIPESTATUS[0]}
+[ $res -eq 137 ] && _notrun "resvtest -i 20 -b $pgsize was SIGKILLed (OOM?)"
+[ $res -eq 0 ] && echo done
 rm -f "$TEST_DIR/mumble"
 
 echo
 echo "*** Second case - 512 byte I/O blocksize"
 $here/src/resvtest -i 40 -b 512 "$TEST_DIR/resv" | _filter_resv
-[ $? -eq 0 ] && echo done
+res=${PIPESTATUS[0]}
+[ $res -eq 137 ] && _notrun "resvtest -i 40 -b 512 was SIGKILLed (OOM?)"
+[ $res -eq 0 ] && echo done
 rm -f "$TEST_DIR/grumble"
 
 # success, all done

