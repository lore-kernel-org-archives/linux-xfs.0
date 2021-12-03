Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5AA71C433EF
	for <linux-xfs@archiver.kernel.org>; Fri,  3 Dec 2021 02:06:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237498AbhLCCJg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 2 Dec 2021 21:09:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235940AbhLCCJg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 2 Dec 2021 21:09:36 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 250A5C06174A
        for <linux-xfs@vger.kernel.org>; Thu,  2 Dec 2021 18:06:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8BDEA628A9
        for <linux-xfs@vger.kernel.org>; Fri,  3 Dec 2021 02:06:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7EEAC00446
        for <linux-xfs@vger.kernel.org>; Fri,  3 Dec 2021 02:06:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638497171;
        bh=1AgjDap/K93u4RcpYaIM5Ck9wiZlJJTQ+5ETI+HE2X4=;
        h=Date:From:To:Subject:From;
        b=uNYlYG5fLvqRfvhAPXYoj6YIvm8XnCb+QpqqkQRc5XMXohBEU2zI+TAMxc+guCpkh
         bG+5D/ZJhGn5O0lbw/3eOeppnEiqnWbiF8rPFgtWyPdEbhCsvjm6HeSdeM1uZd9zW+
         B3UiICTbwpx3AOJkQQI4U9UcwG/78BQ/uxUh2SStpIuC0wkzLlCuhTIxINdk2hJXRQ
         maDOodXh7kLye8J9zEtjbkxETbl1iCO/RLWtFuo5NkblnKQqEu64CTFrZt9yueG5NU
         sgLdWZxMJIlcsZcHSjFxIpehz3Od7ZrU0xonODszlrXfdS/Q/REoC31Ia809I4Fy+4
         xbDcEwNXauL+Q==
Date:   Thu, 2 Dec 2021 18:06:11 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     xfs <linux-xfs@vger.kernel.org>
Subject: [ANNOUNCE] xfs-linux: for-next updated to e445976537ad
Message-ID: <20211203020611.GN8467@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi folks,

The for-next branch of the xfs-linux repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git

has just been updated.

Patches often get missed, so please check if your outstanding patches
were in this update. If they have not been in this update, please
resubmit them to linux-xfs@vger.kernel.org so they can be picked up in
the next update.  Will start on 5.17 stuff next week.

The new head of the for-next branch is commit:

e445976537ad xfs: remove incorrect ASSERT in xfs_rename

New Commits:

Eric Sandeen (1):
      [e445976537ad] xfs: remove incorrect ASSERT in xfs_rename


Code Diffstat:

 fs/xfs/xfs_inode.c | 1 -
 1 file changed, 1 deletion(-)
