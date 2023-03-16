Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D3D6C76196
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Mar 2023 19:37:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230325AbjCPThS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Mar 2023 15:37:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230346AbjCPThQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Mar 2023 15:37:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 472BDDCA56;
        Thu, 16 Mar 2023 12:37:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D7206B82337;
        Thu, 16 Mar 2023 19:37:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99263C4339B;
        Thu, 16 Mar 2023 19:37:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678995425;
        bh=bhjD46g2GGpyNM7odLF5kVrhnSp0hYnSH8/yQhXhAKM=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=r7nj5zYhnR+2+CJm7Qr/1zOznlvUImdih+5ZkTJhreQ/GbZ27lGU+iFPRY3ikpoR8
         dVRU6nlSodO7tPQooMw+xHJtvVI7K6zeyuid8MSqJi0xO6BdXsg845MvDcPyTlkWKO
         MWgCsR0L+0GxsdKfK5yT4sT7U2OB+qcAuC1CKPQOib5TwNVoROdX/Y5yBjUZhHdcLm
         LM27v8e6/kSiaaKw0nUyZ1uhzyV7TTR1F9LJyLv1PmhDX3f27WRvir9+POXiIN+xJZ
         qUeI2UJqR1VTwCV7hCIu/ljn8qWHK1W+gB0aYaI4XOmeMSDKCEBEePCZgfN7YpklbH
         9gq3mxKVR5Zfw==
Date:   Thu, 16 Mar 2023 12:37:05 -0700
Subject: [PATCH 1/1] xfs/{021,122}: adjust parent pointer encoding format
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Message-ID: <167899418455.18363.4094489079960307687.stgit@frogsfrogsfrogs>
In-Reply-To: <167899418443.18363.13765302382460119202.stgit@frogsfrogsfrogs>
References: <167899418443.18363.13765302382460119202.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Adjust these tests to reflect the new parent pointer ondisk format.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/xfs/021.out.parent |   22 ++++++++++------------
 tests/xfs/122.out        |    2 +-
 2 files changed, 11 insertions(+), 13 deletions(-)


diff --git a/tests/xfs/021.out.parent b/tests/xfs/021.out.parent
index 661d130239..c43dd15900 100644
--- a/tests/xfs/021.out.parent
+++ b/tests/xfs/021.out.parent
@@ -19,12 +19,11 @@ size of attr value = 65536
 
 *** unmount FS
 *** dump attributes (1)
-a.sfattr.hdr.totsize = 53
+a.sfattr.hdr.totsize = 49
 a.sfattr.hdr.count = 3
-a.sfattr.list[0].namelen = 16
-a.sfattr.list[0].valuelen = 10
+a.sfattr.list[0].namelen = 22
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
-hdr.usedbytes = 84
+hdr.usedbytes = 80
 hdr.firstused = FIRSTUSED
 hdr.holes = 0
 hdr.freemap[0-2] = [base,size] [FREEMAP..]
@@ -53,12 +52,11 @@ nvlist[1].valueblk = 0x1
 nvlist[1].valuelen = 65535
 nvlist[1].namelen = 2
 nvlist[1].name = "a3"
-nvlist[2].valuelen = 10
-nvlist[2].namelen = 16
-nvlist[2].value = "testfile.2"
-nvlist[3].valuelen = 8
-nvlist[3].namelen = 7
-nvlist[3].name = "a2-----"
-nvlist[3].value = "value_2\d"
+nvlist[2].valuelen = 8
+nvlist[2].namelen = 7
+nvlist[2].name = "a2-----"
+nvlist[2].value = "value_2\d"
+nvlist[3].valuelen = 0
+nvlist[3].namelen = 22
 *** done
 *** unmount
diff --git a/tests/xfs/122.out b/tests/xfs/122.out
index da2da2089c..4b7660fac0 100644
--- a/tests/xfs/122.out
+++ b/tests/xfs/122.out
@@ -111,7 +111,7 @@ sizeof(struct xfs_legacy_timestamp) = 8
 sizeof(struct xfs_log_dinode) = 176
 sizeof(struct xfs_log_legacy_timestamp) = 8
 sizeof(struct xfs_map_extent) = 32
-sizeof(struct xfs_parent_name_rec) = 16
+sizeof(struct xfs_parent_name_rec) = 12
 sizeof(struct xfs_phys_extent) = 16
 sizeof(struct xfs_refcount_key) = 4
 sizeof(struct xfs_refcount_rec) = 12

