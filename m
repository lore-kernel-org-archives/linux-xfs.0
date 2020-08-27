Return-Path: <SRS0=R4OI=CF=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43894C433DF
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Aug 2020 16:53:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1A25B2087C
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Aug 2020 16:53:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="a4mf7k1b"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726946AbgH0Qxi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 27 Aug 2020 12:53:38 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:44571 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726093AbgH0Qxh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Aug 2020 12:53:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1598547216;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=kGjaTJ/WC4j1an4uhLvf89AolPPBZKZAuV5p6ci9QHA=;
        b=a4mf7k1bqzzSUd+9+ChRJvALHlyx1Z0jbZVKVRQUbOh468zRypjI0DuVoQebFVFRJckrt5
        nQsgtb1E+MM1/KMLAoVWZ13fvhYLkUmsdFAi+APSBeYQe5xCuYwJfU1rqFbEQnZN+1Y0Xc
        +ddG7dDJ3aok70Rn6oF7gZLkepuz61Y=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-382-Fz258zUYPfKubCmg8x7vgw-1; Thu, 27 Aug 2020 12:53:34 -0400
X-MC-Unique: Fz258zUYPfKubCmg8x7vgw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B413D185FD84
        for <linux-xfs@vger.kernel.org>; Thu, 27 Aug 2020 16:53:33 +0000 (UTC)
Received: from liberator.sandeen.net (ovpn04.gateway.prod.ext.phx2.redhat.com [10.5.9.4])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 89C2B78426
        for <linux-xfs@vger.kernel.org>; Thu, 27 Aug 2020 16:53:33 +0000 (UTC)
To:     linux-xfs@vger.kernel.org
From:   Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] xfs_db: set b_ops to NULL in set_cur for types without
 verifiers
Message-ID: <06cdcef6-2f44-c702-198b-4ae53052ec28@redhat.com>
Date:   Thu, 27 Aug 2020 11:53:33 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.1.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

If we are using set_cur() to set a type that has no verifier ops,
be sure to set b_ops to NULL so that the old verifiers don't run
against the buffer anymore, which may have changed size.

Fixes: cdabe556 ("xfs_db: consolidate set_iocur_type behavior")
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/db/io.c b/db/io.c
index 9309f361..c79cf105 100644
--- a/db/io.c
+++ b/db/io.c
@@ -561,8 +561,10 @@ set_cur(
 		return;
 	iocur_top->buf = bp->b_addr;
 	iocur_top->bp = bp;
-	if (!ops)
+	if (!ops) {
+		bp->b_ops = NULL;
 		bp->b_flags |= LIBXFS_B_UNCHECKED;
+	}
 
 	iocur_top->bb = blknum;
 	iocur_top->blen = len;

