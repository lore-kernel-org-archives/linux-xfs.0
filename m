Return-Path: <SRS0=JklA=3N=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35EA1C35240
	for <linux-xfs@archiver.kernel.org>; Fri, 24 Jan 2020 02:01:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0645721835
	for <linux-xfs@archiver.kernel.org>; Fri, 24 Jan 2020 02:01:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730163AbgAXCB5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 23 Jan 2020 21:01:57 -0500
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:39444 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730158AbgAXCB5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 23 Jan 2020 21:01:57 -0500
Received: from dread.disaster.area (pa49-195-162-125.pa.nsw.optusnet.com.au [49.195.162.125])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 56E663A2750;
        Fri, 24 Jan 2020 13:01:50 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1iuoI8-0000WO-Mv; Fri, 24 Jan 2020 13:01:48 +1100
Date:   Fri, 24 Jan 2020 13:01:48 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org,
        Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 11/12] xfs: remove unnecessary null pointer checks from
 _read_agf callers
Message-ID: <20200124020148.GL7090@dread.disaster.area>
References: <157976531016.2388944.3654360225810285604.stgit@magnolia>
 <157976538103.2388944.15185862740410550762.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <157976538103.2388944.15185862740410550762.stgit@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=W5xGqiek c=1 sm=1 tr=0
        a=eqEhQ2W7mF93FbYHClaXRw==:117 a=eqEhQ2W7mF93FbYHClaXRw==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=Jdjhy38mL1oA:10
        a=yPCof4ZbAAAA:8 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8 a=0JHGfgnIpbpsem1tjGkA:9
        a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jan 22, 2020 at 11:43:01PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Drop the null buffer pointer checks in all code that calls
> xfs_alloc_read_agf and doesn't pass XFS_ALLOC_FLAG_TRYLOCK because
> they're no longer necessary.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/libxfs/xfs_refcount.c   |    6 ------
>  fs/xfs/scrub/agheader_repair.c |    4 ----
>  fs/xfs/scrub/fscounters.c      |    3 ---
>  fs/xfs/scrub/repair.c          |    2 --
>  fs/xfs/xfs_discard.c           |    2 +-
>  fs/xfs/xfs_reflink.c           |    2 --
>  6 files changed, 1 insertion(+), 18 deletions(-)

looks good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
