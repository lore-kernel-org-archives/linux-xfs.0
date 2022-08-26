Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 381C0ECAAA3
	for <linux-xfs@archiver.kernel.org>; Fri, 26 Aug 2022 17:16:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344952AbiHZRQC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 26 Aug 2022 13:16:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344923AbiHZRP7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 26 Aug 2022 13:15:59 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C5E579611
        for <linux-xfs@vger.kernel.org>; Fri, 26 Aug 2022 10:15:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7B756B831BD
        for <linux-xfs@vger.kernel.org>; Fri, 26 Aug 2022 17:15:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95F55C433D6
        for <linux-xfs@vger.kernel.org>; Fri, 26 Aug 2022 17:15:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661534142;
        bh=4OBOguuYupwk56mO5z83nZlzK+C/zDQlt25ByMq8YNI=;
        h=Date:From:To:Subject:From;
        b=JxkNw1Tm8UrqnnSvzebFjy2IYeuSQF4ZWSchaZ8lj+vrAwp6D1MZKZJlZu+olpSsW
         +mkVoGp9Wrj8N2q3u7c48zQA9oLDhgE3lyPvQAJQY13pLfSV+p3EJ6GOU2pvtcvpFd
         ly1tgo01yUy8r/SfDwBwBkckBUVTYV78u78KxMs/6Z2uLyKMSkwoUZBnucHCODszj0
         BoAUSjDFHnewVxCYUzXbQTIpltZzKdMFskIQJnaqURPQpGVmLmIOExlBjgLEj037zW
         fnNsusWG9octzI9YsIy1G+G8ij8GiwDxkZxJKIQ4J8lRVkGjg4S8Dc5hT94u2bHI5Y
         db84EMY3DKR5w==
Date:   Fri, 26 Aug 2022 19:15:38 +0200
From:   Carlos Maiolino <cem@kernel.org>
To:     linux-xfs@vger.kernel.org
Subject: [ANNOUNCE] xfsdump: Release 3.1.11
Message-ID: <20220826171538.k2lc32v2psrr5uha@andromeda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi folks,

The xfsdump repository at:

git://git.kernel.org/pub/scm/fs/xfs/xfsdump-dev.git

has just been updated.

Patches often get missed, so please check if your outstanding
patches were in this update. If they have not been in this update,
please resubmit them to linux-xfs@vger.kernel.org so they can be
picked up in the next update.

The new head of the master branch is commit:

8b6bbcf xfsdump: Release 3.1.11

New Commits:

Anthony Iliopoulos (1):
      [16cb2e6] xfsdump: remove BMV_IF_NO_DMAPI_READ flag

Carlos Maiolino (4):
      [2875b05] xfsdump: Initialize getbmap structure in quantity2offset
      [520b9f5] Remove trailing white spaces from xfsdump.html
      [e8a2ce1] Rename worker threads from xfsdump's documentation
      [8b6bbcf] xfsdump: Release 3.1.11

Darrick J. Wong (1):
      [20e7474] xfs_restore: remove DMAPI support


Code Diffstat:

 VERSION           |   2 +-
 configure.ac      |   2 +-
 debian/changelog  |   9 ++
 doc/CHANGES       |   6 ++
 doc/xfsdump.html  | 445 ++++++++++++++++++++++++++++++++++++++++----------------------------------------
 dump/content.c    |   1 -
 dump/inomap.c     |   7 +-
 po/de.po          |   9 +-
 po/pl.po          |   9 +-
 restore/content.c |  99 ++----------------
 restore/tree.c    |  33 ------
 restore/tree.h    |   1 -
 12 files changed, 252 insertions(+), 371 deletions(-)


-- 
Carlos Maiolino
