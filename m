Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E93DFC32771
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Sep 2022 05:53:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232565AbiI1Fxg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 28 Sep 2022 01:53:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232444AbiI1Fxe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 28 Sep 2022 01:53:34 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADDCE10FE06
        for <linux-xfs@vger.kernel.org>; Tue, 27 Sep 2022 22:53:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1664344412;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Y/l9UaWGPB68wm4Fw0zTc+FCBEnme57qAi3sgvE4fNQ=;
        b=epa5/3vU0Pug0IRDMS/WYpCt+d4jS66z1THWRFa3IfXKKd1QnANQa5jXtN0VW5GWLYLQ02
        uwFU5e8qZS6OimBvcPEUYJ6AI9w9trHIkdEAsuEpxHmFsBGIYCPXaKSuyUXtcawQ5rgSY+
        DprdpB1HSEmSCNdxsSN/ESLG4vsyIA0=
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com
 [209.85.210.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-591-PGAlw5EJMnSToWXhteJSFQ-1; Wed, 28 Sep 2022 01:53:31 -0400
X-MC-Unique: PGAlw5EJMnSToWXhteJSFQ-1
Received: by mail-pf1-f200.google.com with SMTP id k19-20020a056a00135300b0054096343fc6so6964856pfu.10
        for <linux-xfs@vger.kernel.org>; Tue, 27 Sep 2022 22:53:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=Y/l9UaWGPB68wm4Fw0zTc+FCBEnme57qAi3sgvE4fNQ=;
        b=HGj+WpO6JYPICc+3mggdVC+TJWgnDpYQYLB2LOWgvBEzANKXblZt6L7rEY94HI+X/F
         pD0lI3L/RIxdCZh2HIf663IAvBG/bX9izDG0nbNYF5PBuoe3OOaNAGui0vMtOOv9f2of
         hDwZQm7gZ7AAGemL638A8/V3gMn9es9bgNL2ogm5n2P3Y3B/dG0feA61pWN+5QssDyt3
         uIN+5eJ3Ih+De7jrkhZscVpzLWMvJl6viED1jvjBO4WRT8y3nmjUGrbIaekSrWaNUNPk
         8stc5F/7X9YMr1htPIKEBE3ka+bwD2D5Hz3J6sYozfR9dk4UEeHcD4FR3ghIzgL0eiNW
         mqjg==
X-Gm-Message-State: ACrzQf1MsiBmxh2hTOBCXa6MyOl8KIsegB9lGp7zluYAnowpvfPVG4v+
        Eyw8wHPOLjciZ1bjyNi2xEhZymXhKtGP2ZMvLPQS14tD7OLUhJPR+2GL24e4GBBG327ezVHtmqY
        RecDGZN5vOq2h/EiOgMFhj5UGF/80bK6Hlo5wAjDLjGUNI0ed0ucxLtKbukH4By6BrklrsmRN
X-Received: by 2002:a65:538e:0:b0:434:aa53:2244 with SMTP id x14-20020a65538e000000b00434aa532244mr26837609pgq.343.1664344409730;
        Tue, 27 Sep 2022 22:53:29 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM4+8RItk1FtHqzFRS/e8CNAejVxa2vUBulf+nHw2SA5nd/jxoBCfxHsXB37uLj4eO1Etq2RJg==
X-Received: by 2002:a65:538e:0:b0:434:aa53:2244 with SMTP id x14-20020a65538e000000b00434aa532244mr26837592pgq.343.1664344409428;
        Tue, 27 Sep 2022 22:53:29 -0700 (PDT)
Received: from snowcrash.redhat.com ([2001:8003:4800:1b00:4c4a:1757:c744:923])
        by smtp.gmail.com with ESMTPSA id o129-20020a62cd87000000b005544229b992sm2912971pfg.22.2022.09.27.22.53.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Sep 2022 22:53:28 -0700 (PDT)
From:   Donald Douwsma <ddouwsma@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     Donald Douwsma <ddouwsma@redhat.com>
Subject: [PATCH 2/3] xfsrestore: stobj_unpack_sessinfo cleanup
Date:   Wed, 28 Sep 2022 15:53:06 +1000
Message-Id: <20220928055307.79341-3-ddouwsma@redhat.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220928055307.79341-1-ddouwsma@redhat.com>
References: <20220928055307.79341-1-ddouwsma@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

stobj_unpack_sessinfo should be the reverse of stobj_pack_sessinfo, make
this clearer with respect to the session header and streams processing.

signed-off-by: Donald Douwsma <ddouwsma@redhat.com>
---
 inventory/inv_stobj.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/inventory/inv_stobj.c b/inventory/inv_stobj.c
index 5075ee4..521acff 100644
--- a/inventory/inv_stobj.c
+++ b/inventory/inv_stobj.c
@@ -1065,25 +1065,26 @@ stobj_unpack_sessinfo(
 		return BOOL_FALSE;
 	}
 
+	/* get the seshdr and then, the remainder of the session */
 	xlate_invt_seshdr((invt_seshdr_t *)p, (invt_seshdr_t *)tmpbuf, 1);
 	bcopy(tmpbuf, p, sizeof(invt_seshdr_t));
-
-	/* get the seshdr and then, the remainder of the session */
 	s->seshdr = (invt_seshdr_t *)p;
 	s->seshdr->sh_sess_off = -1;
 	p += sizeof(invt_seshdr_t);
 
-
 	xlate_invt_session((invt_session_t *)p, (invt_session_t *)tmpbuf, 1);
 	bcopy (tmpbuf, p, sizeof(invt_session_t));
 	s->ses = (invt_session_t *)p;
 	p += sizeof(invt_session_t);
 
 	/* the array of all the streams belonging to this session */
-	xlate_invt_stream((invt_stream_t *)p, (invt_stream_t *)tmpbuf, 1);
-	bcopy(tmpbuf, p, sizeof(invt_stream_t));
 	s->strms = (invt_stream_t *)p;
-	p += s->ses->s_cur_nstreams * sizeof(invt_stream_t);
+	for (i = 0; i < s->ses->s_cur_nstreams; i++) {
+		xlate_invt_stream((invt_stream_t *)p, 
+				  (invt_stream_t *)tmpbuf, 1);
+		bcopy(tmpbuf, p, sizeof(invt_stream_t));
+		p += sizeof(invt_stream_t);
+	}
 
 	/* all the media files */
 	s->mfiles = (invt_mediafile_t *)p;
-- 
2.31.1

