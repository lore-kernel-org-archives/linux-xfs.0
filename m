Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A0AFC77B61
	for <linux-xfs@archiver.kernel.org>; Wed, 26 Apr 2023 00:14:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238368AbjDZAO0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 25 Apr 2023 20:14:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238067AbjDZAOZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Apr 2023 20:14:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13C05769B;
        Tue, 25 Apr 2023 17:14:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A637F60C2B;
        Wed, 26 Apr 2023 00:14:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B853C433EF;
        Wed, 26 Apr 2023 00:14:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682468064;
        bh=ozqQR+vvGT15RDDzBtuZWl+8FdDWWed/Qud4QylpBpY=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=s5DzUkQ6DNY+/T3faiNlivHghOS97Lj0yKk1xnhsGloXqSh88CzVzhMfqUVHSYOu4
         dRNgHDuXf9YkkU05EsBLoOtbstBHQrrMV5KoKcD//TfbbFHJ/+A/6hsjh7FuYVl1ly
         9VRYJOIhewo4/iPfG/NW6vcBJAdz0jwgiu45P0cpfSbUTznBCUC6Ooxnb9h+ur8Da/
         33zR1ZWBsnGJCstnWqfCJIbwkIvJm/EpCLmK6bl++vS7o+1oRbCrDacNObWDsjTbTd
         ddz1nJ+VSDNUocjWzTCh6vM5k150p4hSHGiS0EfiH2fiGB81XZAKx1la1gscRVZnNM
         3laQRanTjD/sw==
Subject: [PATCH 1/4] generic/476: reclassify this test as a long running soak
 stress test
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Tue, 25 Apr 2023 17:14:23 -0700
Message-ID: <168246806362.732186.12173643369343352453.stgit@frogsfrogsfrogs>
In-Reply-To: <168246805791.732186.9294980643404649.stgit@frogsfrogsfrogs>
References: <168246805791.732186.9294980643404649.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

This test is a long(ish) running stress test that uses fsstress, so
alter its group membership as follows:

long_rw: because this can read and write to the fs for a long period of
time

stress: because this test employs fsstress

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/generic/476 |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/tests/generic/476 b/tests/generic/476
index 212373d17c..62908654ad 100755
--- a/tests/generic/476
+++ b/tests/generic/476
@@ -8,7 +8,7 @@
 # bugs in the write path.
 #
 . ./common/preamble
-_begin_fstest auto rw
+_begin_fstest auto rw long_rw stress
 
 # Override the default cleanup function.
 _cleanup()

