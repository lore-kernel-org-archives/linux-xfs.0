Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D65BEC433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 19 May 2022 16:41:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234285AbiESQld (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 19 May 2022 12:41:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235012AbiESQla (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 19 May 2022 12:41:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 189BE3CFCE;
        Thu, 19 May 2022 09:41:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A497B60B90;
        Thu, 19 May 2022 16:41:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14C6EC385AA;
        Thu, 19 May 2022 16:41:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652978489;
        bh=De2GcHOK7LXK4lJtJa4X9VZtEJCV16CCO1ycwbJH2uE=;
        h=Date:From:To:Subject:From;
        b=cYFOLUZZRSWsByQCKqYAeVOkmCLJf5mxr3xWHImWIfn4gqc3Yfjy9+pCr+CjGNHcZ
         cNhADazQMNTZEqEJx9UC6ry5/Aj2PI+MXlSWaqhkip1Qy3OmTaBbz7r8tRmp34twbu
         P6xzv13zS1N9xLspimx+vINtoJrdllirY0T8rqUhEjLCvdl1dC8CzRs7EK9tc3OA5a
         TZKfKT8O35NIr/h6hM6g41Ll9tn88jpVG+1Fy5mebVhIdNWJzvwRTXH/VYM3yvofsy
         wy10ensZ06yvgfE504RfZzsHHMivcRz9R502+L0Y9onvGQ9vr2HokaIro4ZLXmM814
         7Zor3Ae8ctdUA==
Date:   Thu, 19 May 2022 09:41:28 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     xfs <linux-xfs@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: [ANNOUNCE] xfs-linux: iomap-for-next updated to e9c3a8e820ed
Message-ID: <YoZzOC+ApTeUdbTW@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi folks,

The iomap-for-next branch of the xfs-linux repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git

has just been updated.

Patches often get missed, so please check if your outstanding patches
were in this update. If they have not been in this update, please
resubmit them to linux-xfs@vger.kernel.org so they can be picked up in
the next update.  I think this is it for 5.19.

The new head of the iomap-for-next branch is commit:

e9c3a8e820ed iomap: don't invalidate folios after writeback errors

3 new commits:

Andreas Gruenbacher (2):
      [b71450e2cc4b] iomap: iomap_write_failed fix
      [d74999c8c060] iomap: iomap_write_end cleanup

Darrick J. Wong (1):
      [e9c3a8e820ed] iomap: don't invalidate folios after writeback errors

Code Diffstat:

 fs/iomap/buffered-io.c | 6 +++---
 fs/xfs/xfs_aops.c      | 4 +---
 2 files changed, 4 insertions(+), 6 deletions(-)
