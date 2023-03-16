Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38E5EC76195
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Mar 2023 19:36:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230337AbjCPTgX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Mar 2023 15:36:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230270AbjCPTgW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Mar 2023 15:36:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E8284B810;
        Thu, 16 Mar 2023 12:36:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1CA4EB82302;
        Thu, 16 Mar 2023 19:36:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC55FC4339E;
        Thu, 16 Mar 2023 19:36:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678995378;
        bh=bePbecE8B6uKqE7NYueUnM2J3etaK/LYKPJmICnAbP8=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=jBocLySXoCzDC3lec6m/NbABmanOxsDHBzGq4ES3Xw2ziSaeqXPObYAbqB9FayKyf
         LFGbF0v5gEPV5HjaBeEjbx5d/ry8FVc14vTg6fyqwvv+6rPPEqaRoKAHWWu10ZFfT1
         VvKP6pa+KkLbAQlf2CBE1TuMXJPPLn74q84c8xWM8v+gSavu9dklxY9iRcvynCjODe
         gkNvtDPRtrtU3lzyg3wYwiPkdsVSr6YQfO8IG5fctNq3lDAKUWPiqzN168SadUqFDv
         yimSVY+J3+UAcG3DDOrbsngt7oIFHXFqDY0NdFcXcaHxcLamdr0NmV3eWHiNCiTHFX
         afEh6uPILpPSw==
Date:   Thu, 16 Mar 2023 12:36:18 -0700
Subject: [PATCH 13/14] common/parent: check xfs_io parent command paths
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Message-ID: <167899417826.17926.2967499296381728014.stgit@frogsfrogsfrogs>
In-Reply-To: <167899417650.17926.7405859750613330339.stgit@frogsfrogsfrogs>
References: <167899417650.17926.7405859750613330339.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Make sure that the paths returned by the xfs_io parent command actually
point to the same file.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 common/parent |    8 ++++++++
 1 file changed, 8 insertions(+)


diff --git a/common/parent b/common/parent
index 8d007bd9ad..f849e4b27c 100644
--- a/common/parent
+++ b/common/parent
@@ -155,6 +155,14 @@ _verify_parent()
 			"but should be $cino"
 	fi
 
+	# Make sure path printing works by checking that the paths returned
+	# all point to the same inode.
+	local tgt="$SCRATCH_MNT/$child_path"
+	$XFS_IO_PROG -x -c 'parent -p' "$tgt" | while read pptr_path; do
+		test "$tgt" -ef "$pptr_path" || \
+			echo "$tgt parent pointer $pptr_path should be the same file"
+	done
+
 	echo "*** Verified parent pointer:"\
 			"name:$PPNAME, namelen:$PPNAME_LEN"
 	echo "*** Parent pointer OK for child $child_path"

