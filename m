Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2707EC433FE
	for <linux-xfs@archiver.kernel.org>; Fri, 14 Oct 2022 03:49:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229818AbiJNDt6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 13 Oct 2022 23:49:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229769AbiJNDt5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 13 Oct 2022 23:49:57 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 269F127FEE
        for <linux-xfs@vger.kernel.org>; Thu, 13 Oct 2022 20:49:53 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-106-210.pa.nsw.optusnet.com.au [49.181.106.210])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id AA6491101746;
        Fri, 14 Oct 2022 14:49:52 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1ojBhm-001jjW-0T; Fri, 14 Oct 2022 14:49:50 +1100
Date:   Fri, 14 Oct 2022 14:49:50 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs: load rtbitmap and rtsummary extent mapping
 btrees at mount time
Message-ID: <20221014034950.GJ3600936@dread.disaster.area>
References: <166473480232.1083697.18352887736798889545.stgit@magnolia>
 <166473480249.1083697.13081552727850377113.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <166473480249.1083697.13081552727850377113.stgit@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=6348dc60
        a=j6JUzzrSC7wlfFge/rmVbg==:117 a=j6JUzzrSC7wlfFge/rmVbg==:17
        a=kj9zAlcOel0A:10 a=Qawa6l4ZSaYA:10 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8
        a=7-415B0cAAAA:8 a=EDEgQ8aR-Fp8ck5jjCkA:9 a=CjuIK1q_8ugA:10
        a=AjGcO6oz07-iQ99wixmX:22 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Oct 02, 2022 at 11:20:02AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> It turns out that GETFSMAP and online fsck have had a bug for years due
> to their use of ILOCK_SHARED to coordinate their linear scans of the
> realtime bitmap.  If the bitmap file's data fork happens to be in BTREE
> format and the scan occurs immediately after mounting, the incore bmbt
> will not be populated, leading to ASSERTs tripping over the incorrect
> inode state.  Because the bitmap scans always lock bitmap buffers in
> increasing order of file offset, it is appropriate for these two callers
> to take a shared ILOCK to improve scalability.
> 
> To fix this problem, load both data and attr fork state into memory when
> mounting the realtime inodes.  Realtime metadata files aren't supposed
> to have an attr fork so the second step is likely a nop.
> 
> On most filesystems this is unlikely since the rtbitmap data fork is
> usually in extents format, but it's possible to craft a filesystem that
> will by fragmenting the free space in the data section and growfsing the
> rt section.
> 
> Fixes: 4c934c7dd60c ("xfs: report realtime space information via the rtbitmap")
> Also-Fixes: 46d9bfb5e706 ("xfs: cross-reference the realtime bitmap")
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/xfs_rtalloc.c |   56 ++++++++++++++++++++++++++++++++++++++++++++++----
>  1 file changed, 52 insertions(+), 4 deletions(-)

Looks fine.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
