Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F5A6C4167B
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 03:10:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236258AbiLaDKT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 22:10:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236304AbiLaDKR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 22:10:17 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1395F10540;
        Fri, 30 Dec 2022 19:10:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A2CE361CFF;
        Sat, 31 Dec 2022 03:10:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FD5BC433F0;
        Sat, 31 Dec 2022 03:10:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672456215;
        bh=BpaBDjKCvZQ+wAUI1pEUjtOo2RP/+hrK1stKhpKlLgU=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Ek8tU484DLMWEQa54KSHPlDz/k78/5490yszOHIkEatZmZ+ImiQEMJ3GtIzp5tt2b
         3ny8WmGh4kj3GxyxDDcg/2L3DMi9yLS4eVkXITV0HvM3CtWgRYfBGFkbY327M78oFe
         bU6xu+jeMY3XVYUnmsZSR4ZrioXnJwpeI1K7a+BmE5qZciN5aGVZuBXI3KbHMOjmfX
         dFK2ndVBT3j1y0/roQO1QOucFInHHNvK3ljBGwKExaQxtYvnaj5/1SPFOxti0QZldi
         nCCtyXvDVuybm16QTaCUB12Oqba1ayRmqwWU6vDHicEeweqKWQi9jS4v53q4EphQL3
         UcnQluqrdSGvg==
Subject: [PATCH 03/12] xfs/206: update mkfs filtering for rt groups feature
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Fri, 30 Dec 2022 14:20:39 -0800
Message-ID: <167243883987.739029.11440531374025755858.stgit@magnolia>
In-Reply-To: <167243883943.739029.3041109696120604285.stgit@magnolia>
References: <167243883943.739029.3041109696120604285.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Filter out the new mkfs lines that show the rtgroup information, since
this test is heavily dependent on old mkfs output.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/xfs/206 |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)


diff --git a/tests/xfs/206 b/tests/xfs/206
index c181d7dd3e..904d53deb0 100755
--- a/tests/xfs/206
+++ b/tests/xfs/206
@@ -65,7 +65,8 @@ mkfs_filter()
 	    -e "s/, lazy-count=[0-9]//" \
 	    -e "/.*crc=/d" \
 	    -e "/^Default configuration/d" \
-	    -e "/metadir=.*/d"
+	    -e "/metadir=.*/d" \
+	    -e '/rgcount=/d'
 }
 
 # mkfs slightly smaller than that, small log for speed.

