Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7CDC7C4332F
	for <linux-xfs@archiver.kernel.org>; Fri, 14 Oct 2022 05:08:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229774AbiJNFIJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 14 Oct 2022 01:08:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229782AbiJNFIH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 14 Oct 2022 01:08:07 -0400
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 966FC1946FC
        for <linux-xfs@vger.kernel.org>; Thu, 13 Oct 2022 22:08:06 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-106-210.pa.nsw.optusnet.com.au [49.181.106.210])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 37BE78AD7F9;
        Fri, 14 Oct 2022 16:08:05 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1ojCvT-001l9D-4o; Fri, 14 Oct 2022 16:08:03 +1100
Date:   Fri, 14 Oct 2022 16:08:03 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 6/6] xfs: teach scrub to flag non-extents format cow forks
Message-ID: <20221014050803.GQ3600936@dread.disaster.area>
References: <166473480864.1083927.11062319917293302327.stgit@magnolia>
 <166473480956.1083927.1804040835619289778.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <166473480956.1083927.1804040835619289778.stgit@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=OJNEYQWB c=1 sm=1 tr=0 ts=6348eeb5
        a=j6JUzzrSC7wlfFge/rmVbg==:117 a=j6JUzzrSC7wlfFge/rmVbg==:17
        a=kj9zAlcOel0A:10 a=Qawa6l4ZSaYA:10 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8
        a=7-415B0cAAAA:8 a=l73UGVZ3hfmw760n7uQA:9 a=CjuIK1q_8ugA:10
        a=AjGcO6oz07-iQ99wixmX:22 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Oct 02, 2022 at 11:20:09AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> CoW forks only exist in memory, which means that they can only ever have
> an incore extent tree.  Hence they must always be FMT_EXTENTS, so check
> this when we're scrubbing them.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/scrub/bmap.c |    2 ++
>  1 file changed, 2 insertions(+)

Makes sense.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
