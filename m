Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8636EB64D9
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Jun 2023 21:30:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229953AbjF0Vau (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 27 Jun 2023 17:30:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229488AbjF0Vau (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 27 Jun 2023 17:30:50 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8950F5
        for <linux-xfs@vger.kernel.org>; Tue, 27 Jun 2023 14:30:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1687901404;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=JquQOtG6dT86uuoh2j7ROM20YdnhBJX/RFUsZGtW5OY=;
        b=f+KogcFdyiv5cC2CxM6u794c4bz8ueT3UstpYrmmGy81UA5ePmODbOA28gv2aw1ah1Pm7S
        6n571jdQ2lCr087kMhxp8CrLN1VnqXzzRcmu6LB3TvEbwJA9ZhZdP31nQqgOJdWOtiRMxe
        bemsJtcZ/mBrlOmw4c9+hVoBIcjdDDw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-223-zGPv96GjMbyd11e1LwB0sQ-1; Tue, 27 Jun 2023 17:30:03 -0400
X-MC-Unique: zGPv96GjMbyd11e1LwB0sQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 339C1830DB8
        for <linux-xfs@vger.kernel.org>; Tue, 27 Jun 2023 21:30:03 +0000 (UTC)
Received: from toolbox.redhat.com (unknown [10.22.8.171])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 12AAA200BA8D
        for <linux-xfs@vger.kernel.org>; Tue, 27 Jun 2023 21:30:03 +0000 (UTC)
From:   Yaakov Selkowitz <yselkowi@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH] po: fix German translation
Date:   Tue, 27 Jun 2023 17:29:31 -0400
Message-ID: <20230627212959.1155472-1-yselkowi@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

gettext-0.22 raises an error on what is clearly an typo in the translation:

  de.po:3087: 'msgstr' is not a valid C format string, unlike 'msgid'.
  Reason: In the directive number 2, the argument size specifier is invalid.

Signed-off-by: Yaakov Selkowitz <yselkowi@redhat.com>
---
 po/de.po | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/po/de.po b/po/de.po
index 944b0e91..a6f8fde1 100644
--- a/po/de.po
+++ b/po/de.po
@@ -3084,7 +3084,7 @@ msgstr "%llu Spezialdateien\n"
 #: .././estimate/xfs_estimate.c:191
 #, c-format
 msgid "%s will take about %.1f megabytes\n"
-msgstr "%s wird etwa %.lf Megabytes einnehmen\n"
+msgstr "%s wird etwa %.1f Megabytes einnehmen\n"
 
 #: .././estimate/xfs_estimate.c:198
 #, c-format
-- 
2.41.0

