Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01AB8C433FE
	for <linux-xfs@archiver.kernel.org>; Fri, 14 Oct 2022 07:59:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229470AbiJNH7L (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 14 Oct 2022 03:59:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229614AbiJNH7J (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 14 Oct 2022 03:59:09 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD54F317D7
        for <linux-xfs@vger.kernel.org>; Fri, 14 Oct 2022 00:59:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1665734347;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UaKxwXZs5j3I47+jfA+D9uXp42ETQG8kiqYPq0Jybsk=;
        b=eZ6irP7otudFm24n5mLrMAOPEfTacTRUaYJOeVusK2WcrS2H+coiv416B0e+1PDAn6pAjp
        wG3Tr3QF1O1m3/HrRTKGuC7FcODKtK3cVjlP786CclX4FMJv5rfbUzeNg2r36g/HfBsRif
        JfCF5eDiTo3Hm53EyD3YJs/7UVqx3MA=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-158-EYxmsBSMO-KmPZcMciXSYQ-1; Fri, 14 Oct 2022 03:59:06 -0400
X-MC-Unique: EYxmsBSMO-KmPZcMciXSYQ-1
Received: by mail-pl1-f198.google.com with SMTP id u5-20020a170902e80500b00178944c46aaso2858657plg.4
        for <linux-xfs@vger.kernel.org>; Fri, 14 Oct 2022 00:59:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UaKxwXZs5j3I47+jfA+D9uXp42ETQG8kiqYPq0Jybsk=;
        b=N8eOsyzizwpmi/KKss5JxFnN2lNpIH4USlnbmnsSTKfLMeW1eIMQ4VofimtE9vAGXh
         bx0i5V5s7mb4lq3CPEWFSse+8/DlUkRAo+VkJGJG+0j8NCS0naW5nOnWXzlsF8X2Eryj
         JcYOssL2hYBNykiEkNoMzRHoRHzl+6QDkTl/fvcoe+EfO2+T3YGRDEHcUFCJojlNiyBn
         omJFX61azsnBzEbIFnR2kGxsc/SJj7XhqsROYJsfTet2ZlAMg7lMAXs9JLb0d8SEoyfL
         lywM2TBoBcdq01WNJ9WybHkQHz8Tw702P12Fya12NtzA4gL4SR6m815mqjolkK6CglsO
         flAA==
X-Gm-Message-State: ACrzQf0w87ls1Bx9EiggTghKIYC59H7K42BPex9YgqRv43v9YHPPzVpN
        z3BKDFi/hIw64psWkTq9tQG/yBPBqPI6kuNMzil2lErboeN5VO2+mtYl1pSAzPzO775e186eICw
        OQhFARDfq7APLL+ByE+m69fs3I/ngqc7VgKbEQ8NPpuyj6F0n9JIHZVkdlx+82rItZxGWEJAH
X-Received: by 2002:a63:18f:0:b0:43c:24d2:c0f7 with SMTP id 137-20020a63018f000000b0043c24d2c0f7mr3524261pgb.470.1665734345579;
        Fri, 14 Oct 2022 00:59:05 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM5WCaCWo+Gec2PQpMdMRSxTH53581SGgZgbJB3PdRVB8myG2BMlPLV08XsT0taKENWho/9tmA==
X-Received: by 2002:a63:18f:0:b0:43c:24d2:c0f7 with SMTP id 137-20020a63018f000000b0043c24d2c0f7mr3524243pgb.470.1665734345167;
        Fri, 14 Oct 2022 00:59:05 -0700 (PDT)
Received: from snowcrash.redhat.com ([2001:8003:4800:1b00:4c4a:1757:c744:923])
        by smtp.gmail.com with ESMTPSA id nn13-20020a17090b38cd00b0020b21019086sm8550382pjb.3.2022.10.14.00.59.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Oct 2022 00:59:04 -0700 (PDT)
From:   Donald Douwsma <ddouwsma@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     Donald Douwsma <ddouwsma@redhat.com>,
        "Darrick J . Wong" <djwong@kernel.org>
Subject: [PATCH 4/4] xfsrestore: untangle inventory unpacking logic
Date:   Fri, 14 Oct 2022 18:58:47 +1100
Message-Id: <20221014075847.2047427-5-ddouwsma@redhat.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20221014075847.2047427-1-ddouwsma@redhat.com>
References: <20221014075847.2047427-1-ddouwsma@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

stobj_unpack_sessinfo returns bool_t, fix logic in pi_addfile so errors
can be properly reported.

Signed-off-by: Donald Douwsma <ddouwsma@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 restore/content.c | 13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff --git a/restore/content.c b/restore/content.c
index b3999f9..04b6f81 100644
--- a/restore/content.c
+++ b/restore/content.c
@@ -5463,17 +5463,14 @@ pi_addfile(Media_t *Mediap,
 			 * desc.
 			 */
 			sessp = 0;
-			if (!buflen) {
-				ok = BOOL_FALSE;
-			} else {
-			    /* extract the session information from the buffer */
-			    if (stobj_unpack_sessinfo(bufp, buflen, &sessinfo)<0) {
-				ok = BOOL_FALSE;
-			    } else {
+			ok = BOOL_FALSE;
+			/* extract the session information from the buffer */
+			if (buflen &&
+			    stobj_unpack_sessinfo(bufp, buflen, &sessinfo)) {
 				stobj_convert_sessinfo(&sessp, &sessinfo);
 				ok = BOOL_TRUE;
-			    }
 			}
+
 			if (!ok || !sessp) {
 				mlog(MLOG_DEBUG | MLOG_WARNING | MLOG_MEDIA, _(
 				      "on-media session "
-- 
2.31.1

