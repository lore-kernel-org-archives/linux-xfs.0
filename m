Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CFC63C4332F
	for <linux-xfs@archiver.kernel.org>; Wed, 16 Mar 2022 03:30:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353462AbiCPDbk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 15 Mar 2022 23:31:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353461AbiCPDbk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 15 Mar 2022 23:31:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 672863981F;
        Tue, 15 Mar 2022 20:30:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 037F161716;
        Wed, 16 Mar 2022 03:30:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CE99C340E8;
        Wed, 16 Mar 2022 03:30:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647401426;
        bh=euXMmFFqv5U92GMGhH0sggzumUK8fKZB3HfYE667j3U=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=YkQYD2nPBXVqWFQEvxuFg9nn7Gur7tEGJh5XNXHh8LtsYbqFkB45+LR5mlMYRUl6y
         YqljX+rwR3lglYtYUtqk5pz6B/8JZlV/uhFp5/Z5V6myZ/6MWEiVaKSUEGaepsl/0G
         dBfteia36yFYRS0jZIOsFfEWABc4YwHFHLSHZEMie3rgscBr1z5pxbLp2KgPLhH0Tk
         A1A1moiGS/E5B1H+7Yd4rwBsXcnHLZUWIrbz85KiK/D2qCJtNFUFfKpUFMXj8FbWW5
         T6dJGYFW2tIwJZwQ/IcckSfMnAIIVECr7ZFG1Gt8xcvP4JlhMULr44R4TjdSDm2OVI
         L0f9oKWKMmFxw==
Subject: [PATCH 4/4] generic/673: fix golden output to reflect vfs setgid
 behavior
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Tue, 15 Mar 2022 20:30:25 -0700
Message-ID: <164740142591.3371628.12793589713189041823.stgit@magnolia>
In-Reply-To: <164740140348.3371628.12967562090320741592.stgit@magnolia>
References: <164740140348.3371628.12967562090320741592.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Filipe Manana pointed out[1] that the setgid dropping behavior encoded
in this generic test is based on some outdated XFS code, and not based
on what the VFS inode attribute change functions actually do.  Now that
we're working on fixing that, we should update the golden output to
reflect what all filesystems are supposed to be doing.

[1] https://lore.kernel.org/linux-xfs/CAL3q7H47iNQ=Wmk83WcGB-KBJVOEtR9+qGczzCeXJ9Y2KCV25Q@mail.gmail.com/

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/generic/673.out |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)


diff --git a/tests/generic/673.out b/tests/generic/673.out
index 8df672d6..4d18bca2 100644
--- a/tests/generic/673.out
+++ b/tests/generic/673.out
@@ -3,7 +3,7 @@ Test 1 - qa_user, non-exec file
 310f146ce52077fcd3308dcbe7632bb2  SCRATCH_MNT/a
 6666 -rwSrwSrw- SCRATCH_MNT/a
 3784de23efab7a2074c9ec66901e39e5  SCRATCH_MNT/a
-2666 -rw-rwSrw- SCRATCH_MNT/a
+666 -rw-rw-rw- SCRATCH_MNT/a
 
 Test 2 - qa_user, group-exec file
 310f146ce52077fcd3308dcbe7632bb2  SCRATCH_MNT/a
@@ -15,7 +15,7 @@ Test 3 - qa_user, user-exec file
 310f146ce52077fcd3308dcbe7632bb2  SCRATCH_MNT/a
 6766 -rwsrwSrw- SCRATCH_MNT/a
 3784de23efab7a2074c9ec66901e39e5  SCRATCH_MNT/a
-2766 -rwxrwSrw- SCRATCH_MNT/a
+766 -rwxrw-rw- SCRATCH_MNT/a
 
 Test 4 - qa_user, all-exec file
 310f146ce52077fcd3308dcbe7632bb2  SCRATCH_MNT/a

