Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5EF5C61DA4
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Feb 2023 21:17:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229741AbjBPVRB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Feb 2023 16:17:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229637AbjBPVRA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Feb 2023 16:17:00 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BB5048E22;
        Thu, 16 Feb 2023 13:16:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DBC3360C1A;
        Thu, 16 Feb 2023 21:16:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B18DC433EF;
        Thu, 16 Feb 2023 21:16:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676582218;
        bh=kh85dL/qqZbuVSzMbEPCcfYMMB4l1wBbf8L6umKwQEk=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=XMEI2mzaQVrYD5j4OQzjV4QlsIm2xXB6DSImcX78rEdAY72/CQoss7yRgRWRI/NVA
         qkoTZiwDGQhEMLZRj3qFxvA19DbVtFD4NnfEjBG9/36sitbEtdlpagolDylGTokjWu
         B1sId6UmQWpPKrCtjBaZn6BzsRhKLU9rkhViLYxPbAo+6AtCUFrQbUFzVjNfM0i75j
         rouJDiOaOSJSj9Rw4dcCghIRO5LWjx2/L2gsdoAf/AyTtO7m3BlUFvH15HTD/1mzHw
         2ABWokRJOrKyESdQ0LRi5wa28BrAMiYLSVTaMgkAH9yNUgKbaki6bFHoK57SEx31pQ
         A1lFowWIXz/7A==
Date:   Thu, 16 Feb 2023 13:16:57 -0800
Subject: [PATCH 13/14] common/parent: check xfs_io parent command paths
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, zlang@redhat.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Message-ID: <167657884661.3481377.17754411294910000961.stgit@magnolia>
In-Reply-To: <167657884480.3481377.14824439551809919632.stgit@magnolia>
References: <167657884480.3481377.14824439551809919632.stgit@magnolia>
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
index 7e63765d56..96547727d9 100644
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

