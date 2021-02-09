Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D7FFC433E9
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Feb 2021 02:19:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E928C64EC5
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Feb 2021 02:19:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230124AbhBICT0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 8 Feb 2021 21:19:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:59646 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229544AbhBICTZ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 8 Feb 2021 21:19:25 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id ED2A764EBA
        for <linux-xfs@vger.kernel.org>; Tue,  9 Feb 2021 02:18:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612837125;
        bh=Ozof2NXbpjpuG4oZUadGkdvWanyQkqbodRiSmVq7mOA=;
        h=Date:From:To:Subject:From;
        b=G6yCjIBVt3IygGFo8EziNKp9Nr2/bvIDv8rE7y5PVbY70UpAYmtMaJxWi2xdyHOd6
         9dnZvSYkhFxiAOlcOirxBADMTvhUITdamZqma0B9LK/5r5PUu6XIm5GKQ3Sssa4BPI
         k72kD0n2CuksRVT0r0HN8l9TcBOFel6IiI5+uW3EDf166OL2Ny90PFw/GQEhnO0h38
         DK5qHL0foNglDodyJUpOGFwPgdW3CUtoduaJFobCC/TvBYS5LIE2F4EsmhagPTEpUu
         znwyPVuaNcIoSVad/IQfRfH5vNOg1OVogLVT9gGrGYZ+r2c2XBOgJuww/Z+eYw9Lov
         VT98s4eOjOkuw==
Date:   Mon, 8 Feb 2021 18:18:43 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     xfs <linux-xfs@vger.kernel.org>
Subject: [PATCH] xfs: fix rst syntax error in admin guide
Message-ID: <20210209021843.GP7193@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Tables are supposed to have a matching line of "===" to signal the end
of a table.  The rst compiler gets grouchy if it encounters EOF instead,
so fix this warning.

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 Documentation/admin-guide/xfs.rst |    1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/admin-guide/xfs.rst b/Documentation/admin-guide/xfs.rst
index d2064a52811b..6178153d3320 100644
--- a/Documentation/admin-guide/xfs.rst
+++ b/Documentation/admin-guide/xfs.rst
@@ -536,3 +536,4 @@ The interesting knobs for XFS workqueues are as follows:
   cpumask        CPUs upon which the threads are allowed to run.
   nice           Relative priority of scheduling the threads.  These are the
                  same nice levels that can be applied to userspace processes.
+============     ===========
