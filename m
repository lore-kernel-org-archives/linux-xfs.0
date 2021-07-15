Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE49CC636CB
	for <linux-xfs@archiver.kernel.org>; Thu, 15 Jul 2021 23:47:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ACBCB613DC
	for <linux-xfs@archiver.kernel.org>; Thu, 15 Jul 2021 23:47:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229783AbhGOXuN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 15 Jul 2021 19:50:13 -0400
Received: from mail106.syd.optusnet.com.au ([211.29.132.42]:48232 "EHLO
        mail106.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232452AbhGOXuM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 15 Jul 2021 19:50:12 -0400
Received: from dread.disaster.area (pa49-181-34-10.pa.nsw.optusnet.com.au [49.181.34.10])
        by mail106.syd.optusnet.com.au (Postfix) with ESMTPS id 29CBE80BAF3;
        Fri, 16 Jul 2021 09:47:16 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1m4B4V-0070Ld-Ka; Fri, 16 Jul 2021 09:47:15 +1000
Date:   Fri, 16 Jul 2021 09:47:15 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 03/16] xfs: rework attr2 feature and mount options
Message-ID: <20210715234715.GI664593@dread.disaster.area>
References: <20210714041912.2625692-1-david@fromorbit.com>
 <20210714041912.2625692-4-david@fromorbit.com>
 <YO6LCbZWRz3q4JRg@infradead.org>
 <20210714094533.GY664593@dread.disaster.area>
 <YO/NtwOVVanEl6HE@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YO/NtwOVVanEl6HE@infradead.org>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=YKPhNiOx c=1 sm=1 tr=0
        a=hdaoRb6WoHYrV466vVKEyw==:117 a=hdaoRb6WoHYrV466vVKEyw==:17
        a=kj9zAlcOel0A:10 a=e_q4qTt1xDgA:10 a=7-415B0cAAAA:8
        a=K04sG84_labBq7MUWWUA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jul 15, 2021 at 06:55:03AM +0100, Christoph Hellwig wrote:
> On Wed, Jul 14, 2021 at 07:45:33PM +1000, Dave Chinner wrote:
> > That's what happens later in the patchset. The XFS_FEAT_ATTR2 is
> > set when either the mount option or the on-disk sb flag is set, and
> > it is overridden after log recovery (which can set the SB flag) if
> > the XFS_FEAT_NOATTR2 feature has been specified.
> 
> I see where this is going.  I still think keeping the logic changes
> together and killing XFS_MOUNT_ATTR2 here would be preferably,
> especially with all the documentation you have for the attr2
> situation in the commit log here.

The problem is that I can't kill XFS_MOUNT_ATTR2 until all the
m_features infrastructure is in place to replace XFS_MOUNT_ATTR2
being set in m_flags. We still have to check that the mount options
are valid (i.e. attr2 && noattr2 is not allowed) before we read in
the superblock and determine if XFS_SB_VERSION_ATTR2BIT is set on
disk...

It's a catch-22 situation, and this was the simplest way I could
come up with to enable a relatively clean change-over...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
