Return-Path: <SRS0=xOwi=4F=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE451C34022
	for <linux-xfs@archiver.kernel.org>; Mon, 17 Feb 2020 22:04:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BF32320801
	for <linux-xfs@archiver.kernel.org>; Mon, 17 Feb 2020 22:04:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725873AbgBQWE6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 17 Feb 2020 17:04:58 -0500
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:46191 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726010AbgBQWE6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 17 Feb 2020 17:04:58 -0500
Received: from dread.disaster.area (pa49-179-138-28.pa.nsw.optusnet.com.au [49.179.138.28])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 5EB803A1FAF;
        Tue, 18 Feb 2020 09:04:56 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1j3oVb-0003PV-9H; Tue, 18 Feb 2020 09:04:55 +1100
Date:   Tue, 18 Feb 2020 09:04:55 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org,
        Allison Collins <allison.henderson@oracle.com>,
        Chandan Rajendra <chandanrlinux@gmail.com>,
        "Darrick J . Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 04/31] xfs: merge xfs_attrmulti_attr_remove into
 xfs_attrmulti_attr_set
Message-ID: <20200217220455.GI10776@dread.disaster.area>
References: <20200217125957.263434-1-hch@lst.de>
 <20200217125957.263434-5-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200217125957.263434-5-hch@lst.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=W5xGqiek c=1 sm=1 tr=0
        a=zAxSp4fFY/GQY8/esVNjqw==:117 a=zAxSp4fFY/GQY8/esVNjqw==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=l697ptgUJYAA:10
        a=pGLkceISAAAA:8 a=yPCof4ZbAAAA:8 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8
        a=Bp7DrwGW5AdoQjAezo4A:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Feb 17, 2020 at 01:59:30PM +0100, Christoph Hellwig wrote:
> Merge the ioctl handlers just like the low-level xfs_attr_set function.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Chandan Rajendra <chandanrlinux@gmail.com>
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/xfs_ioctl.c   | 34 ++++++++++------------------------
>  fs/xfs/xfs_ioctl.h   |  6 ------
>  fs/xfs/xfs_ioctl32.c |  4 ++--
>  3 files changed, 12 insertions(+), 32 deletions(-)

Looks fine.


Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
