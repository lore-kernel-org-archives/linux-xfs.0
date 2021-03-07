Return-Path: <SRS0=xiMZ=IF=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6BA2C433E0
	for <linux-xfs@archiver.kernel.org>; Sun,  7 Mar 2021 22:37:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9B37765151
	for <linux-xfs@archiver.kernel.org>; Sun,  7 Mar 2021 22:37:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230475AbhCGWhI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 7 Mar 2021 17:37:08 -0500
Received: from mail110.syd.optusnet.com.au ([211.29.132.97]:34124 "EHLO
        mail110.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229740AbhCGWhI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 7 Mar 2021 17:37:08 -0500
Received: from dread.disaster.area (pa49-179-130-210.pa.nsw.optusnet.com.au [49.179.130.210])
        by mail110.syd.optusnet.com.au (Postfix) with ESMTPS id 97646108AB0;
        Mon,  8 Mar 2021 09:37:04 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lJ21H-0020rR-QI; Mon, 08 Mar 2021 09:37:03 +1100
Date:   Mon, 8 Mar 2021 09:37:03 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, hch@lst.de, dchinner@redhat.com,
        christian.brauner@ubuntu.com
Subject: Re: [PATCH v2.1 2/4] xfs: avoid buffer deadlocks when walking fs
 inodes
Message-ID: <20210307223703.GX4662@dread.disaster.area>
References: <161514874040.698643.2749449122589431232.stgit@magnolia>
 <161514875165.698643.17020544838073213424.stgit@magnolia>
 <20210307203638.GJ3419940@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210307203638.GJ3419940@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=Tu+Yewfh c=1 sm=1 tr=0 cx=a_idp_d
        a=JD06eNgDs9tuHP7JIKoLzw==:117 a=JD06eNgDs9tuHP7JIKoLzw==:17
        a=kj9zAlcOel0A:10 a=dESyimp9J3IA:10 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8
        a=7-415B0cAAAA:8 a=h2mM3Y-dPZZPkediAsoA:9 a=CjuIK1q_8ugA:10
        a=AjGcO6oz07-iQ99wixmX:22 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Mar 07, 2021 at 12:36:38PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> When we're servicing an INUMBERS or BULKSTAT request or running
> quotacheck, grab an empty transaction so that we can use its inherent
> recursive buffer locking abilities to detect inode btree cycles without
> hitting ABBA buffer deadlocks.
> 
> Found by fuzzing an inode btree pointer to introduce a cycle into the
> tree (xfs/365).
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
> v2.1: actually pass tp in the bulkstat_single case
> ---
>  fs/xfs/xfs_itable.c |   42 +++++++++++++++++++++++++++++++++++++-----
>  fs/xfs/xfs_iwalk.c  |   32 +++++++++++++++++++++++++++-----
>  2 files changed, 64 insertions(+), 10 deletions(-)

Looks ok, but I can't help but wonder if this case should flag
corruption if lock recursion does actually occur...

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
