Return-Path: <SRS0=xiMZ=IF=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9AE12C433E0
	for <linux-xfs@archiver.kernel.org>; Sun,  7 Mar 2021 22:29:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7214A65155
	for <linux-xfs@archiver.kernel.org>; Sun,  7 Mar 2021 22:29:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230051AbhCGW2a (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 7 Mar 2021 17:28:30 -0500
Received: from mail107.syd.optusnet.com.au ([211.29.132.53]:47245 "EHLO
        mail107.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231539AbhCGW2N (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 7 Mar 2021 17:28:13 -0500
Received: from dread.disaster.area (pa49-179-130-210.pa.nsw.optusnet.com.au [49.179.130.210])
        by mail107.syd.optusnet.com.au (Postfix) with ESMTPS id 6CC0FFAABCC;
        Mon,  8 Mar 2021 09:28:07 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lJ1sc-0020IF-AO; Mon, 08 Mar 2021 09:28:06 +1100
Date:   Mon, 8 Mar 2021 09:28:06 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Christoph Hellwig <hch@lst.de>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        linux-xfs@vger.kernel.org, dchinner@redhat.com
Subject: Re: [PATCH 1/4] xfs: fix quota accounting when a mount is idmapped
Message-ID: <20210307222806.GW4662@dread.disaster.area>
References: <161514874040.698643.2749449122589431232.stgit@magnolia>
 <161514874609.698643.4736582270457949683.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161514874609.698643.4736582270457949683.stgit@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=F8MpiZpN c=1 sm=1 tr=0 cx=a_idp_d
        a=JD06eNgDs9tuHP7JIKoLzw==:117 a=JD06eNgDs9tuHP7JIKoLzw==:17
        a=kj9zAlcOel0A:10 a=dESyimp9J3IA:10 a=VwQbUJbxAAAA:8 a=fxJcL_dCAAAA:8
        a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8 a=qus2-oIPqWcNSThEL3UA:9
        a=CjuIK1q_8ugA:10 a=AjGcO6oz07-iQ99wixmX:22 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Mar 07, 2021 at 12:25:46PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Nowadays, we indirectly use the idmap-aware helper functions in the VFS
> to set the initial uid and gid of a file being created.  Unfortunately,
> we didn't convert the quota code, which means we attach the wrong dquots
> to files created on an idmapped mount.
> 
> Fixes: f736d93d76d3 ("xfs: support idmapped mounts")
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Acked-by: Christian Brauner <christian.brauner@ubuntu.com>
> ---
>  fs/xfs/xfs_inode.c   |   14 ++++++++------
>  fs/xfs/xfs_symlink.c |    3 ++-
>  2 files changed, 10 insertions(+), 7 deletions(-)

Looks good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
