Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BA35C77B7E
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 02:27:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233448AbjEZC1g (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 22:27:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235169AbjEZC1g (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 22:27:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B66C9B
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 19:27:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D458064C56
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 02:27:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4587FC433D2;
        Fri, 26 May 2023 02:27:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685068054;
        bh=6fLNIenh/+izzgOksenA4UfhR4GURe07oqoTTNmox+c=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=bnuvnnQ6EXTl4dGqMHlFBMv+tA7GMrd/yhyRz7oxg96vnzQyZvCa3PmHSGj6YVjbC
         o1MUkRlxRUlo8lx6ISoCXYrnVgMj4V96y77C6jUwEYwYwZIWlvr3lvjxGOVczg3eOQ
         mUGfnbYejgKzrkzqfaIcSxrSRCTJnyxfbfM0e3DgxWeG3JIxfvX1FUBOF7MZX+9wFR
         a11us3Yafb01GTn3Zs1sKn8HA2DNq2UJVTxhaqEDSlRl//Y8Sh0zwd9YuGiZZ8wwf9
         vATZjlPSp/ModxLfl5aLapnWfWEmevrfZuvmO0UK0AwkGJDkaPFZO3gy7gNmH0cPwi
         wWMtZ5bHMbJ4A==
Date:   Thu, 25 May 2023 19:27:33 -0700
Subject: [PATCH 22/30] xfs_db: report parent bit on xattrs
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     Allison Henderson <allison.henderson@oracle.com>,
        linux-xfs@vger.kernel.org, allison.henderson@oracle.com,
        catherine.hoang@oracle.com
Message-ID: <168506078187.3749421.15484403053645276279.stgit@frogsfrogsfrogs>
In-Reply-To: <168506077876.3749421.7883085669588003826.stgit@frogsfrogsfrogs>
References: <168506077876.3749421.7883085669588003826.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Display the parent bit on xattr keys

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
---
 db/attr.c      |    3 +++
 db/attrshort.c |    3 +++
 2 files changed, 6 insertions(+)


diff --git a/db/attr.c b/db/attr.c
index ba722e146e2..f29e4a54454 100644
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
index e234fbd8365..872d771d5ed 100644
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

