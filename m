Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F221BC4708F
	for <linux-xfs@archiver.kernel.org>; Wed,  2 Jun 2021 02:04:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D8EDE60720
	for <linux-xfs@archiver.kernel.org>; Wed,  2 Jun 2021 02:04:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229746AbhFBCGG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 1 Jun 2021 22:06:06 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:56246 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229739AbhFBCGE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 1 Jun 2021 22:06:04 -0400
Received: from dread.disaster.area (pa49-179-138-183.pa.nsw.optusnet.com.au [49.179.138.183])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 6BC4A861AD9;
        Wed,  2 Jun 2021 12:04:17 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1loGEy-007vvh-Iq; Wed, 02 Jun 2021 12:04:16 +1000
Date:   Wed, 2 Jun 2021 12:04:16 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        hch@infradead.org
Subject: Re: [PATCH 12/14] xfs: pass struct xfs_eofblocks to the inode scan
 callback
Message-ID: <20210602020416.GR664593@dread.disaster.area>
References: <162259515220.662681.6750744293005850812.stgit@locust>
 <162259521860.662681.12154848311244033442.stgit@locust>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <162259521860.662681.12154848311244033442.stgit@locust>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=YKPhNiOx c=1 sm=1 tr=0
        a=MnllW2CieawZLw/OcHE/Ng==:117 a=MnllW2CieawZLw/OcHE/Ng==:17
        a=kj9zAlcOel0A:10 a=r6YtysWOX24A:10 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8
        a=7-415B0cAAAA:8 a=pH7jHgOuYLZdLXyr0foA:9 a=CjuIK1q_8ugA:10
        a=AjGcO6oz07-iQ99wixmX:22 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jun 01, 2021 at 05:53:38PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Pass a pointer to the actual eofb structure around the inode scanner
> functions instead of a void pointer, now that none of the functions is
> used as a callback.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_icache.c |   30 +++++++++++++-----------------
>  1 file changed, 13 insertions(+), 17 deletions(-)

Looks ok.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

As mentioned in #xfs, I think there's followup work here to rename
struct xfs_eofblocks to struct xfs_icwalk now that it really has
nothing specific to do with eofblock scanning anymore.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
