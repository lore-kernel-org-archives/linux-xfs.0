Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26597C433F5
	for <linux-xfs@archiver.kernel.org>; Wed, 30 Mar 2022 17:20:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344833AbiC3RW2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 30 Mar 2022 13:22:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231516AbiC3RW2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 30 Mar 2022 13:22:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 098172FE47;
        Wed, 30 Mar 2022 10:20:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A575661880;
        Wed, 30 Mar 2022 17:20:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08DF1C340EC;
        Wed, 30 Mar 2022 17:20:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648660841;
        bh=DhupPvJgiKKOWneUmPrsikzm3E9zkY1Ge6UHetjhdTA=;
        h=Date:From:To:Subject:From;
        b=XVld6QwbHuqxjvdkBqjkTuFJOwCdg5/nUmVRmRezHROeaNeJWuD8Gua/M3htuIfoD
         qxR+oe+nJjhjh/veaGZN5t8c0VblP8SPL/VOosMpGaJozbYe3ApTlVP7pKWVZCAGM7
         WTNgBrKjmS43PDDqM06Yjg8kHC5/PwRT4b17e1M6BwJymZE+sp/ef4WiHDe1pZoC91
         3WLVpfXN8NAw1xyTKOCf8CkDZ8Ktw1gIrgdIVH7DiMoFpV7jKyII7mnfltU6IZh6Cj
         ib9tFAPi1lhTknqWOVTZmt5TyZXEajrtDvC2+kAPulluI8m2+5p+c83shchRrF5MEB
         AWpvah27g51mw==
Date:   Wed, 30 Mar 2022 10:20:40 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     xfs <linux-xfs@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>, hch@lst.de,
        guoxuenan@huawei.com
Subject: [ANNOUNCE] xfs-linux: vfs-for-next updated to 49df34221804
Message-ID: <20220330172040.GK27690@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi folks,

The vfs-for-next branch of the xfs-linux repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git

has just been updated.

Patches often get missed, so please check if your outstanding patches
were in this update. If they have not been in this update, please
resubmit them to linux-xfs@vger.kernel.org so they can be picked up in
the next update.

The new head of the vfs-for-next branch is commit:

49df34221804 fs: fix an infinite loop in iomap_fiemap

1 new commit:

Guo Xuenan (1):
      [49df34221804] fs: fix an infinite loop in iomap_fiemap

Code Diffstat:

 fs/ioctl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)
