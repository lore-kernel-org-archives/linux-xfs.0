Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F147C76196
	for <linux-xfs@archiver.kernel.org>; Thu,  6 Apr 2023 19:37:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229794AbjDFThg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 6 Apr 2023 15:37:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229458AbjDFThf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 6 Apr 2023 15:37:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD873E72
        for <linux-xfs@vger.kernel.org>; Thu,  6 Apr 2023 12:37:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 56CA260F24
        for <linux-xfs@vger.kernel.org>; Thu,  6 Apr 2023 19:37:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF002C433D2;
        Thu,  6 Apr 2023 19:37:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680809853;
        bh=4zog0V7X2LVKO95wOW+NtSxXVED0FGXZthcFixbxSP8=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=AoMhyMxDiND0QuaDwal2ofjjXPvu3dy2MjQEeXHB2Qzz98K6iCMf2mRSV/aJbfshI
         h/QRWQEUFlu/+yKUXPNzYVZzF+I5MJL5lro3idWw7xkC6Orb78vrnLc255spHiCS6O
         VHv7A3BcgMsbstjWIBnAtXOsAhziQUWnF2HAjYmUITP6ZPoukwBN/KQ0ZY7kKbBhpT
         Z9ButoJKvsz5gjNmtV7BwSWMrkLrka/CZ23Ycyf7PM31MvgEFT2L/U+45LsfiPadwG
         zJdqMomoJgn3/fP6hP+QRXtjX7e9B4I5Yir3SafhW4ypuiRleHl0s5mjwngpfMPb0G
         PZtiAr30YXa/w==
Date:   Thu, 06 Apr 2023 12:37:33 -0700
Subject: [PATCH 23/32] xfs_db: report parent bit on xattrs
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Allison Henderson <allison.henderson@oracle.com>,
        allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <168080827859.616793.17238285720530002492.stgit@frogsfrogsfrogs>
In-Reply-To: <168080827546.616793.7264157843231723676.stgit@frogsfrogsfrogs>
References: <168080827546.616793.7264157843231723676.stgit@frogsfrogsfrogs>
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
index ba722e146..f29e4a544 100644
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
index e234fbd83..872d771d5 100644
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

