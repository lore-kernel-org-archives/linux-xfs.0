Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 939E4C6FD19
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Mar 2023 19:28:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229895AbjCPT2U (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Mar 2023 15:28:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229820AbjCPT2T (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Mar 2023 15:28:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0924B13527
        for <linux-xfs@vger.kernel.org>; Thu, 16 Mar 2023 12:28:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AB9A0B8231F
        for <linux-xfs@vger.kernel.org>; Thu, 16 Mar 2023 19:28:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61AF5C433EF;
        Thu, 16 Mar 2023 19:28:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678994895;
        bh=jiwFHXZktiKxZsaRVJyoGRvgthhI+8QDBIJ5awuct/M=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=VPlaL0kecVG1Wv5DnDlL/vEybPZpr4egIKLdjLk/q5OsVEe8IVnXKkq2qTuNMANZi
         KOi0WECV8hIudOeIbzjBnbiz53gDEQAwS9genkTDGbk0e5SM/xybJ9Qe8VeAGyzZo9
         VW/ggbW3tYDMD+fNd8JWk3lF0Pw6nrBfrsPMdRpbOjshEJv9QLtDTLqrwxYLIjzcE0
         cGKsekxUBWQs3uvM73tHOg5BQaJzEpV1HJ3gfssd1BhjK6GB5QqoTU9ajVeNStbX/W
         9Ylt09hMjJwa46Pfq9O8FtsZLkB845KKnOfC2bz7PBn2Y2A6W35tjt3AB9C0Lc4X1s
         PzyZ+cMVL9H2Q==
Date:   Thu, 16 Mar 2023 12:28:15 -0700
Subject: [PATCH 9/9] xfs_repair: fix incorrect dabtree hashval comparison
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <167899415493.16278.8913999236747348438.stgit@frogsfrogsfrogs>
In-Reply-To: <167899415375.16278.9528475200288521209.stgit@frogsfrogsfrogs>
References: <167899415375.16278.9528475200288521209.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

If an xattr structure contains enough names with the same hash value to
fill multiple xattr leaf blocks with names all hashing to the same
value, then the dabtree nodes will contain consecutive entries with the
same hash value.

This causes false corruption reports in xfs_repair because it's not
expecting such a huge same-hashing structure.  Fix that.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 repair/da_util.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/repair/da_util.c b/repair/da_util.c
index 7239c2e2c..b229422c8 100644
--- a/repair/da_util.c
+++ b/repair/da_util.c
@@ -330,7 +330,7 @@ _("%s block used/count inconsistency - %d/%hu\n"),
 	/*
 	 * hash values monotonically increasing ???
 	 */
-	if (cursor->level[this_level].hashval >=
+	if (cursor->level[this_level].hashval >
 				be32_to_cpu(nodehdr.btree[entry].hashval)) {
 		do_warn(
 _("%s block hashvalue inconsistency, expected > %u / saw %u\n"),

