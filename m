Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8CD4C433E0
	for <linux-xfs@archiver.kernel.org>; Wed, 24 Mar 2021 01:08:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B39CA619EC
	for <linux-xfs@archiver.kernel.org>; Wed, 24 Mar 2021 01:08:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233642AbhCXBHm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 23 Mar 2021 21:07:42 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:40966 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233946AbhCXBHK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 23 Mar 2021 21:07:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616548029;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tkFDrcyglR2qPwXLDl3h+PSFANN06x2maUnhV0kW3IU=;
        b=Hi+gmsnjhXn3bGwvkzC+PSgJMlBPsY8DwP/yi2uURCbvGW2ooCW/njYMhqUCs1YY1hlC6Z
        R8KRJNioQQ1+bfw8eLnY76Vi/LxAyxgen0zXgKbSex6M5+DQccPMAXgJe3dDnOlHSF2mBU
        wvnydeKYzTddz/Yn1eMlBXWrNsWap1M=
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com
 [209.85.214.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-16-AmC51FCrOManQvDA0jyWBg-1; Tue, 23 Mar 2021 21:07:07 -0400
X-MC-Unique: AmC51FCrOManQvDA0jyWBg-1
Received: by mail-pl1-f197.google.com with SMTP id 17so54002plj.1
        for <linux-xfs@vger.kernel.org>; Tue, 23 Mar 2021 18:07:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=tkFDrcyglR2qPwXLDl3h+PSFANN06x2maUnhV0kW3IU=;
        b=tzgR/CGYnpDizZZWNiqzTHNFpVh6FnuvTmZ9SwI7X7GQKoQ8oDBBAaLcclmg+kBXqw
         6BJ6Jg0isnB1PhaSOMBErmQp3S6sob+MX+sMmbAVb9NlIGnfs8Tpkx6b2Qoq/iMaduqc
         Z3MHY6sF9/NEprTkaW19EeqHCYbKjcjymx6W3DQdeuhQbH/ySsDF3cROAEolGFsMZy2p
         sZr6q5WJMn79M0iSWbKjEd8Zkf8NjfiK4HQEbxtdGepiKRxdjGIR+Ip7e/30qh1Wakt0
         xl/2YfeWmncz5oTmeJA4qBeIx+RtmDQNNQxxvwiYCvqz0A4vD5oYTIFXuhRnlu2DyN0U
         6+FQ==
X-Gm-Message-State: AOAM533bqrkT3VZLElYCadBsuZN9nV9okLGMSf2G9E7rvQQ+95cHBTE9
        c6/eRZnoILFhyR0uGiBAwpWtiWvdq8zpYxHDcpBVKUuvKfAiWlLb8uiqcOYH3/yYmwqHQsHHV8w
        a/KEYYgRXrMYbOjEvdRoVJmcLyFZ57EMaCwBDHAh+KLO5ceyNRGoQfxx4xB1pDifZX+kw7e2Jdg
        ==
X-Received: by 2002:a17:90a:f68a:: with SMTP id cl10mr751677pjb.87.1616548026084;
        Tue, 23 Mar 2021 18:07:06 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwlveWDqWbb3iRCDA7gF2WJKbv0xtTtyQxBlHuOAfW6wGmQWeFqKEAkwtjPshmZswgTYN3DfQ==
X-Received: by 2002:a17:90a:f68a:: with SMTP id cl10mr751649pjb.87.1616548025820;
        Tue, 23 Mar 2021 18:07:05 -0700 (PDT)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id t18sm379219pgg.33.2021.03.23.18.07.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Mar 2021 18:07:05 -0700 (PDT)
From:   Gao Xiang <hsiangkao@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     "Darrick J. Wong" <djwong@kernel.org>,
        Brian Foster <bfoster@redhat.com>,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@lst.de>,
        Eric Sandeen <sandeen@sandeen.net>,
        Gao Xiang <hsiangkao@redhat.com>
Subject: [PATCH v9 1/5] xfs: update lazy sb counters immediately for resizefs
Date:   Wed, 24 Mar 2021 09:06:17 +0800
Message-Id: <20210324010621.2244671-2-hsiangkao@redhat.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210324010621.2244671-1-hsiangkao@redhat.com>
References: <20210324010621.2244671-1-hsiangkao@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

sb_fdblocks will be updated lazily if lazysbcount is enabled,
therefore when shrinking the filesystem sb_fdblocks could be
larger than sb_dblocks and xfs_validate_sb_write() would fail.

Even for growfs case, it'd be better to update lazy sb counters
immediately to reflect the real sb counters.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
---
 fs/xfs/xfs_fsops.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index a2a407039227..9f9ba8bd0213 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -128,6 +128,15 @@ xfs_growfs_data_private(
 				 nb - mp->m_sb.sb_dblocks);
 	if (id.nfree)
 		xfs_trans_mod_sb(tp, XFS_TRANS_SB_FDBLOCKS, id.nfree);
+
+	/*
+	 * Sync sb counters now to reflect the updated values. This is
+	 * particularly important for shrink because the write verifier
+	 * will fail if sb_fdblocks is ever larger than sb_dblocks.
+	 */
+	if (xfs_sb_version_haslazysbcount(&mp->m_sb))
+		xfs_log_sb(tp);
+
 	xfs_trans_set_sync(tp);
 	error = xfs_trans_commit(tp);
 	if (error)
-- 
2.27.0

