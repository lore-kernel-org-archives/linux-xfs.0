Return-Path: <SRS0=UV4a=4J=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EFCD2C35669
	for <linux-xfs@archiver.kernel.org>; Fri, 21 Feb 2020 22:57:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C0C2620722
	for <linux-xfs@archiver.kernel.org>; Fri, 21 Feb 2020 22:57:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729179AbgBUW5d (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 21 Feb 2020 17:57:33 -0500
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:40110 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727822AbgBUW5d (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Feb 2020 17:57:33 -0500
Received: from dread.disaster.area (pa49-195-185-106.pa.nsw.optusnet.com.au [49.195.185.106])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id B54483A3FA3;
        Sat, 22 Feb 2020 09:57:29 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1j5HEe-0004RS-VG; Sat, 22 Feb 2020 09:57:28 +1100
Date:   Sat, 22 Feb 2020 09:57:28 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org,
        Allison Collins <allison.henderson@oracle.com>,
        "Darrick J . Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 09/31] xfs: move struct xfs_da_args to xfs_types.h
Message-ID: <20200221225728.GX10776@dread.disaster.area>
References: <20200221141154.476496-1-hch@lst.de>
 <20200221141154.476496-10-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200221141154.476496-10-hch@lst.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=W5xGqiek c=1 sm=1 tr=0
        a=bkRQb8bsQZKWSSj4M57YXw==:117 a=bkRQb8bsQZKWSSj4M57YXw==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=l697ptgUJYAA:10
        a=yPCof4ZbAAAA:8 a=7-415B0cAAAA:8 a=yFrD9zFSM_CzhnQ0ApQA:9
        a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Feb 21, 2020 at 06:11:32AM -0800, Christoph Hellwig wrote:
> To allow passing a struct xfs_da_args to the high-level attr helpers
> it needs to be easily includable by files like xfs_xattr.c.  Move the
> struct definition to xfs_types.h to allow for that.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_da_btree.h | 64 ------------------------------------
>  fs/xfs/libxfs/xfs_types.h    | 60 +++++++++++++++++++++++++++++++++
>  2 files changed, 60 insertions(+), 64 deletions(-)

This seems way too broad. Stuff in fs/xfs/libxfs/xfs_types.h is
really for fundamental XFS types, not for complex, subsystem
specific API structures.

Why can't the xattr code simply include what it needs to get this
structure from xfs_da_btree.h like everything else does?  Indeed,
fs/xfs/xfs_xattr.c already includes xfs_da_format.h, so it should be
able to directly include xfs_da_btree.h without much extra hassle.

Hence I don't really see why making this structure globally visible
is actually necessary, especially as the function prototypes in
header files can simply use a forward declaration of struct
xfs_da_args....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
