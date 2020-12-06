Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9D54C433FE
	for <linux-xfs@archiver.kernel.org>; Sun,  6 Dec 2020 23:48:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 87AC422D08
	for <linux-xfs@archiver.kernel.org>; Sun,  6 Dec 2020 23:48:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728557AbgLFXsV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 6 Dec 2020 18:48:21 -0500
Received: from mail109.syd.optusnet.com.au ([211.29.132.80]:53487 "EHLO
        mail109.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726400AbgLFXsU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 6 Dec 2020 18:48:20 -0500
Received: from dread.disaster.area (pa49-179-6-140.pa.nsw.optusnet.com.au [49.179.6.140])
        by mail109.syd.optusnet.com.au (Postfix) with ESMTPS id 8A7A1D7FE96;
        Mon,  7 Dec 2020 10:47:38 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1km3kg-001GGv-26; Mon, 07 Dec 2020 10:47:38 +1100
Date:   Mon, 7 Dec 2020 10:47:38 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, bfoster@redhat.com, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/3] xfs: define a new "needrepair" feature
Message-ID: <20201206234738.GM3913616@dread.disaster.area>
References: <160729616025.1606994.13590463307385382944.stgit@magnolia>
 <160729617344.1606994.3329458995178500981.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <160729617344.1606994.3329458995178500981.stgit@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=F8MpiZpN c=1 sm=1 tr=0 cx=a_idp_d
        a=uDU3YIYVKEaHT0eX+MXYOQ==:117 a=uDU3YIYVKEaHT0eX+MXYOQ==:17
        a=kj9zAlcOel0A:10 a=zTNgK-yGK50A:10 a=yPCof4ZbAAAA:8 a=20KFwNOVAAAA:8
        a=7-415B0cAAAA:8 a=11xyIMSjX81Ja18heTQA:9 a=CjuIK1q_8ugA:10
        a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Dec 06, 2020 at 03:09:33PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Define an incompat feature flag to indicate that the filesystem needs to
> be repaired.  While libxfs will recognize this feature, the kernel will
> refuse to mount if the feature flag is set, and only xfs_repair will be
> able to clear the flag.  The goal here is to force the admin to run
> xfs_repair to completion after upgrading the filesystem, or if we
> otherwise detect anomalies.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> Reviewed-by: Brian Foster <bfoster@redhat.com>

lgtm

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
