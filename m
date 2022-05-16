Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07654C433EF
	for <linux-xfs@archiver.kernel.org>; Mon, 16 May 2022 03:32:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239664AbiEPDcC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 15 May 2022 23:32:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239679AbiEPDcA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 15 May 2022 23:32:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6C901FCD2
        for <linux-xfs@vger.kernel.org>; Sun, 15 May 2022 20:31:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 365D660ECC
        for <linux-xfs@vger.kernel.org>; Mon, 16 May 2022 03:31:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C4C2C385B8;
        Mon, 16 May 2022 03:31:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652671912;
        bh=tsdpHICVkiy1As6YzFJGtVf9Z2ksPdpVBCckrl4rCYw=;
        h=Subject:From:To:Cc:Date:From;
        b=Kdlpj+W6SDjn0x+6IM80/ZTITsy2TGud9nbjiyhJ9mb694GDyeA9412/7DdRgFH5Y
         gfL0umO1Mf9Zro0JmWwcXV/xMofgTPqoZsa++0Nk+4SluBODgKRbZ7Uu2k7NtVqWp7
         qgtfYonM2Jno8x2z0NhUFXUUrHiJqNLayB46cNb0VlbPafOxeZ9VnpVyxY2CidFZi0
         rJeEqpeS/Ql/w8PLS1rgBQyoRRge6mATxah064oUxKdBQeO00stXxpf6ctprnHBApc
         bwqmWCuzV196/zCt66PVWDmHvOwQysYYdgTEYjb0w/fO/reO64A6fLQAQHdmM8Mt9g
         HmDuuMilOobfA==
Subject: [PATCHSET 0/4] xfs: fix leaks and validation errors in logged xattr
 updates
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com,
        allison.henderson@oracle.com
Date:   Sun, 15 May 2022 20:31:52 -0700
Message-ID: <165267191199.625255.12173648515376165187.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

As I've detailed in my reply to Dave, this is a short series of fixes
for the 5.19 for-next branch that fixes some validation deficiencies in
xattr log item recovery and some memory leaks due to a confusing API.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D
---
 fs/xfs/libxfs/xfs_attr.c       |   32 ++++++++++++++++++++++----------
 fs/xfs/libxfs/xfs_log_format.h |    9 ++++++++-
 fs/xfs/xfs_attr_item.c         |   36 +++++++++++++++++++++++++++---------
 3 files changed, 57 insertions(+), 20 deletions(-)

