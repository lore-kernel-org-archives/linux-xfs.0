Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 992CBC43460
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Apr 2021 04:09:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7664961411
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Apr 2021 04:09:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229600AbhD1EJ5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 28 Apr 2021 00:09:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:54146 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229437AbhD1EJ5 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 28 Apr 2021 00:09:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6A41B60720;
        Wed, 28 Apr 2021 04:09:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619582953;
        bh=MXKb7c+JEa063s9FYkl2+xArK9lVxucj5qXOfwbJQns=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Qb8v0e8z+BY2CM7yC64RJbFJZe/nfM8ZDqPf1Ap2KJVHza3/QXUSfXx3SabNF3c5d
         FZjPx/HO21fNApwmz7TgSbCprpsMpXnS2j4ui4mxCvEB6dsxSiWWKa0Shc4ib67N5J
         2Vt2jIfzSghJjumucUuuHGDAGerCmOXQxfdtLA195kwzXXsBUJu58454aOjYOk06Q2
         M/2XBuHCpmPIDXab+1vMzo85XYRPGQsx0Uo3GMGV4y1zaCAzyDyTFAnGZERro30zoE
         xfrejREWc8QSeH+ffUbp/+5Ny/nQo80HsMkumVO2eIdT0rfLRrfXOW0uoSzIbb2We3
         KFrZIGbcj+NLQ==
Subject: [PATCH 3/5] generic/449: always fill up the data device
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Tue, 27 Apr 2021 21:09:12 -0700
Message-ID: <161958295276.3452351.11071488836337123863.stgit@magnolia>
In-Reply-To: <161958293466.3452351.14394620932744162301.stgit@magnolia>
References: <161958293466.3452351.14394620932744162301.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

This is yet another one of those tests that looks at what happens when
we run out of space for more metadata (in this case, xattrs).  Make sure
that the 256M we write to the file to try to stimulate ENOSPC gets
written to the same place that xfs puts xattr data -- the data device.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/generic/449 |    5 +++++
 1 file changed, 5 insertions(+)


diff --git a/tests/generic/449 b/tests/generic/449
index a2d882df..5fd15367 100755
--- a/tests/generic/449
+++ b/tests/generic/449
@@ -43,6 +43,11 @@ _require_attrs trusted
 _scratch_mkfs_sized $((256 * 1024 * 1024)) >> $seqres.full 2>&1
 _scratch_mount || _fail "mount failed"
 
+# This is a test of xattr behavior when we run out of disk space for xattrs,
+# so make sure the pwrite goes to the data device and not the rt volume.
+test "$FSTYP" = "xfs" && \
+	$XFS_IO_PROG -c 'chattr -t' $SCRATCH_MNT
+
 TFILE=$SCRATCH_MNT/testfile.$seq
 
 # Create the test file and choose its permissions

