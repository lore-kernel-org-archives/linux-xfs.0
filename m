Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BEB21C433F5
	for <linux-xfs@archiver.kernel.org>; Tue, 24 May 2022 22:05:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238937AbiEXWFT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 24 May 2022 18:05:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241099AbiEXWFS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 24 May 2022 18:05:18 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id DE50366222
        for <linux-xfs@vger.kernel.org>; Tue, 24 May 2022 15:05:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653429917;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IB48HDNMV1O0J2W8Uo4tfAHWDeNT5YlUZULP8ajEiVU=;
        b=Fn1Qk4GW2M83c57cg0vmxX+2/YJD4VTGvN3JR+bmElOwAhlLh7hPORnJkp1XGeU6jsB0Ct
        GNkTrOZyB5oYWwTyF4I2PE8NuUyWyNDlVppIHSMgW8v/sRVEqisp30vjE5KNUue75yu3xn
        vkN5MMYzFFlz0rS79NM2h4NvvQyUEgI=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-202-nXkla9XBPDWSgzTtyCtHLA-1; Tue, 24 May 2022 18:05:15 -0400
X-MC-Unique: nXkla9XBPDWSgzTtyCtHLA-1
Received: by mail-wm1-f70.google.com with SMTP id m9-20020a05600c4f4900b0039746692dc2so3453086wmq.6
        for <linux-xfs@vger.kernel.org>; Tue, 24 May 2022 15:05:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=IB48HDNMV1O0J2W8Uo4tfAHWDeNT5YlUZULP8ajEiVU=;
        b=ZlRwglJvaget3dVwhomD8veDYMWt31t+HVr9ckhxUTGr0CLJAcd9vzJlWINWi5JOp4
         F26rptrUyYjezR0iC5hgnsP/4CVUYb6CtDUeLlI9aNu6G02tfgq5aVHuG1fkAUaK9Z11
         eL2u0b5ITsuo8HNlRkNLGbbMHywGYRhBzwWpHrZaK+h/wDSL70uQPrT4LflgRrgbhkJx
         PZPe/rCjl3VDg2KBZDwA0m6az7d2Qv2I3EWpAdBw0dqc5CAHBeKDZRWhsqV9OdCE8GJw
         RDNESz8Fh8eqnbxlv9Kz2bjdRDYqT8EtowVniYb9ZCh2W3o8G4UxkU/9We9EnCVMziCq
         nEJg==
X-Gm-Message-State: AOAM531c6BGrbigXtGcmcRDFb5A5kUaBv740Zl9fDznsnFhivJSZPBXP
        HwtF2TIVn/3qSMU75hSTexJy6cpTq2gcR+XNJUKlz52TAjkwGT9Ux8M2ZNwoGM2LfPlkXCvQ7gB
        Ctbz+bc5xQBah5fSW60e1TXelmqYLkDOmjRImhyrc8QtulVo/sVPHu8eCDYW6Wjd/2brdFPc=
X-Received: by 2002:adf:f291:0:b0:20d:bc00:61d1 with SMTP id k17-20020adff291000000b0020dbc0061d1mr24603941wro.203.1653429914354;
        Tue, 24 May 2022 15:05:14 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxPT8K5+FQNVIjMnE/+ldPeMcGcDbBCjhPhZuaAvR+P05Z0mxsQNsGjhbkkYuH7dG0Yb1i57w==
X-Received: by 2002:adf:f291:0:b0:20d:bc00:61d1 with SMTP id k17-20020adff291000000b0020dbc0061d1mr24603928wro.203.1653429914025;
        Tue, 24 May 2022 15:05:14 -0700 (PDT)
Received: from localhost.localdomain.com (gw19-pha-stl-mmo-1.avonet.cz. [131.117.213.203])
        by smtp.gmail.com with ESMTPSA id c4-20020adfc6c4000000b0020e5d2a9d0bsm579885wrh.54.2022.05.24.15.05.12
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 May 2022 15:05:13 -0700 (PDT)
From:   Pavel Reichl <preichl@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v2 1/1] mkfs: Fix memory leak
Date:   Wed, 25 May 2022 00:05:09 +0200
Message-Id: <20220524220509.967287-2-preichl@redhat.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220524220509.967287-1-preichl@redhat.com>
References: <20220524220509.967287-1-preichl@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

'value' is allocated by strdup() in getstr(). It
needs to be freed as we do not keep any permanent
reference to it.

Signed-off-by: Pavel Reichl <preichl@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
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

