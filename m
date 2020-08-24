Return-Path: <SRS0=BK4F=CC=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8142C433E1
	for <linux-xfs@archiver.kernel.org>; Mon, 24 Aug 2020 16:53:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B71452067C
	for <linux-xfs@archiver.kernel.org>; Mon, 24 Aug 2020 16:53:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Z37cJUPD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727878AbgHXQx3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 24 Aug 2020 12:53:29 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:54853 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726225AbgHXQwE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Aug 2020 12:52:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1598287922;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=S1Jpn19cGt8CpuNvRdqcZv58RlK4+XZzGDHz3TTrb6g=;
        b=Z37cJUPDwtpBjlC6saA/MwIH9dhMlkA6K8okEw39R/joobm6zKsifM8Kn92fB43niDFLKu
        86K75fLFW1/dOuCBYP1kgM18axffooGySti1Qdc4HkMHnHy2sJbd8iMvpRYh5Xtgpks/Zz
        K8BfWUIRrw2vWtkvNn1msGDi7KxBnMo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-500-wJovBoyIO-2wYbRPY61j2w-1; Mon, 24 Aug 2020 12:51:58 -0400
X-MC-Unique: wJovBoyIO-2wYbRPY61j2w-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0FD3B1DE1A;
        Mon, 24 Aug 2020 16:51:57 +0000 (UTC)
Received: from liberator.sandeen.net (ovpn04.gateway.prod.ext.phx2.redhat.com [10.5.9.4])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CE23A69CA3;
        Mon, 24 Aug 2020 16:51:56 +0000 (UTC)
Subject: [PATCH 2/2 V2] xfs_db: consolidate set_iocur_type() behavior
From:   Eric Sandeen <sandeen@redhat.com>
To:     linux-xfs@vger.kernel.org
References: <8b1ab1c4-64f6-5410-bf40-30776dae4dd5@redhat.com>
 <8062b2d0-3fbb-0240-d5dd-c7bfb452f0b3@redhat.com>
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>
Message-ID: <bf4a939b-d02b-a916-62e0-e24b967eff38@redhat.com>
Date:   Mon, 24 Aug 2020 11:51:56 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.1.1
MIME-Version: 1.0
In-Reply-To: <8062b2d0-3fbb-0240-d5dd-c7bfb452f0b3@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Right now there are 3 cases to type_f(): inode type, type with fields,
and a default. The first two were added to address issues with handling
V5 metadata.

The first two already use some version of set_cur(), which handles all
of the validation etc. There's no reason to leave the open-coded bits
at the end, just send every non-inode type through set_cur() and be
done with it.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

V2: Drop unused *bp var declaration
    un-indent/un-else the non-inode code

diff --git a/db/io.c b/db/io.c
index 884da599..b8cb767e 100644
--- a/db/io.c
+++ b/db/io.c
@@ -586,7 +586,7 @@ void
 set_iocur_type(
 	const typ_t	*type)
 {
-	struct xfs_buf	*bp = iocur_top->bp;
+	int 		bb_count = 1;	/* type's size in basic blocks */
 
 	/*
 	 * Inodes are special; verifier checks all inodes in the chunk, the
@@ -607,29 +607,10 @@ set_iocur_type(
 	}
 
 	/* adjust buffer size for types with fields & hence fsize() */
-	if (type->fields) {
-		int bb_count;	/* type's size in basic blocks */
-
+	if (type->fields)
 		bb_count = BTOBB(byteize(fsize(type->fields,
-					       iocur_top->data, 0, 0)));
-		set_cur(type, iocur_top->bb, bb_count, DB_RING_IGN, NULL);
-	}
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
+				       iocur_top->data, 0, 0)));
+	set_cur(type, iocur_top->bb, bb_count, DB_RING_IGN, NULL);
 }
 
 static void


