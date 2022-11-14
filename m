Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64691C4332F
	for <linux-xfs@archiver.kernel.org>; Mon, 14 Nov 2022 19:16:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237248AbiKNTQp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 14 Nov 2022 14:16:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236601AbiKNTQd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 14 Nov 2022 14:16:33 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1FF5264B8
        for <linux-xfs@vger.kernel.org>; Mon, 14 Nov 2022 11:16:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 36CDAB81203
        for <linux-xfs@vger.kernel.org>; Mon, 14 Nov 2022 19:16:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1FB8C433D7;
        Mon, 14 Nov 2022 19:16:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668453386;
        bh=GVx+ytp63L8yz4eA2vLmgJ17GrM9CtwS+zx/VI+erTY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=V1UJb/TXb5m8pmmnvduIitb00JQmCBRpN8MbyC5x/yTN7FMym+GJhoRgtnGwSe08X
         PoZpd1CcaWJbwpd85QO19LM1vKZNDbWOyvjExFzH0E+jc32eA8KW8VfNyKncK+SF1t
         EEpGOaQ2j2kuffTLwesbI9DxYoS/hWs0NOXjlKBjZfzS8mkC00/NCeA34Ns6Ve8Et4
         HBt25u4hbSovjvJ4Rhdoix9FoSdMojEqIkYaIRjCeEbwfdvBoUrML5IgzdeL0a2qyI
         Nad4rBgguGldwGfL71KhKopJtVgx3WJ8U81P4GHKWuZGMyMbr8aHmR5nZjFDiHgz0a
         Ae561ZfKtqonA==
Date:   Mon, 14 Nov 2022 11:16:26 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Carlos Maiolino <cem@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [ANNOUNCE] xfsprogs-6.0.0 released
Message-ID: <Y3KUCsPH0rSv2Tzb@magnolia>
References: <20221114113639.mxgewf2zjgokr6cb@andromeda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221114113639.mxgewf2zjgokr6cb@andromeda>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Nov 14, 2022 at 12:36:39PM +0100, Carlos Maiolino wrote:
> Hi folks,
> 
> The xfsprogs repository at:
> 
>         git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git
> 
> has just been updated and tagged for a v6.0.0 release. The condensed changelog
> since v6.0.0-rc0 is below.
> 
> Tarballs are available at:
> 
> https://www.kernel.org/pub/linux/utils/fs/xfs/xfsprogs/xfsprogs-6.0.0.tar.gz
> https://www.kernel.org/pub/linux/utils/fs/xfs/xfsprogs/xfsprogs-6.0.0.tar.xz
> https://www.kernel.org/pub/linux/utils/fs/xfs/xfsprogs/xfsprogs-6.0.0.tar.sign
> 
> Patches often get missed, so please check if your outstanding
> patches were in this update. If they have not been in this update,
> please resubmit them to linux-xfs@vger.kernel.org so they can be
> picked up in the next update.

That means I should requeue this pile of bugfixes
https://lore.kernel.org/linux-xfs/166795950005.3761353.14062544433865007925.stgit@magnolia/T/#t

for 6.1, right?

--D

> The new head of the master branch is commit:
> 
> 3498b6802 xfsprogs: Release v6.0.0
> 
> New Commits:
> 
> Andrey Albershteyn (5):
>       [f103166a9] xfs_quota: separate quota info acquisition into get_dquot()
>       [2c1e7aefd] xfs_quota: separate get_dquot() and dump_file()
>       [79e651743] xfs_quota: separate get_dquot() and report_mount()
>       [6c007276a] xfs_quota: utilize XFS_GETNEXTQUOTA for ranged calls in report/dump
>       [f2fde322d] xfs_quota: apply -L/-U range limits in uid/gid/pid loops
> 
> Carlos Maiolino (1):
>       [3498b6802] xfsprogs: Release v6.0.0
> 
> Jakub Bogusz (1):
>       [f034a3215] Polish translation update for xfsprogs 5.19.0.
> 
> Xiaole He (1):
>       [d878935dd] xfs_db: use preferable macro to seek offset for local dir3 entry fields
> 
>  VERSION          |     2 +-
>  configure.ac     |     2 +-
>  db/dir2sf.c      |     6 +-
>  debian/changelog |     6 +
>  doc/CHANGES      |     5 +
>  po/pl.po         | 21351 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++------------------------------------------------------------------------------------------
>  quota/report.c   |   343 ++-
>  7 files changed, 11248 insertions(+), 10467 deletions(-)
> 
> 
> I needed to do a forced update to the tree, to fix a patch authoring mistake,
> since both push and forced push were done only a few minutes apart, I hope it
> didn't cause any trouble for anyone, otherwise, please accept my apologies.
> 
> -- 
> Carlos Maiolino
