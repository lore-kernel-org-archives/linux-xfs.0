Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 803A4C636D7
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Feb 2023 20:32:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229721AbjBPUco (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Feb 2023 15:32:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229653AbjBPUco (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Feb 2023 15:32:44 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 163BE528BE;
        Thu, 16 Feb 2023 12:32:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BF676B82962;
        Thu, 16 Feb 2023 20:32:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82EE1C433D2;
        Thu, 16 Feb 2023 20:32:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676579560;
        bh=rSVv+o5dyZ1rk0qgjPCkK2cJhU3oI6/dFQpE5jLsxiA=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=LYjcKow7Ler8x4y+EJTDh7A6u43PCvADdlRErUvAgLsyykJEJYStUcgDiWNyl9T+6
         bNZkET3cP5OLHgtPs1qkuQd2f5PBTVDHlR+xidDr5w4yku8EgKRLtvoxIUXMIw5sX9
         z2+mB9eVRqkQoRFstrlBjDxVcWgvo7pNUSr4nZXQ8gGU1A8IGxGyTzIOWV916yI4CD
         s8xikdfERocnPP9AwTgVcEy9Cw3vOvwgWMpnKJDW53WxOC8dTV1i+JNZKo+YBz+Q8c
         CmV6F81syMDhH9llw+cD4Uisi3aLHAyaHW8P13J4qm7Bd6ijJFkM5KKjzRqnjLTNuR
         MA0BeuFeH59GQ==
Date:   Thu, 16 Feb 2023 12:32:40 -0800
Subject: [PATCHSET v9r2 0/1] fstests: use flex arrays for XFS_IOC_GETPARENTS
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, zlang@redhat.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Message-ID: <167657885325.3481879.849107578244828019.stgit@magnolia>
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

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=pptrs-ioctl-flexarray

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=pptrs-ioctl-flexarray

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=pptrs-ioctl-flexarray
---
 tests/xfs/122.out |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

