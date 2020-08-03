Return-Path: <SRS0=ns7q=BN=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7C09C433E0
	for <linux-xfs@archiver.kernel.org>; Mon,  3 Aug 2020 13:46:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9D6E12076E
	for <linux-xfs@archiver.kernel.org>; Mon,  3 Aug 2020 13:46:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="O/7gyANh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727785AbgHCNqN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 3 Aug 2020 09:46:13 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:22855 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726579AbgHCNqM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 3 Aug 2020 09:46:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596462371;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=NAemkr0liG+PR5v5uY2JJpPXr17ZKVT/tLcQrkbAH2o=;
        b=O/7gyANh4jzxGSjZeFqCLYKDBtB7z0doVhOSWtyUqvYUZb8vMdoc36gi2TgGvpXQvKX6qp
        gALFMHdIZocTsnoz72PHwERTjaudxQ6LjDCutK0kSS8WjZV1Ca7DMOqtmQUm15ZK89GKJ5
        cbAHwUssvYdL+5LMl8KqnQT1JPH2BQM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-211-h6E8lwEOPOS9QI7IOm9amQ-1; Mon, 03 Aug 2020 09:46:07 -0400
X-MC-Unique: h6E8lwEOPOS9QI7IOm9amQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CDA508015F3;
        Mon,  3 Aug 2020 13:46:06 +0000 (UTC)
Received: from localhost.localdomain.com (ovpn-116-244.rdu2.redhat.com [10.10.116.244])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A66C77176E;
        Mon,  3 Aug 2020 13:46:01 +0000 (UTC)
From:   Bill O'Donnell <billodo@redhat.com>
To:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org
Cc:     darrick.wong@oracle.com, sandeen@redhat.com
Subject: [PATCH] xfs/263: filters to accommodate new xfs_quota state command and prevent regression
Date:   Mon,  3 Aug 2020 08:46:00 -0500
Message-Id: <20200803134601.577775-1-billodo@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

New xfs_quota kernel and xfsprogs add grace timers for group and project,
in addition to user quota. Adjust xfs/263 to accommodate those
changes, and avoid regression.

Signed-off-by: Bill O'Donnell <billodo@redhat.com>
---
NOTE: this patch needs to follow:
      [PATCH] xfs/{263,106} erase max warnings printout (djwong)

 tests/xfs/263 | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/tests/xfs/263 b/tests/xfs/263
index 2f23318d..c18b2e1e 100755
--- a/tests/xfs/263
+++ b/tests/xfs/263
@@ -59,6 +59,18 @@ function option_string()
 filter_quota_state() {
 	sed -e 's/Inode: #[0-9]\+/Inode #XXX/g' \
 	    -e '/max warnings:/d' \
+	    -e '/Blocks grace time:/d' \
+	    -e '/Inodes grace time:/d' \
+		| _filter_scratch
+}
+
+filter_quota_state2() {
+	sed -e '/User quota state on/d' \
+	    -e '/ Accounting: /d' \
+	    -e '/ Enforcement: /d' \
+	    -e '/ Inode: /d' \
+	    -e '/Blocks max warnings: /d' \
+	    -e '/Inodes max warnings: /d' \
 		| _filter_scratch
 }
 
@@ -70,7 +82,10 @@ function test_all_state()
 		# Some combinations won't mount on V4 supers (grp + prj)
 		_qmount_option "$OPTIONS"
 		_try_scratch_mount &>> $seqres.full || continue
-		$XFS_QUOTA_PROG -x -c "state" $SCRATCH_MNT | filter_quota_state
+		$XFS_QUOTA_PROG -x -c "state -u" $SCRATCH_MNT | filter_quota_state
+		$XFS_QUOTA_PROG -x -c "state -g" $SCRATCH_MNT | filter_quota_state
+		$XFS_QUOTA_PROG -x -c "state -p" $SCRATCH_MNT | filter_quota_state
+		$XFS_QUOTA_PROG -x -c "state -u" $SCRATCH_MNT | filter_quota_state2
 		_scratch_unmount
 	done
 }
-- 
2.26.2

