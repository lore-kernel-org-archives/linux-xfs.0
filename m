Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6CBB1C7EE23
	for <linux-xfs@archiver.kernel.org>; Thu,  8 Jun 2023 02:52:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233812AbjFHCwI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 7 Jun 2023 22:52:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233806AbjFHCwH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 7 Jun 2023 22:52:07 -0400
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2341F26A3
        for <linux-xfs@vger.kernel.org>; Wed,  7 Jun 2023 19:51:58 -0700 (PDT)
Received: from canpemm500005.china.huawei.com (unknown [172.30.72.56])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4Qc7x03LcJzLmWb;
        Thu,  8 Jun 2023 10:50:12 +0800 (CST)
Received: from Y00251687ALE274.china.huawei.com (10.174.178.198) by
 canpemm500005.china.huawei.com (7.192.104.229) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 8 Jun 2023 10:51:55 +0800
From:   Weifeng Su <suweifeng1@huawei.com>
To:     <linux-xfs@vger.kernel.org>, <djwong@kernel.org>, <hch@lst.de>,
        <sandeen@sandeen.net>
CC:     <linfeilong@huawei.com>, <liuzhiqiang26@huawei.com>,
        Weifeng Su <suweifeng1@huawei.com>
Subject: [PATCH v2] libxcmd: add return value check for dynamic memory function
Date:   Thu, 8 Jun 2023 10:51:46 +0800
Message-ID: <20230608025146.64940-1-suweifeng1@huawei.com>
X-Mailer: git-send-email 2.18.0.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.174.178.198]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 canpemm500005.china.huawei.com (7.192.104.229)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The result check was missed and It cause the coredump like:
0x00005589f3e358dd in add_command (ci=0x5589f3e3f020 <health_cmd>) at command.c:37
0x00005589f3e337d8 in init_commands () at init.c:37
init (argc=<optimized out>, argv=0x7ffecfb0cd28) at init.c:102
0x00005589f3e33399 in main (argc=<optimized out>, argv=<optimized out>) at init.c:112

Add check for realloc function to ignore this coredump and exit with
error output

Signed-off-by: Weifeng Su <suweifeng1@huawei.com>
---
Changes since version 1:
- Modify according to review opinions, Add more string 

 libxcmd/command.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/libxcmd/command.c b/libxcmd/command.c
index a76d1515..e2603097 100644
--- a/libxcmd/command.c
+++ b/libxcmd/command.c
@@ -34,6 +34,10 @@ add_command(
 	const cmdinfo_t	*ci)
 {
 	cmdtab = realloc((void *)cmdtab, ++ncmds * sizeof(*cmdtab));
+	if (!cmdtab) {
+		perror(_("adding libxcmd command"));
+		exit(1);
+	}
 	cmdtab[ncmds - 1] = *ci;
 	qsort(cmdtab, ncmds, sizeof(*cmdtab), compare);
 }
-- 
2.18.0.windows.1

