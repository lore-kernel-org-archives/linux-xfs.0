Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9323FC25B08
	for <linux-xfs@archiver.kernel.org>; Thu, 18 Aug 2022 00:22:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234268AbiHRAWB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 17 Aug 2022 20:22:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231510AbiHRAWB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 17 Aug 2022 20:22:01 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 564DEA5709
        for <linux-xfs@vger.kernel.org>; Wed, 17 Aug 2022 17:22:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0A6DBB81DEB
        for <linux-xfs@vger.kernel.org>; Thu, 18 Aug 2022 00:21:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA8EAC433C1;
        Thu, 18 Aug 2022 00:21:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660782117;
        bh=Ad8q6/mAE++R7bRdFZys/RdCTcoIcVli3HDCLBEeI5g=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hCuymHnpijzCJYU83GHOHHBWxzNvcow5W664Dq3d6G/5BRzF17RUUUmzXSExMy3q9
         agyz7Ie1G8Io9JHudgO3w4iyK809/6SFknKGdNbpl7O6jEUTFHOqTUE2sYtfCDBZIn
         C4BUJV/mAiZpj/VXBqhv5tlM6k2RrEzTviLEp8SLkUJLgvg3QAqkDHa07kAg7h8ShJ
         XVn2wWpfVMVaOfIZfgRuRRpJKeVpHD2hQIzUXZHvSZFDN+trHc9Z0Va/DdfjvPy6qJ
         JhA0oQkHWin7DOeOraWnc+ahH0S/L3txtm3QOAVIwfVV+aQEUEvNJ33IbJWJbIlDQJ
         8KWUF8gGZlKdg==
Date:   Wed, 17 Aug 2022 17:21:57 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Leah Rumancik <leah.rumancik@gmail.com>
Cc:     linux-xfs@vger.kernel.org, amir73il@gmail.com
Subject: Re: [PATCH CANDIDATE 5.15 0/9] xfs stable candidate patches for
 5.15.y (part 4)
Message-ID: <Yv2GJUk+/6JPbmFu@magnolia>
References: <20220817005610.3170067-1-leah.rumancik@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220817005610.3170067-1-leah.rumancik@gmail.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Aug 16, 2022 at 05:56:01PM -0700, Leah Rumancik wrote:
> Hello,
> 
> No regressions were found for this set via the usual testing.
> 
> Additional targeted testing:
> 
> generic/691 for bc37e4fb5cac
> generic/681 for 871b9316e7a7
> generic/682 for 41667260bc84
>   Ensured these regression tests failed before but not after backports
> 
> xfs/170 for f650df7171b88
>   Was not able to reproduce failure before or after on my setup

Looks good to me,
Acked-by: Darrick J. Wong <djwong@kernel.org>

--D

> 
> - Leah
> 
> Brian Foster (2):
>   xfs: flush inodegc workqueue tasks before cancel
>   xfs: fix soft lockup via spinning in filestream ag selection loop
> 
> Darrick J. Wong (6):
>   xfs: reserve quota for dir expansion when linking/unlinking files
>   xfs: reserve quota for target dir expansion when renaming files
>   xfs: remove infinite loop when reserving free block pool
>   xfs: always succeed at setting the reserve pool size
>   xfs: fix overfilling of reserve pool
>   xfs: reject crazy array sizes being fed to XFS_IOC_GETBMAP*
> 
> Eric Sandeen (1):
>   xfs: revert "xfs: actually bump warning counts when we send warnings"
> 
>  fs/xfs/xfs_filestream.c  |  7 ++--
>  fs/xfs/xfs_fsops.c       | 50 ++++++++++-------------
>  fs/xfs/xfs_icache.c      | 22 ++--------
>  fs/xfs/xfs_inode.c       | 79 ++++++++++++++++++++++--------------
>  fs/xfs/xfs_ioctl.c       |  2 +-
>  fs/xfs/xfs_trans.c       | 86 ++++++++++++++++++++++++++++++++++++++++
>  fs/xfs/xfs_trans.h       |  3 ++
>  fs/xfs/xfs_trans_dquot.c |  1 -
>  8 files changed, 167 insertions(+), 83 deletions(-)
> 
> -- 
> 2.37.1.595.g718a3a8f04-goog
> 
