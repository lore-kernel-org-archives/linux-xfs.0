Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9746C28CC4
	for <linux-xfs@archiver.kernel.org>; Wed,  3 Mar 2021 03:19:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 96C5461477
	for <linux-xfs@archiver.kernel.org>; Wed,  3 Mar 2021 03:19:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349460AbhCCDQS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 2 Mar 2021 22:16:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:38530 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2361109AbhCBXXU (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 2 Mar 2021 18:23:20 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0616E64F34;
        Tue,  2 Mar 2021 23:22:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614727360;
        bh=WYpnpXEdkxLChyk2Ffg5+vuAPJHiTNT5oscrzIXJVzM=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=EVb8oPSo7FnRDZwc2zlljYFtNOLgopwKXIY+yLYg/a53jvdzt/pZxex7V0mpWsEps
         +MlAgXBJ5MU5j83PitzQ06WdjWEcx6A9u/DlihlZoWcaLStHbMWp9Y1ORkxSt7pIfu
         d6b1Vr+Tu+ejyoGQ3oMjMcuEwX5wJfjETsYpAHvgmKUSIIAMeMyUFRE7/IjyxyHvpI
         K7rpL6bVJoGv8yIcy7eFWS2v2d+OpyhrcH/f98SzLQbrs2y9T/H59Dlk8FvTBmuN72
         ZjhFVbLai0XLwLoxtkKAuOx1IzoF2yumd2NgGP1HRrTKb8YIbYocNuLoSUHBmK7obL
         i7Qr0Wzw5Btzg==
Subject: [PATCH 1/4] generic/623: don't fail on core dumps
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Tue, 02 Mar 2021 15:22:39 -0800
Message-ID: <161472735969.3478298.17752955323122832118.stgit@magnolia>
In-Reply-To: <161472735404.3478298.8179031068431918520.stgit@magnolia>
References: <161472735404.3478298.8179031068431918520.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

This test is designed to fail an mmap write and see what happens.
Typically this is a segmentation fault.  If the user's computer is
configured to capture core dumps, this will cause the test to fail, even
though we got the reaction we wanted.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/generic/623 |    1 +
 1 file changed, 1 insertion(+)


diff --git a/tests/generic/623 b/tests/generic/623
index 7be38955..04411405 100755
--- a/tests/generic/623
+++ b/tests/generic/623
@@ -37,6 +37,7 @@ _scratch_mount
 # status on the page.
 file=$SCRATCH_MNT/file
 $XFS_IO_PROG -fc "pwrite 0 4k" -c fsync $file | _filter_xfs_io
+ulimit -c 0
 $XFS_IO_PROG -x -c "mmap 0 4k" -c "mwrite 0 4k" -c shutdown -c fsync \
 	-c "mwrite 0 4k" $file | _filter_xfs_io
 

