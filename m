Return-Path: <SRS0=59Ki=B7=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0F90C433E1
	for <linux-xfs@archiver.kernel.org>; Fri, 21 Aug 2020 00:09:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7326120702
	for <linux-xfs@archiver.kernel.org>; Fri, 21 Aug 2020 00:09:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="F6I7RLO7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726702AbgHUAJv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 20 Aug 2020 20:09:51 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:45659 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725859AbgHUAJu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 20 Aug 2020 20:09:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597968589;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=44jnb5biGdpHeIGO/y9eJTx2xWF+SR9dIGa79EaS0ng=;
        b=F6I7RLO7NUwYREktEfyEsUpkrzeWvyVo+JPKKHHjqGZSqgKPn8rPNaaqqNv7z0qCAkY0Cx
        y8Ldr+sN3BLQACEnq1c3FD6XEOdLxGZldVnfg+gOyCYB69TYznjfg1y03+A/7vFvGQruCb
        zQkwJoEODQCroETg1KkcbRqzjIfqvRo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-150-DtD65TCwOcOwJNfAZvli2g-1; Thu, 20 Aug 2020 20:09:47 -0400
X-MC-Unique: DtD65TCwOcOwJNfAZvli2g-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5574281F028
        for <linux-xfs@vger.kernel.org>; Fri, 21 Aug 2020 00:09:46 +0000 (UTC)
Received: from liberator.sandeen.net (ovpn04.gateway.prod.ext.phx2.redhat.com [10.5.9.4])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2A58619C66
        for <linux-xfs@vger.kernel.org>; Fri, 21 Aug 2020 00:09:46 +0000 (UTC)
Subject: [PATCH 2/2] xfs_db: consolidate set_iocur_type behavior
From:   Eric Sandeen <sandeen@redhat.com>
To:     linux-xfs@vger.kernel.org
References: <8b1ab1c4-64f6-5410-bf40-30776dae4dd5@redhat.com>
Message-ID: <8062b2d0-3fbb-0240-d5dd-c7bfb452f0b3@redhat.com>
Date:   Thu, 20 Aug 2020 19:09:45 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.1.1
MIME-Version: 1.0
In-Reply-To: <8b1ab1c4-64f6-5410-bf40-30776dae4dd5@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Right now there are 3 cases to type_f: inode type, type with fields,
and a default.  The first two were added to address issues with handling
V5 metadata.

The first two already use some version of set_cur, which handles all
of the validation etc. There's no reason to leave the open-coded bits
at the end, just send every non-inode type through set_cur and be done
with it.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

 io.c |   28 +++++-----------------------
 1 file changed, 5 insertions(+), 23 deletions(-)

diff --git a/db/io.c b/db/io.c
index 884da599..235191f5 100644
--- a/db/io.c
+++ b/db/io.c
@@ -603,33 +603,15 @@ set_iocur_type(
 				iocur_top->boff / mp->m_sb.sb_inodesize);
 		ino = XFS_AGINO_TO_INO(mp, xfs_daddr_to_agno(mp, b), agino);
 		set_cur_inode(ino);
-		return;
-	}
-
-	/* adjust buffer size for types with fields & hence fsize() */
-	if (type->fields) {
-		int bb_count;	/* type's size in basic blocks */
+	} else  {
+		int bb_count = 1;	/* type's size in basic blocks */
 
-		bb_count = BTOBB(byteize(fsize(type->fields,
+		/* adjust buffer size for types with fields & hence fsize() */
+		if (type->fields)
+			bb_count = BTOBB(byteize(fsize(type->fields,
 					       iocur_top->data, 0, 0)));
 		set_cur(type, iocur_top->bb, bb_count, DB_RING_IGN, NULL);
 	}
-	iocur_top->typ = type;
-
-	/* verify the buffer if the type has one. */
-	if (!bp)
-		return;
-	if (!type->bops) {
-		bp->b_ops = NULL;
-		bp->b_flags |= LIBXFS_B_UNCHECKED;
-		return;
-	}
-	if (!(bp->b_flags & LIBXFS_B_UPTODATE))
-		return;
-	bp->b_error = 0;
-	bp->b_ops = type->bops;
-	bp->b_ops->verify_read(bp);
-	bp->b_flags &= ~LIBXFS_B_UNCHECKED;
 }
 
 static void

