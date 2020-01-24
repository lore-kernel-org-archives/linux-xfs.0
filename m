Return-Path: <SRS0=JklA=3N=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3ACBAC2D0CE
	for <linux-xfs@archiver.kernel.org>; Fri, 24 Jan 2020 22:05:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0BBD62071E
	for <linux-xfs@archiver.kernel.org>; Fri, 24 Jan 2020 22:05:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728853AbgAXWFI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 24 Jan 2020 17:05:08 -0500
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:52689 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725821AbgAXWFI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 24 Jan 2020 17:05:08 -0500
Received: from dread.disaster.area (pa49-195-162-125.pa.nsw.optusnet.com.au [49.195.162.125])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 66F1F3A2744;
        Sat, 25 Jan 2020 09:05:06 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1iv74b-0007Us-0X; Sat, 25 Jan 2020 09:05:05 +1100
Date:   Sat, 25 Jan 2020 09:05:04 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org
Subject: Re: [PATCH 03/12] xfs: make xfs_buf_read_map return an error code
Message-ID: <20200124220504.GO7090@dread.disaster.area>
References: <157984313582.3139258.1136501362141645797.stgit@magnolia>
 <157984315522.3139258.1946613629222213561.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <157984315522.3139258.1946613629222213561.stgit@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=W5xGqiek c=1 sm=1 tr=0
        a=eqEhQ2W7mF93FbYHClaXRw==:117 a=eqEhQ2W7mF93FbYHClaXRw==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=Jdjhy38mL1oA:10
        a=yPCof4ZbAAAA:8 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8 a=xYGgo8aeCtFn_Qqv500A:9
        a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jan 23, 2020 at 09:19:15PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Convert xfs_buf_read_map() to return numeric error codes like most
> everywhere else in xfs.  This involves moving the open-coded logic that
> reports metadata IO read / corruption errors and stales the buffer into
> xfs_buf_read_map so that the logic is all in one place.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_alloc.c       |   11 ++++---
>  fs/xfs/libxfs/xfs_attr_remote.c |   10 ------
>  fs/xfs/xfs_buf.c                |   63 +++++++++++++++++++++++++++++----------
>  fs/xfs/xfs_buf.h                |   15 ++++++---
>  fs/xfs/xfs_log_recover.c        |   10 ------
>  fs/xfs/xfs_symlink.c            |   10 ------
>  fs/xfs/xfs_trans_buf.c          |   36 +++++-----------------
>  7 files changed, 72 insertions(+), 83 deletions(-)

Error handling in xfs_trans_read_buf_map() looks ok now.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
