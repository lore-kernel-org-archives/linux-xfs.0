Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53A59C54E5B
	for <linux-xfs@archiver.kernel.org>; Tue, 14 Nov 2023 20:02:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232345AbjKNUCD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 14 Nov 2023 15:02:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232277AbjKNUCD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 14 Nov 2023 15:02:03 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0656B7
        for <linux-xfs@vger.kernel.org>; Tue, 14 Nov 2023 12:01:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1699992119;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=kNLO6YqL2XQYNApYB4SvjQxGmPPiJvSTM0qf/sZLc5s=;
        b=R8WD92J21iEu0BjXuZRgCrqri/CfunHvEpiugDZ4cjuTIFEk/8wSPeyjAmE0tMRxx0rRw9
        EKURxbvRANPYJeih7kpMl7bUfSCpUNamtYVgRskgKM/HSvN7PxLwUtX90H7YjbNWYHsspg
        cw/bDs/pUTIAFOE9i3AkcKFXYfrkAJI=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-602-DSRDz_uiM1Si65xwjBTTFA-1; Tue, 14 Nov 2023 15:01:56 -0500
X-MC-Unique: DSRDz_uiM1Si65xwjBTTFA-1
Received: by mail-ed1-f72.google.com with SMTP id 4fb4d7f45d1cf-53df4385dccso4324120a12.0
        for <linux-xfs@vger.kernel.org>; Tue, 14 Nov 2023 12:01:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699992115; x=1700596915;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kNLO6YqL2XQYNApYB4SvjQxGmPPiJvSTM0qf/sZLc5s=;
        b=nM7GMLB/0+qRSdGPTUhoIx8pGllygWOJ7aYXCaQMF+E5dPqV7O4L2NW5gsR8jLu18O
         rKlk+PDyJR1Ib4p0fTGDjwY7vzzTpUgw6g3uwQ8NmriebuZ8HYcYiQM6Upffw6SwrZkm
         uZZwnMAHQGp1JvH3m/ROPLvv1rZCSHiCHr3kVINbEKIne3X78uXgTb5K15DSuwhMyHIn
         dtArUR9c3obma0Ed10rH2mxbFfNZyl6iob/V3lRLQ2CuKrhwKhP4qIuzXmVDA+dPSifj
         RamWr7LlG+sxLRWjIKWER6Dk7EMAKiByyAInSyXl3jTaAbyBk/YMjUVZ1GpC3XsbUt6o
         EYVA==
X-Gm-Message-State: AOJu0Yxk+n3vbgfeeEU+TamnoORENa6B0C2f9b9b1ioSdEF704okhxZZ
        ysBZmwbOXbaS1a+VlZ9ND2u4+4V2QqQJesh5dQSAPPv13y3k91GKG4I41ogvT+wKHi3s8a8EXgp
        CPZ+YL8j45vhzmAFqI3T/GX8CefXY6ej3ESGQUVRxKVvg7pTiEfI3onT6wk6Fl88dn9KgGw1UIf
        g1yRE=
X-Received: by 2002:aa7:c84d:0:b0:53e:1388:cb2e with SMTP id g13-20020aa7c84d000000b0053e1388cb2emr7318495edt.35.1699992115104;
        Tue, 14 Nov 2023 12:01:55 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGz0AfP1WXMnJgPFLAo5As2Pj3aB5faWoK7IVcHDb5X8m587HodqaYeZTmv1I/tIFPPjXedYA==
X-Received: by 2002:aa7:c84d:0:b0:53e:1388:cb2e with SMTP id g13-20020aa7c84d000000b0053e1388cb2emr7318477edt.35.1699992114613;
        Tue, 14 Nov 2023 12:01:54 -0800 (PST)
Received: from thinky.redhat.com ([109.183.6.197])
        by smtp.gmail.com with ESMTPSA id fd7-20020a056402388700b0053e07fe8d98sm5526277edb.79.2023.11.14.12.01.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Nov 2023 12:01:53 -0800 (PST)
From:   Andrey Albershteyn <aalbersh@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     djwong@kernel.org, david@fromorbit.com,
        Andrey Albershteyn <aalbersh@redhat.com>
Subject: [PATCH] xfs: reset XFS_ATTR_INCOMPLETE filter on node removal
Date:   Tue, 14 Nov 2023 21:01:17 +0100
Message-Id: <20231114200116.164007-1-aalbersh@redhat.com>
X-Mailer: git-send-email 2.40.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

In XFS_DAS_NODE_REMOVE_ATTR case, xfs_attr_mode_remove_attr() sets
filter to XFS_ATTR_INCOMPLETE. The filter is then reset in
xfs_attr_complete_op() if XFS_DA_OP_REPLACE operation is performed.

The filter is not reset though if XFS just removes the attribute
(args->value == NULL) with xfs_attr_defer_remove(). attr code goes
to XFS_DAS_DONE state.

Fix this by always resetting XFS_ATTR_INCOMPLETE filter. The replace
operation already resets this filter in anyway and others are
completed at this step hence don't need it.

Signed-off-by: Andrey Albershteyn <aalbersh@redhat.com>
---
 fs/xfs/libxfs/xfs_attr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index e28d93d232de..79ff633ad63d 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -421,8 +421,8 @@ xfs_attr_complete_op(
 	bool			do_replace = args->op_flags & XFS_DA_OP_REPLACE;
 
 	args->op_flags &= ~XFS_DA_OP_REPLACE;
+	args->attr_filter &= ~XFS_ATTR_INCOMPLETE;
 	if (do_replace) {
-		args->attr_filter &= ~XFS_ATTR_INCOMPLETE;
 		return replace_state;
 	}
 	return XFS_DAS_DONE;
-- 
2.40.1

