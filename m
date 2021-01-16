Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AACFDC43331
	for <linux-xfs@archiver.kernel.org>; Sat, 16 Jan 2021 01:25:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8509223B04
	for <linux-xfs@archiver.kernel.org>; Sat, 16 Jan 2021 01:25:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725815AbhAPBZs (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 15 Jan 2021 20:25:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:33188 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725922AbhAPBZr (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 15 Jan 2021 20:25:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CA60623A50;
        Sat, 16 Jan 2021 01:24:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610760294;
        bh=7nI82z5HgjFvHIWKDcemtQ1ZEreDaWvqwiWecae8JzA=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=JkeRZRUXIcXtrL+A9WvsT24p89nQlYjy8GBuYg/B5wPR4bhdeVnjyMVlGaX+zyUYZ
         te+Vjdqqlgb2RpDIA++x3E/ED9kect3RRJzhb/uJy7ZIADDSNDw9ssEMbJWdrrBzJ+
         /+kJwn254zKRkE5KpoACdWImkGqDLTHI//BdaNhGftCpZYkQSNzUXB56ovoOBGTuSR
         z9CsB5U7USxVN82039FqdB0LxYwqwflXdbaHD7ke3IAQDA8z752OJSsOb41ruzBwb7
         Yo5J12USjpKdP+Pf47pEOPxH9c5l3vsuAh03ZksBbQpcLkJUZZUyhH+X+NJFrwEASm
         n/v0wFf5ZpNFA==
Subject: [PATCH 2/2] xfs_repair: clear the needsrepair flag
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 15 Jan 2021 17:24:53 -0800
Message-ID: <161076029319.3386490.2011901341184065451.stgit@magnolia>
In-Reply-To: <161076028124.3386490.8050189989277321393.stgit@magnolia>
References: <161076028124.3386490.8050189989277321393.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Clear the needsrepair flag, since it's used to prevent mounting of an
inconsistent filesystem.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 repair/agheader.c |   15 +++++++++++++++
 1 file changed, 15 insertions(+)


diff --git a/repair/agheader.c b/repair/agheader.c
index 8bb99489..d9b72d3a 100644
--- a/repair/agheader.c
+++ b/repair/agheader.c
@@ -452,6 +452,21 @@ secondary_sb_whack(
 			rval |= XR_AG_SB_SEC;
 	}
 
+	if (xfs_sb_version_needsrepair(sb)) {
+		if (!no_modify)
+			sb->sb_features_incompat &=
+					~XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR;
+		if (i == 0) {
+			if (!no_modify)
+				do_warn(
+	_("clearing needsrepair flag and regenerating metadata\n"));
+			else
+				do_warn(
+	_("would clear needsrepair flag and regenerate metadata\n"));
+		}
+		rval |= XR_AG_SB_SEC;
+	}
+
 	return(rval);
 }
 

