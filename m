Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74108C6FD1E
	for <linux-xfs@archiver.kernel.org>; Mon,  6 Mar 2023 18:30:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230180AbjCFSan (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 6 Mar 2023 13:30:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230186AbjCFSan (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 6 Mar 2023 13:30:43 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 334C238B4D
        for <linux-xfs@vger.kernel.org>; Mon,  6 Mar 2023 10:30:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B6B64B81088
        for <linux-xfs@vger.kernel.org>; Mon,  6 Mar 2023 18:30:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69EE0C4339C;
        Mon,  6 Mar 2023 18:30:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678127439;
        bh=vPWMu0UIXeCSkMhhK7ymVoApJ7xIWipvm7ZdR/8BxQk=;
        h=Date:From:To:Cc:Subject:From;
        b=RBS45OJFirwcY3MBGRqIAyqH22cgCRsye0rTdMXwnog14rvyvMR8qFnRfPSXWuRmf
         gevSgAoOMyRPPylS8BXHUMP7jC5hJJOhAJ5I//hHoIQNaw2zcZxqkTjssCGqly2xy9
         51Zm7oo18MyjagcHaM5lhO8HxmXdBdkRhDfEtphC/6efgzx50Ud2JXq7ilH4qeGfLP
         6Oit8TaGuYZNgS4Mjvh7OyFiyRkHmZw3fVxuUbFV5elrV9QFGxae8WarPJS4ksuxa3
         oc+VIg4Pco0cTX0wm6IZbu6eO+Ze2BD2fFi+91oosxVE2NhIJG1WgNyAr0QCOiLqwb
         dj4BKnmW/MDKA==
Date:   Mon, 6 Mar 2023 10:30:38 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     david@fromorbit.com, dchinner@redhat.com,
        linux-xfs@vger.kernel.org, pengfei.xu@intel.com
Subject: [ANNOUNCE] xfs-linux: for-next updated to 8ac5b996bf51
Message-ID: <167812703667.3386652.4678184956506401542.stg-ugh@magnolia>
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
the next update.

The new head of the for-next branch is commit:

8ac5b996bf51 xfs: fix off-by-one-block in xfs_discard_folio()

2 new commits:

Dave Chinner (2):
[0c7273e494dd] xfs: quotacheck failure can race with background inode inactivation
[8ac5b996bf51] xfs: fix off-by-one-block in xfs_discard_folio()

Code Diffstat:

fs/xfs/xfs_aops.c | 21 ++++++++++++++-------
fs/xfs/xfs_qm.c   | 40 ++++++++++++++++++++++++++--------------
2 files changed, 40 insertions(+), 21 deletions(-)
