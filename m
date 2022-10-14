Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B845AC433FE
	for <linux-xfs@archiver.kernel.org>; Fri, 14 Oct 2022 03:50:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229576AbiJNDuo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 13 Oct 2022 23:50:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229830AbiJNDum (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 13 Oct 2022 23:50:42 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3633C16D888
        for <linux-xfs@vger.kernel.org>; Thu, 13 Oct 2022 20:50:36 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-106-210.pa.nsw.optusnet.com.au [49.181.106.210])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 8D4EB110176B;
        Fri, 14 Oct 2022 14:50:34 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1ojBiS-001jkE-TM; Fri, 14 Oct 2022 14:50:32 +1100
Date:   Fri, 14 Oct 2022 14:50:32 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs: make rtbitmap ILOCKing consistent when scanning
 the rt bitmap file
Message-ID: <20221014035032.GK3600936@dread.disaster.area>
References: <166473480232.1083697.18352887736798889545.stgit@magnolia>
 <166473480263.1083697.13141104857984829878.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <166473480263.1083697.13141104857984829878.stgit@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=OJNEYQWB c=1 sm=1 tr=0 ts=6348dc8a
        a=j6JUzzrSC7wlfFge/rmVbg==:117 a=j6JUzzrSC7wlfFge/rmVbg==:17
        a=kj9zAlcOel0A:10 a=Qawa6l4ZSaYA:10 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8
        a=7-415B0cAAAA:8 a=hRSGyfx89EX2pbNm__0A:9 a=CjuIK1q_8ugA:10
        a=AjGcO6oz07-iQ99wixmX:22 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Oct 02, 2022 at 11:20:02AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> xfs_rtalloc_query_range scans the realtime bitmap file in order of
> increasing file offset, so this caller can take ILOCK_SHARED on the rt
> bitmap inode instead of ILOCK_EXCL.  This isn't going to yield any
> practical benefits at mount time, but we'd like to make the locking
> usage consistent around xfs_rtalloc_query_all calls.  Make all the
> places we do this use the same xfs_ilock lockflags for consistency.
> 
> Fixes: 4c934c7dd60c ("xfs: report realtime space information via the rtbitmap")
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/xfs_fsmap.c   |    4 ++--
>  fs/xfs/xfs_rtalloc.c |    4 ++--
>  2 files changed, 4 insertions(+), 4 deletions(-)

LGTM.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
