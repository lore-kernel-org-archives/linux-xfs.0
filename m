Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C571C6FA82
	for <linux-xfs@archiver.kernel.org>; Sat, 10 Sep 2022 02:38:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229796AbiIJCiv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 9 Sep 2022 22:38:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229491AbiIJCiu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 9 Sep 2022 22:38:50 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEBCFF0A83
        for <linux-xfs@vger.kernel.org>; Fri,  9 Sep 2022 19:38:49 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id t3so3431837ply.2
        for <linux-xfs@vger.kernel.org>; Fri, 09 Sep 2022 19:38:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=tCZg1NS699l3g3L72xV4b7UJBf9E4aktwcPjQf4BBII=;
        b=atfcSFjB0T+5zzUqVLPDLXNMCO1INYCh2IH75EQ4AJSPg2vy0Q9JPNrbE37wNCwMDZ
         aKppw4VjK6cdFkrzGBIEztWLUMW4OivXjmpcPIQ2IB0hQ7ZX1IdxE0YhPyGDX26hfS9D
         14oVd1q5Ho8z0icO4thOCstyu10cTnsSQXQscSD9/2KXYshFhxLLvSRPAOORqLxxK/gA
         nBwdl1tJLpmdpWgzHtg1lP+o8Hfq7490BH+gIMe/nRBJHBvDfB8ofuK0PkBAplXIG+ot
         H2ajQi8IlziaM5GSGKF9896ji32UCUT9rlhyDxZwzGtuI5ltqDpw62+EhZyb8eCHUJMe
         SGuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=tCZg1NS699l3g3L72xV4b7UJBf9E4aktwcPjQf4BBII=;
        b=A7q91G3iy3WPIkc0EAVpf1Axq7qiJev2kPD1tJtWKlel8I6TcoWqm3lM5lCNwug3pI
         lkKACYQs0G3uJszYrzQaQLJYW9URCWlc/WUzWhac181iF3RA719IdMXyVQTGpHs9D1rO
         cjZilzEEaCQEtclOw6DbATBmeVzgnrlKjhA6u6/T8CMW1n1mkwq9X/6lQh/Id47DnOEH
         adCCguvgeMihIUCVPV4gGBCzFL/bwMP+ZG+S/Du+KORwQpfSEcLgWo/BGM0aKe1VzKRa
         RvlujDilNzshaRVm1DKsFA1V5IZLKPBOUmuatYu3sNRzp5zmgyK9G+cmQjHqCj156/XY
         Q4tQ==
X-Gm-Message-State: ACgBeo2V7agfnfkWeY6KQh1fQqzkK+coDhxYicpmlsSMtJ+68kb694wp
        n3juCPS1j2krGscoxAOJHWw=
X-Google-Smtp-Source: AA6agR67Vw9uFsCZoleVPhUq90rD5DNNS4npR78p1BYCd8cJUOiwZYbCDWxzarR6AvEffmCHxtvBdA==
X-Received: by 2002:a17:90a:fd8c:b0:200:8cf9:63f4 with SMTP id cx12-20020a17090afd8c00b002008cf963f4mr12500158pjb.201.1662777529044;
        Fri, 09 Sep 2022 19:38:49 -0700 (PDT)
Received: from localhost.localdomain ([165.154.253.46])
        by smtp.gmail.com with ESMTPSA id s9-20020a170902ea0900b0015e8d4eb26esm1132301plg.184.2022.09.09.19.38.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Sep 2022 19:38:48 -0700 (PDT)
From:   Stephen Zhang <starzhangzsd@gmail.com>
X-Google-Original-From: Stephen Zhang <zhangshida@kylinos.cn>
To:     djwong@kernel.org, dchinner@redhat.com, chandan.babu@oracle.com,
        yang.guang5@zte.com.cn
Cc:     zhangshida@kylinos.cn, starzhangzsd@gmail.com,
        linux-xfs@vger.kernel.org
Subject: [PATCH] xfs: eliminate the potential overflow risk in xfs_da_grow_inode_int
Date:   Sat, 10 Sep 2022 10:38:39 +0800
Message-Id: <20220910023839.3964539-1-zhangshida@kylinos.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The problem lies in the for-loop of xfs_da_grow_inode_int:
======
for(){
        nmap = min(XFS_BMAP_MAX_NMAP, count);
        ...
        error = xfs_bmapi_write(...,&mapp[mapi], &nmap);//(..., $1, $2)
        ...
        mapi += nmap;
}
=====
where $1 stands for the start address of the array,
while $2 is used to indicate the size of the array.

The array $1 will advanced by $nmap in each iteration after
the allocation of extents.
But the size $2 still remains constant, which is determined by
min(XFS_BMAP_MAX_NMAP, count).

Hence there is a risk of overflow when the remained space in
the array is less than $2.
So variablize the array size $2 correspondingly in each iteration
to eliminate the risk.

Signed-off-by: Shida Zhang <zhangshida@kylinos.cn>
---
 fs/xfs/libxfs/xfs_da_btree.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.c
index e7201dc68f43..3ef8c04624cc 100644
--- a/fs/xfs/libxfs/xfs_da_btree.c
+++ b/fs/xfs/libxfs/xfs_da_btree.c
@@ -2192,7 +2192,7 @@ xfs_da_grow_inode_int(
 		 */
 		mapp = kmem_alloc(sizeof(*mapp) * count, 0);
 		for (b = *bno, mapi = 0; b < *bno + count; ) {
-			nmap = min(XFS_BMAP_MAX_NMAP, count);
+			nmap = min(XFS_BMAP_MAX_NMAP, count - mapi);
 			c = (int)(*bno + count - b);
 			error = xfs_bmapi_write(tp, dp, b, c,
 					xfs_bmapi_aflag(w)|XFS_BMAPI_METADATA,
-- 
2.25.1

