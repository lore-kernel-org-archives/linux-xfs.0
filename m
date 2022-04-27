Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B987FC433F5
	for <linux-xfs@archiver.kernel.org>; Wed, 27 Apr 2022 04:29:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357721AbiD0Ecr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 27 Apr 2022 00:32:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357702AbiD0Eco (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 27 Apr 2022 00:32:44 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1C569161A74
        for <linux-xfs@vger.kernel.org>; Tue, 26 Apr 2022 21:29:30 -0700 (PDT)
Received: from dread.disaster.area (pa49-195-62-197.pa.nsw.optusnet.com.au [49.195.62.197])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 58A2A10E61C2;
        Wed, 27 Apr 2022 14:29:29 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1njZIt-0051IN-ME; Wed, 27 Apr 2022 14:29:27 +1000
Date:   Wed, 27 Apr 2022 14:29:27 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 6/9] xfs: reduce the absurdly large log operation count
Message-ID: <20220427042927.GI1098723@dread.disaster.area>
References: <165102071223.3922658.5241787533081256670.stgit@magnolia>
 <165102074605.3922658.2732417123514234429.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <165102074605.3922658.2732417123514234429.stgit@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=6268c6a9
        a=KhGSFSjofVlN3/cgq4AT7A==:117 a=KhGSFSjofVlN3/cgq4AT7A==:17
        a=kj9zAlcOel0A:10 a=z0gMJWrwH1QA:10 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8
        a=7-415B0cAAAA:8 a=gL1-kHRYkFWvcOnKXysA:9 a=CjuIK1q_8ugA:10
        a=AjGcO6oz07-iQ99wixmX:22 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Apr 26, 2022 at 05:52:26PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Back in the early days of reflink and rmap development I set the
> transaction reservation sizes to be overly generous for rmap+reflink
> filesystems, and a little under-generous for rmap-only filesystems.
> 
> Since we don't need *eight* transaction rolls to handle three new log
> intent items, decrease the logcounts to what we actually need, and amend
> the shadow reservation computation function to reflect what we used to
> do so that the minimum log size doesn't change.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/libxfs/xfs_log_rlimit.c |   51 ++++++++++++++++++++++++++++++++++++++--
>  fs/xfs/libxfs/xfs_trans_resv.c |   46 +++++++++++++++---------------------
>  fs/xfs/libxfs/xfs_trans_resv.h |   10 ++++++--
>  3 files changed, 76 insertions(+), 31 deletions(-)

Much nicer.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
