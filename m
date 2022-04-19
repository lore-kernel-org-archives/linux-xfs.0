Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E82EC433F5
	for <linux-xfs@archiver.kernel.org>; Tue, 19 Apr 2022 18:01:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241166AbiDSSDu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 19 Apr 2022 14:03:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238961AbiDSSDr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 19 Apr 2022 14:03:47 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 989D2230
        for <linux-xfs@vger.kernel.org>; Tue, 19 Apr 2022 11:01:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1650391263;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=EnHtAHzHbAks/N/ls8V2G38/2H+Z5ACM/biC9RLEzUo=;
        b=dsAbUOuU/it37J2iBmaMydQzWRACSSeYmgddIENN8IYWWdqNl6sP2JuVuUfweWSRwlpcSf
        KmCb+8qZ2o4dA++qAjrvuJUr16UGZk3JwjEu6nm8X7wzPTotrqjh+YKYolXNwhpGDJZg8+
        vcibPgf0CrtWo6IjIXtqTLLjI9VANTs=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-416-zCJWcOBDOvuQFdb1RDjkCw-1; Tue, 19 Apr 2022 14:01:02 -0400
X-MC-Unique: zCJWcOBDOvuQFdb1RDjkCw-1
Received: by mail-ej1-f70.google.com with SMTP id x2-20020a1709065ac200b006d9b316257fso6377203ejs.12
        for <linux-xfs@vger.kernel.org>; Tue, 19 Apr 2022 11:01:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=EnHtAHzHbAks/N/ls8V2G38/2H+Z5ACM/biC9RLEzUo=;
        b=E38f08q8whEiemulYn1EvODkZkueaiS1y/mE7VYBotVsQNYu/7/+zGB0vX7gH4gROl
         qWUGra/0MIO5kfhdrsuvMV5BzSlFLmbZ1lIqPGJWGrSvzn7HTLvi2Y51S/H4dQF5tyLM
         EROXVX++WKhWQZ++qwYlT1hLJkH/szmaWEPBsZEXhi9HZRvw5LXVKD+TEKIdmcF2o5zT
         BTo/s5TRCeufmk6HqrWZGpPqQYX+K+zqClwcmclCs4/RiLMkmboJj1GAl4zN+2h2S++N
         xyNUXNbgk28c1ELQ0H/fnwA8yx5VKH5EBY0akKAZLGkDSckyXEcn4TD7qR/vD2K6tzFR
         U1Ug==
X-Gm-Message-State: AOAM533uuy/XDYr6omGKrOe3tdCLaMzMVphIru3NxW2BhhDc3nwpPkSs
        9KLMC8DzHIq40rdbLq8snccGBwVX3/1IOYv1muv9zriBGgpqyXyFJYmddBrthQGrimXNqCGhYFo
        nGZGKvugOnqTXvrJ1x3wncOoKQyDK/SL4s+MKI1RjVWH/DeQnUfJ7KUAZyTqx3ucnD02paKI=
X-Received: by 2002:a17:907:7f8d:b0:6db:7227:daea with SMTP id qk13-20020a1709077f8d00b006db7227daeamr14382570ejc.100.1650391261072;
        Tue, 19 Apr 2022 11:01:01 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzTCGDSvci1P/lGAt8213pZPY+/GeK3gUckId9fDYB4fx/akaObRmbFme5TYOlwZ/DBC4J+Pw==
X-Received: by 2002:a17:907:7f8d:b0:6db:7227:daea with SMTP id qk13-20020a1709077f8d00b006db7227daeamr14382552ejc.100.1650391260803;
        Tue, 19 Apr 2022 11:01:00 -0700 (PDT)
Received: from aalbersh.remote.csb ([109.183.6.197])
        by smtp.gmail.com with ESMTPSA id g21-20020a056402115500b00413c824e422sm8744195edw.72.2022.04.19.11.00.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Apr 2022 11:01:00 -0700 (PDT)
From:   Andrey Albershteyn <aalbersh@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     Andrey Albershteyn <aalbersh@redhat.com>
Subject: [PATCH v2] xfs_db: take BB cluster offset into account when using 'type' cmd
Date:   Tue, 19 Apr 2022 20:00:39 +0200
Message-Id: <20220419180038.116805-1-aalbersh@redhat.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Changing the interpretation type of data under the cursor moves the
cursor to the beginning of BB cluster. When cursor is set to an
inode the cursor is offset in BB buffer. However, this offset is not
considered when type of the data is changed - the cursor points to
the beginning of BB buffer. For example:

$ xfs_db -c "inode 131" -c "daddr" -c "type text" \
	-c "daddr" /dev/sdb1
current daddr is 131
current daddr is 128

Signed-off-by: Andrey Albershteyn <aalbersh@redhat.com>
---
Changes from V1:
- Refactor set_cur_boff() into separate funciton
---
 db/io.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/db/io.c b/db/io.c
index df97ed91..5aec31de 100644
--- a/db/io.c
+++ b/db/io.c
@@ -73,6 +73,13 @@ io_init(void)
 	add_command(&ring_cmd);
 }
 
+static inline void set_cur_boff(int off)
+{
+	iocur_top->boff = off;
+	iocur_top->off = ((xfs_off_t)iocur_top->bb << BBSHIFT) + off;
+	iocur_top->data = (void *)((char *)iocur_top->buf + off);
+}
+
 void
 off_cur(
 	int	off,
@@ -81,10 +88,8 @@ off_cur(
 	if (iocur_top == NULL || off + len > BBTOB(iocur_top->blen))
 		dbprintf(_("can't set block offset to %d\n"), off);
 	else {
-		iocur_top->boff = off;
-		iocur_top->off = ((xfs_off_t)iocur_top->bb << BBSHIFT) + off;
+		set_cur_boff(off);
 		iocur_top->len = len;
-		iocur_top->data = (void *)((char *)iocur_top->buf + off);
 	}
 }
 
@@ -589,6 +594,7 @@ set_iocur_type(
 	const typ_t	*type)
 {
 	int		bb_count = 1;	/* type's size in basic blocks */
+	int		boff = iocur_top->boff;
 
 	/*
 	 * Inodes are special; verifier checks all inodes in the chunk, the
@@ -613,6 +619,7 @@ set_iocur_type(
 		bb_count = BTOBB(byteize(fsize(type->fields,
 				       iocur_top->data, 0, 0)));
 	set_cur(type, iocur_top->bb, bb_count, DB_RING_IGN, NULL);
+	set_cur_boff(boff);
 }
 
 static void
-- 
2.27.0

