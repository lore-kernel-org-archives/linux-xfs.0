Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8B92CDB465
	for <linux-xfs@archiver.kernel.org>; Thu, 19 Oct 2023 16:47:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235372AbjJSQrW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 19 Oct 2023 12:47:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231601AbjJSQrV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 19 Oct 2023 12:47:21 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4529A11B
        for <linux-xfs@vger.kernel.org>; Thu, 19 Oct 2023 09:47:20 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9676C433C7;
        Thu, 19 Oct 2023 16:47:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697734039;
        bh=7ByxCLNpPBhFylp0Z+BxtRMtfo0a5R8DkVaCrjthb44=;
        h=Date:From:To:Cc:Subject:From;
        b=GFsDd4HBzKgwuQuwB3p7TSQg5ObvwXUEx3ADE+UqTB1sBlwlhoLWuUJEF42eXnrqU
         8peMKRyS6v11rP1caqwmr+fju7Bhko38+MZOQkObvL9jQG6ReJ1QjfsxJKPhiXkZys
         qBhGXTitR1K/vgznczP1J4UZIgRPDORmOcSxR7pjWzYUopYygmLv3tootB6eIyjC4S
         yF2f8+0mVOFy1C8CsoMbL2Ov+EuKhGlInDrDPMBPMQ9ooxD8wOAAPuZy1uUXK2xy2S
         jw9wQZTt+1vdL173nVeqo3hbv43Qfdls98IFMWcyTXWWtDSF+/LiH3YOdWo4ozRZ9j
         okPOTw5jS18GA==
Date:   Thu, 19 Oct 2023 09:47:19 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     hch@lst.de, jstancek@redhat.com, linux-fsdevel@vger.kernel.org,
        linux-xfs@vger.kernel.org
Subject: [ANNOUNCE] xfs-linux: iomap-for-next updated to 3ac974796e5d
Message-ID: <169773388032.253238.1731507472177515983.stg-ugh@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi folks,

The iomap-for-next branch of the xfs-linux repository at:

https://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git

has just been updated.  One last bug fix for 6.6.  I hope.

Patches often get missed, so please check if your outstanding patches
were in this update. If they have not been in this update, please
resubmit them to linux-xfs@vger.kernel.org so they can be picked up in
the next update.

The new head of the iomap-for-next branch is commit:

3ac974796e5d iomap: fix short copy in iomap_write_iter()

1 new commit:

Jan Stancek (1):
[3ac974796e5d] iomap: fix short copy in iomap_write_iter()

Code Diffstat:

fs/iomap/buffered-io.c | 10 +++++++---
1 file changed, 7 insertions(+), 3 deletions(-)
