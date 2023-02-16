Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F97FC61DA4
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Feb 2023 20:31:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229505AbjBPUbk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Feb 2023 15:31:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229489AbjBPUbj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Feb 2023 15:31:39 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D8EB196A9
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 12:31:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BEAFD60C04
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 20:31:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27655C433D2;
        Thu, 16 Feb 2023 20:31:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676579498;
        bh=tOiiDkVUkOa1xQ2EpfZrQGS8JOCO46R5WpXagH1MogM=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=nIOBq0CG/aPFLjA7QlMhJueY/T8P688LaNF2u0Yl76yu61yRQsZKdhWYxo9PhwYkP
         rtq7pgrt177AHJtPN5TcPPb2vmy7WrTHuCuHrVRescT6ntWdjEuhEdcPTULHJuzmYl
         j/tzGtLfoSIUKdXUy3aJDiv200wgaLTJZD2OcvcJsjBh8y/f+q/tZRDoLVQwNNrM6d
         /65JbyACjOfXpuHPIGDKeeYwRbLfBDNGz9mCFAKY8+sNb8E8HxlGpOIaVa/ns3gv/m
         5jKx6PTIRen9Hf+21+sDHiBOiMK7HWFUWLLJyEW4USMAvHIUxNPKoJeU/mq682Q3qV
         JFCvx0n1Pmn2Q==
Date:   Thu, 16 Feb 2023 12:31:37 -0800
Subject: [PATCHSET v9r2d1 0/3] xfsprogs: use flex arrays for
 XFS_IOC_GETPARENTS
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <167657882746.3478223.17677270918788774260.stgit@magnolia>
In-Reply-To: <Y+6MxEgswrJMUNOI@magnolia>
References: <Y+6MxEgswrJMUNOI@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

Change the XFS_IOC_GETPARENTS structure definitions so that we can pack
parent pointer information more densely, in a manner similar to the
attrlistmulti ioctl.  This also reduces the amount of memory that has to
be copied back to userspace if the buffer doesn't fill up.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.
kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=pptrs-ioctl-flexarray

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=pptrs-ioctl-flexarray

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=pptrs-ioctl-flexarray
---
 io/parent.c       |   22 ++++++++--------
 libfrog/pptrs.c   |   44 ++++++++++++++++---------------
 libfrog/pptrs.h   |    4 +--
 libxfs/xfs_fs.h   |   75 +++++++++++++++++++++++------------------------------
 man/man3/xfsctl.3 |   16 ++++++-----
 5 files changed, 76 insertions(+), 85 deletions(-)

