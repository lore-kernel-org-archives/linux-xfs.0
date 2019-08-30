Return-Path: <SRS0=FA12=W2=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AAD2AC3A5A3
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Aug 2019 05:37:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6BD5C21897
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Aug 2019 05:37:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OoqvZ/vU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725902AbfH3FhN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Aug 2019 01:37:13 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:39345 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725901AbfH3FhM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Aug 2019 01:37:12 -0400
Received: by mail-pg1-f196.google.com with SMTP id u17so2935699pgi.6;
        Thu, 29 Aug 2019 22:37:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=w7YEtGvCAOlZwrqQsoF3/LXuqZDGNstU9nE89n8+OrQ=;
        b=OoqvZ/vUxFI6labySN8wIMZm111YgA8EMKBCc/9d+kIVWKKSin8fyuSZnHLsWgLCew
         ucpeOlhTMWY/3XccH57aPaaRSUs/diAwe3Uq5tnKvbXz2YWI2XLJwYvjHYugLOL7dcJ5
         z2S2kVX3VITtcrRpOpGi7VBGg9/ni0MaTzvjHq+s4BVlghaZ42k7q2+v37oDlSj4vbgn
         ELIwuPI2Dy1pDMHiFEAUPGdDyX/KmZnFi5sAW3sW7ndbb1BTdrN9BEvy4VG/8Enz7sQt
         IqrOIk/goJQAIVCLOZ3JvQPylCAWWLjCOp2sOFDSS2+2yKrNw8WynGCl7eXDBZ+KDT18
         LeeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=w7YEtGvCAOlZwrqQsoF3/LXuqZDGNstU9nE89n8+OrQ=;
        b=VGFdsB8gFfBgrJwy7o1Hyj0R61tKsgN39mXGBwru/oG/VQMJvhVP+XRFl89P1LoHI+
         4btrbvq9+4WlH1Rb3QaLk601RWrY3AUn9/lnEzliz5sEQ+FJaqll/LsL0IWVqHONXLkn
         KwVrHn/tXe+XXuMBRnMlXNhffUO8AnimVKu19dmr9IlJZ80WG0AC1sCYxGxpl/e6XkOn
         d0Ix419XvfeKEsIqG4IDBaogKkK4UM7d6IZByCFuN+9+Wwbe0+ObvJMeDdR46GxW4iCL
         MkL+GTZGMAv+RFLgQLqi+TCOI5QUyhkJF0LTnMwjXTVF6YqqTim3CIjr3AUaUV5HCBmv
         NXcg==
X-Gm-Message-State: APjAAAVRVTP7urfnZui2N33YdkwMgc8kaE8mR4csu+GdZI4eDe8GyrmR
        6z2FdRqC4hzDsgZDKM+KTiZhalk90X8=
X-Google-Smtp-Source: APXvYqyvlY5W7ohXFLAalwW3xB8x2eN8NPb55vlospRd7LBCyNqXx91dMIigqQ9sWAOQd24JrosIeA==
X-Received: by 2002:a62:8344:: with SMTP id h65mr16090697pfe.85.1567143431949;
        Thu, 29 Aug 2019 22:37:11 -0700 (PDT)
Received: from LGEARND20B15 ([27.122.242.75])
        by smtp.gmail.com with ESMTPSA id e129sm11854174pfa.92.2019.08.29.22.37.10
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 29 Aug 2019 22:37:11 -0700 (PDT)
Date:   Fri, 30 Aug 2019 14:37:07 +0900
From:   Austin Kim <austindh.kim@gmail.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        austindh.kim@gmail.com
Subject: [PATCH] xfs: Initialize label array properly
Message-ID: <20190830053707.GA69101@LGEARND20B15>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

In case kernel stack variable is not initialized properly,
there is a risk of kernel information disclosure.

So, initialize 'char label[]' array with null characters.

Signed-off-by: Austin Kim <austindh.kim@gmail.com>
---
 fs/xfs/xfs_ioctl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 9ea5166..09b3bee 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -2037,7 +2037,7 @@ xfs_ioc_setlabel(
 	char			__user *newlabel)
 {
 	struct xfs_sb		*sbp = &mp->m_sb;
-	char			label[XFSLABEL_MAX + 1];
+	char			label[XFSLABEL_MAX + 1] = {0};
 	size_t			len;
 	int			error;
 
-- 
2.6.2

