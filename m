Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE429C433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 14 Oct 2021 22:49:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B3AC461027
	for <linux-xfs@archiver.kernel.org>; Thu, 14 Oct 2021 22:49:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233705AbhJNWvH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 14 Oct 2021 18:51:07 -0400
Received: from mail107.syd.optusnet.com.au ([211.29.132.53]:44681 "EHLO
        mail107.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229818AbhJNWvG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 14 Oct 2021 18:51:06 -0400
Received: from dread.disaster.area (pa49-195-238-16.pa.nsw.optusnet.com.au [49.195.238.16])
        by mail107.syd.optusnet.com.au (Postfix) with ESMTPS id 4222B106624B;
        Fri, 15 Oct 2021 09:49:00 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1mb9X1-006JGu-KX; Fri, 15 Oct 2021 09:48:59 +1100
Date:   Fri, 15 Oct 2021 09:48:59 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, chandan.babu@oracle.com, hch@lst.de
Subject: Re: [PATCH 05/17] xfs: dynamically allocate btree scrub context
 structure
Message-ID: <20211014224859.GO2361455@dread.disaster.area>
References: <163424261462.756780.16294781570977242370.stgit@magnolia>
 <163424264249.756780.1871555838190156050.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <163424264249.756780.1871555838190156050.stgit@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=VuxAv86n c=1 sm=1 tr=0 ts=6168b3dc
        a=DzKKRZjfViQTE5W6EVc0VA==:117 a=DzKKRZjfViQTE5W6EVc0VA==:17
        a=kj9zAlcOel0A:10 a=8gfv0ekSlNoA:10 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8
        a=7-415B0cAAAA:8 a=BpUwPweneEnkhko5wZ4A:9 a=CjuIK1q_8ugA:10
        a=AjGcO6oz07-iQ99wixmX:22 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Oct 14, 2021 at 01:17:22PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Reorganize struct xchk_btree so that we can dynamically size the context
> structure to fit the type of btree cursor that we have.  This will
> enable us to use memory more efficiently once we start adding very tall
> btree types.  Right-size the lastkey array to match the number of *node*
> levels in the tree so that we stop wasting space.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/scrub/btree.c |   23 ++++++++++++-----------
>  fs/xfs/scrub/btree.h |   15 ++++++++++++++-
>  2 files changed, 26 insertions(+), 12 deletions(-)

Looks good now.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
