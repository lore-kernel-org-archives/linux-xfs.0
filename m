Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72F85C61DA4
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Feb 2023 20:59:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230010AbjBPU71 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Feb 2023 15:59:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230007AbjBPU7W (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Feb 2023 15:59:22 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 284C0528BE
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 12:59:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D897CB82962
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 20:59:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 953EAC433EF;
        Thu, 16 Feb 2023 20:59:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676581154;
        bh=rMIqy3yUnFVYfjKK++U6n17GtUlAI8hq1rHQ5EgIeyA=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=RpdqYqztlatEgSUn18TKTXoBJnSkhczx4pOY/lExGUEVBKR5eFS94yfy/Fb8L1ebE
         3DQnPPDV8m6j7V1oqJ5/YPpPEtgFI5zlT14UzrdZZ3kvktA0yJHpWT53Ao7CNhmaR1
         6xEvYqcJpAXANdbuNXFeDm5ZGHppxreiIf7f85OvV40XjKXhD3lEGv5pFdr/jnfagD
         LtQ58jm07zs+gI6/OnrX+CL9PhLb/QTNuLQ8J7xdtJWmFDv1no99ASX2nWj1Klr4L5
         tXGHR0ZvOn5JOjTbSBEI3Sf7UsFR7pYX1ixfEtizadtLFs76DwezHBiK9yKlGY5FzD
         RGHFKBwIG2zmQ==
Date:   Thu, 16 Feb 2023 12:59:14 -0800
Subject: [PATCH 22/25] xfs_db: report parent bit on xattrs
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Allison Henderson <allison.henderson@oracle.com>,
        allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <167657879201.3476112.8276460435509436134.stgit@magnolia>
In-Reply-To: <167657878885.3476112.11949206434283274332.stgit@magnolia>
References: <167657878885.3476112.11949206434283274332.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

Display the parent bit on xattr keys

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
---
 db/attr.c      |    3 +++
 db/attrshort.c |    3 +++
 2 files changed, 6 insertions(+)


diff --git a/db/attr.c b/db/attr.c
index ba722e14..f29e4a54 100644
--- a/db/attr.c
+++ b/db/attr.c
@@ -82,6 +82,9 @@ const field_t	attr_leaf_entry_flds[] = {
 	{ "local", FLDT_UINT1,
 	  OI(LEOFF(flags) + bitsz(uint8_t) - XFS_ATTR_LOCAL_BIT - 1), C1, 0,
 	  TYP_NONE },
+	{ "parent", FLDT_UINT1,
+	  OI(LEOFF(flags) + bitsz(uint8_t) - XFS_ATTR_PARENT_BIT - 1), C1, 0,
+	  TYP_NONE },
 	{ "pad2", FLDT_UINT8X, OI(LEOFF(pad2)), C1, FLD_SKIPALL, TYP_NONE },
 	{ NULL }
 };
diff --git a/db/attrshort.c b/db/attrshort.c
index e234fbd8..872d771d 100644
--- a/db/attrshort.c
+++ b/db/attrshort.c
@@ -44,6 +44,9 @@ const field_t	attr_sf_entry_flds[] = {
 	{ "secure", FLDT_UINT1,
 	  OI(EOFF(flags) + bitsz(uint8_t) - XFS_ATTR_SECURE_BIT - 1), C1, 0,
 	  TYP_NONE },
+	{ "parent", FLDT_UINT1,
+	  OI(EOFF(flags) + bitsz(uint8_t) - XFS_ATTR_PARENT_BIT - 1), C1, 0,
+	  TYP_NONE },
 	{ "name", FLDT_CHARNS, OI(EOFF(nameval)), attr_sf_entry_name_count,
 	  FLD_COUNT, TYP_NONE },
 	{ "value", FLDT_CHARNS, attr_sf_entry_value_offset,

