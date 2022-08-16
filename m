Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 400EAC2BB41
	for <linux-xfs@archiver.kernel.org>; Tue, 16 Aug 2022 10:27:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234557AbiHPK1Y (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 16 Aug 2022 06:27:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234561AbiHPK0t (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 16 Aug 2022 06:26:49 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 04878606A4
        for <linux-xfs@vger.kernel.org>; Tue, 16 Aug 2022 01:45:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660639553;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=gIP1yViGVYvN9cx3m4jBBPVaFAFg23Pf+8Dx4Sa6RcM=;
        b=fDOCQVohGYsIZ35UXD1gYEHE2a/TNYCHVD5HWHpwDMmi4kQs9ZrDoKg0PntJJJ/LCtQzU1
        TfaKxcfHWqC8ZevKCp/nvPN7hh09EgzJ+AVniXmFo4Y9f/8ql+nTXvciTB6ybvTF2j8USR
        tHBM+7FODbUdFKG9vtNog1M5FCkpC2o=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-393-GNomduv4M7G_jrBwLdt7mQ-1; Tue, 16 Aug 2022 04:45:52 -0400
X-MC-Unique: GNomduv4M7G_jrBwLdt7mQ-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 756451C0899A
        for <linux-xfs@vger.kernel.org>; Tue, 16 Aug 2022 08:45:51 +0000 (UTC)
Received: from [10.10.0.108] (unknown [10.40.193.155])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 36DAF492C3B
        for <linux-xfs@vger.kernel.org>; Tue, 16 Aug 2022 08:45:51 +0000 (UTC)
Subject: [PATCH] xfsdump: Initialize getbmap structure in quantity2offset
From:   Carlos Maiolino <cmaiolino@redhat.com>
To:     linux-xfs@vger.kernel.org
Date:   Tue, 16 Aug 2022 10:45:50 +0200
Message-ID: <166063952935.40771.5357077583333371260.stgit@orion>
User-Agent: StGit/1.4
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Prevent uninitialized data in the stack by initializing getbmap structure
to zero.

Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
---

There is already a patch on the list to remove remaining DMAPI stuff from
xfsdump:
xfsdump: remove BMV_IF_NO_DMAPI_READ flag

This patch though, does not initialize the getbmap structure, and although
the
first struct in the array is initialized, the remaining structures in the
array are not, leaving garbage in the stack.


 dump/inomap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/dump/inomap.c b/dump/inomap.c
index f3200be..c4ea21d 100644
--- a/dump/inomap.c
+++ b/dump/inomap.c
@@ -1627,7 +1627,7 @@ static off64_t
 quantity2offset(jdm_fshandle_t *fshandlep, struct xfs_bstat *statp, off64_t qty)
 {
 	int fd;
-	struct getbmap bmap[BMAP_LEN];
+	struct getbmap bmap[BMAP_LEN] = {0};
 	off64_t offset;
 	off64_t offset_next;
 	off64_t qty_accum;


