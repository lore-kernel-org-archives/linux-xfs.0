Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E15F4C4332F
	for <linux-xfs@archiver.kernel.org>; Fri, 14 Oct 2022 04:45:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229459AbiJNEpi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 14 Oct 2022 00:45:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229513AbiJNEpi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 14 Oct 2022 00:45:38 -0400
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D46A8B1DCF
        for <linux-xfs@vger.kernel.org>; Thu, 13 Oct 2022 21:45:35 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-106-210.pa.nsw.optusnet.com.au [49.181.106.210])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 531FE8AD82F;
        Fri, 14 Oct 2022 15:45:34 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1ojCZg-001kiO-8r; Fri, 14 Oct 2022 15:45:32 +1100
Date:   Fri, 14 Oct 2022 15:45:32 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/6] xfs: fix perag loop in xchk_bmap_check_rmaps
Message-ID: <20221014044532.GN3600936@dread.disaster.area>
References: <166473480864.1083927.11062319917293302327.stgit@magnolia>
 <166473480888.1083927.912685328486215875.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <166473480888.1083927.912685328486215875.stgit@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=OJNEYQWB c=1 sm=1 tr=0 ts=6348e96e
        a=j6JUzzrSC7wlfFge/rmVbg==:117 a=j6JUzzrSC7wlfFge/rmVbg==:17
        a=kj9zAlcOel0A:10 a=Qawa6l4ZSaYA:10 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8
        a=7-415B0cAAAA:8 a=e1q0pV-D92whSrFHV90A:9 a=CjuIK1q_8ugA:10
        a=AjGcO6oz07-iQ99wixmX:22 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Oct 02, 2022 at 11:20:08AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> sparse complains that we can return an uninitialized error from this
> function and that pag could be uninitialized.  We know that there are no
> zero-AG filesystems and hence we had to call xchk_bmap_check_ag_rmaps at
> least once, so this is not actually possible, but I'm too worn out from
> automated complaints from unsophisticated AIs so let's just fix this and
> move on to more interesting problems, eh?
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/scrub/bmap.c |   14 +++++++-------
>  1 file changed, 7 insertions(+), 7 deletions(-)

Looks fine.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
