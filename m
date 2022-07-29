Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BFEE5C00144
	for <linux-xfs@archiver.kernel.org>; Fri, 29 Jul 2022 07:58:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235134AbiG2H56 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 29 Jul 2022 03:57:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235159AbiG2H54 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 29 Jul 2022 03:57:56 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FAC97E02A
        for <linux-xfs@vger.kernel.org>; Fri, 29 Jul 2022 00:57:55 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id pw15so3980177pjb.3
        for <linux-xfs@vger.kernel.org>; Fri, 29 Jul 2022 00:57:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc;
        bh=HmX196I3swVrZZOun875sKtwHkx2lPTFSURhsv6oFIk=;
        b=llR+P4oea4LoHfKkud0NaKUSr3gwndaZQDMltBB8hOX24e1STFNJyWsz2azCWx0HTA
         Uga4BPN4zf4nN9y/cF3W5Kc0i/B1tkEgPG/RfakkYDTF+9fOTcxwQKxdTa997uesx+oV
         t/6rKKbB+oxlSV7kbTlwbzhDLeJ0BIOQVHmfS/fGQuXAGOX0Bm76r+Cx2cDDfSfDq0EM
         iltC8I+7zkX9b6EfFmBgV3TMN6LYY8SikQd/n5lIvBvyixrJcc6rEakt+lS76bSf8wcm
         QUWO8X4GhVKoW0a/GcyxzMS2u4QP6dI4nky+HtWr1zmlBeVOxyPajbdMKnbtV1+Qn5GN
         xncg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=HmX196I3swVrZZOun875sKtwHkx2lPTFSURhsv6oFIk=;
        b=GvTi16nNnoHb8fluhAi1flURifHOBxW/JxChe6WEF/OTnALNwNhEDSoLxCynT76Ygc
         dGDAlsmvxvWLJ/prcaYYOWdaScrQT8WK/zATywnc8uKhO5EtQSHivjZbeJmKRleAi71p
         0tnuwkZT1SHpszyh4/TnPl1FP+LYz3OHncVbzG3FFDjNGXpjreCyxpo1NEcUPZS2YR7m
         LsekpOFAP9d8yf4lVJ1PWX15nyG4EZ0SMPH/K2HkATGMoWAhrHsBIzId5zjT0mZhG7bZ
         Q1YzyRBxSSA5JmqUbjTzCaWMW8DVei14wOes4g/2WgoNcbmdfuw5YSHbqe7S/Q7HjnFa
         GRfg==
X-Gm-Message-State: ACgBeo30l/eV6kXoF49Sh5ZJF4Eiiy6GWREyUL1GnszBjDEuEJCr2U2w
        Lgzr2/dLhGT0t68ippbEI+c=
X-Google-Smtp-Source: AA6agR6sEyzHSmNSFUQgpHszWMqZ/eeUNXCWQxi14ODbEeEeFZf1QZkhp3saPUvTHv8GQEBNYyEN7Q==
X-Received: by 2002:a17:90b:3c47:b0:1f2:feea:db9b with SMTP id pm7-20020a17090b3c4700b001f2feeadb9bmr2780673pjb.7.1659081474870;
        Fri, 29 Jul 2022 00:57:54 -0700 (PDT)
Received: from localhost.localdomain ([165.154.253.46])
        by smtp.gmail.com with ESMTPSA id b15-20020a170902d88f00b0016a565f3f34sm2732124plz.168.2022.07.29.00.57.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Jul 2022 00:57:54 -0700 (PDT)
From:   Stephen Zhang <starzhangzsd@gmail.com>
X-Google-Original-From: Stephen Zhang <zhangshida@kylinos.cn>
To:     sandeen@redhat.com, djwong@kernel.org, hch@lst.de
Cc:     zhangshida@kylinos.cn, starzhangzsd@gmail.com,
        linux-xfs@vger.kernel.org
Subject: [PATCH] libfrog: fix the if condition in xfrog_bulk_req_v1_setup
Date:   Fri, 29 Jul 2022 15:57:46 +0800
Message-Id: <20220729075746.1918783-1-zhangshida@kylinos.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

when scanning all inodes in each ag, hdr->ino serves as a iterator to
specify the ino to start scanning with.

After hdr->ino-- , we can get the last ino returned from the previous
iteration.

But there are cases that hdr->ino-- is pointless, that is,the case when
starting to scan inodes in each ag.

Hence the condition should be cvt_ino_to_agno(xfd, hdr->ino) ==0, which
represents the start of scan in each ag,
instead of hdr->ino ==0, which represents the start of scan in ag 0 only.

Signed-off-by: Stephen Zhang <zhangshida@kylinos.cn>
---
 libfrog/bulkstat.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/libfrog/bulkstat.c b/libfrog/bulkstat.c
index 195f6ea0..77a385bb 100644
--- a/libfrog/bulkstat.c
+++ b/libfrog/bulkstat.c
@@ -172,7 +172,7 @@ xfrog_bulk_req_v1_setup(
 	if (!buf)
 		return -errno;
 
-	if (hdr->ino)
+	if (cvt_ino_to_agno(xfd, hdr->ino))
 		hdr->ino--;
 	bulkreq->lastip = (__u64 *)&hdr->ino,
 	bulkreq->icount = hdr->icount,
-- 
2.25.1

