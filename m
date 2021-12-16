Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 294E0C433F5
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Dec 2021 04:57:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231816AbhLPE5Y (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 15 Dec 2021 23:57:24 -0500
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:50121 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231639AbhLPE5Y (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 15 Dec 2021 23:57:24 -0500
Received: from dread.disaster.area (pa49-181-243-119.pa.nsw.optusnet.com.au [49.181.243.119])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 2D0C910A480D;
        Thu, 16 Dec 2021 15:57:23 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1mxipW-003dXI-Ko; Thu, 16 Dec 2021 15:57:22 +1100
Date:   Thu, 16 Dec 2021 15:57:22 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/7] xfs: shut down filesystem if we xfs_trans_cancel
 with deferred work items
Message-ID: <20211216045722.GZ449541@dread.disaster.area>
References: <163961695502.3129691.3496134437073533141.stgit@magnolia>
 <163961696648.3129691.5075630610079213754.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <163961696648.3129691.5075630610079213754.stgit@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=61bac733
        a=BEa52nrBdFykVEm6RU8P4g==:117 a=BEa52nrBdFykVEm6RU8P4g==:17
        a=kj9zAlcOel0A:10 a=IOMw9HtfNCkA:10 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8
        a=7-415B0cAAAA:8 a=XiolSKywiDWJ7uvXww4A:9 a=CjuIK1q_8ugA:10
        a=AjGcO6oz07-iQ99wixmX:22 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Dec 15, 2021 at 05:09:26PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> While debugging some very strange rmap corruption reports in connection
> with the online directory repair code.  I root-caused the error to the
> following incorrect sequence:
> 
> <start repair transaction>
> <expand directory, causing a deferred rmap to be queued>
> <roll transaction>
> <cancel transaction>
> 
> Obviously, we should have committed the transaction instead of
> cancelling it.  Thinking more broadly, however, xfs_trans_cancel should
> have warned us that we were throwing away work item that we already
> committed to performing.  This is not correct, and we need to shut down
> the filesystem.
> 
> Change xfs_trans_cancel to complain in the loudest manner if we're
> cancelling any transaction with deferred work items attached.

Yup, seems reasonable.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
