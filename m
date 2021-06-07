Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 070D6C4743D
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Jun 2021 01:46:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DDA88611C2
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Jun 2021 01:45:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230110AbhFGBrs (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 6 Jun 2021 21:47:48 -0400
Received: from mail109.syd.optusnet.com.au ([211.29.132.80]:47598 "EHLO
        mail109.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230104AbhFGBrs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 6 Jun 2021 21:47:48 -0400
Received: from dread.disaster.area (pa49-179-138-183.pa.nsw.optusnet.com.au [49.179.138.183])
        by mail109.syd.optusnet.com.au (Postfix) with ESMTPS id 0F81A69DD2;
        Mon,  7 Jun 2021 11:45:44 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lq4Kl-009pqx-Gx; Mon, 07 Jun 2021 11:45:43 +1000
Date:   Mon, 7 Jun 2021 11:45:43 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs: change the prefix of XFS_EOF_FLAGS_* to
 XFS_ICWALK_FLAG_
Message-ID: <20210607014543.GD664593@dread.disaster.area>
References: <162300206433.1202657.5753685964265403056.stgit@locust>
 <162300206990.1202657.3281876344287883806.stgit@locust>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <162300206990.1202657.3281876344287883806.stgit@locust>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=YKPhNiOx c=1 sm=1 tr=0
        a=MnllW2CieawZLw/OcHE/Ng==:117 a=MnllW2CieawZLw/OcHE/Ng==:17
        a=kj9zAlcOel0A:10 a=r6YtysWOX24A:10 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8
        a=7-415B0cAAAA:8 a=fgtISsnasNbhBIo_Hu4A:9 a=CjuIK1q_8ugA:10
        a=AjGcO6oz07-iQ99wixmX:22 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Jun 06, 2021 at 10:54:29AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> In preparation for renaming struct xfs_eofblocks to struct xfs_icwalk,
> change the prefix of the existing XFS_EOF_FLAGS_* flags to
> XFS_ICWALK_FLAG_ and convert all the existing users.  This adds a degree
> of interface separation between the ioctl definitions and the incore
> parameters.  Since FLAGS_UNION is only used in xfs_icache.c, move it
> there as a private flag.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/xfs_file.c   |    4 ++--
>  fs/xfs/xfs_icache.c |   44 +++++++++++++++++++++++---------------------
>  fs/xfs/xfs_icache.h |   17 +++++++++++++++--
>  fs/xfs/xfs_ioctl.c  |   13 ++++++++++++-
>  4 files changed, 52 insertions(+), 26 deletions(-)

Looks reasonable.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
