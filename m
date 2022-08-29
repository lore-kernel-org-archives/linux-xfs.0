Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34783ECAAD5
	for <linux-xfs@archiver.kernel.org>; Mon, 29 Aug 2022 09:50:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229525AbiH2Juv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 29 Aug 2022 05:50:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbiH2Juu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 29 Aug 2022 05:50:50 -0400
Received: from m15114.mail.126.com (m15114.mail.126.com [220.181.15.114])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 014B524BFA
        for <linux-xfs@vger.kernel.org>; Mon, 29 Aug 2022 02:50:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=126.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=MBSSv
        21C9zmQ3XTwy7yHsK+mAh4kidNIuAwhlAz+GMo=; b=pfQzZLqfeJYZ541Q7ROLQ
        bi188i/nmmn/BLorrFs6N3JpLqj9sPqdB1b7kTrYMA7sUCqldRZDq2Q+Z3YMyoJz
        nHH5NhtByw8upwnL4q2hxdB7xQ7DCAU4B05cGSR+bVRRW6bS0WrMLo5kYzb1MU7W
        V5IAn3wuPJbJ64oxF/Yh8k=
Received: from localhost.localdomain (unknown [123.150.8.42])
        by smtp7 (Coremail) with SMTP id DsmowADH9Zj0iwxjQ+ZWAQ--.54439S2;
        Mon, 29 Aug 2022 17:50:45 +0800 (CST)
From:   Xiaole He <hexiaole1994@126.com>
To:     linux-xfs@vger.kernel.org
Cc:     Xiaole He <hexiaole1994@126.com>, Xiaole He <hexiaole@kylinos.cn>
Subject: [PATCH v1] xfs_db: use preferable macro to seek offset for local dir3 entry fields
Date:   Mon, 29 Aug 2022 17:50:25 +0800
Message-Id: <20220829095025.10287-1-hexiaole1994@126.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: DsmowADH9Zj0iwxjQ+ZWAQ--.54439S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7Kr48Wr18Cr1DAFW3uF1rZwb_yoW8uF4kpF
        s2vFWDKwn7JF4SqF4xKa4kXry5ua4q9FZxZ345G39Yk347Xrn7GaykCw4FqryDtF4rAF98
        CF45tayYgFyUZrUanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07Upa0PUUUUU=
X-Originating-IP: [123.150.8.42]
X-CM-SenderInfo: 5kh0xt5rohimizu6ij2wof0z/1tbiOxtmBlpEHIUfxQABsc
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

In 'xfsprogs-dev' source:

/* db/dir2sf.c begin */
 #define        EOFF(f) bitize(offsetof(xfs_dir2_sf_entry_t, f))
const field_t   dir2_sf_entry_flds[] = {
        { "namelen", FLDT_UINT8D, OI(EOFF(namelen)), C1, 0, TYP_NONE },
...
 #define        E3OFF(f)        bitize(offsetof(xfs_dir2_sf_entry_t, f))
const field_t   dir3_sf_entry_flds[] = {
        { "namelen", FLDT_UINT8D, OI(EOFF(namelen)), C1, 0, TYP_NONE },
...
/* db/dir2sf.c end */

The macro definitions of 'EOFF' and 'E3OFF' are same, so no matter to
use either to seek field offset in 'dir3_sf_entry_flds'.
But it seems the intent of defining 'E3OFF' macro is to be used in
'dir3_sf_entry_flds', and 'E3OFF' macro has not been used at any place
of the 'xfsprogs-dev' source:

/* command begin */
$ grep -r E3OFF /path/to/xfsprogs-dev/git/repository/
./db/dir2sf.c:#define   E3OFF(f)        bitize(offsetof(xfs_dir2_sf_entry_t, f))
$
/* command end */

Above command shows the 'E3OFF' is only been defined but nerver been
used, that is weird, so there has reason to suspect using 'EOFF'
rather than 'E3OFF' in 'dir3_sf_entry_flds' is a typo, this patch fix
it, there has no logical change in this commit at all.

Signed-off-by: Xiaole He <hexiaole@kylinos.cn>
---
 db/dir2sf.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/db/dir2sf.c b/db/dir2sf.c
index 8165b79b..9f1880dc 100644
--- a/db/dir2sf.c
+++ b/db/dir2sf.c
@@ -246,9 +246,9 @@ const field_t	dir3sf_flds[] = {
 
 #define	E3OFF(f)	bitize(offsetof(xfs_dir2_sf_entry_t, f))
 const field_t	dir3_sf_entry_flds[] = {
-	{ "namelen", FLDT_UINT8D, OI(EOFF(namelen)), C1, 0, TYP_NONE },
-	{ "offset", FLDT_DIR2_SF_OFF, OI(EOFF(offset)), C1, 0, TYP_NONE },
-	{ "name", FLDT_CHARNS, OI(EOFF(name)), dir2_sf_entry_name_count,
+	{ "namelen", FLDT_UINT8D, OI(E3OFF(namelen)), C1, 0, TYP_NONE },
+	{ "offset", FLDT_DIR2_SF_OFF, OI(E3OFF(offset)), C1, 0, TYP_NONE },
+	{ "name", FLDT_CHARNS, OI(E3OFF(name)), dir2_sf_entry_name_count,
 	  FLD_COUNT, TYP_NONE },
 	{ "inumber", FLDT_DIR2_INOU, dir3_sf_entry_inumber_offset, C1,
 	  FLD_OFFSET, TYP_NONE },
-- 
2.27.0

