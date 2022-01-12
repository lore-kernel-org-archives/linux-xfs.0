Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84C6CC433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 12 Jan 2022 17:57:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344053AbiALR5d (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 12 Jan 2022 12:57:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242192AbiALR5c (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 12 Jan 2022 12:57:32 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66C5AC06173F
        for <linux-xfs@vger.kernel.org>; Wed, 12 Jan 2022 09:57:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 07949B8202A
        for <linux-xfs@vger.kernel.org>; Wed, 12 Jan 2022 17:57:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7100C36AEA
        for <linux-xfs@vger.kernel.org>; Wed, 12 Jan 2022 17:57:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642010249;
        bh=0FtJwtz1ht9EQEue+JadJKxWy6gUE2PDvbfAQBUiNv0=;
        h=Date:From:To:Subject:From;
        b=hgjG2pYYGuc13icM8DvKduLf4PBawoEQzdGWzpGUe+q69ciXz56RuxXQFp8DrJ+Uz
         TDPtzX8SHxR0wIrbmFxGc16JTn1JqyQ/2eUgkRoXUv9XIUEdtoHLGhHrXnv+EVJsf2
         zAbggmcyGTpj39TDXuOGWrdaiRF49gwlKch9CNJNOynw5LKTUg/8EECnqf0K0hBMRl
         9UpR5lwUV1khq1BVrCk4/zKGIABwDI+hBcucl4csrCSB68Zv4aMWU1plrrnQP5Gv1f
         7p2brIONRzKZwTIWs1bkbfvWHQJSEYUc9dn9HsJNsRntX8K8+sP+W8kITnzB0jgFb/
         tQV54HQlfhwvQ==
Date:   Wed, 12 Jan 2022 09:57:29 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     xfs <linux-xfs@vger.kernel.org>
Subject: [ANNOUNCE] xfs-linux: for-next updated to 4a9bca86806f
Message-ID: <20220112175729.GB19198@magnolia>
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
the next update.  This posting is all bug fixes, but I /would/ like to
complete reviews of the ioctl removal series that I posted yesterday.

The new head of the for-next branch is commit:

4a9bca86806f xfs: fix online fsck handling of v5 feature bits on secondary supers

New Commits:

Darrick J. Wong (2):
      [65552b02a10a] xfs: take the ILOCK when readdir inspects directory mapping data
      [4a9bca86806f] xfs: fix online fsck handling of v5 feature bits on secondary supers


Code Diffstat:

 fs/xfs/scrub/agheader.c        | 53 ++++++++++++++++++++--------------------
 fs/xfs/scrub/agheader_repair.c | 12 +++++++++
 fs/xfs/xfs_dir2_readdir.c      | 55 +++++++++++++++++++++++++++---------------
 3 files changed, 73 insertions(+), 47 deletions(-)
