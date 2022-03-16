Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4304C433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 16 Mar 2022 03:30:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353458AbiCPDbZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 15 Mar 2022 23:31:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353450AbiCPDbZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 15 Mar 2022 23:31:25 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 414053981F;
        Tue, 15 Mar 2022 20:30:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E7F4FB81883;
        Wed, 16 Mar 2022 03:30:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96F3AC340E8;
        Wed, 16 Mar 2022 03:30:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647401409;
        bh=oKYIh0hVq+dJHf9GEEF/9uewAwfU3ZAVXop7uqNYhR4=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=S8usV3bXLEt5S6OQf20REWvEUPtyHBzE7zo7PxTHBfwqsOxt//WufNP8Y3pjfN3FS
         e1LItVVzxpwZt75d4//cotV05M6iu3qiKq7Bm4GrPKWgysKvZguSSlIEwYB2gKMqaF
         1s9O/mftkDgQ6s/xRMkYKvtbHLLGHF1PaQKbpCFC7k81h6P4hR6obXvvUnI2Hqt+9u
         bb40rdX/cep2ie61cykDc37UvCHK9HP27XIgWBfnHN9lvYPiV51uUxy3DKDdJGRlrQ
         hX8SkuVaKAwBUmtuWTRCXkP6m7B4byzLkXPznFVUl9cZp4I3Kt4fg0/z4qJ9oWx1uN
         6mCRXyHTp1RYg==
Subject: [PATCH 1/4] generic/459: ensure that the lvm devices have been
 created
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Tue, 15 Mar 2022 20:30:09 -0700
Message-ID: <164740140920.3371628.4554997239924071993.stgit@magnolia>
In-Reply-To: <164740140348.3371628.12967562090320741592.stgit@magnolia>
References: <164740140348.3371628.12967562090320741592.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Once in a /very/ long while this test fails because _mkfs_dev can't find
the LVM thinp volume after it's been created.  Since the "solution" du
jour seems to be to sprinkle udevadm settle calls everywhere, do that
here in the hopes that will fix it.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/generic/459 |    1 +
 1 file changed, 1 insertion(+)


diff --git a/tests/generic/459 b/tests/generic/459
index cda19e6e..57d58e55 100755
--- a/tests/generic/459
+++ b/tests/generic/459
@@ -70,6 +70,7 @@ $LVM_PROG lvcreate  --virtualsize $virtsize \
 		    -T $vgname/$poolname \
 		    -n $lvname >>$seqres.full 2>&1
 
+$UDEV_SETTLE_PROG &>/dev/null
 _mkfs_dev /dev/mapper/$vgname-$lvname >>$seqres.full 2>&1
 
 # Running the test over the original volume doesn't reproduce the problem

