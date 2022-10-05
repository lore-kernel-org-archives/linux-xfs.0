Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDA24C4332F
	for <linux-xfs@archiver.kernel.org>; Wed,  5 Oct 2022 22:31:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229514AbiJEWbJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 5 Oct 2022 18:31:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229687AbiJEWbI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 5 Oct 2022 18:31:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 129A183F28;
        Wed,  5 Oct 2022 15:31:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A519E617E5;
        Wed,  5 Oct 2022 22:31:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A5DBC433B5;
        Wed,  5 Oct 2022 22:31:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665009067;
        bh=tN+pI5TIJ/FHJZ7DtmUX0JuK9o5Pd0pwl8Ib3nY9hDw=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=dPbaSjqXM/O4kfZVqZWnV61ixCyl4udJimzGKIqf9w1CQ+FMUc9LZXRUjXlaBo91Q
         MjZrH/lZYQ7Bog3Bl/aiOJZs/KtUqXxyDRERDvjGPlaYgh0OLNE5gvRz5uGsu6EyjD
         Eqd8rMgTm3noJMv9/WjH9unM3Gra7xNhtHfGiwS5aB8Z0bf4kNjZH4DQZoWg0wKsg0
         UBBZBFQyQ9iF0KC9Q5gKIecjSFYfhcIlIpyHSG3RyhWShxkN0IXQWDpxClt2NlYanr
         /QDe9jlUrAcWJnQv7H7Te/95CX/CEwcA72zsNHWJttvahHhM92a0dIcPEJiG1OnZcr
         Nw7QSK9o3VAUQ==
Subject: [PATCH 6/6] common/populate: fix _xfs_metadump usage in
 _scratch_populate_cached
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com, zlang@redhat.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Wed, 05 Oct 2022 15:31:06 -0700
Message-ID: <166500906664.886939.1596674456976768238.stgit@magnolia>
In-Reply-To: <166500903290.886939.12532028548655386973.stgit@magnolia>
References: <166500903290.886939.12532028548655386973.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

_xfs_metadump requires that the caller pass in "none" for the log device
if it doesn't have a log device, so fix this call site.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 common/populate |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/common/populate b/common/populate
index 4eee7e8c66..cfdaf766f0 100644
--- a/common/populate
+++ b/common/populate
@@ -891,7 +891,7 @@ _scratch_populate_cached() {
 		_scratch_xfs_populate $@
 		_scratch_xfs_populate_check
 
-		local logdev=
+		local logdev=none
 		[ "$USE_EXTERNAL" = yes -a ! -z "$SCRATCH_LOGDEV" ] && \
 			logdev=$SCRATCH_LOGDEV
 

