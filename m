Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8D86C4332F
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Nov 2022 02:05:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229528AbiKICF1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 8 Nov 2022 21:05:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229556AbiKICF0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 8 Nov 2022 21:05:26 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 872B85EFBF
        for <linux-xfs@vger.kernel.org>; Tue,  8 Nov 2022 18:05:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4046BB81CD7
        for <linux-xfs@vger.kernel.org>; Wed,  9 Nov 2022 02:05:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB97DC433D6;
        Wed,  9 Nov 2022 02:05:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667959522;
        bh=pdf7qW1IcSZM532hqef2QHND/wyxG9+mCWGOl93AIwU=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Pg1VVNGKmCgWgzBZAmRjlW4FwODilZ2FNNm1m1CPBIYYcUZS6cxowvXHsT3PCXO9x
         dsnx1zIhePTtB9HHf7tc2HkEvi6Qt0MnvThMx9AvvMpq3Q1OG4jn6NdETt3WjFWJuA
         piKPKxe0u2aWE/WNXeeJiOhDArYMIKF4LMRpepShhpxiCu9foGiNdbLATEDaXScCVm
         4LzBXUnJheELNjjVRWa5fsAF8l/kraM36XOc7mIfuacI48halMgKK9+zXN8fj4gCKI
         xlQTNhPYuivxx2e2R+zBuX6FwYlQJpgTjqxi7A9zyUOjsBj59Mkn2GZhIPIZtZwi+E
         QWdhkvBYvkTtQ==
Subject: [PATCH 4/7] xfs_db: fix octal conversion logic
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     cem@kernel.org, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 08 Nov 2022 18:05:22 -0800
Message-ID: <166795952244.3761353.15080246366537276936.stgit@magnolia>
In-Reply-To: <166795950005.3761353.14062544433865007925.stgit@magnolia>
References: <166795950005.3761353.14062544433865007925.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Fix the backwards boolean logic here, which results in weird behavior.

# xfs_db -x -c /dev/sda
xfs_db> print fname
fname = "\000\000\000\000\000\000\000\000\000\000\000\000"
xfs_db> write fname "mo\0h5o"
fname = "mo\005o\000\000\000\000\000\000\000\000"
xfs_db> print fname
fname = "mo\005o\000\000\000\000\000\000\000\000"

Notice that we passed in octal-zero, 'h', '5', 'o', but the fs label is
set to octal-5, 'o' because of the incorrect loop logic.  -Wlogical-op
found this one.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 db/write.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)


diff --git a/db/write.c b/db/write.c
index 70cb0518d0..6c67e839a9 100644
--- a/db/write.c
+++ b/db/write.c
@@ -479,7 +479,7 @@ convert_oct(
 		if (arg[count] == '\0')
 			break;
 
-		if ((arg[count] < '0') && (arg[count] > '7'))
+		if ((arg[count] < '0') || (arg[count] > '7'))
 			break;
 	}
 
@@ -553,7 +553,7 @@ convert_arg(
 
 			/* do octal conversion */
 			if (*ostr == '\\') {
-				if (*(ostr + 1) >= '0' || *(ostr + 1) <= '7') {
+				if (*(ostr + 1) >= '0' && *(ostr + 1) <= '7') {
 					ret = convert_oct(ostr + 1, &octval);
 					*rbuf++ = octval;
 					ostr += ret + 1;

