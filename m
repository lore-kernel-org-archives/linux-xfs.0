Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B43C2C25B06
	for <linux-xfs@archiver.kernel.org>; Thu,  4 Aug 2022 16:26:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236598AbiHDQ0z (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 4 Aug 2022 12:26:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232643AbiHDQ0x (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 4 Aug 2022 12:26:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A642C13F91;
        Thu,  4 Aug 2022 09:26:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 63547B824B3;
        Thu,  4 Aug 2022 16:26:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 061E4C433B5;
        Thu,  4 Aug 2022 16:26:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659630410;
        bh=lrSiw14d/U+oIYMUnC/QO7BRBpEicHdt+XCb50EZUpo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=klqn6fjtpTaAwXy3LclAuLs2vmmLZhXzAm9+jwY2kaJ0xnSV8qlq4KnxCc/QD3bjW
         QqTTBlP1u0InwJg3g3fg9Y6SYH0FXnXHjPntf6A1QGF4Lquogf0HCOtsx/kHr9IP5p
         nPXrE48gVisRJo2x/CvTJSnazuhCJOYEvNjIKsXRABKgvdMFP0beYToLL6fsEJyjBF
         930IRm2m+UgVpIh5yILSYGJ8sblgCaXtUP+apmoZVBOnqWn+m9Om9tqBIOephlBX1E
         P8+vbMuEOV7QUYxEFT9TaFRv/8DSwq2w0AG0btdcT4dF2GNexGFTX+lf+tT4byUCYA
         CUYDnb8EOigQw==
Date:   Thu, 4 Aug 2022 09:26:49 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     guaneryu@gmail.com, zlang@redhat.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me,
        xuyang2018.jy@fujitsu.com
Subject: [PATCH v1.1 3/3] xfs/533: fix false negatives for this test
Message-ID: <YuvzSdINZZ3PV20q@magnolia>
References: <165950048029.198815.11843926234080013062.stgit@magnolia>
 <165950049724.198815.5496412458825635633.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <165950049724.198815.5496412458825635633.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

xfsprogs 5.19 will change the error message that gets printed when the
primary superblock validation fails.  Filter the _get_metadata_field
output so that the new message looks like the old message.

While we're at it, _notrun this test on V4 filesystems because the
validation messages are in the V5 superblock validation functions.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/xfs/533 |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/tests/xfs/533 b/tests/xfs/533
index afbdadac..31858cc9 100755
--- a/tests/xfs/533
+++ b/tests/xfs/533
@@ -21,13 +21,19 @@ _fixed_by_git_commit xfsprogs f4afdcb0ad11 \
 #skip fs check because invalid superblock 1
 _require_scratch_nocheck
 
+# The error messages in the golden output come from the V5 superblock verifier
+# routines, so ignore V4 filesystems.
+_require_scratch_xfs_crc
+
 _scratch_mkfs_xfs >>$seqres.full 2>&1
 
 # write the bad magicnum field value(0) to the superblock 1
 _scratch_xfs_set_metadata_field "magicnum" "0" "sb 1"
 
-#Even magicnum field has been corrupted, we still can read this field value
-_scratch_xfs_get_metadata_field "magicnum" "sb 1"
+# Even magicnum field has been corrupted, we still can read this field value.
+# The error message changed in xfsprogs 5.19.
+_scratch_xfs_get_metadata_field "magicnum" "sb 1" 2>&1 | \
+	sed -e 's/Superblock has bad magic number 0x0. Not an XFS filesystem?/bad magic number/g'
 
 # success, all done
 status=0
