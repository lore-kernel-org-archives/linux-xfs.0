Return-Path: <SRS0=dZhK=A2=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89265C433E5
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Jul 2020 14:08:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5BBF3205CB
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Jul 2020 14:08:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cZR5j79L"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728606AbgGOOIo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 15 Jul 2020 10:08:44 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:54601 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728626AbgGOOIn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 15 Jul 2020 10:08:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594822122;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=t/yrvPgAp4fm1thhPUXgOPPQ2hkQ3D18gag6YlgIJwU=;
        b=cZR5j79LhGZ2Yc/0Xwu/acqMg6zsKqnEEMNWT0dsBovlx1t2mTesy/4bukSTEfu7I9Fnw5
        UIfjSGPA+mpTSqaRfwdUyO3afIvVWXmyH+mErlLRMoQTe0RRpHU+/vooAj2FHmPAuiGj0/
        2uvcOQ9k2xbGTkHW0mz6P9AqFROQiDI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-294-D8voqtL5NyiN0iOnnYvSgA-1; Wed, 15 Jul 2020 10:08:38 -0400
X-MC-Unique: D8voqtL5NyiN0iOnnYvSgA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id ED24C800400
        for <linux-xfs@vger.kernel.org>; Wed, 15 Jul 2020 14:08:37 +0000 (UTC)
Received: from bfoster.redhat.com (ovpn-113-214.rdu2.redhat.com [10.10.113.214])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B10D85D9CA
        for <linux-xfs@vger.kernel.org>; Wed, 15 Jul 2020 14:08:37 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 2/4] repair: don't double check dir2 sf parent in phase 4
Date:   Wed, 15 Jul 2020 10:08:34 -0400
Message-Id: <20200715140836.10197-3-bfoster@redhat.com>
In-Reply-To: <20200715140836.10197-1-bfoster@redhat.com>
References: <20200715140836.10197-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The shortform parent ino verification code runs once in phase 3
(ino_discovery == true) and once in phase 4 (ino_discovery ==
false). This is unnecessary and leads to duplicate error messages if
repair replaces an invalid parent value with zero because zero is
still an invalid value. Skip the check in phase 4.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 repair/dir2.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/repair/dir2.c b/repair/dir2.c
index cbbce601..caf6963d 100644
--- a/repair/dir2.c
+++ b/repair/dir2.c
@@ -480,6 +480,9 @@ _("corrected entry offsets in directory %" PRIu64 "\n"),
 	 * check parent (..) entry
 	 */
 	*parent = libxfs_dir2_sf_get_parent_ino(sfp);
+	if (!ino_discovery)
+		return 0;
+
 
 	/*
 	 * if parent entry is bogus, null it out.  we'll fix it later .
-- 
2.21.3

