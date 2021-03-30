Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D98F1C433E5
	for <linux-xfs@archiver.kernel.org>; Tue, 30 Mar 2021 14:26:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BDFAE619D8
	for <linux-xfs@archiver.kernel.org>; Tue, 30 Mar 2021 14:26:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232004AbhC3O0V (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 30 Mar 2021 10:26:21 -0400
Received: from sonic304-24.consmr.mail.gq1.yahoo.com ([98.137.68.205]:36953
        "EHLO sonic304-24.consmr.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232067AbhC3O0I (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 30 Mar 2021 10:26:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=aol.com; s=a2048; t=1617114368; bh=C+ztXxiHumfPzPm5X3Le/YXGTxHnu+eEnHfWnfIpcXQ=; h=From:To:Cc:Subject:Date:In-Reply-To:References:From:Subject:Reply-To; b=YAboQyijyqa7ZbZYMgzNnK3AhdSdnv69lncVMdBMlpksRn/uAzcjxnQWUQF58kTfl08bnXZGWmVQAf44ARWg1Uz02/Et1nj0mwRBwtdBAAGzg/t2wgDmJzRNrbXUP5zib5ELpcbciL2U63frSMT9COnj3jm1XwJKlHr5a5Df0Wrp8mLGo8RPLRv9WRifrlnJfwCweRAgxkn2WSqGxck2vSM16NSEeaUdds8xrD55VWy/oLMNSexV5ZY9wP/+J8kao2YjeAF4CxsMYmz0dxjIauWfO0uioC7ZlnEeOcyAFiww00ll9xuOAuSqCJxWeu6ha8THoz2u73eUbWWwVqccDg==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1617114368; bh=dwlmUaBefD5lBZIaQU1sPm+AV73CWKLAaEoQ3WWcPaO=; h=X-Sonic-MF:From:To:Subject:Date:From:Subject; b=S766LXjYqR/I3Uj46QHasLYEnqDR7NGbQjkcPvCvXqkJTkbmXHZblyezYE2B7ViQLlwQyRobH791JtlHvHUpIcVmFEgcR0PKZitIipBJZhNId5K9lu2WgP7cHE3c/6uf4imepvNSPUhROkUMwK1EePU7ssybnVeyhWWq9YO1X4aT4VLn8BrEeOqeahzE9Sjeu1/3YS1r7Grjc4Gq6VKWN+L9oyF4CaBZf0ruP4y03DGBZUg6lE9WfsXzH0HJAGi+hlxtv9nHei+JK1+GU8T82J+mRaHME9l/QyiG2TaQQxN20UOz/wAGgSrFjo+vgJ0K/ev/1RJPUxTZ7hurON4PPA==
X-YMail-OSG: hh6qyJ0VM1k1OQjguSk88vK0GLiZUK.pyNy45WfrVjFOXv6JXQ7kux7wst.7vNh
 hMw68HEfgaV2Ygzbpjz9cl6SIqRA_j30V9c03u_m6SA2T5B8B4F8t0wk3rJ8tK.aK6XDiPlxu.bi
 wJEa1oV4m1zhMTU8H1Z5am7ZaiVmnKw166_84woExgYFCznBd9DvO9buf3s0sAG_66Jo4DBItEWh
 APTT_KpUhsHvPXVd.DnDTgeIvaAq8pexJ71w5IkHg9XR8_cy9v3KUsf8lp9C.XFpgcZOAfxo9Bd5
 UQzcKTtRpzk85xC_DBsvV81026_oJI.llU6cEbRQ_ZZFz_LF.5q4lZgX87jC1WeFF.gDnPrco36a
 7bLioL1BghVbLFDUrHNdrmTtWK5TauNLghgEKB85ocPybLvHTYOWhQQsA13fTNJu89spSZFuilOl
 MYspjBydqpbiepMdmJLrnSvqcp.j7B9BSFJwTeQlFRCztNC1uINv9btq16odvYFf.pAES9m6_ImS
 458At6rGbw7e35K8oAyGiAkjTmiwqV38zhu2hZbbOxq84PVc1a.f1C7NlHahlJAJBDe1OIP78QSd
 3KDPqF6iZdyXJW2EyRBk.Y7MtAt1KpO0alS7ymqJZAi.niz1lJj90MvZfw6p_5omIU8wE8Gf8uTh
 nZ6HEpx.OXtGdnP9b24nX5K4lOp.MO.VqM3HjW4pphAmfbzeYU1tSi3Rdb4j_fLB23OPIQhQO7na
 zRSrIvHQoS1ELDUZbIrDqwU_ruLl52dYvvBMLEFEqIq5Ls3htQsix_WqYu7S9DF96_iZ7Dy4kCkk
 VI3TAb_Ou3gbTcGPUSfe8aiE0mF7YoGbSFBA2B_WoznHzBHK5hyKFaM_znpe1WZJgWCheP4wnScQ
 X9ZFETq3ggVCFSNINdm9CDo6bxtkGQFnh9p1HTq0m_trsSWW1uhlTvfX.ef6ujrLn4Xj5Yh.rVY7
 oDznc5lIvmW6Yeiwn0VbwEwDnMTdy9WySZWbAgBAZDqRfWV1dxtMNHFcp8kjLjSHv_TndHWmfjc9
 fpynPp4ywUcL9lUUvXc.NgE8TMc8_h9i7hzeYdg8JEY4PlZd.ABodUX.IhDOX85kRKRcfAEhA7Me
 wsBR7Nax1xgdjV7dtZn5NVS7MTT4YRZp9HmoG2IrVaZkZec2N3Vso4ePWci4W4rQ8Me5xCSvECbK
 H_86Ej4DbUNfC.wS.9vZkP3StsOAluJbcQ_gjay5.X0WOv2nj05TpU79nsYE6i_gjKtUTE480pIr
 avmcqb3vvm047HFdu1r3JwM6AagBvXLv5udAStjEhpYHc7lH0.PdyZOkcYMwmE_rpgJNi3v8gsZf
 4aXH3SVfmhDsj.A3nMZcGqkxPpAaPRMA3OPo.oPduz1YCqycIJDiafvUn0MztfIAXtn7RqwiTJAd
 rqvWfXmPI0b_WqQnJ0QrSaeTCElpJPd6VBD_xqL3InUcgP8ZZWAeYbT0.Mmk1pebLDswQGxtDtT7
 NwSO_lbcRitD0UXxlt4eKjvv.mgTLSv1pVG2oFFp6UUgxtLHaTREIqo70qJfARg_0.lCNCuKJQBl
 uZqDjFzfifMWRHLKaSgEv2iybpnN5K71qnzlMEA0pRz40raGxE.xm73sEmIujqlfJo3PzbHUYyGj
 XBtp4WQyvTqVLQGmfVxw9M1swHYVhKCtySx5uMRAn24G09THc8ROmOnXdg7BecJjVtc.LMR4pvsD
 gc.M6kgufMo8jcW0FKs5LrMaSkUsosuJRzGZQ7mUBwmAvwKxG7QWVKWbqm0URO.SwCFy6jf1Rqv2
 E8XCjUmckrOmq4J818KA5vv3PPSRBN2BDtFm4wG3_R20C_mIs2ORShmPz4SRR5qCbmOzfd8HZEW.
 jEsbcjp3uOCLYIC8l833lsy0oJPbCgZW0bzTOM1r0jYZMnw9vXFomNnFsEpQ0kc6gXdAHHlJQGR5
 eZvAe1g.RoG0x0.sheEqI9ZFtKPc.BApXwxCRJggy7Zf4rj5f0yZuQugJnLd6QYQ2wLu7rhnQKGX
 BHFRcNMh5tdkpWN3LD6xyhHO3_ogRLmM7_AxarCaXp26_xsa.PhSqCiyOds0jzr7VStSde6JJAcg
 k7ZG1oKmZg8damO3Bm_OJRZqcCnZ_81aLqKC3o0SjEAGMsSKUdvqPCzY5AdwKgr22Ui..sA6OJ_k
 3BUDq__w3hFvkNqYkBSrz1bKdT3e_1pzOSM1cpksG.iLL372YErQPW8KLomcD.R9JPpZ_Gv3Me4T
 R6eNmH8fbll1VXBcngl3tKAs6V1ULwF9ATEFU1p3XxGQdPi_6.fduWsbwkXzM0zDVQqXavOLb9rl
 72CaBaW8ccdK40XvVZvUgfaTtVs8gkUSoSACqiv9azLULTLIgtrWVK2XEN1V3wCe2sRRUr5Ta1pJ
 nwC621qhkRlEZKmRqdltnMCQgPr.PiNvXlkJtxmR5jCYqw04QiiC4hECsKF.J79UkzaiJOfJ.7p3
 kahPDaTiW5bAfEvGNElbnpyHZCsVskSiqtSbFMYP2oP4lzOYHpHDp98shcelsinvcnL68jqrDHhw
 evMc0HRv4H8kF43XxUt1P_Sc2xmErMCsdMvVsDVq.62JKTT7EsO_ELTo8y0E-
X-Sonic-MF: <hsiangkao@aol.com>
Received: from sonic.gate.mail.ne1.yahoo.com by sonic304.consmr.mail.gq1.yahoo.com with HTTP; Tue, 30 Mar 2021 14:26:08 +0000
Received: by kubenode575.mail-prod1.omega.gq1.yahoo.com (VZM Hermes SMTP Server) with ESMTPA ID d17ac850f756223f45b54c36ad526fbe;
          Tue, 30 Mar 2021 14:26:04 +0000 (UTC)
From:   Gao Xiang <hsiangkao@aol.com>
To:     linux-xfs@vger.kernel.org
Cc:     Dave Chinner <dchinner@redhat.com>,
        Gao Xiang <hsiangkao@redhat.com>
Subject: [PATCH v3 8/8] repair: scale duplicate name checking in phase 6.
Date:   Tue, 30 Mar 2021 22:25:31 +0800
Message-Id: <20210330142531.19809-9-hsiangkao@aol.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210330142531.19809-1-hsiangkao@aol.com>
References: <20210330142531.19809-1-hsiangkao@aol.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

phase 6 on large directories is cpu bound on duplicate name checking
due to the algorithm having effectively O(n^2) scalability. Hence
when the duplicate name hash table  size is far smaller than the
number of directory entries, we end up with long hash chains that
are searched linearly on every new entry that is found in the
directory to do duplicate detection.

The in-memory hash table size is limited to 64k entries. Hence when
we have millions of entries in a directory, duplicate entry lookups
on the hash table have substantial overhead. Scale this table out to
larger sizes so that we keep the chain lengths short and hence the
O(n^2) scalability impact is limited because N is always small.

For a 10M entry directory consuming 400MB of directory data, the
hash table now sizes at 6.4 million entries instead of ~64k - it is
~100x larger. While the hash table now consumes ~50MB of RAM, the
xfs_repair footprint barely changes as it's using already consuming
~9GB of RAM at this point in time. IOWs, the incremental memory
usage change is noise, but the directory checking time:

Unpatched:

  97.11%  xfs_repair          [.] dir_hash_add
   0.38%  xfs_repair          [.] longform_dir2_entry_check_data
   0.34%  libc-2.31.so        [.] __libc_calloc
   0.32%  xfs_repair          [.] avl_ino_start

Phase 6:        10/22 12:11:40  10/22 12:14:28  2 minutes, 48 seconds

Patched:

  46.74%  xfs_repair          [.] radix_tree_lookup
  32.13%  xfs_repair          [.] dir_hash_see_all
   7.70%  xfs_repair          [.] radix_tree_tag_get
   3.92%  xfs_repair          [.] dir_hash_add
   3.52%  xfs_repair          [.] radix_tree_tag_clear
   2.43%  xfs_repair          [.] crc32c_le

Phase 6:        10/22 13:11:01  10/22 13:11:18  17 seconds

has been reduced by an order of magnitude.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
---
 repair/phase6.c | 30 ++++++++++++++++++++++++------
 1 file changed, 24 insertions(+), 6 deletions(-)

diff --git a/repair/phase6.c b/repair/phase6.c
index 063329636500..aa991bf76da6 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -288,19 +288,37 @@ dir_hash_done(
 	free(hashtab);
 }
 
+/*
+ * Create a directory hash index structure based on the size of the directory we
+ * are about to try to repair. The size passed in is the size of the data
+ * segment of the directory in bytes, so we don't really know exactly how many
+ * entries are in it. Hence assume an entry size of around 64 bytes - that's a
+ * name length of 40+ bytes so should cover a most situations with large
+ * really directories.
+ */
 static struct dir_hash_tab *
 dir_hash_init(
 	xfs_fsize_t		size)
 {
-	struct dir_hash_tab	*hashtab;
+	struct dir_hash_tab	*hashtab = NULL;
 	int			hsize;
 
-	hsize = size / (16 * 4);
-	if (hsize > 65536)
-		hsize = 63336;
-	else if (hsize < 16)
+	hsize = size / 64;
+	if (hsize < 16)
 		hsize = 16;
-	if ((hashtab = calloc(DIR_HASH_TAB_SIZE(hsize), 1)) == NULL)
+
+	/*
+	 * Try to allocate as large a hash table as possible. Failure to
+	 * allocate isn't fatal, it will just result in slower performance as we
+	 * reduce the size of the table.
+	 */
+	while (hsize >= 16) {
+		hashtab = calloc(DIR_HASH_TAB_SIZE(hsize), 1);
+		if (hashtab)
+			break;
+		hsize /= 2;
+	}
+	if (!hashtab)
 		do_error(_("calloc failed in dir_hash_init\n"));
 	hashtab->size = hsize;
 	hashtab->byhash = (struct dir_hash_ent **)((char *)hashtab +
-- 
2.20.1

