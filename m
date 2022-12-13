Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4DF7BC4332F
	for <linux-xfs@archiver.kernel.org>; Tue, 13 Dec 2022 17:31:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236210AbiLMRbC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 13 Dec 2022 12:31:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236311AbiLMRaj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 13 Dec 2022 12:30:39 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1417722BC4
        for <linux-xfs@vger.kernel.org>; Tue, 13 Dec 2022 09:29:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670952583;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=X7aOzaH8w1oPNGJxdFvZ299A/3LW0IWhj+uSH4co6uo=;
        b=LihQCsTZDU7bICQ4x8zfpsZZ6ThO63huTOH6R/a3G0IaK1KUlqZZaYBU/ldMa5XgPRH+KR
        KuxEfdr34RYB0p0JmaHKddrZlPwwWFn2ozNmWfXJJJ9yc3mT5Y44VoXqR54A3lQsLHciv5
        VGNKJ5d90zslDDgAnGcMhc1pKAgYbvg=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-42-zryZX5N5MW6pd6oxKoenOQ-1; Tue, 13 Dec 2022 12:29:42 -0500
X-MC-Unique: zryZX5N5MW6pd6oxKoenOQ-1
Received: by mail-ed1-f72.google.com with SMTP id y20-20020a056402271400b0046c9a6ec30fso7686359edd.14
        for <linux-xfs@vger.kernel.org>; Tue, 13 Dec 2022 09:29:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=X7aOzaH8w1oPNGJxdFvZ299A/3LW0IWhj+uSH4co6uo=;
        b=RWN6fFEqJAP6tzlh7F0oRLa60KnfRUAjLjdIJ2/AfyrpZ/zY4bV9fE/lvbAxAy6kcJ
         C4uV2egfEtWk4TpGNR+5OoaqJSDsZodReCGXlJof667h8/hAXVPkqhupsj3tAf/6kxoy
         argyfjzCOnbXjTsrHIUpbiSVDR5N+m0kk7Li8mAS8Aaa7u8VPgpBdyyoV5J0bE/eSNB8
         a4MOWJlFhBn/qcaVjoAPDfHXS1t+A8BmUozEl83tmw9DD7YhxYdmyRL/Xsz2wenpA+p1
         NlxJI+knzqpAkt++DnMaSsi4lAsI3OjmvlpBFblbN1xiqKF8igzzF3j7ZILHIg5pCrLN
         1EOw==
X-Gm-Message-State: ANoB5pnWi6uMDoy089yt/h2PhcV4y8xsAtTKt8SY/Rf97sVUK5zfjrPq
        sk3419JRIqmBfl+YcWj3csBzob6jOX6qvUrkCBi86bjrAqZr7Lh+b2fCYZmLLFohGp4zF6WmmJj
        R+Yd+aoIRtNvCmLHwnMx2e0sdT+sqiRiUa2ekpwBGRC3TNzntV+j9Gn0Jy2nB/FvJ08ITJJs=
X-Received: by 2002:aa7:d4d6:0:b0:46a:a94a:e424 with SMTP id t22-20020aa7d4d6000000b0046aa94ae424mr18886516edr.40.1670952580646;
        Tue, 13 Dec 2022 09:29:40 -0800 (PST)
X-Google-Smtp-Source: AA0mqf5aVRp2Bd9Ma/3Z+2HR9K9G5JRA0WyHS7yqf2ie0nMXqV9Ii28qX8GFd8o1XgjlG6pHoLu+qw==
X-Received: by 2002:aa7:d4d6:0:b0:46a:a94a:e424 with SMTP id t22-20020aa7d4d6000000b0046aa94ae424mr18886502edr.40.1670952580439;
        Tue, 13 Dec 2022 09:29:40 -0800 (PST)
Received: from aalbersh.remote.csb ([109.183.6.197])
        by smtp.gmail.com with ESMTPSA id ec14-20020a0564020d4e00b0047025bf942bsm1204187edb.16.2022.12.13.09.29.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Dec 2022 09:29:40 -0800 (PST)
From:   Andrey Albershteyn <aalbersh@redhat.com>
To:     linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc:     Andrey Albershteyn <aalbersh@redhat.com>
Subject: [RFC PATCH 02/11] pagemap: add mapping_clear_large_folios() wrapper
Date:   Tue, 13 Dec 2022 18:29:26 +0100
Message-Id: <20221213172935.680971-3-aalbersh@redhat.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20221213172935.680971-1-aalbersh@redhat.com>
References: <20221213172935.680971-1-aalbersh@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Add wrapper to clear mapping's large folio flag. This is handy for
disabling large folios on already existing inodes (e.g. future XFS
integration of fs-verity).

Signed-off-by: Andrey Albershteyn <aalbersh@redhat.com>
---
 include/linux/pagemap.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index bbccb40442224..63ca600bdf8f7 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -306,6 +306,11 @@ static inline void mapping_set_large_folios(struct address_space *mapping)
 	__set_bit(AS_LARGE_FOLIO_SUPPORT, &mapping->flags);
 }
 
+static inline void mapping_clear_large_folios(struct address_space *mapping)
+{
+	__clear_bit(AS_LARGE_FOLIO_SUPPORT, &mapping->flags);
+}
+
 /*
  * Large folio support currently depends on THP.  These dependencies are
  * being worked on but are not yet fixed.
-- 
2.31.1

