Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ECDA1C433E2
	for <linux-xfs@archiver.kernel.org>; Wed, 31 Mar 2021 06:02:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D563C619E1
	for <linux-xfs@archiver.kernel.org>; Wed, 31 Mar 2021 06:02:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233729AbhCaGCC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 31 Mar 2021 02:02:02 -0400
Received: from sonic306-19.consmr.mail.gq1.yahoo.com ([98.137.68.82]:46514
        "EHLO sonic306-19.consmr.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233723AbhCaGBc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 31 Mar 2021 02:01:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=aol.com; s=a2048; t=1617170492; bh=O+X5RQ4KxhI731JaPwn2i9hxqbO0rX+Nkvj5t61u2Wc=; h=From:To:Cc:Subject:Date:In-Reply-To:References:From:Subject:Reply-To; b=caE72ZfDcv8XmU69KqUmQY+DrZwTnQk0wwuLSvhJWj8yyE86/Da9T/+z0/c1uGkkVuK8pC/gjIOwbcl9Ir1g3b7sZv+aMsuZ6eMqsVcaJdql1ClOkmWZpyvy9HetKcYoVEBb7AsMl/EuGnte9/55ZfXKzeqAjPKhPUM/0bG5NsHoeKEQzO/w0yuRqFo5NzUcYw2g2iww4f5IrnBJ5bS++4BqnTKwDg7E0A+BwjeJJG0BC0U7nOXH/1jty/7eWSyDqj1nANbARqvH3+6ct5L8cDm+gX+wU1IRODZCF2YabOWT5aMfMWRlppiqXHaC21dPHsyqThk83yrzNXmbVWAgTw==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1617170492; bh=p7OFXrpkrIT/V3QQMBh/hNRp5JIZVLVBvyEbd7JN4aC=; h=X-Sonic-MF:From:To:Subject:Date:From:Subject; b=j+vdUSZfPCylPa4U5aVUqxxa8IzKnzpBjrhY96RIuePWTqnq23QRxeJMXmY63fDa9NoVs6/so9s8fSbJHtDJ5FK5nnfE1CFvV/tK2JVzeGSJ4c1k7a6XX9Bg+njD6HqTqxp1FzdQKKY2EVrk9Z+j5fMvdJjEnl7LwN5BC2XmZNFhmzMmCDh3VzwXc+Qn4f8zLrEdOF8KWqFKCRIL5532Yl8oPIs3XMnGyV0tQIumLRGzVcU/IvyULt6abj1Z+r2U1/iAPpGx8Q8x3Yn38qjp+NMGdITwM/ai+mXp0WGz6uDnrpx3pWzmAhwaHnOlHzavIx1KNIz0GpmigBVzQnPP0g==
X-YMail-OSG: ORisqg8VM1mR4tl659tB3e0qQXqV8.hBD4LxDUgY3svC8qvzTZo.XG_CCmjTf4F
 LVW0SdOrdq0DxZWex1baYNFjWwfwhaNrrf8dBnAx6yDE9KSqDcrVsnmIo7yX4_jbaB9GBSBjiiEw
 7yYIhbeLNErAREYDli2ow4Dd1AcXcfNlfq1q9QGJMDKL4MD9gPhQVQpXbOQpuBjbrnOPfP6C_W8i
 V6A3tCNcxqZIfrvD8U3MsmDdcgHxADLCwl7yNHTWXOd3Irt8GM4Lrdqin2W0GEuce_0QTlCGRSPe
 xzHJQ.xH3cmFMC6hOpJbOSdKaqgFBCFfL9nguM6crz5EsmJ_CA2C_twrNJpe7CgHy15qkaN6lEjt
 kRfiZoJAsZMOTdmJAHkcQwQjarnfO0oqqlVPMLcaR_V5d3sy31cGJ9Z6aUWkXLo96mTO1TCVdB_Z
 gTiVDv13CGRHt45vgfYte7VquMRTpbDCHxxOMLm.b0SjRR2ub2dA3Yy0MBWpo0b_rM2sLco9c_zL
 o97aLLq4.jPEaZMqXqyDANvGfs3s7f1TWJIypZH53qSd.uIDiGp2Cqm3HB4NQOsvAvUVCY0Qj.ql
 61fTXvF3WEKS1xGgf2xyIjQZjxbX.BFsVRAqo9rZdI82WL6JEB.JCFTcAozS.1A98MYWxVL8nqvR
 8ydVJHsTutbmhRzDxpTHndT2pFqE8oUZX9_GFHxsXkfT497EVqy9Ek1INVVkEwvGh6yO52ZcHKmD
 PZ0HKHwYbqsvSgBHWGz26O_9KGdkdfNqnABwAkVI23lzjii1iUuTSYmGfrFRzv.zinuZQvCYZ.wm
 kfrJvknb2EWTknh.2JjnXok3qRREMk4xGU_I8zC8Zm9XdxtE6XfDljAvu3lUoyhEXzG3yXZ9Foas
 edxUPyGAw1kih0n_oE4HKpQBPd6o6keaMiGU_FSuBz_OW3nOczZZtGeQzSENtfb4yOnzkIdIMDSQ
 oQXsMesK_0_U4PS35SyVZfCGKS9T12A0CpCRmhtt4oyWrLj3IFAV4u8yxwcL9JsRhZBUgfy.hwcf
 8D_vyc2hsjYPuHiIlWGGhr1XBGLkY0YBgQx2r20Rz.YQyoggR5XOAcQ8vL.i0HVs82lp2bzv2bw_
 0UpU7vkVPCs5Ga7VcS9hmmwHX969hsvHHsNNzfmn2yg_PeNw2Dsas3vUJP4M1bQn3sOFkV4gx8bt
 .bMsvNjFseuxBqfL3dgpHJvwH6GKMa94qxHUYGEQHax.DUCa6RGrrTZ1rTn4mcZPDbkNNfT8myLI
 2rBnLCMUFSYQaPAEX2JEtnVSkP_aaZsZOj05Z.IH8C8z7ePStpSP02QFmWDi7KTMUL25G9gRiZQe
 WGp6LgrgYUNWPU_ttdHOdA832gpBnV3irnLVocd1ix3UCdv.D7CXrb4dRCkoTB4GjGakk17AHBQo
 EdUpBW_GkRWXVwS2mp.PxxOlBOaAjV1uC9VwaXbC7Cs9ywqeysp8dUL2SHB_hUcldKHNoY3qUhyt
 HoC1ijTFf6B58ypC8zaaccujzPliaPqN2743D1Uienk7Cr_tNsCCxhQ9yaH7FqUzYdLf1VL.AxBA
 8_Kv9RzfZQaB58HHdxvSd4zQJExXJfdNFm4M4vaBuQYfXPER83MYvVrXok0feerQeyS7l9KqBAn0
 8lpwZuziTq1nPwTGgT6vqxZWy1nRau_8x5VhkbelYdfIVoWgWyjO54HLPTWriUJ3ozEcLkjrUV16
 zBakwgsWif.ZFjzLh2JpjX_yA0FazXPJ.9qdc27KFvqMhKNUbp4NUEnCUZ4PV6NQCB16lSNAO_T7
 kPK3yxNR...sp2Tu7JDaTaiLiIR5yxgbc2.ZPppndkJr1thkgWUbJX4Djv6yx.ikXd.ojp0yT3p3
 thK_jF7f3hqEJyM8Orl4hnIN14.uuRKhWjtzBTXhsIWrOgJKc_SI6Sq7Zrw_M7PDeVJjNHWkJ4up
 psGdN01eEp9CPFRlKe4R6P_A7bL.WuRP.ucmj2xfZl3u3EDhSgJJIEx.CI3LLfhn9sqMhmZcACIB
 Af3EnbZKWyqfiqoD3MTmzolpHkAqL6adUfJZEHNwnzU84SAZG5.VfVtC54cSjcA7n_jX3hFFbJRw
 pT.SWBrkOWyf1yS7f9zz9fmE9kEAAGhF38YFFt9H.1muEUqJ0eo_zNOIEdvUo3ZrMBA7_tzzs8ZY
 lOeAAngvo_uCUTctEFELkqBD8k.HInnyFh5GG6naojpI8Nhl37YAL1XIwvN0NN9u8wxCBvAguiaK
 OL5I4TpUXHuhPY1pFPKEpFPHHZ_LGYAyD0hGFezAWbn_0mA7x9Jq.W1VIiH1ea.Cn1Fuiqfyo63y
 32cm_GEy9eRcfsLdKQEuX7CzyqpE.LjjxKVDR5zKuHW.zvg7u43QXpQUQDeIIMhVOIDpYzBmUaFT
 NpLemSAUQilW2nuvGSGDuk3EFUEtmX9bHNUCCTvaF1zYe.sYVK1zFYxUvPceOgigp51aOCmQAtjl
 Uxzh0ZbTzPkmR8r.pE7If83iuiBWkpdCU8HWRkRAoUaNwIkgCZDD4fh1NrxNX6hDscNSqk2eM45z
 PIshX6MaFTBpw4wIt9aTrRDxnMDU2JFMMPB9GXmAnpDKIbEd6DDpyJR_eSPs2YLkwxy3brn1QheN
 JvRMvvw38teOuCGzPLu1vTUY4v8RHk8k-
X-Sonic-MF: <hsiangkao@aol.com>
Received: from sonic.gate.mail.ne1.yahoo.com by sonic306.consmr.mail.gq1.yahoo.com with HTTP; Wed, 31 Mar 2021 06:01:32 +0000
Received: by kubenode525.mail-prod1.omega.gq1.yahoo.com (VZM Hermes SMTP Server) with ESMTPA ID 190a809d5456af9661811acc5a61b089;
          Wed, 31 Mar 2021 06:01:29 +0000 (UTC)
From:   Gao Xiang <hsiangkao@aol.com>
To:     linux-xfs@vger.kernel.org
Cc:     Dave Chinner <dchinner@redhat.com>,
        "Darrick J . Wong" <djwong@kernel.org>,
        Gao Xiang <hsiangkao@redhat.com>
Subject: [PATCH v4 2/7] repair: Protect bad inode list with mutex
Date:   Wed, 31 Mar 2021 14:01:12 +0800
Message-Id: <20210331060117.28159-3-hsiangkao@aol.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210331060117.28159-1-hsiangkao@aol.com>
References: <20210331060117.28159-1-hsiangkao@aol.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

To enable phase 6 parallelisation, we need to protect the bad inode
list from concurrent modification and/or access. Wrap it with a
mutex and clean up the nasty typedefs.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
---
 repair/dir2.c | 34 ++++++++++++++++++++++------------
 repair/dir2.h |  2 +-
 2 files changed, 23 insertions(+), 13 deletions(-)

diff --git a/repair/dir2.c b/repair/dir2.c
index eabdb4f2d497..fdf915327e2d 100644
--- a/repair/dir2.c
+++ b/repair/dir2.c
@@ -20,40 +20,50 @@
  * Known bad inode list.  These are seen when the leaf and node
  * block linkages are incorrect.
  */
-typedef struct dir2_bad {
+struct dir2_bad {
 	xfs_ino_t	ino;
 	struct dir2_bad	*next;
-} dir2_bad_t;
+};
 
-static dir2_bad_t *dir2_bad_list;
+static struct dir2_bad	*dir2_bad_list;
+pthread_mutex_t		dir2_bad_list_lock = PTHREAD_MUTEX_INITIALIZER;
 
 static void
 dir2_add_badlist(
 	xfs_ino_t	ino)
 {
-	dir2_bad_t	*l;
+	struct dir2_bad	*l;
 
-	if ((l = malloc(sizeof(dir2_bad_t))) == NULL) {
+	l = malloc(sizeof(*l));
+	if (!l) {
 		do_error(
 _("malloc failed (%zu bytes) dir2_add_badlist:ino %" PRIu64 "\n"),
-			sizeof(dir2_bad_t), ino);
+			sizeof(*l), ino);
 		exit(1);
 	}
+	pthread_mutex_lock(&dir2_bad_list_lock);
 	l->next = dir2_bad_list;
 	dir2_bad_list = l;
 	l->ino = ino;
+	pthread_mutex_unlock(&dir2_bad_list_lock);
 }
 
-int
+bool
 dir2_is_badino(
 	xfs_ino_t	ino)
 {
-	dir2_bad_t	*l;
+	struct dir2_bad	*l;
+	bool		ret = false;
 
-	for (l = dir2_bad_list; l; l = l->next)
-		if (l->ino == ino)
-			return 1;
-	return 0;
+	pthread_mutex_lock(&dir2_bad_list_lock);
+	for (l = dir2_bad_list; l; l = l->next) {
+		if (l->ino == ino) {
+			ret = true;
+			break;
+		}
+	}
+	pthread_mutex_unlock(&dir2_bad_list_lock);
+	return ret;
 }
 
 /*
diff --git a/repair/dir2.h b/repair/dir2.h
index 5795aac5eaab..af4cfb1da329 100644
--- a/repair/dir2.h
+++ b/repair/dir2.h
@@ -27,7 +27,7 @@ process_sf_dir2_fixi8(
 	struct xfs_dir2_sf_hdr	*sfp,
 	xfs_dir2_sf_entry_t	**next_sfep);
 
-int
+bool
 dir2_is_badino(
 	xfs_ino_t	ino);
 
-- 
2.20.1

