Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40D7DEB64DD
	for <linux-xfs@archiver.kernel.org>; Fri, 28 Jul 2023 22:21:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229765AbjG1WVm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 28 Jul 2023 18:21:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229666AbjG1WVm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 28 Jul 2023 18:21:42 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6C09448A
        for <linux-xfs@vger.kernel.org>; Fri, 28 Jul 2023 15:20:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1690582851;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=rOpBN/YP3AZvHvRv77ILEAT8PzKgIkXLLCDVLK5ly+8=;
        b=SyhwNSx1mVATFqHCM+xgBjSpgW/vK3dfSEMsv8kLiCj++BdBdxQvef2T6yxpK9Mws/BFnr
        MTW/UF0TwMrZ4ntmNvFPiFbc7/PMO3+Q3DAIGZ1eC6aJuysEZ3KIyVckYont4+BB207/Dr
        VcruCfXFU1kA3lxUC4qkKyRgNLeLdB0=
Received: from mimecast-mx02.redhat.com (66.187.233.73 [66.187.233.73]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-257-J2zE1OkgMtuGl9xiVds6yA-1; Fri, 28 Jul 2023 18:20:44 -0400
X-MC-Unique: J2zE1OkgMtuGl9xiVds6yA-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4C83429ABA0E;
        Fri, 28 Jul 2023 22:20:44 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.22.10.121])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2CE75492B02;
        Fri, 28 Jul 2023 22:20:43 +0000 (UTC)
From:   Bill O'Donnell <bodonnel@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     cem@kernel.org, bodonnel@redhat.com
Subject: [PATCH] mkfs.xfs.8: correction on mkfs.xfs manpage since reflink and dax are compatible
Date:   Fri, 28 Jul 2023 17:20:17 -0500
Message-ID: <20230728222017.178599-1-bodonnel@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Merged early in 2023: Commit 480017957d638 xfs: remove restrictions for fsdax
and reflink. There needs to be a corresponding change to the mkfs.xfs manpage
to remove the incompatiblity statement.

Signed-off-by: Bill O'Donnell <bodonnel@redhat.com>
---
 man/man8/mkfs.xfs.8.in | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/man/man8/mkfs.xfs.8.in b/man/man8/mkfs.xfs.8.in
index ce6f1e2d..08bb92f6 100644
--- a/man/man8/mkfs.xfs.8.in
+++ b/man/man8/mkfs.xfs.8.in
@@ -323,13 +323,6 @@ option set. When the option
 .B \-m crc=0
 is used, the reference count btree feature is not supported and reflink is
 disabled.
-.IP
-Note: the filesystem DAX mount option (
-.B \-o dax
-) is incompatible with
-reflink-enabled XFS filesystems.  To use filesystem DAX with XFS, specify the
-.B \-m reflink=0
-option to mkfs.xfs to disable the reflink feature.
 .RE
 .PP
 .PD 0
-- 
2.41.0

