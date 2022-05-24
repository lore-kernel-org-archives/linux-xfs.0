Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0FFBC433F5
	for <linux-xfs@archiver.kernel.org>; Tue, 24 May 2022 20:40:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241566AbiEXUks (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 24 May 2022 16:40:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229503AbiEXUkr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 24 May 2022 16:40:47 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 344A86C57C
        for <linux-xfs@vger.kernel.org>; Tue, 24 May 2022 13:40:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653424846;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=aNbOrZ+GWQ+N10Dg73ZY9YNKV2uofFKROuO2G/j4+fs=;
        b=J/bkbXZCmdoONyZqDNW1omvWmxiWQyupXzrUmxaLYFViKuotSVGdiT/P+8Oiob3Q5Fd8Kb
        OZqfySPQ1lvJc3/K/JDB06Ghsf/Sfh3tHKmxRe8YT+VtEjx8yxD9fLI5r4Yu8BT3NjoH7N
        jsBPSpj0oK2NlZy+tdmri2FZWhTLj9E=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-35-9Yh3OIN4OGiQz4CWc0-W1g-1; Tue, 24 May 2022 16:40:44 -0400
X-MC-Unique: 9Yh3OIN4OGiQz4CWc0-W1g-1
Received: by mail-ej1-f70.google.com with SMTP id v13-20020a170906b00d00b006f51e289f7cso8283541ejy.19
        for <linux-xfs@vger.kernel.org>; Tue, 24 May 2022 13:40:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=aNbOrZ+GWQ+N10Dg73ZY9YNKV2uofFKROuO2G/j4+fs=;
        b=R0JYcYBeVEwYiOCpqCenDRyBRiNXfSW1EQcHRUtza0UKVHpFYqBzJdfSsLU2DwtZM0
         io0w06x1zlYte5xcXSNcG3ILI+e3086ehK5AwrMRwrGdibIY46W0LV2Zowls9fZmAr9l
         XWDpKjimjGuMTFZhIjLpHZa2GhWguYe2NukS15kmaU3tyEA7IKqtU7aspVtG4BZN0nxQ
         L0KNF8AWdcbdOEepZPBg7FWPetC9ab6eIJ5zbrSTWMltVmWHuCl7Nx463X4HtK5TnCfL
         qbHo9igRqHyvy+jn/D5GzkWmW+L8rYSpf8gMQMozN6ubdP54oVlvtUt6/9OphO8B988f
         761Q==
X-Gm-Message-State: AOAM5302sr1j9nNwc1Gf2Ql64umtSPrMsuA4yI+ZhoGvEnBzr8rzUbb9
        p+pad7Sk/xchMYIDjsqLvMX/kY78c84aApN4lcZnTShpIkx7KFkZazD0C9V5EVz71Nda6+PxB3R
        zcBv+6/8ISyqP2KR/wOrpoaySXWcIMPEqhgaIi6f+mj1rASTC1zTxcQVPqY4FVTUUbQTpqoU=
X-Received: by 2002:a17:907:1ca2:b0:6f7:f64:2788 with SMTP id nb34-20020a1709071ca200b006f70f642788mr25836045ejc.97.1653424843468;
        Tue, 24 May 2022 13:40:43 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJweiTLDI48CujDN4pITOMnrmzWRpStv4Ld3rhagCaOkKbiXruM+YoQOT8gRAacCCCtN0lqRow==
X-Received: by 2002:a17:907:1ca2:b0:6f7:f64:2788 with SMTP id nb34-20020a1709071ca200b006f70f642788mr25836027ejc.97.1653424843194;
        Tue, 24 May 2022 13:40:43 -0700 (PDT)
Received: from localhost.localdomain.com (gw19-pha-stl-mmo-1.avonet.cz. [131.117.213.203])
        by smtp.gmail.com with ESMTPSA id hy16-20020a1709068a7000b006f3ef214e27sm7490414ejc.141.2022.05.24.13.40.41
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 May 2022 13:40:42 -0700 (PDT)
From:   Pavel Reichl <preichl@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH] mkfs: Fix memory leak
Date:   Tue, 24 May 2022 22:40:40 +0200
Message-Id: <20220524204040.954138-1-preichl@redhat.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

'value' is allocated by strup() in getstr(). It
needs to be freed as we do not keep any permanent
reference to it.

Signed-off-by: Pavel Reichl <preichl@redhat.com>
---
 mkfs/xfs_mkfs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 01d2e8ca..a37d6848 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -1714,6 +1714,7 @@ naming_opts_parser(
 		} else {
 			cli->sb_feat.dir_version = getnum(value, opts, subopt);
 		}
+		free((char *)value);
 		break;
 	case N_FTYPE:
 		cli->sb_feat.dirftype = getnum(value, opts, subopt);
-- 
2.36.1

