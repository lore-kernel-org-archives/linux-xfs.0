Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0AB3EC433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 21 Jul 2022 04:32:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229692AbiGUEcc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 21 Jul 2022 00:32:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229569AbiGUEcb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 21 Jul 2022 00:32:31 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5497B2ED63
        for <linux-xfs@vger.kernel.org>; Wed, 20 Jul 2022 21:32:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id C408ECE23B9
        for <linux-xfs@vger.kernel.org>; Thu, 21 Jul 2022 04:32:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07337C3411E;
        Thu, 21 Jul 2022 04:32:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658377947;
        bh=PFU+wAJKd2ht3ayQbOk2PC2KjeFWrBqEe0SWP0LCP4A=;
        h=Date:From:To:Cc:Subject:From;
        b=q1sgJaWDx4Xo4HxbsIx6BOpEvvBcAqnqueYMBuecXAeRMy3Hrem64eyVXTR8oVEnH
         PRvBTkI+1XzOFkuifqI9jyCmie0ppq47Xs8kk5/BIgfFHMH6bCgCZLmHexww+uFR4l
         o7WSduNILEU3CwcmPP6M57MKGJrs5sVnA0/WJyzvVRzoV2TA3Af+Lz/6zczYJMHmE4
         L7+Ytgq3wa86XzewjMu2Yaih4pJK4EJ7FqIVQjaJUc0L6Wf01izd8bgTyrYzzUNQBp
         qd2IEygTl4cABw2VTkHLQ9+ELWoLUSeIfNt+Q7hZzmk3NK7Ydj0C0O6d5gwvaenpb1
         e7NCzxsB4NRNA==
Date:   Wed, 20 Jul 2022 21:32:26 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     linux-xfs@vger.kernel.org
Cc:     =?utf-8?B?5L2V5bCP5LmQ?= <hexiaole1994@126.com>,
        sandeen@redhat.com, Xiaole He <hexiaole@kylinos.cn>
Subject: [PATCH] xfsdocs: fix extent record format image
Message-ID: <YtjW2qVlBZaIOBJf@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Xiaole He <hexiaole@kylinos.cn>

The image of 'design/XFS_Filesystem_Structure/images/31.png' depicts
extent record format as below:

+----+-------------------------+---------------------+------------+
|flag|bits 72 to 126(54)       |bits 21 to 72(52)    |bit 0-20(21)|
|    |logical file block offset|absolute block number|# blocks    |
+----+-------------------------+---------------------+------------+

There has a typo for 'logical file block offset' part, it writes 'bits
72 to 126', but it should be 'bits 73 to 126' because the 72st bit is
consumed by 'absolute block number' part, this patch fix this problem
and redrawing the image as below:

+---------+-------------------------+---------------------+----------+
|bits[127]|bits[73-126]             |bits[21-72]          |bits[0-20]|
+---------+-------------------------+---------------------+----------+
|flag     |logical file block offset|absolute block number|# blocks  |
+---------+-------------------------+---------------------+----------+

Signed-off-by: Xiaole He <hexiaole@kylinos.cn>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
[djwong: convert the raw table above into asciidoc and remove the png]
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
Originally this patch was against 31.png itself, but apparently vger has
been eating the entire thread because spam.  It's very annoying that
vger still lets through plenty of spam and phishing attempts while
blocking legitimate patch submissions.

Since there's nothing I can do about our crap infrastructure, I've taken
the original patch submitter's table from the commit description and
converted that directly into an asciidoc table format.  I'll remove the
PNG when I commit this patch, but I'm not including it here because you
can't spell terrible without IT.

--D
---
 .../XFS_Filesystem_Structure/data_extents.asciidoc |   14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/design/XFS_Filesystem_Structure/data_extents.asciidoc b/design/XFS_Filesystem_Structure/data_extents.asciidoc
index 4f1109b..29c78fe 100644
--- a/design/XFS_Filesystem_Structure/data_extents.asciidoc
+++ b/design/XFS_Filesystem_Structure/data_extents.asciidoc
@@ -17,7 +17,19 @@ vary depending on the extent allocator used in the XFS driver.
 An extent is 128 bits in size and uses the following packed layout:
 
 .Extent record format
-image::images/31.png[]
+
+[cols="1,1,1,1"]
+|===
+|bit[127]
+|bits[73-126]
+|bits[21-72]
+|bits[0-20]
+
+|flag
+|logical file block offset
+|absolute block number
+|# of blocks
+|===
 
 The extent is represented by the +xfs_bmbt_rec+ structure which uses a big
 endian format on-disk. In-core management of extents use the +xfs_bmbt_irec+
