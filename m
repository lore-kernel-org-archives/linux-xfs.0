Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A356CA0EEB
	for <linux-xfs@archiver.kernel.org>; Tue, 12 Sep 2023 15:18:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236278AbjILPS4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 12 Sep 2023 11:18:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236276AbjILPSz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 12 Sep 2023 11:18:55 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 374E01BB
        for <linux-xfs@vger.kernel.org>; Tue, 12 Sep 2023 08:18:51 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id ffacd0b85a97d-31f7400cb74so4919637f8f.2
        for <linux-xfs@vger.kernel.org>; Tue, 12 Sep 2023 08:18:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1694531929; x=1695136729; darn=vger.kernel.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=wxJCnX9ULZJZ5EZ1+KhUGW2+yh2EzIqp3qUG+6odjo0=;
        b=wLRzgA0q66t1rXgnB/XT/MGaMLm1VOkSW++SfHAht+n5kkCtLfH4fh6Jn0PcWkq9iB
         2Iinak9AsgbZy5aNMgkfKfNpWYYyTFILQ7v6tD6DNpZOfKRXyCs8LO/ko/82ApKYRP1k
         2E8cnhrnsASXNf/ZZ9JuWstGwXuX1j2iENyUMzMxTEvBGW8uWE0QymdW1aIDm0qXKTfI
         2lURgVRcmtiqmWe8UiauVYKcZ9Rs/Oxhzt56ScFM6e5yzDHFTwV0nDFa1t2oIrsH5Ri7
         bmL4pODaqwqxQMmGI841qiG+do8222trgmfAeJ7QziIPqKp+dR+5Nx88mXJHY6upmfoe
         8v3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694531929; x=1695136729;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wxJCnX9ULZJZ5EZ1+KhUGW2+yh2EzIqp3qUG+6odjo0=;
        b=TkiG+H4sOhPXj+vSbI43h12naVmJeoeBr7hwa2it5q5z/zlRDXDNur6pmzuPa44JeF
         AGMdUGW3CwIciTylkmAtNKsoOZ7R4iSGPmIV12SmGKGzdRpGhgJVICUwEci5d95D0+Zf
         PGq8hM64kiX/KRN39JoVBeasmQb0nc9C+8FK5XKqG2uCD6iWmxzsqrqNq6MS5AWoUEiI
         o7fPp3EAkOdEK2UvV9Kb7r2rFP+7AFj1XJEvDfUc08GYsEy26nTMuQrqVEAaEOc1bqK+
         pTw9TJ+uEjQUW0bsinjLK6YQ0/MBXt4fEMtY23B6r7CcT6KOPTd0aq0LFbQfOKLGuT7o
         0REw==
X-Gm-Message-State: AOJu0YzVP8ANTjCdg1JXNh9qMoJxOsOweri4tJ1eoJr/baVTLSyNS4XV
        zdTxfKw+26zbzw/yIlMqxnkZDQ==
X-Google-Smtp-Source: AGHT+IG4G4EPJSBi08YRktht53x04eTCy4Xm66qjHNK8xF5mLb+PMtQt5HnUjbjnFd1cBboa+E7eNw==
X-Received: by 2002:a5d:4584:0:b0:317:5bb2:aeca with SMTP id p4-20020a5d4584000000b003175bb2aecamr10300996wrq.16.1694531929340;
        Tue, 12 Sep 2023 08:18:49 -0700 (PDT)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id ay21-20020a5d6f15000000b0031fbbe347e1sm1805881wrb.65.2023.09.12.08.18.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Sep 2023 08:18:48 -0700 (PDT)
Date:   Tue, 12 Sep 2023 18:18:45 +0300
From:   Dan Carpenter <dan.carpenter@linaro.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Chandan Babu R <chandan.babu@oracle.com>,
        Dave Chinner <dchinner@redhat.com>,
        Kent Overstreet <kent.overstreet@linux.dev>,
        linux-xfs@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH] xfs: delete some dead code in xfile_create()
Message-ID: <1429a5db-874d-45f4-8571-7854d15da58d@moroto.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The shmem_file_setup() function can't return NULL so there is no need
to check and doing so is a bit confusing.

Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
---
No fixes tag because this is not a bug, just some confusing code.

 fs/xfs/scrub/xfile.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/xfs/scrub/xfile.c b/fs/xfs/scrub/xfile.c
index d98e8e77c684..71779d81cad7 100644
--- a/fs/xfs/scrub/xfile.c
+++ b/fs/xfs/scrub/xfile.c
@@ -70,8 +70,6 @@ xfile_create(
 		return -ENOMEM;
 
 	xf->file = shmem_file_setup(description, isize, 0);
-	if (!xf->file)
-		goto out_xfile;
 	if (IS_ERR(xf->file)) {
 		error = PTR_ERR(xf->file);
 		goto out_xfile;
-- 
2.39.2

