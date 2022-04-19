Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1A57C433F5
	for <linux-xfs@archiver.kernel.org>; Tue, 19 Apr 2022 12:20:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240032AbiDSMW7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 19 Apr 2022 08:22:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352313AbiDSMWp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 19 Apr 2022 08:22:45 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7E7E727FD9
        for <linux-xfs@vger.kernel.org>; Tue, 19 Apr 2022 05:20:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1650370802;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=xdYfGToT71M7N/nXacqoZaWqD9U2pikRlXpp8hkYqdc=;
        b=iLllHk6g5nE5jB2IcXkG1aZ9/p6Q2T2PwNecQCmJOyGcTn/Ab+XKcBokaK/bRg7zA9MG2i
        G2tmTVCMvc+KXgy2ETxU5pNhu7CEKwH72O0t91/igaPCXFMR4EjDs60cXe0xgtJLxc+L/i
        0kdHLh5QPD6z383p8wDKY6UvdCGiyrE=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-363-YqiG96b4PCGgF79qNKPWqg-1; Tue, 19 Apr 2022 08:20:01 -0400
X-MC-Unique: YqiG96b4PCGgF79qNKPWqg-1
Received: by mail-ej1-f71.google.com with SMTP id sh19-20020a1709076e9300b006e8b88cb88bso5893966ejc.4
        for <linux-xfs@vger.kernel.org>; Tue, 19 Apr 2022 05:20:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xdYfGToT71M7N/nXacqoZaWqD9U2pikRlXpp8hkYqdc=;
        b=v3LzSFSOVZlYTpPhJu5KvPzXtOzZILL9TEnzweSB3GsXGhhvWPMjarBWxauPBC5R0j
         arnKMZsGJ3OirBFlBCIXU7e/MPOwdycX6h3+3CWd6AHMJ3FdR+o7DqAj2zSSMzEo1GXP
         4rJ02b9ei/mJRJfRSYgWX8k3NGvGJS7PDj+VnLXgVf/w6kmiurV0UAN4CJnN2aH1Bt8e
         4dksOBcUA7hBzpybYWCrWtM+RePMdEFWC9jBVJ3ywdZY+lT3fjCSo964ivLg9a6uf2RE
         hhqYmtEmVb0ighZFb4nTfivya32t0NE+YVo/8Hvm9oJy4JtDsTIHa8un27lsLb/fDs18
         JlYg==
X-Gm-Message-State: AOAM531KrqzQNuArqopHle/OpEYXDD2cYDmD529eAYVImsL6F+xWdvRz
        y1XxS0le4ecX0g0mlxujoJt4W07V+wCjNwfN85PMOtQJbRm/FNrewuklI6LO67lRBBek7GrGtX2
        E3WSvHJssCy/OtRezch3DPeM2o4qjhmmBNF1ZCHBtk59W/e1yptVqdmv5W97j9SvdddXrJ68=
X-Received: by 2002:a17:907:6d8a:b0:6ef:f019:3793 with SMTP id sb10-20020a1709076d8a00b006eff0193793mr819161ejc.634.1650370800193;
        Tue, 19 Apr 2022 05:20:00 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwg0iK4hGu+pzHq2i5FgQd3K64B/twbJilIZUZCgUchkD5XbZk7ih4Jcv5u8cGdjPLRrb6vKg==
X-Received: by 2002:a17:907:6d8a:b0:6ef:f019:3793 with SMTP id sb10-20020a1709076d8a00b006eff0193793mr819142ejc.634.1650370799902;
        Tue, 19 Apr 2022 05:19:59 -0700 (PDT)
Received: from aalbersh.remote.csb ([109.183.6.197])
        by smtp.gmail.com with ESMTPSA id r29-20020a50c01d000000b00415fb0dc793sm8647616edb.47.2022.04.19.05.19.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Apr 2022 05:19:59 -0700 (PDT)
From:   Andrey Albershteyn <aalbersh@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     Andrey Albershteyn <aalbersh@redhat.com>
Subject: [PATCH] xfs_db: take BB cluster offset into account when using 'type' cmd
Date:   Tue, 19 Apr 2022 14:19:51 +0200
Message-Id: <20220419121951.50412-1-aalbersh@redhat.com>
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
 db/io.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/db/io.c b/db/io.c
index df97ed91..107f2e11 100644
--- a/db/io.c
+++ b/db/io.c
@@ -589,6 +589,7 @@ set_iocur_type(
 	const typ_t	*type)
 {
 	int		bb_count = 1;	/* type's size in basic blocks */
+	int boff = iocur_top->boff;
 
 	/*
 	 * Inodes are special; verifier checks all inodes in the chunk, the
@@ -613,6 +614,9 @@ set_iocur_type(
 		bb_count = BTOBB(byteize(fsize(type->fields,
 				       iocur_top->data, 0, 0)));
 	set_cur(type, iocur_top->bb, bb_count, DB_RING_IGN, NULL);
+	iocur_top->boff = boff;
+	iocur_top->off = ((xfs_off_t)iocur_top->bb << BBSHIFT) + boff;
+	iocur_top->data = (void *)((char *)iocur_top->buf + boff);
 }
 
 static void
-- 
2.27.0

