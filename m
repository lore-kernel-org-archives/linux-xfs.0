Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D6D5C636CC
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Feb 2023 21:18:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230006AbjBPVSU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Feb 2023 16:18:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229563AbjBPVST (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Feb 2023 16:18:19 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFCED497EF;
        Thu, 16 Feb 2023 13:18:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 73A91B82922;
        Thu, 16 Feb 2023 21:18:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36822C433EF;
        Thu, 16 Feb 2023 21:18:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676582296;
        bh=k7ZipMDuZMxV6VbdH454mer6JK5pZi2G89n0U2BIf+I=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=gajoy8iyTZIvmEwLhQCMSfFkc758gFLlBw+FVbEg4sr9tfuadPUuRGZG62l12ZvlL
         Oem7WbJYB705VLhiCBubo8miCRh6htJDW1fQlB+JnJ27nQ/sWZDc0K5NnItsf/3z1b
         6rIMogPBAWtuAH+gU9h/eTPff2ct1GhtMzF6M6cRBU0CWg96SEiOyAHzsK5/XJwpPO
         /wzziaKvU7rEqoo6K2PnRJZi2sJk4QEcY3DsWdUAF+r7L7HxHzBOHaKWIAk0wsDlom
         kiQssbYvswq3FftXndewr3StiOtUQGWUqfzRzxnHAGYhJBW/fRCvRbMlmcZ8g3lqfM
         ZFcGMu36/xPHQ==
Date:   Thu, 16 Feb 2023 13:18:15 -0800
Subject: [PATCH 4/4] xfs/021: adjust for short valuelens
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, zlang@redhat.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Message-ID: <167657885031.3481738.6815427580927744278.stgit@magnolia>
In-Reply-To: <167657884979.3481738.5353655058338554587.stgit@magnolia>
References: <167657884979.3481738.5353655058338554587.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/xfs/021.out.parent |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)


diff --git a/tests/xfs/021.out.parent b/tests/xfs/021.out.parent
index 837b17ffdf..c43dd15900 100644
--- a/tests/xfs/021.out.parent
+++ b/tests/xfs/021.out.parent
@@ -19,12 +19,11 @@ size of attr value = 65536
 
 *** unmount FS
 *** dump attributes (1)
-a.sfattr.hdr.totsize = 59
+a.sfattr.hdr.totsize = 49
 a.sfattr.hdr.count = 3
 a.sfattr.list[0].namelen = 22
-a.sfattr.list[0].valuelen = 10
+a.sfattr.list[0].valuelen = 0
 a.sfattr.list[0].root = 0
-a.sfattr.list[0].value = "testfile.1"
 a.sfattr.list[1].namelen = 2
 a.sfattr.list[1].valuelen = 3
 a.sfattr.list[1].root = 0
@@ -40,7 +39,7 @@ hdr.info.forw = 0
 hdr.info.back = 0
 hdr.info.magic = 0xfbee
 hdr.count = 4
-hdr.usedbytes = 88
+hdr.usedbytes = 80
 hdr.firstused = FIRSTUSED
 hdr.holes = 0
 hdr.freemap[0-2] = [base,size] [FREEMAP..]
@@ -57,8 +56,7 @@ nvlist[2].valuelen = 8
 nvlist[2].namelen = 7
 nvlist[2].name = "a2-----"
 nvlist[2].value = "value_2\d"
-nvlist[3].valuelen = 10
+nvlist[3].valuelen = 0
 nvlist[3].namelen = 22
-nvlist[3].value = "testfile.2"
 *** done
 *** unmount

