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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C689C433E9
	for <linux-xfs@archiver.kernel.org>; Wed, 31 Mar 2021 06:02:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3886D619D7
	for <linux-xfs@archiver.kernel.org>; Wed, 31 Mar 2021 06:02:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233670AbhCaGCE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 31 Mar 2021 02:02:04 -0400
Received: from sonic307-54.consmr.mail.gq1.yahoo.com ([98.137.64.30]:44960
        "EHLO sonic307-54.consmr.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233736AbhCaGBs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 31 Mar 2021 02:01:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=aol.com; s=a2048; t=1617170508; bh=jGveTCeHipi+FNag3xMuS7B1EN1XNz9bAo083NUWoEQ=; h=From:To:Cc:Subject:Date:In-Reply-To:References:From:Subject:Reply-To; b=tTBZqPkNpRntIlJ5GAUPq9/Sa+4sMwC2k8PFak0R29xv6YweHZ5WFzyEi8GPZHFJ+c+y0UXaCi/cYFIntuHXLdqO9OCE6/5nqZyYbKNuHw1l6sCqWojniIo57XkYsJG3cl42c+Wr96gsT3djfFMVjcSbTloCfr2xDrq872Tq4/PX428iMpNMfhaSdxnGUuupKILS9v0zxCVw8a0YSZXYZOnwMZp4z7WipwkYkXtd9RTIyiNBxHOxRT520UgvmJhSa8lY9cfMPssmyVs6EGxBgMbK4YQmSYq0Q8Tn3XWDaVsV7xatbGf5QvIUf1PqVZJbMhhVG0z629XTvpRGhXm3sw==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1617170508; bh=Ahbczpnjom6lXFyQP+WlTNIYdWJHKe31OtzkFn6RvPc=; h=X-Sonic-MF:From:To:Subject:Date:From:Subject; b=Vl+giXxLAIOzAtKTHVlk/NLdy3s4dazbfVCYYPZUTPiXN/hfoKmP9qdn5tqG02E8CkSvoIGpoCzv/MXCYUcLLOzLBMZdwin4+zIv3hY7mAOgvGrDq4zye5DC6SJvg6wGLgPBzOuGPNpoawYKvyFeuRw8nzDqtCiNpwKvWwMp7euwTCroxcxFvuYXjjC6r5op650srd3EU4P6Kdj51BmIj2dxPmFEoAtKp9bwfwk/mC8AFArUl8P8fbsPoZVphOjAeBKHcOC+sVnUyAFQ0VULjb8DbBqPA+zx1hkycpJFXs8tNaSqSYYgE4MRIKx1FojjUF5ShqJnfBGLOkVR9zUV6w==
X-YMail-OSG: IGub3MUVM1nupkJ1TpOzab8dJcaKePX7fnz0ODY7GuPBHGiktbv28rsfAhMlS6D
 De8dDHoTNn.MT92gyp89pH53zEhbXk35aFI_ODfvTEbFNYai97Ser6rZX3AT1GMtbuNoa2c4cl3I
 go_Vr4iiZz6INat_l1pw6lpjUwuIweg99t3CT052Yp4dBLOSpvfHp1HCdeJYUPPeurejcoFCkdzb
 IXncuiTj.p3U6ACphSmD93dx1FIzrX1L7iiJgue2BuFuXMNgam377IkLxxnNG2rnjhtJ4UWpjAe6
 HhEA7oiiViF_ANvsU0uBXYovcoaKnbXfmBNvT8g08wcXtw4i8eb3Bsxvqc4WzATQWij.0N1d2enp
 4xEmsUg10FnLIVCX.eG.Lqk5MuyobNz_GVrAyLGVWcwL76.G6yYnmcWH_ZhRXss9FX5WPFukQBnN
 mcpSJpZjkMGgn2lS5AMVVAUa1m5SFkv7eQbsvnOWo3XPNmv3mjyxRA_QlYWulcraOzT5tjsJLA_K
 HybgR1P6T7fE1IREhLBg2hH1PqNPY1udcbOLcpr9sc9NVYe3bdD9FQD8xQ3bhMtxAoeJOpWjg152
 5XhtPtN6UoNazGdVyP5xm5UV.L_cOdlODf80g1yoBEFdOAvuCyiPSYUhV_Pf7frQfUlzYMiThAc1
 4vNT.mgN4Ft7KWmYobofFqWJykzTnLiCk6iEMCKmYn3qAQI5y7Acel3yYntaREhHJf.0ZSwWh7rV
 Z9w1BUra69j_txE63O_Xz6eybAkyHw_Day3tt0i.fVD5uXCXvzwONN5b.E.GT57QqhShI1WZKw3u
 ojCZ6lY7IHgmuIPQxKqaRdAn3EQ3qLO6QxgKTNyQjQflR9oAK_DlMNXStJkFmSJt4UiOvWIV.MQ5
 B1xBCZSMpm2clk_j2GAICGTTobExaFfZGkcLyIjYDe.F3rumye4dDk7Gs19LCfbn.koHewKd8UBF
 GU8lBMK4rbPwzIgx4ZkKZo8lGAAMUOg.ebQjFJRxrXsqUyMNzmz31hYFZxC.TxRytdyI7QA3rviR
 xg7OGW4YgxSQsyCN_AuKcihYvXzK_iKDQP9oTKdNV6olEyWvtc8OKdFxh6O9XCIv_HMAjJou5des
 9rlgRbscrjKOu8vpc6wX_VwA2GU9sToBvw6TMn87qbUIzieGvR11zUwPADx8eyAOGpkYNRfWWgTD
 rHISpbRi6Y.X46exkMDRd9RHDHiBx1L9cCvONByiN4yTpoHJ.TfmASHgfCyyzvmy.8c8jPmXPAse
 GyhVMZHxeyyU9sLFY8hWkhiG4WQwuDAuCoTpNtt5fYwMdsMnxmCAwBRhnf7gg7TzhHuMCB930pdO
 RO_z4Flni1iK_haq9114m_xoH9TNltztLHWX1.bD0Te8WTUlT0N7diHW8WSY32pOnFNkksDA1Jf8
 Ot_ocgcxhFZ_rPgFevZm9IoXtgyEMI2k3kVz9bN1CdfVRhlKFsRfUvOeX7HkzqsQ4K3Nc34krB8m
 TD6pTLRsf_FTFHJFkMOIrtUgiGGTWjjmFZnLa.g9UULTvkdXjpzqSWsJhKwrEAQlUffdkQsSHtNp
 YrkY9qvuyQCb7z54XiAv333LTlGuv5a.scdrh.ExC4hj0h3TYHjwGbCh7po681Pi3fpw8i7e84an
 3QYwOEwO.FxrxHOXcwgDomwC7O1b_H96i0q_gipXK.bVo50.S9iyaDyjC9uK46CKoIVW5Nfkyu7K
 vRCiRySdrTzKMJhh302a8pdkJn1wSpQAaDFBioH2KzE9fpse_2xYKPik9ApCANGTUcyHeQvauYR.
 TORTyceDsyeHSPrZryz_AS4A8JuAiOP4kai6pgUwaPO7YfKTpCn18oJBw6V8N3tzoU1_T26aHkr2
 qm66IciewKJCY5SHp8JuD3Bl0..5zwgjuMIXitD0GuHYJET0DVs.kmwpv9eCgBpbugPRpSleFa5Q
 qC5rHe2dZGH0hkkY8FIv2AZIW1NTtNgsNqS.U7M1f_qw1RjYwwqI9VMwLOfkbU_yvoPLP.UY6efR
 VMMaelghaEb36vcCiAaPP11K2_NT2SgyfD72m1SrBVNa6niAMMGE3lfMZbzCALCb2T2lg6JY26Hf
 ib_KwQsQUC0aQSpM9jiHuKERd2fzzA9vw7rtU_YSLEHVp9urqYaX.bOPwVRmJt2mc30AxG6EOYND
 08Wwl_e6NMGT1UXBsqaiuOugW88PJwju.CO6LsjIowhYosmSUpKN5M0eKZ_kmdV2PG2fhr9QfzIl
 XtPJTnlNLExjDq7Ms3jB2CPVmv1IxG5OyJ7lnkgW9PHGAKScIut0utxFQJTBm3SwnNsg45E3ThW4
 VI9ntIqWv5VJuZQrtcAnbazxhoKoqqLq3qC8TCzxjxn_79TGJgTpPjZklDPUDjcoN9_TuiXWJtdQ
 aWYvggwmHQovN1J8pNHcCtcF.YyIo0BvpOy8CPTezP7Rs.5Xr0oWmphzBo0.zq3_G_WE9D_CsmRh
 RUBQOh3L2NhpFBU2iB27Zx0woF.qMh6RFhURdoNvFWvBerM7KK4Teh2LA5abBtEDwvIBIdQX7DeZ
 u7PcYWZTbaFd7BfoaA3pzGjkqvKrQmgwht4G7biaHadPf0QAVsN3bCpu78Dmh7rs7qj._RqMvVtE
 UYJJVLQhhj9eaxpr.W8rAZoSYmZNInSo6o7rRXRwB.gMLG1NvZr4ymrDTPmH9kWmGWrWpuLA5zCp
 AWD9tr6qdxDyYZwIUWHXPH4Y1
X-Sonic-MF: <hsiangkao@aol.com>
Received: from sonic.gate.mail.ne1.yahoo.com by sonic307.consmr.mail.gq1.yahoo.com with HTTP; Wed, 31 Mar 2021 06:01:48 +0000
Received: by kubenode525.mail-prod1.omega.gq1.yahoo.com (VZM Hermes SMTP Server) with ESMTPA ID 190a809d5456af9661811acc5a61b089;
          Wed, 31 Mar 2021 06:01:43 +0000 (UTC)
From:   Gao Xiang <hsiangkao@aol.com>
To:     linux-xfs@vger.kernel.org
Cc:     Dave Chinner <dchinner@redhat.com>,
        "Darrick J . Wong" <djwong@kernel.org>,
        Gao Xiang <hsiangkao@redhat.com>
Subject: [PATCH v4 7/7] repair: scale duplicate name checking in phase 6.
Date:   Wed, 31 Mar 2021 14:01:17 +0800
Message-Id: <20210331060117.28159-8-hsiangkao@aol.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210331060117.28159-1-hsiangkao@aol.com>
References: <20210331060117.28159-1-hsiangkao@aol.com>
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

Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
---
 repair/phase6.c | 30 ++++++++++++++++++++++++------
 1 file changed, 24 insertions(+), 6 deletions(-)

diff --git a/repair/phase6.c b/repair/phase6.c
index 063329636500..72287b5c66ca 100644
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
+ * name length of 40+ bytes so should cover a most situations with really large
+ * directories.
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

