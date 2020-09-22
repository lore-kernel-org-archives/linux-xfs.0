Return-Path: <SRS0=chL6=C7=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2B12C2D0E2
	for <linux-xfs@archiver.kernel.org>; Tue, 22 Sep 2020 03:43:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5FEA623A32
	for <linux-xfs@archiver.kernel.org>; Tue, 22 Sep 2020 03:43:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=aol.com header.i=@aol.com header.b="UNU7kXJw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727435AbgIVDni (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 21 Sep 2020 23:43:38 -0400
Received: from sonic302-20.consmr.mail.gq1.yahoo.com ([98.137.68.146]:32815
        "EHLO sonic302-20.consmr.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726047AbgIVDnh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 21 Sep 2020 23:43:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=aol.com; s=a2048; t=1600746216; bh=utPdDuS27XE+bHcYOPd7HWFITsO2lrEiPStfyUv2JyQ=; h=From:To:Cc:Subject:Date:References:From:Subject; b=UNU7kXJwtXugOzfq/l1OCB0CrxFxtxlwvPV9oc/OhlgmJT1MBN2TlLoZaG6ikfBmXexuEa6mZNFFkx8VeoOr0QTCQqDmqa7yc37KEv4MSRWyvlpT3YFkElSVcVGZnjQiHsnf3uVK/zNWSq4wAmaBE6dRWTtUNVtWUsB3g5cWzEgjmcKoofDD290OGiRzvh5t7vSAumwEw0CMaBHbWREbId770JbKgnXJp+vsrCCFapE7feRM+4gCCI6fQ9Q0Q5POiyqh3e6aGLRRIDHDQYM6XCtmZBb2jGoS+hYS8sLeCoBDGlCtmPaL4AItZ5rXX31p92iSOXZM+k38CeUKTZzRjg==
X-YMail-OSG: ccVUpMYVM1k1YF4V_B3E5JPKlOgyxKJNfhDxCVSYGup02JMoXnvraD4bFqNcpAc
 MeEkTxBNJLtt4VuKq9FvMJ.c0ZT_dE3C_LedV.9y5PKS1YmkwmXUXb4a.D8.AFGeLbXyRAyp065J
 xu7UEbdntOLXYToJMLq49GVfUo1bxDxtOWg.pL3dgK7d._qO5yChJuPELvl0cp2FPXZEZproGE_p
 jVPRNC9JLqrir3Bp5Xdsp0lJuK8dtQzUDkwHIj3v5A1.d5TKfXri.wkPDxRQwFLgpX0_D9.u6594
 RY7H5x0w.KDNDUtNSaWn5cGFEs_V2XKEh4b03TX2uE7l.5soal6mXb9AwjrFmIQBjxMqmt.9OO7v
 oDWRz0x0xoLhmo4DvLROLAtQFYcB27d8uJTe_0p4IOyA6P84VCEcs9_K53kp1rzLIYllaaTFliPT
 r33pQB6zdPStTGtNMiZe4Gzs9aB32kjvKZTEl334Z.HHs2Q9N9CnmCPUVIRr8TSrGaJ7sbZMf7GB
 EslgkFkhKWKBkmHZwQlchBQaxvctHfgudYxxJauLjXhz5lNiEzlRp82R4CqfnWurmiO658eA.cKd
 xzE82hdZ8QtUy9cJk0UPHZr8kHt1cLx_o_Cdf27M4xdjkZnQHnHtzv.Sud_JYGASRysnslN7lTUA
 nu0y8BaAviTTzV8fGjyJgNylJbTrMpVBduc4Br2beiOonttONYPu0dQjt4s0LL2l1BfR4sQhtbrx
 4P_FLYP5x6JhPTOSWiyUE3br59u9WeMENTjJkKpEKZsijg5U2lin.T46L007imJ3oqHWfTwX1rP2
 RO50_pCK6By3vn_ybame7Z3PYlAkTZnIsperKW18mE1Z.ZGw6AbEO6nQx2WpLrM7oX9D3FebEhHf
 ghhdUHFMl1gSC37roJHO1MdNh3cSwmwQt0C9xEKcMizGXPLYPlsRrTnO4pozlwKxJ65B6zkpfeST
 qneHr8z_B7kgq5rw7JDLe8SHf_83CNC4bUtUQXe.iclOzDYkGio4osNz9zS0L7ThPgj9Ma06Rgng
 .8s7.N9uFnP60aa2GrCJ9CbJUXwNrDhX4s0P0jlAO6lXzJGXeER0wE5SRacbjl4gqNRnfjG0DG8q
 CeVmtXniUV1vPVMmvw4RYNiHqRulMTmn1fH2h3MHX0DLy.4B5eRMpnCAgjLu3p22fqTrkaoUsVAF
 ogJWDfKWbzwMHR0I3D2A2jHe3DdQAA97QZfFT6cNXaT29V3aGQ.xzhrmNoOFhdtpyNC08bwVOTez
 d0qP442NJRTIjMs82sL2y.YnMHoZNi26y5nMiLU6gn_URlTb7CEXhlqUpj_I9JWt7XThfnJrqs8_
 vX28Y_oHY78KY.QuFRJMRSKcswIJ5gy8sGSrfrFyA9u9kZKDMqcjUHzWlKkLBNSfy.2_zvs8BlPE
 LIG5KYBsR16DoE5AuHR8Rkeh_j1RKvTdgNZS8tnHjqRYx6vAWpq9PUxcGE5WFvlGACMq8qhjkSuM
 0Ci7gMhoF3JOBYbl_VE9oDB8PpN38qHJrz4RW
Received: from sonic.gate.mail.ne1.yahoo.com by sonic302.consmr.mail.gq1.yahoo.com with HTTP; Tue, 22 Sep 2020 03:43:36 +0000
Received: by smtp411.mail.ir2.yahoo.com (VZM Hermes SMTP Server) with ESMTPA ID 3e22b08a0f7aafcd23a1be68674f3913;
          Tue, 22 Sep 2020 03:43:32 +0000 (UTC)
From:   Gao Xiang <hsiangkao@aol.com>
To:     linux-xfs@vger.kernel.org
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        Gao Xiang <hsiangkao@redhat.com>
Subject: [PATCH] xfs: drop the obsolete comment on filestream locking
Date:   Tue, 22 Sep 2020 11:42:49 +0800
Message-Id: <20200922034249.20549-1-hsiangkao@aol.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
References: <20200922034249.20549-1-hsiangkao.ref@aol.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Gao Xiang <hsiangkao@redhat.com>

Since commit 1c1c6ebcf52 ("xfs: Replace per-ag array with a radix
tree"), there is no m_peraglock anymore, so it's hard to understand
the described situation since per-ag is no longer an array and no
need to reallocate, call xfs_filestream_flush() in growfs.

In addition, the race condition for shrink feature is quite confusing
to me currently as well. Get rid of it instead.

Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
---
 fs/xfs/xfs_filestream.c | 34 +---------------------------------
 1 file changed, 1 insertion(+), 33 deletions(-)

diff --git a/fs/xfs/xfs_filestream.c b/fs/xfs/xfs_filestream.c
index 1a88025e68a3..db23e455eb91 100644
--- a/fs/xfs/xfs_filestream.c
+++ b/fs/xfs/xfs_filestream.c
@@ -33,39 +33,7 @@ enum xfs_fstrm_alloc {
 /*
  * Allocation group filestream associations are tracked with per-ag atomic
  * counters.  These counters allow xfs_filestream_pick_ag() to tell whether a
- * particular AG already has active filestreams associated with it. The mount
- * point's m_peraglock is used to protect these counters from per-ag array
- * re-allocation during a growfs operation.  When xfs_growfs_data_private() is
- * about to reallocate the array, it calls xfs_filestream_flush() with the
- * m_peraglock held in write mode.
- *
- * Since xfs_mru_cache_flush() guarantees that all the free functions for all
- * the cache elements have finished executing before it returns, it's safe for
- * the free functions to use the atomic counters without m_peraglock protection.
- * This allows the implementation of xfs_fstrm_free_func() to be agnostic about
- * whether it was called with the m_peraglock held in read mode, write mode or
- * not held at all.  The race condition this addresses is the following:
- *
- *  - The work queue scheduler fires and pulls a filestream directory cache
- *    element off the LRU end of the cache for deletion, then gets pre-empted.
- *  - A growfs operation grabs the m_peraglock in write mode, flushes all the
- *    remaining items from the cache and reallocates the mount point's per-ag
- *    array, resetting all the counters to zero.
- *  - The work queue thread resumes and calls the free function for the element
- *    it started cleaning up earlier.  In the process it decrements the
- *    filestreams counter for an AG that now has no references.
- *
- * With a shrinkfs feature, the above scenario could panic the system.
- *
- * All other uses of the following macros should be protected by either the
- * m_peraglock held in read mode, or the cache's internal locking exposed by the
- * interval between a call to xfs_mru_cache_lookup() and a call to
- * xfs_mru_cache_done().  In addition, the m_peraglock must be held in read mode
- * when new elements are added to the cache.
- *
- * Combined, these locking rules ensure that no associations will ever exist in
- * the cache that reference per-ag array elements that have since been
- * reallocated.
+ * particular AG already has active filestreams associated with it.
  */
 int
 xfs_filestream_peek_ag(
-- 
2.24.0

