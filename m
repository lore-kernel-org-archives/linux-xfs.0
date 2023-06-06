Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C21DC7EE43
	for <linux-xfs@archiver.kernel.org>; Tue,  6 Jun 2023 22:29:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239871AbjFFW3o (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 6 Jun 2023 18:29:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239862AbjFFW3m (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 6 Jun 2023 18:29:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 257361717;
        Tue,  6 Jun 2023 15:29:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AEA936387C;
        Tue,  6 Jun 2023 22:29:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13EC6C433EF;
        Tue,  6 Jun 2023 22:29:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1686090580;
        bh=fEm/Idf75DCZarblOvbO8t1Xx4/xc9Xee6F/imxJwIU=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=FvfvPJ7YH80Sq7U4BAKjVI6gXViI/fAtswokgFdbuRrv9NLFMtTFrtMhxzmqfb2xH
         /442zC8wKGoAV5PHx+wIQvAH1Uk97H3uhvm3h8hcYz64xWNYNgVHJKXEQQGzjQ+O5q
         596Y5CGzQP9duViqvW7e4D4KqzC5G0JNnWPzyeUaq4HaCdk+8fGn8IU50glB/E2dKH
         KORS4rldytRUDIhs0RDYF32dMYngUiiGMQbHdLG8ZLHPTq3mrQZUzAHca/VyBQA8XA
         kahyT8R/XSHl3SrVeXQaArkRe13RwWDwGNYXhitosoMp9F5M2qiircby0JKG7Wna3j
         G6rtz6+4YC95w==
Subject: [PATCH 3/3] common/xfs: compress online repair rebuild output by
 default
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Tue, 06 Jun 2023 15:29:39 -0700
Message-ID: <168609057963.2592490.3833577466322610879.stgit@frogsfrogsfrogs>
In-Reply-To: <168609056295.2592490.1272515528324889317.stgit@frogsfrogsfrogs>
References: <168609056295.2592490.1272515528324889317.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Force-repairing the filesystem after a test can fill up /tmp with quite
a lot of logging message.  We don't have a better place to stash that
output in case the scrub fails and we need to analyze it later, so
compress it with gzip and only decompress it later.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 common/xfs |   19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)


diff --git a/common/xfs b/common/xfs
index d85acd9572..c7671f8f9d 100644
--- a/common/xfs
+++ b/common/xfs
@@ -910,25 +910,28 @@ _check_xfs_filesystem()
 		# repairs considerably when the directory tree is very large.
 		find $mntpt &>/dev/null &
 
-		XFS_SCRUB_FORCE_REPAIR=1 "$XFS_SCRUB_PROG" -v -d $mntpt > $tmp.scrub 2>&1
-		if [ $? -ne 0 ]; then
-			if grep -q 'No space left on device' $tmp.scrub; then
+		XFS_SCRUB_FORCE_REPAIR=1 "$XFS_SCRUB_PROG" -v -d $mntpt 2>&1 | gzip > $tmp.scrub.gz
+		ret=$?
+		if [ $ret -ne 0 ]; then
+			if zgrep -q 'No space left on device' $tmp.scrub.gz; then
 				# It's not an error if the fs does not have
 				# enough space to complete a repair.  We will
 				# check everything, though.
-				echo "*** XFS_SCRUB_FORCE_REPAIR=1 xfs_scrub -v -d ran out of space ***" >> $seqres.full
-				cat $tmp.scrub >> $seqres.full
+				echo "*** XFS_SCRUB_FORCE_REPAIR=1 xfs_scrub -v -d ran out of space ret=$ret ***" >> $seqres.full
+				echo "See $seqres.scrubout.gz for details." >> $seqres.full
+				mv $tmp.scrub.gz $seqres.scrubout.gz
 				echo "*** end xfs_scrub output" >> $seqres.full
 			else
 				_log_err "_check_xfs_filesystem: filesystem on $device failed scrub orebuild"
-				echo "*** XFS_SCRUB_FORCE_REPAIR=1 xfs_scrub -v -d output ***" >> $seqres.full
-				cat $tmp.scrub >> $seqres.full
+				echo "*** XFS_SCRUB_FORCE_REPAIR=1 xfs_scrub -v -d output ret=$ret ***" >> $seqres.full
+				echo "See $seqres.scrubout.gz for details." >> $seqres.full
+				mv $tmp.scrub.gz $seqres.scrubout.gz
 				echo "*** end xfs_scrub output" >> $seqres.full
 				ok=0
 				orebuild_ok=0
 			fi
 		fi
-		rm -f $tmp.scrub
+		rm -f $tmp.scrub.gz
 
 		# Clear force_repair because xfs_scrub could have set it
 		$XFS_IO_PROG -x -c 'inject noerror' "$mntpt" >> $seqres.full

