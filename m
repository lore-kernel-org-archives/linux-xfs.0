Return-Path: <SRS0=nhRG=CO=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 502A8C43461
	for <linux-xfs@archiver.kernel.org>; Sat,  5 Sep 2020 15:52:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 198AB206B8
	for <linux-xfs@archiver.kernel.org>; Sat,  5 Sep 2020 15:52:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1599321172;
	bh=TZOWi+HBwDSzqqcu2ndK0rh+9RbRR0CjdXfzqDyJjxI=;
	h=Date:From:To:Cc:Subject:List-ID:From;
	b=crRYIjRdon3jRcsY9o/Aiwohdqa2Y1Qccjhl9iU4Z4LDAUwrcQK64Sn/ICoGH9fyN
	 ZerqkhbP0JX39Eedm4GE1COBvX1CJeYI1wh2KLIDIDCYdGcQ0FA0zDOnnrUtXJJuMG
	 VerCreDrH/OyjCHs04EglPu+yFkh3NMXIPzkyhpY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728376AbgIEPwt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 5 Sep 2020 11:52:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:39442 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726468AbgIEPwr (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 5 Sep 2020 11:52:47 -0400
Received: from localhost (c-67-169-218-210.hsd1.or.comcast.net [67.169.218.210])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D0B32206B8;
        Sat,  5 Sep 2020 15:52:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599321163;
        bh=TZOWi+HBwDSzqqcu2ndK0rh+9RbRR0CjdXfzqDyJjxI=;
        h=Date:From:To:Cc:Subject:From;
        b=SL9DhgYCiHtjAmIr8bvmfhWzaI218iLbtN5hos9Silm6UiEQYqqJivjCtl8yUxOPg
         7u6jBBRAAo7EC5Bx8UVwNrzak87kQsABH2CWpD+mjcM7Bmw3iWRZkqMrrtaH4z6k+Y
         udOBMyr0mFm+NVX467c2ZEwWvARHapjBFZHq642Y=
Date:   Sat, 5 Sep 2020 08:52:43 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     "Darrick J. Wong" <djwong@kernel.org>,
        linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
        david@fromorbit.com, linux-kernel@vger.kernel.org,
        sandeen@sandeen.net, hch@lst.de
Subject: [GIT PULL] xfs: small fixes (2) for 5.9
Message-ID: <20200905155243.GB7955@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Linus,

Please pull this single fix for a broken metadata verifier.  The branch
merges cleanly with upstream as of a few minutes ago, so please let me
know if anything strange happens.

--D

The following changes since commit 125eac243806e021f33a1fdea3687eccbb9f7636:

  xfs: initialize the shortform attr header padding entry (2020-08-27 08:01:31 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/xfs-5.9-fixes-2

for you to fetch changes up to d0c20d38af135b2b4b90aa59df7878ef0c8fbef4:

  xfs: fix xfs_bmap_validate_extent_raw when checking attr fork of rt files (2020-09-03 08:33:50 -0700)

----------------------------------------------------------------
Fixes (2) for 5.9:
- Fix a broken metadata verifier that would incorrectly validate attr
fork extents of a realtime file against the realtime volume.

----------------------------------------------------------------
Darrick J. Wong (1):
      xfs: fix xfs_bmap_validate_extent_raw when checking attr fork of rt files

 fs/xfs/libxfs/xfs_bmap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)
