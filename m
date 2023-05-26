Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8508C77B7E
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 02:02:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232388AbjEZCCe (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 22:02:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236327AbjEZCCY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 22:02:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B2A31A4;
        Thu, 25 May 2023 19:02:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D5A096179C;
        Fri, 26 May 2023 02:02:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CDC0C433EF;
        Fri, 26 May 2023 02:02:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685066542;
        bh=LH5q+aSG98FcQV9OMtAWhsX747vXiHbVLa2jpTrhpWc=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=raJxYajexebn25381gGqCY12HxqjilR0SlzUiYyrwZN8VJKl3v+c4bRK6GlXY/S+V
         PBJD9333v7/QRM/J9U6yFZZLr0RVJ1bA3Qk4eWS2pvVYikcKXw6s5GOjIyWTFhilJb
         WqUiaFNVBX35UV+mrKOQ+Su+WOUezlRL5+J4d70EN1+pkEMj1SzPrGhyhOXc5fSIyq
         olAAsrzNfveeMnI/a2XkMTvS6+wGv8Q4uAsFyL4nxY9+BHDHEWUz/DLXR3Ivmm+Jlq
         k++d4AtFsD4M7i6pZI56i0MyI3j5LYc828SyfcCyZQz1sJasq0b2PvtoMSigZ/Qh0u
         ki1iGuU74gVyA==
Date:   Thu, 25 May 2023 19:02:21 -0700
Subject: [PATCH 01/11] xfs/206: filter out the parent= status from mkfs
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me,
        allison.henderson@oracle.com, catherine.hoang@oracle.com
Message-ID: <168506060861.3732476.3517693645871830366.stgit@frogsfrogsfrogs>
In-Reply-To: <168506060845.3732476.15364197106064737675.stgit@frogsfrogsfrogs>
References: <168506060845.3732476.15364197106064737675.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Filter out the parent pointer bits from the mkfs output so that we don't
cause a regression in this test.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/xfs/206 |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)


diff --git a/tests/xfs/206 b/tests/xfs/206
index cb346b6dc9..af86570a81 100755
--- a/tests/xfs/206
+++ b/tests/xfs/206
@@ -64,7 +64,8 @@ mkfs_filter()
 	    -e "s/\(sunit=\)\([0-9]* blks,\)/\10 blks,/" \
 	    -e "s/, lazy-count=[0-9]//" \
 	    -e "/.*crc=/d" \
-	    -e "/^Default configuration/d"
+	    -e "/^Default configuration/d" \
+	    -e '/parent=/d'
 }
 
 # mkfs slightly smaller than that, small log for speed.

