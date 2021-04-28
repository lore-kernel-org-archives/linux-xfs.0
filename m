Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83A8CC433ED
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Apr 2021 04:09:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 60675613F9
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Apr 2021 04:09:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234180AbhD1EK0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 28 Apr 2021 00:10:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:54552 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229868AbhD1EK0 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 28 Apr 2021 00:10:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id ECA4B60720;
        Wed, 28 Apr 2021 04:09:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619582982;
        bh=m9gNDeIsZxipvutlmN/mcY+9u2GLy0O4705DWNCUJ3A=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=s4wbkpYXhuKFjLBDLY6eFNmZI+BPGlSlT3r3Q/DxXRBXldMQ46z9SQamsemY72hoH
         3x6iQ5alJKttmoSlAEgJe2ePOq2C22Lg5+VrRg09NziV26QHt8CzCZ7nlVlNkFXIl0
         q1mm5F/tYf23cJactuWg3vQZYLxJQmkw/GClHNlYWpah1aWS+DhUX89vLG7bp/G0lu
         IoUKi8t7Kur5nR/Fy0IMyq11WwjOp0kNaHLXXFYAPA6tGO1FBVzDFcalfKziwIkrgr
         /CERnwXFAcQEMS+87VPj0g/5Ew3qzM0KcoCa9mobkllyg6Xi0yNHGlfJNGxuuKrf2T
         bUHtCFSwFuBkw==
Subject: [PATCH 2/3] rc: check dax mode in _require_scratch_swapfile
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Tue, 27 Apr 2021 21:09:41 -0700
Message-ID: <161958298115.3452499.907986597475080875.stgit@magnolia>
In-Reply-To: <161958296906.3452499.12678290296714187590.stgit@magnolia>
References: <161958296906.3452499.12678290296714187590.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

It turns out that the mm refuses to swapon() files that don't have a
a_ops->readpage function, because it wants to be able to read the swap
header.  S_DAX files don't have a readpage function (though oddly both
ext4 and xfs link to a swapfile activation function in their aops) so
they fail.  The recent commit 725feeff changed this from a _notrun to
_fail on xfs and ext4, so amend this not to fail on pmem test setups.

Fixes: 725feeff ("common/rc: swapon should not fail for given FS in _require_scratch_swapfile()")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 common/rc |    4 ++++
 1 file changed, 4 insertions(+)


diff --git a/common/rc b/common/rc
index 6752c92d..429cc24d 100644
--- a/common/rc
+++ b/common/rc
@@ -2490,6 +2490,10 @@ _require_scratch_swapfile()
 	# Minimum size for mkswap is 10 pages
 	_format_swapfile "$SCRATCH_MNT/swap" $(($(get_page_size) * 10))
 
+	# swapfiles cannot use cpu direct access mode (STATX_ATTR_DAX) for now
+	statx_attr="$($XFS_IO_PROG -c 'statx -r' $SCRATCH_MNT/swap 2>/dev/null | grep 'stat.attributes = ' | awk '{print $3}')"
+	test "$((statx_attr & 0x200000))" -gt 0 && _notrun "swapfiles not supported on DAX"
+
 	# ext* and xfs have supported all variants of swap files since their
 	# introduction, so swapon should not fail.
 	case "$FSTYP" in

