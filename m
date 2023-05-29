Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98C9DC7EE23
	for <linux-xfs@archiver.kernel.org>; Mon, 29 May 2023 00:08:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230347AbjE2AIe (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 28 May 2023 20:08:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229634AbjE2AIe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 28 May 2023 20:08:34 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD7B1BD
        for <linux-xfs@vger.kernel.org>; Sun, 28 May 2023 17:08:32 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id d2e1a72fcca58-64d44b198baso1872068b3a.0
        for <linux-xfs@vger.kernel.org>; Sun, 28 May 2023 17:08:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1685318912; x=1687910912;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=G0n5f1L7Dbesh/QRK2OEoeqbxhiaRwsKTNbGaPGSSKo=;
        b=FgVNSuwQcEVFSJidEYNuY/LYWPftDvBryXtDA984L867UlqmigAm13BxPipJ6gxq/v
         G+clkYplV4NsN/g8lkddiX4w9Yd0Pq6hcNvSW65xQZX1c3BBnGwIyuXaCFMPV7x2+Mdf
         iKs3OftZn1VsW2fkrld0AzPh2ILTjkAvh8IJmuj2LjMJQ9iWXF0ylydFluQ+lV+3Cr7H
         SwXQjlC7yjCY5mFSUkl+iTqcMrfvwbeKjGqZoIklCdg9IgTQTTkDOrA0LZtKpJsFdiSW
         9Mv6cF9WXkgMLV1VMvj4CpDPQChaKst2KEPeXwTOIHORRl7R/Y2dz0YRAvlZLcpcEIv8
         GN+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685318912; x=1687910912;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=G0n5f1L7Dbesh/QRK2OEoeqbxhiaRwsKTNbGaPGSSKo=;
        b=drZdwl9j18eUbAmV919OfXVu0IWJFOYMBlR2gdh0oQEkO9p1RDtTrsJKcvK5zoHgvX
         i3elDU7VC68rf7sQBno28W1n5j+/B8KU98gjl35mjMjAsDNd2x7Kihet2lIZGXsItGO3
         ZQV307XM7yUjtqgS9QdHOkA4gge/VCpuaN2BAJGwP55t7hB6YNTeTMclvqBJ5PJkwhUj
         hK5BA86s/4xpNJqYormty559a3+pDC7tEQadF82XnvraZ02qXYqk4zRcgPAxdD9rw1NW
         qCM/2HDosOyQSnW2AHX6Y+Zd6q6Qe7Md/SY/pL0bmpjjwyWIypUAjcynh+SY7sMfqGpE
         Elow==
X-Gm-Message-State: AC+VfDxfTrJ6V2AOgQFK+mTANmZLtEagkzMNzflPpPFlfD1FS2uBUGSs
        hFoTbcdYZ67ZbP/kccetKXd8hsF01vHiGDUzm5E=
X-Google-Smtp-Source: ACHHUZ5mjxqbeR/Q9Q0Pcc9uLyinQQzIRBdFoFG1bmiCnI3iR5w2a5B7Du4hDaEhe42j5CTGGTs4zw==
X-Received: by 2002:a05:6a00:1586:b0:648:a518:4ac6 with SMTP id u6-20020a056a00158600b00648a5184ac6mr6764946pfk.14.1685318912268;
        Sun, 28 May 2023 17:08:32 -0700 (PDT)
Received: from dread.disaster.area (pa49-179-0-188.pa.nsw.optusnet.com.au. [49.179.0.188])
        by smtp.gmail.com with ESMTPSA id b189-20020a6367c6000000b00530704f3a53sm5915721pgc.30.2023.05.28.17.08.30
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 May 2023 17:08:31 -0700 (PDT)
Received: from [192.168.253.23] (helo=devoid.disaster.area)
        by dread.disaster.area with esmtp (Exim 4.96)
        (envelope-from <dave@fromorbit.com>)
        id 1q3QR2-005761-2l
        for linux-xfs@vger.kernel.org;
        Mon, 29 May 2023 10:08:28 +1000
Received: from dave by devoid.disaster.area with local (Exim 4.96)
        (envelope-from <dave@devoid.disaster.area>)
        id 1q3QR2-00A6VW-1e
        for linux-xfs@vger.kernel.org;
        Mon, 29 May 2023 10:08:28 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 2/3] xfs: validity check agbnos on the AGFL
Date:   Mon, 29 May 2023 10:08:24 +1000
Message-Id: <20230529000825.2325477-3-david@fromorbit.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230529000825.2325477-1-david@fromorbit.com>
References: <20230529000825.2325477-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

If the agfl or the indexing in the AGF has been corrupted, getting a
block form the AGFL could return an invalid block number. If this
happens, bad things happen. Check the agbno we pull off the AGFL
and return -EFSCORRUPTED if we find somethign bad.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_alloc.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index fd3293a8c659..643d17877832 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -2780,6 +2780,9 @@ xfs_alloc_get_freelist(
 	 */
 	agfl_bno = xfs_buf_to_agfl_bno(agflbp);
 	bno = be32_to_cpu(agfl_bno[be32_to_cpu(agf->agf_flfirst)]);
+	if (XFS_IS_CORRUPT(tp->t_mountp, !xfs_verify_agbno(pag, bno)))
+		return -EFSCORRUPTED;
+
 	be32_add_cpu(&agf->agf_flfirst, 1);
 	xfs_trans_brelse(tp, agflbp);
 	if (be32_to_cpu(agf->agf_flfirst) == xfs_agfl_size(mp))
-- 
2.40.1

