Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E75CC433FE
	for <linux-xfs@archiver.kernel.org>; Tue,  4 Jan 2022 01:58:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232096AbiADB6W (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 3 Jan 2022 20:58:22 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:57238 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230511AbiADB6S (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 3 Jan 2022 20:58:18 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1EEDA61267
        for <linux-xfs@vger.kernel.org>; Tue,  4 Jan 2022 01:58:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76410C36AEF;
        Tue,  4 Jan 2022 01:58:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641261496;
        bh=KcKkum5stjYauw7upbvoyvb2/Nl+k7ha2iqfti6ZNb0=;
        h=Date:From:To:Cc:Subject:From;
        b=gO8aItdQz/VFv0jTMZuMd3jyFa4s/eNCySEliRjb4e1B9P3JBEP6ovuoJrAI6fOKb
         55Ybm7JJbtlwC2ffGcgzYS/PXuW0URXHBhULrlJfqVdoN5ESgPDKA2c0Q7Q1crPnvg
         BwsD+4Gehpc1nIwi6dvlsRLRp2WZhNxmMvf3ABzT18LNCY5due6bZgJJUGd3DfNLRg
         N/hU4OTBaYO+ISd11vms+dldLOUPT9Gj9P+RwONNvOOmPoJmHOCBE255IM5LdkD9Kp
         Msi1uP0Z/9fQ/sQ1JAvHlneKCTFNq6MUiXxYFPSJTJafuIrpGDQ2Plrcxi/b6e7k48
         SUu7S0DAkxF3A==
Date:   Mon, 3 Jan 2022 17:58:16 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     xfs <linux-xfs@vger.kernel.org>, chandan.babu@oracle.com
Cc:     Wengang Wang <wen.gang.wang@oracle.com>
Subject: [PATCH v2] design: fix computation of buffer log item bitmap size
Message-ID: <20220104015816.GD31583@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Wengang Wang was trying to work through a buffer log item by consulting
the ondisk format documentation, and was confused by the formula given
in section 14.3.14 regarding the size of blf_data_map, aka the dirty
bitmap for buffer log items.  We noticed that the documentation doesn't
match what the kernel actually does, so let's fix this.

Reported-by: Wengang Wang <wen.gang.wang@oracle.com>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 .../journaling_log.asciidoc                        |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/design/XFS_Filesystem_Structure/journaling_log.asciidoc b/design/XFS_Filesystem_Structure/journaling_log.asciidoc
index 8421a53..ddcb87f 100644
--- a/design/XFS_Filesystem_Structure/journaling_log.asciidoc
+++ b/design/XFS_Filesystem_Structure/journaling_log.asciidoc
@@ -867,7 +867,7 @@ The size of +blf_data_map+, in 32-bit words.
 This variable-sized array acts as a dirty bitmap for the logged buffer.  Each
 1 bit represents a dirty region in the buffer, and each run of 1 bits
 corresponds to a subsequent log item containing the new contents of the buffer
-area.  Each bit represents +(blf_len * 512) / (blf_map_size * NBBY)+ bytes.
+area.  Each bit represents +XFS_BLF_CHUNK+ (i.e. 128) bytes.
 
 [[Buffer_Data_Log_Item]]
 === Buffer Data Log Item
