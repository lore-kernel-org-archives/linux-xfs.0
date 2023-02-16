Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDF50C636D6
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Feb 2023 21:17:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229751AbjBPVRt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Feb 2023 16:17:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229637AbjBPVRs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Feb 2023 16:17:48 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92E1B3B864;
        Thu, 16 Feb 2023 13:17:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4E32FB82922;
        Thu, 16 Feb 2023 21:17:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A6CDC433EF;
        Thu, 16 Feb 2023 21:17:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676582265;
        bh=E65fkd2+civEMD0c2iT5AGe5o+ua8oEpT6heoSul1gA=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=gpCC97x0P552yDGm1vxCvraNuGZayXvHZeUk4HV2RgArYuL6KKjDBnZtr051eNc48
         iosEugw7QueNr9SC0D2VIEwFPsnPDprVlk+lUUfR35k5QETkb8j1orTC0Vvw4IRUIM
         82q/B2bclLe3vigVpxyErQ4f50JE4MigGjR6brYpBXkelUWieUJT7R6/DnRcsOsYjy
         JEDuPoHWv6L+FET9/p4/XbPDwzeXnXXXahBuZkK/shdngOeXnhEILFjD7dpeQFImeE
         UOGYbVSOA+ziQ74P41poMsvAH/5r811I2C9ldvqD3kgtTETMLSPWIz57CqgBa3JIm6
         gFunWU0Wp5EvQ==
Date:   Thu, 16 Feb 2023 13:17:44 -0800
Subject: [PATCH 2/4] xfs/021: adjust for short parent pointers with hashes
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, zlang@redhat.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Message-ID: <167657885005.3481738.10589861682942722453.stgit@magnolia>
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

Adjust this again to handle shortened namehashes.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/xfs/021.out.parent |   20 ++++++++++----------
 tests/xfs/122.out        |    2 +-
 2 files changed, 11 insertions(+), 11 deletions(-)


diff --git a/tests/xfs/021.out.parent b/tests/xfs/021.out.parent
index e7ed72fc27..837b17ffdf 100644
--- a/tests/xfs/021.out.parent
+++ b/tests/xfs/021.out.parent
@@ -19,9 +19,9 @@ size of attr value = 65536
 
 *** unmount FS
 *** dump attributes (1)
-a.sfattr.hdr.totsize = 113
+a.sfattr.hdr.totsize = 59
 a.sfattr.hdr.count = 3
-a.sfattr.list[0].namelen = 76
+a.sfattr.list[0].namelen = 22
 a.sfattr.list[0].valuelen = 10
 a.sfattr.list[0].root = 0
 a.sfattr.list[0].value = "testfile.1"
@@ -40,7 +40,7 @@ hdr.info.forw = 0
 hdr.info.back = 0
 hdr.info.magic = 0xfbee
 hdr.count = 4
-hdr.usedbytes = 144
+hdr.usedbytes = 88
 hdr.firstused = FIRSTUSED
 hdr.holes = 0
 hdr.freemap[0-2] = [base,size] [FREEMAP..]
@@ -53,12 +53,12 @@ nvlist[1].valueblk = 0x1
 nvlist[1].valuelen = 65535
 nvlist[1].namelen = 2
 nvlist[1].name = "a3"
-nvlist[2].valuelen = 10
-nvlist[2].namelen = 76
-nvlist[2].value = "testfile.2"
-nvlist[3].valuelen = 8
-nvlist[3].namelen = 7
-nvlist[3].name = "a2-----"
-nvlist[3].value = "value_2\d"
+nvlist[2].valuelen = 8
+nvlist[2].namelen = 7
+nvlist[2].name = "a2-----"
+nvlist[2].value = "value_2\d"
+nvlist[3].valuelen = 10
+nvlist[3].namelen = 22
+nvlist[3].value = "testfile.2"
 *** done
 *** unmount
diff --git a/tests/xfs/122.out b/tests/xfs/122.out
index 97be93274e..5233aaad5f 100644
--- a/tests/xfs/122.out
+++ b/tests/xfs/122.out
@@ -110,7 +110,7 @@ sizeof(struct xfs_log_dinode) = 176
 sizeof(struct xfs_log_legacy_timestamp) = 8
 sizeof(struct xfs_map_extent) = 32
 sizeof(struct xfs_parent_name_irec) = 96
-sizeof(struct xfs_parent_name_rec) = 76
+sizeof(struct xfs_parent_name_rec) = 12
 sizeof(struct xfs_parent_ptr) = 280
 sizeof(struct xfs_phys_extent) = 16
 sizeof(struct xfs_pptr_info) = 104

