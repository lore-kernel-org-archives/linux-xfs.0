Return-Path: <SRS0=FA12=W2=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BF30C3A59F
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Aug 2019 01:41:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 23844208C2
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Aug 2019 01:41:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="T5UsmuqO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726825AbfH3BlP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 29 Aug 2019 21:41:15 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:46371 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727139AbfH3BlP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Aug 2019 21:41:15 -0400
Received: by mail-pg1-f193.google.com with SMTP id m3so2598661pgv.13;
        Thu, 29 Aug 2019 18:41:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=/Lp6+wPpOLr+QBiQVP34X35aQP4sAer1yeUvbRho3WA=;
        b=T5UsmuqOFpHuAdyZzaXOpR+04JgvYjmBsGflC74rtgqqOGyLZDvtmkTMXnemun2joX
         YgtGwUgDEMXuCyLXBnEDOZEYWWd8xFxz/YnxKyZpp0Ss7dzuKzBEUo53xRd4+Dr+uDvs
         ck58yTFepfXbmsOhFwHO6XBVVUk8YXA6sW5g8t6tuwNArBkoQm0NWIjevhFhcFXf9hET
         Xd2jfjAN5V8jox3+CyQmRHyp0btS4wxXUME9w+KuL7aIL/aNq5Nj/p+wS10u/XJtDWtn
         kKKQ8NGK+N7/G31PJKepPShzFGT51zro8UbF0Y/ooETsSPPmOW5Tuhdl3Gq1mEWYstlI
         AUwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=/Lp6+wPpOLr+QBiQVP34X35aQP4sAer1yeUvbRho3WA=;
        b=HJB+rP+cCWwRotKx2C0P6eldupe/fhYc9M2KpObF4UABgSFjl90K6pt01IYdMWvx8R
         MLdAOS33gIuigGp4yI5NmwD7HknG2gDQsISFAXCWQfzCTHcm4W5Ht5ppIXaakP0tVkM7
         ArNZuFoxmemh+SawM8BqAKno//z6X4FYDyK2T079bOF5raW4E1xKH7TvAbHq51JFGC70
         JlqqOOCCRMQBbeWyncr8bGocnLOYesBUTfPzg7sm3FANw3Vua9G7GyeYmQQqcHlNCRDj
         s8WIRdvWtW/CHC/pDxjPEqliGTc7nI8cTmhNjlArq4LLo2xJzZHPyJ3FyRiFb8F8fqqu
         35Rw==
X-Gm-Message-State: APjAAAUaZDP7PZaZYRh6SZvDv3Rq4a4lDAITO4ChHgINwPtojddD20fn
        dgtmXeg/tfZ5HFzgRJsWl20=
X-Google-Smtp-Source: APXvYqy56Dojsx1uG8CmI2owUoO3zuSJKyuuHDcRiaTez1U9zNaQOO1K7i3PF+AyNn11MKaRIONcDA==
X-Received: by 2002:a63:290:: with SMTP id 138mr9984863pgc.402.1567129274662;
        Thu, 29 Aug 2019 18:41:14 -0700 (PDT)
Received: from LGEARND20B15 ([27.122.242.75])
        by smtp.gmail.com with ESMTPSA id t23sm4549984pfl.154.2019.08.29.18.41.12
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 29 Aug 2019 18:41:14 -0700 (PDT)
Date:   Fri, 30 Aug 2019 10:41:10 +0900
From:   Austin Kim <austindh.kim@gmail.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        austindh.kim@gmail.com
Subject: [PATCH] xfs: Use WARN_ON_ONCE for bailout mount-operation
Message-ID: <20190830014110.GA20651@LGEARND20B15>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

If the CONFIG_BUG is enabled, BUG is executed and then system is crashed.
However, the bailout for mount is no longer proceeding.

Using WARN_ON_ONCE rather than BUG can prevent this situation.

Signed-off-by: Austin Kim <austindh.kim@gmail.com>
---
 fs/xfs/xfs_mount.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 322da69..3ab2acf 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -214,7 +214,7 @@ xfs_initialize_perag(
 
 		spin_lock(&mp->m_perag_lock);
 		if (radix_tree_insert(&mp->m_perag_tree, index, pag)) {
-			BUG();
+			WARN_ON_ONCE(1);
 			spin_unlock(&mp->m_perag_lock);
 			radix_tree_preload_end();
 			error = -EEXIST;
-- 
2.6.2

