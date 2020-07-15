Return-Path: <SRS0=dZhK=A2=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E72DC433E2
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Jul 2020 14:08:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EE50C205CB
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Jul 2020 14:08:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YA9t53Pf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728282AbgGOOIl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 15 Jul 2020 10:08:41 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:26081 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728326AbgGOOIl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 15 Jul 2020 10:08:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594822120;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hfn/hyw1xORmef0X+t2LjUPP3d0gwPynLPISJBIEoao=;
        b=YA9t53PflTl8/IGI1K+yZwYVyDHS7rwzujZwjWJTFsdeS25rbgpY2Cii00R6vKGOhmFUvZ
        3BATHq+19IEQ6za7aKiCslNRcQeWrU1wenoZz88fntEP7NTSxgFmbBhzp3c7pmADzbBido
        Hxz423+F5VizFEiVXfRnWkJtETZLW3w=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-27-KoyZs9HIO3Kl6Sd4NfOVAw-1; Wed, 15 Jul 2020 10:08:38 -0400
X-MC-Unique: KoyZs9HIO3Kl6Sd4NfOVAw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8F93B107ACCA
        for <linux-xfs@vger.kernel.org>; Wed, 15 Jul 2020 14:08:37 +0000 (UTC)
Received: from bfoster.redhat.com (ovpn-113-214.rdu2.redhat.com [10.10.113.214])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 529975D9C5
        for <linux-xfs@vger.kernel.org>; Wed, 15 Jul 2020 14:08:37 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 1/4] repair: set the in-core inode parent in phase 3
Date:   Wed, 15 Jul 2020 10:08:33 -0400
Message-Id: <20200715140836.10197-2-bfoster@redhat.com>
In-Reply-To: <20200715140836.10197-1-bfoster@redhat.com>
References: <20200715140836.10197-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The inode processing code checks and resets invalid parent values on
physical inodes in phase 3 but waits to update the parent value in
the in-core tracking until phase 4. There doesn't appear to be any
specific reason for the latter beyond caution. In reality, the only
reason this doesn't cause problems is that phase 3 replaces an
invalid on-disk parent with another invalid value, so the in-core
parent returned by phase 4 translates to NULLFSINO.

This is subtle and fragile. To eliminate this duplicate processing
behavior and break the subtle dependency of requiring an invalid
dummy value in physical directory inodes, update the in-core parent
tracking structure at the same point in phase 3 that physical inodes
are updated. Invalid on-disk parent values will still translate to
NULLFSINO for the in-core tracking to be identified by later phases.
This ensures that if a valid dummy value is placed in a physical
inode (such as rootino) with an invalid parent in phase 3, phase 4
won't mistakenly return the valid dummy value to be incorrectly set
in the in-core tracking over the NULLFSINO value that represents the
broken on-disk state.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 repair/dino_chunks.c | 9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/repair/dino_chunks.c b/repair/dino_chunks.c
index 6685a4d2..96ed6a5b 100644
--- a/repair/dino_chunks.c
+++ b/repair/dino_chunks.c
@@ -859,14 +859,7 @@ next_readbuf:
 		 */
 		if (isa_dir)  {
 			set_inode_isadir(ino_rec, irec_offset);
-			/*
-			 * we always set the parent but
-			 * we may as well wait until
-			 * phase 4 (no inode discovery)
-			 * because the parent info will
-			 * be solid then.
-			 */
-			if (!ino_discovery)  {
+			if (ino_discovery)  {
 				ASSERT(parent != 0);
 				set_inode_parent(ino_rec, irec_offset, parent);
 				ASSERT(parent ==
-- 
2.21.3

