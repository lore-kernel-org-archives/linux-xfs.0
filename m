Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27BAEC6FA82
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Sep 2022 05:53:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232444AbiI1Fxi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 28 Sep 2022 01:53:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232577AbiI1Fxh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 28 Sep 2022 01:53:37 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44A2910FE3D
        for <linux-xfs@vger.kernel.org>; Tue, 27 Sep 2022 22:53:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1664344415;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=u6YsUJgWpWHWDylv3uTVviDKms+FA4M/MxVzlBlS234=;
        b=COSRRYwURAxMWtwzHZeZYnGq45teXFOIcfKv5TOgCewBBHdN+vHdP8dNDffgnsyQ7YYHB2
        KKC782lA9bgRGc4MyDVaRvr7f55n9bn03xbd+pMv2dR0mPleHdxoHvkgk880oruTYKv+Pd
        0vC1fHmhcLTBbo8SQoN+1SPS2d15rKI=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-258-94NUBEERPbeMMnUKwn7TiA-1; Wed, 28 Sep 2022 01:53:33 -0400
X-MC-Unique: 94NUBEERPbeMMnUKwn7TiA-1
Received: by mail-pj1-f72.google.com with SMTP id a6-20020a17090abe0600b00200303ba903so754068pjs.2
        for <linux-xfs@vger.kernel.org>; Tue, 27 Sep 2022 22:53:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=u6YsUJgWpWHWDylv3uTVviDKms+FA4M/MxVzlBlS234=;
        b=BVZsVxmdAyJ76lnEmoX8mSdbKb0X1k51+PWwgjgQFcFkaCzkFAtbdfsRnbdstOJ0Io
         3jODCvW4Lzvgb+VqXmsMVfcte8zeGTBczxUjesTgdmQCAuGUEvAWRecPOT+vew3Q7AeT
         l1ZJWrise2t9/B+mXIhFe8lUA8pZwYp/4sANNu8eZE9fChfudxJXUtaepYxFon8ct9/S
         53bGhU4VOYuq7G3fZUxd8xZs0TMAiIwr1WaOjO+HhqJWpgsxBd9UC6RDLx01ot6Tkchj
         s+aqzd5wp3TqDtve/GlKeTUD7DHBrB+ZNZeGyvmK7M1aCCVlvHeLemHewOS8Ixm4Bj7Y
         ygJQ==
X-Gm-Message-State: ACrzQf2NIVQpXks7zj9JniNkqelkxFvOBKoEKSRFqXm0yGgJbHXa4swe
        g9kEe3l1bYwMBCwcuVsb0dkh36wAMVPK9KEJlLhmNKUJYCqX0KIuLtDASUm/j9s/SLMO0wLCJwb
        CDE/GTVGh4oqTz2rMmlAvw3QGYf6rHHpWkh/mPLtGoeNMHYHkFzXgHfNqRZeO7KZfZHOiO62W
X-Received: by 2002:a05:6a00:a04:b0:534:d8a6:40ce with SMTP id p4-20020a056a000a0400b00534d8a640cemr33191783pfh.15.1664344412501;
        Tue, 27 Sep 2022 22:53:32 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM5fMHdwVygrLAu39a5LTlGSOCBtnNrPtUa3EQgyRG70sMos89NVleF4b4PfxaR1yUkYqfrVYw==
X-Received: by 2002:a05:6a00:a04:b0:534:d8a6:40ce with SMTP id p4-20020a056a000a0400b00534d8a640cemr33191762pfh.15.1664344412137;
        Tue, 27 Sep 2022 22:53:32 -0700 (PDT)
Received: from snowcrash.redhat.com ([2001:8003:4800:1b00:4c4a:1757:c744:923])
        by smtp.gmail.com with ESMTPSA id o129-20020a62cd87000000b005544229b992sm2912971pfg.22.2022.09.27.22.53.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Sep 2022 22:53:31 -0700 (PDT)
From:   Donald Douwsma <ddouwsma@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     Donald Douwsma <ddouwsma@redhat.com>
Subject: [PATCH 3/3] xfsrestore: untangle inventory unpacking logic
Date:   Wed, 28 Sep 2022 15:53:07 +1000
Message-Id: <20220928055307.79341-4-ddouwsma@redhat.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220928055307.79341-1-ddouwsma@redhat.com>
References: <20220928055307.79341-1-ddouwsma@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

stobj_unpack_sessinfo returns bool_t, fix logic in pi_addfile so errors
can be properly reported.

signed-off-by: Donald Douwsma <ddouwsma@redhat.com>
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

