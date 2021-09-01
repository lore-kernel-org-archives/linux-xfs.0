Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06960C4320E
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Sep 2021 00:12:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E59C661054
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Sep 2021 00:12:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241143AbhIAAM5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 31 Aug 2021 20:12:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:46866 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243020AbhIAAM5 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 31 Aug 2021 20:12:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6E99761008;
        Wed,  1 Sep 2021 00:12:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630455121;
        bh=Iy6YC+wp04goI3E2mJ6CbMEeoJKPs3qFh946YNhlQ0U=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=kPuj+obGbQcWKVJe5483O2zRAOVS7IU0bmOwWZrmwPDp54IRENI6aMFkqnTKClsfn
         VF3NGJVodpy0jFqADL1D9XR25tgKBnE+jSUjpSYyHh4cACMJcVQNXIMakdP89cFAO2
         naRBHGr9lVg0gGAfQE0NXbufDfbDSxWPRPI6MdCpb9sHgVmXiRAlPLyIgUF6mErLp+
         c2eRfAl+ooxcGlzhRXr6ibozYe6tMMYSR77Dxlt5kRFLwO9MBPKIdIT9gu/tDiJiDF
         lr/Mv4TuyGBHmoEPicSzQJoVL1gowAsVWb4fG4QzcqqkIGAhjptmVDe9cDuDvcEHgC
         yxzc20gc3ycig==
Subject: [PATCH 3/3] xfs/449: filter out deprecation warnings from mkfs
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Tue, 31 Aug 2021 17:12:01 -0700
Message-ID: <163045512113.770026.14089523911790151666.stgit@magnolia>
In-Reply-To: <163045510470.770026.14067376159951420121.stgit@magnolia>
References: <163045510470.770026.14067376159951420121.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

To avoid regressing this test when testing XFS v4 when mkfs is new
enough to whine about creating new deprecated filesystems, filter out
the deprecation warning.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/xfs/449 |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/tests/xfs/449 b/tests/xfs/449
index a3fcd78e..5374bf2f 100755
--- a/tests/xfs/449
+++ b/tests/xfs/449
@@ -23,7 +23,7 @@ _require_scratch_nocheck
 _require_xfs_spaceman_command "info"
 _require_command "$XFS_GROWFS_PROG" xfs_growfs
 
-_scratch_mkfs | sed -e '/Discarding/d' > $tmp.mkfs
+_scratch_mkfs | sed -e '/Discarding/d' -e '/deprecated/d' > $tmp.mkfs
 echo MKFS >> $seqres.full
 cat $tmp.mkfs >> $seqres.full
 

