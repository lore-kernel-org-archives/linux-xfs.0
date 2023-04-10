Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3B6EC76196
	for <linux-xfs@archiver.kernel.org>; Mon, 10 Apr 2023 16:08:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229771AbjDJQIx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 10 Apr 2023 12:08:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229703AbjDJQIw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 10 Apr 2023 12:08:52 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFA44E74
        for <linux-xfs@vger.kernel.org>; Mon, 10 Apr 2023 09:08:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681142885;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=tKyrBwfd2oDcUs2lWJFq6u064SVhVNeOSwEIW7vUOn0=;
        b=cMkAykPuILHbVs9bEVEB90jrlTB8zQ+4BKto41xSXvRQ+qCfrEF/qCmWQ/DZzJ3w5v8x2N
        3cC8CswhffrPZD0gfSZvXiDhg/v8gHGrfKHujzUThyWBsq1PAS2ahY+EobxN3rgO0UaNSK
        O6fv+TWUdEkCUltrdrur2SczpaO3fiY=
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com
 [209.85.214.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-292-fstIEpD0PfK7pQVXXKNxOw-1; Mon, 10 Apr 2023 12:08:03 -0400
X-MC-Unique: fstIEpD0PfK7pQVXXKNxOw-1
Received: by mail-pl1-f200.google.com with SMTP id e4-20020a17090301c400b001a1aa687e4bso3395530plh.17
        for <linux-xfs@vger.kernel.org>; Mon, 10 Apr 2023 09:08:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681142881; x=1683734881;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tKyrBwfd2oDcUs2lWJFq6u064SVhVNeOSwEIW7vUOn0=;
        b=aKKOsxImRAjOEgjHcPS+2wDbcvBnr9bZVv8TT9Te+XHAKAES53Z4EkS0l2AApFLxhz
         pT/NRvbZgnDO85o3pzhZNHTK1qzlH0zrOKuvlpH8cuZ3Oy1cqY9JaVVTrY2rI0d0ZLmt
         9JASWcY7m//Gfee8XD7OP+TmDv/uxDLmT+/cDfogDCpIL7COhBFWq/y78UgAGuiGm36g
         qdWemhjIZ/7c2yHb/C1FnFaa+iV6d49ICuhVTeXDcxYoTkgLmwsgSRdoZS5F+ws2t3KQ
         4mttpA2WEo6+w5hCfTz4KA3toTUC9dG6tRnV8H/K4ix9NF7/CPq2Ml5kKdyzGAr3Ifyt
         TNIw==
X-Gm-Message-State: AAQBX9f8VgUeoy2kppU9a2/KWfdklRq/Qk5RCBbBY77YBtkI6aXfNS4R
        daTiXRpaSPYehQBiXMDxEx/0tV7/IT2pCwGFOgVIRNpPY8I0yx8Vu4dMGTUhgVpdUHyikVU0DTa
        6ZRWHYNjx4Ly502gsSrwcsylqe4If
X-Received: by 2002:a05:6a20:7a86:b0:e4:2a2c:869b with SMTP id u6-20020a056a207a8600b000e42a2c869bmr12067472pzh.36.1681142881291;
        Mon, 10 Apr 2023 09:08:01 -0700 (PDT)
X-Google-Smtp-Source: AKy350ZXeZrFMveM/HuIZlNvxfD4NqlUe/w1jLGkwF5Qj6WkdSiJUAg3vzTfi5sKD3AiJ/e//XOcYg==
X-Received: by 2002:a05:6a20:7a86:b0:e4:2a2c:869b with SMTP id u6-20020a056a207a8600b000e42a2c869bmr12067447pzh.36.1681142880863;
        Mon, 10 Apr 2023 09:08:00 -0700 (PDT)
Received: from zeus.elecom ([240b:10:83a2:bd00:6e35:f2f5:2e21:ae3a])
        by smtp.gmail.com with ESMTPSA id l14-20020a63da4e000000b005004919b31dsm3449040pgj.72.2023.04.10.09.07.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Apr 2023 09:08:00 -0700 (PDT)
From:   Ryosuke Yasuoka <ryasuoka@redhat.com>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        sandeen@sandeen.net, david@fromorbit.com,
        Ryosuke Yasuoka <ryasuoka@redhat.com>
Subject: [PATCH v2] xfs: Use for_each_perag_from() to iterate all available AGs
Date:   Tue, 11 Apr 2023 01:07:27 +0900
Message-Id: <20230410160727.3748239-1-ryasuoka@redhat.com>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

xfs_filestream_pick_ag() iterates all the available AGs when no
unassociated AGs are available by using for_each_perag_wrap().
To iterate all the available AGs, just use for_each_perag_from() instead.


This patch cleans up a code where xfs_filestream_pick_ag() iterates 
all the available AGs when no unassociated AGs are available.
Current implementation is using a for_each_perag_wrap() macro which
iterates all AGs from start_agno through wrap_agno, wraps to
restart_agno, and then iterates again toward to (start_agno - 1).
In this case, xfs_filestream_pick_ag() start to iterate from 0 and
does't need to wrap. Although passing 0 as start_agno to
for_each_perag_wrap() 
is not problematic, we have already a for_each_perag() macro family
which just iterates all AGs from 0 and doesn't wrap. Hense, I propose
to use for_each_perag() family simply.


Changes since v1 [1]:
Use for_each_perag_from() instead of for_each_perag() to clarify
where we are iterating from.

[1]:
https://lore.kernel.org/linux-xfs/CAHpthZrvhqh8O1HO7U_jVnaq9R9Ur=Yq2eWzjWfNx3ryDbnGPA@mail.gmail.com/T/#m5704d0409bec1ce5273be0d3860e8ad60e9886fd

Signed-off-by: Ryosuke Yasuoka <ryasuoka@redhat.com>
---
 fs/xfs/xfs_filestream.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_filestream.c b/fs/xfs/xfs_filestream.c
index 22c13933c8f8..29acd9f7d422 100644
--- a/fs/xfs/xfs_filestream.c
+++ b/fs/xfs/xfs_filestream.c
@@ -151,7 +151,8 @@ xfs_filestream_pick_ag(
 		 * grab.
 		 */
 		if (!max_pag) {
-			for_each_perag_wrap(args->mp, 0, start_agno, args->pag)
+			start_agno = 0;
+			for_each_perag_from(args->mp, start_agno, args->pag)
 				break;
 			atomic_inc(&args->pag->pagf_fstrms);
 			*longest = 0;
-- 
2.39.2

