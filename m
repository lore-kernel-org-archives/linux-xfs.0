Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39240ECAAA1
	for <linux-xfs@archiver.kernel.org>; Mon, 24 Oct 2022 18:41:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232156AbiJXSlA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 24 Oct 2022 14:41:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232159AbiJXSk3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Oct 2022 14:40:29 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E8691213CC
        for <linux-xfs@vger.kernel.org>; Mon, 24 Oct 2022 10:22:19 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id io19so4059078plb.8
        for <linux-xfs@vger.kernel.org>; Mon, 24 Oct 2022 10:22:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rfwpvweGi1Ucx8HQshpxviuI+RQIpmr8edZSxz2ZyS8=;
        b=cRHBNse3LDl7knerfXifthateEO5UMiwl8a2j41s/BW6mt9+2V3xiOBC2HFZioyyJH
         i+yc2YUJzK2L4RQsm7M3cbP6yJybDkXRaeZV/j2urLVjf0krimJh45HbXtqBVhQL1Iqq
         JmXAxZ1V4PIuXYnDklyo4doMEr87jbivpe/Vc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rfwpvweGi1Ucx8HQshpxviuI+RQIpmr8edZSxz2ZyS8=;
        b=TDHRXFEowQ/zf7QKPdDPQiDd8M18fcxd8AhxUeHPTSpPshqOJxAu3Y3GItzddeR5qV
         psDj5Xp/RxZiTVE10Ds7WgycDGcvaPkioIVuiK2aa8sIkGqpsPiMUJGoZQSSLl8jqjCz
         uH6nUS0Sn4jFFz3BKU0cRF2PGfIyUkk0xzln49jyk95aoigYTLgTP0EBT5EjUQlJUJOL
         OewX58SVc7eG/T7XD6AeqTF6EWp3TMFw2iW5A4J1FVilyTbxNR1/qZ6tCCzV/KH3/yQA
         /GR/etDxx5+1a/h992HeU49HQ9DzKmF7QsC1HiSnX/sKvtkapylaQhIDh3gyvvFf0Ii0
         0VHA==
X-Gm-Message-State: ACrzQf1ZDVPBd6pCWME0Y6DswTOuZRVdrVF5WmDEAqaUbD7Tzg/HsbyH
        axAePdirPwc1PTCbhOM2jz7o+Q==
X-Google-Smtp-Source: AMsMyM7PFXJJIVqkR6UWadHj6ls9b0femM8h8ZBqzJ3mOQ08s0OS0x6/s1Yef5s8sJBjNsSBl/joMw==
X-Received: by 2002:a17:903:2307:b0:181:e618:b4c5 with SMTP id d7-20020a170903230700b00181e618b4c5mr33087193plh.172.1666632060401;
        Mon, 24 Oct 2022 10:21:00 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id i188-20020a626dc5000000b0056262811c5fsm72421pfc.59.2022.10.24.10.20.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Oct 2022 10:20:59 -0700 (PDT)
From:   Kees Cook <keescook@chromium.org>
To:     "Darrick J . Wong" <djwong@kernel.org>
Cc:     Kees Cook <keescook@chromium.org>, Zorro Lang <zlang@redhat.com>,
        linux-xfs@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Keith Packard <keithp@keithp.com>,
        Francis Laniel <laniel_francis@privacyrequired.com>,
        Daniel Axtens <dja@axtens.net>,
        Dan Williams <dan.j.williams@intel.com>,
        Vincenzo Frascino <vincenzo.frascino@arm.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Tadeusz Struk <tadeusz.struk@linaro.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Andy Shevchenko <andriy.shevchenko@intel.com>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org
Subject: [PATCH 2/2] xfs: Use flex_cpy() to check extent copying
Date:   Mon, 24 Oct 2022 10:20:58 -0700
Message-Id: <20221024172058.534477-2-keescook@chromium.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221024171848.never.522-kees@kernel.org>
References: <20221024171848.never.522-kees@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1465; h=from:subject; bh=x7Rm68JdcafZ41E9GsTynBW1VglPIkAcCBWjMgC1XZs=; b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBjVsl5e3fUqEVHLRTWTi07FP0i2KlufVIIqNEwvzK+ yPgcmKOJAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCY1bJeQAKCRCJcvTf3G3AJpMWEA CCEj7newKc7qcVZhldSpFBK/EeIB9fXY4+iLuVdu3LFqPY13Hef3MaSmkB/Y4IRnNYMG1z40nYXPIX BRl9opcuI31xnN1rs9ZUql+0uHLhCbkvPekMurdx40/rXV8JSpfAawk6g/Hu4CzhhSEZPdV2BCmaA2 gPls9t3srVcaoPQcet6h5Vl878GD2tUPabyGLFzf2zrvkrYFuVG9Vcf8M6rzhWjAgTUrKXTOgGosnk yGdKK2sRbrNnAI3hLfunqyLQKTE2SM35KEak96gL9DDY4Yj+Jir7NkBast9okeDQfOYj3pfkyZyvVv yq3vnuORIfjZgdqMs/p+kv8pQKeOqwBTmplsuSM9xrTvOT1ElTE4P2+4hKNvRivsAlyme/BYPaUdW/ sUfyLqIoCWWsRNTtJ1BkJsPqnHMTxkelyCDmn5xTuYv+GAbx/2UG13vPbNvmJUPLxYTw+YeksRdUYl ZrMgfde6Ifb4yzbsuerEt/fkpd6/85Y7vJ4vf/GtZOdVt/QN4BDxlETGpas8pgV+Bs4tqMNFPpHRHm eFd8JmG9/qGYmtuaMepu/Rn7zhnwIYUevSDwoH+OanWEGdftSxXaQyEO28EEoMYEGbyWDTqkz04/4O zC5bLw/JhL8gPbVuJHIo7cu+CcKMc0HdtDfDGHW0LDUBdHrqREEUb2tKT8hw==
X-Developer-Key: i=keescook@chromium.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Use flex_cpy() instead of memcpy() to copy the bui_fmt flexible array
structure, which will perform bounds checking internally. Avoids the
false positive warning seen under FORTIFY_SOURCE:

  memcpy: detected field-spanning write (size 48) of single field "dst_bui_fmt" at fs/xfs/xfs_bmap_item.c:628 (size 16)

Reported-by: Zorro Lang <zlang@redhat.com>
Link: https://bugzilla.kernel.org/show_bug.cgi?id=216563
Cc: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 fs/xfs/xfs_bmap_item.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
index 51f66e982484..5f135893df66 100644
--- a/fs/xfs/xfs_bmap_item.c
+++ b/fs/xfs/xfs_bmap_item.c
@@ -24,6 +24,7 @@
 #include "xfs_error.h"
 #include "xfs_log_priv.h"
 #include "xfs_log_recover.h"
+#include <linux/flex_array.h>
 
 struct kmem_cache	*xfs_bui_cache;
 struct kmem_cache	*xfs_bud_cache;
@@ -624,10 +625,10 @@ xfs_bui_copy_format(
 	src_bui_fmt = buf->i_addr;
 	len = xfs_bui_log_format_sizeof(src_bui_fmt->bui_nextents);
 
-	if (buf->i_len == len) {
-		memcpy(dst_bui_fmt, src_bui_fmt, len);
+	if (buf->i_len == len &&
+	    __flex_cpy(dst_bui_fmt, src_bui_fmt,
+		       bui_extents, bui_nextents, __passthru) == 0)
 		return 0;
-	}
 	XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, NULL);
 	return -EFSCORRUPTED;
 }
-- 
2.34.1

