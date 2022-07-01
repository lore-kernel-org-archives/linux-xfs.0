Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9044C43334
	for <linux-xfs@archiver.kernel.org>; Fri,  1 Jul 2022 01:06:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232370AbiGABG4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 30 Jun 2022 21:06:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229586AbiGABGz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 30 Jun 2022 21:06:55 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5DC93599DC;
        Thu, 30 Jun 2022 18:06:54 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id AD54410E791B;
        Fri,  1 Jul 2022 11:06:52 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1o757S-00D4kb-Kt; Fri, 01 Jul 2022 11:06:50 +1000
Date:   Fri, 1 Jul 2022 11:06:50 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     guaneryu@gmail.com, zlang@redhat.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, guan@eryu.me
Subject: Re: [PATCH v2.1 4/9] xfs: test xfs_copy doesn't do cached read
 before libxfs_mount
Message-ID: <20220701010650.GA3108597@dread.disaster.area>
References: <165644767753.1045534.18231838177395571946.stgit@magnolia>
 <165644770013.1045534.5572366430392518217.stgit@magnolia>
 <YrzyzsYZDx9AI4fy@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YrzyzsYZDx9AI4fy@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=62be48ad
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=kj9zAlcOel0A:10 a=RgO8CyIxsXoA:10 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8
        a=7-415B0cAAAA:8 a=QKkJzwNKOGFdgAcrkWQA:9 a=CjuIK1q_8ugA:10
        a=AjGcO6oz07-iQ99wixmX:22 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jun 29, 2022 at 05:48:14PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> This is a regression test for an xfs_copy fix that ensures that it
> doesn't perform a cached read of an XFS filesystem prior to initializing
> libxfs, since the xfs_mount (and hence the buffer cache) isn't set up
> yet.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>

Looks good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
