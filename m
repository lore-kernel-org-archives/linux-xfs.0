Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5922DC433EF
	for <linux-xfs@archiver.kernel.org>; Mon, 18 Jul 2022 17:39:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234354AbiGRRjd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 18 Jul 2022 13:39:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233725AbiGRRjd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 18 Jul 2022 13:39:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A51CA220E6
        for <linux-xfs@vger.kernel.org>; Mon, 18 Jul 2022 10:39:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 38B7A61538
        for <linux-xfs@vger.kernel.org>; Mon, 18 Jul 2022 17:39:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C25DC341C0
        for <linux-xfs@vger.kernel.org>; Mon, 18 Jul 2022 17:39:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658165971;
        bh=/Cc89Y+IsmW0f42QrXCrDPVbKUos2yFMmtSCq77alBE=;
        h=Date:From:To:Subject:From;
        b=lO9gRzFGPHKTq4FYGPFmg/yDvUvCFeJm+jO2r47QWz1bDrlSig+gpuk7PtUrvORfy
         esXyx+86FVOjayzB1vqVhIKMZB4hrrdxgit8JQMqE10uc3p1C60Yrn2WElZO8O4DQG
         I/2+teyyiCIJg12nnW1acUqLDVvChRxwytkn4zhyhcYQ51Na3Q8YaXYJwpwVDrphC4
         Pio0jLMsfJE0PjQCV8xmNY1NyuG+PR1DoX1adorD2k7NlqAG62mtzcZRW9Y6h2wGNU
         14cG0gy6t0hyH4q0SmFZrYusZ8aOmD/Y9ZPIvgUyTgcbPn+Dx7QUVLDukG+JM2sp+n
         T1pDPxhk13ORw==
Date:   Mon, 18 Jul 2022 10:39:31 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     xfs <linux-xfs@vger.kernel.org>
Subject: [ANNOUNCE] xfs-documentation: for-next updated to 32259aa
Message-ID: <YtWa03lLJIEd7GJH@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi folks,

The for-next branch of the xfs-documentation repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfs-documentation.git

has just been updated.

Patches often get missed, so please check if your outstanding patches
were in this update. If they have not been in this update, please
resubmit them to linux-xfs@vger.kernel.org so they can be picked up in
the next update.  This reminds me that I need to update the ondisk
format documentation to accomodate nrext64...

The new head of the for-next branch is commit:

32259aa xfsdocs: fix inode timestamps lower limit value

1 new commit:

Xiaole He (1):
      [32259aa] xfsdocs: fix inode timestamps lower limit value

Code Diffstat:

 design/XFS_Filesystem_Structure/timestamps.asciidoc | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)
