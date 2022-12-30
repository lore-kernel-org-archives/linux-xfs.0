Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96F62C4167B
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 03:11:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229560AbiLaDLH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 22:11:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236311AbiLaDLG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 22:11:06 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65E1DB844;
        Fri, 30 Dec 2022 19:11:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0E296B81E69;
        Sat, 31 Dec 2022 03:11:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3856C433EF;
        Sat, 31 Dec 2022 03:11:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672456261;
        bh=wsqC3D7LUO/WzeJWOdHsFQhiOxAWi4EJ1NZMu3PLVgo=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=rDwq5kOKSjSCIY8D3C/43a35UPdAy7HSShfhPMtnJ7jgSGWAKvq4JDNXK/f4O2rHr
         aBk9BmevDdiCsoY8ls4atbSJtFkaGPTT466jowQtxPW9baVJIJjwus2NdiQKpBHhd+
         4XmjdwLqViw6sUzXTd7QDcfAUvzBMoUOdMIPVmbNfkI4zrXhfc6Zyx1luCgEzvd4ig
         iHzjbzDRduLTK2r0wC0Gw/zOT6RxTOiKSh8y4wyMxeHp+bd1aZRw3TpFGM0v+/SGqh
         m6SdyQakQWn5FJzr+sI9QkX8Krr8HRJLuJ4rTKTst58YC1ZD1ZymbzsznQxr/e5thf
         oqRDsYJnkiyIQ==
Subject: [PATCH 06/12] xfs/185: update for rtgroups
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Fri, 30 Dec 2022 14:20:40 -0800
Message-ID: <167243884026.739029.5256016394301933477.stgit@magnolia>
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

Send the fallocate results to seqres.full, since it doesn't matter if
the call fails as long as we get the layout that we wanted.  This test
already has code to check the layout, so there's no point in failing on
random ENOSPC errors.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/xfs/185 |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/tests/xfs/185 b/tests/xfs/185
index abeb052580..04770fd6c9 100755
--- a/tests/xfs/185
+++ b/tests/xfs/185
@@ -100,7 +100,7 @@ test "$ddbytes" -lt "$((rtbytes + (10 * rtextsize) ))" || \
 # easy because fallocate for the first rt file always starts allocating at
 # physical offset zero.
 alloc_rtx="$((rtbytes / rtextsize))"
-$XFS_IO_PROG -c "falloc 0 $((alloc_rtx * rtextsize))" $rtfile
+$XFS_IO_PROG -c "falloc 0 $((alloc_rtx * rtextsize))" $rtfile &>> $seqres.full
 
 expected_end="$(( (alloc_rtx * rtextsize - 1) / 512 ))"
 

