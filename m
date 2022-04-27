Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE2DDC433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 27 Apr 2022 04:22:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232216AbiD0EZP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 27 Apr 2022 00:25:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230232AbiD0EZP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 27 Apr 2022 00:25:15 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E263F13CDB
        for <linux-xfs@vger.kernel.org>; Tue, 26 Apr 2022 21:22:02 -0700 (PDT)
Received: from dread.disaster.area (pa49-195-62-197.pa.nsw.optusnet.com.au [49.195.62.197])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 9F57410E5FF0;
        Wed, 27 Apr 2022 14:22:01 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1njZBg-00510i-BW; Wed, 27 Apr 2022 14:22:00 +1000
Date:   Wed, 27 Apr 2022 14:22:00 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/4] xfs: speed up write operations by using
 non-overlapped lookups when possible
Message-ID: <20220427042200.GF1098723@dread.disaster.area>
References: <165102068549.3922526.15959517253241370597.stgit@magnolia>
 <165102070826.3922526.7040761074869734523.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <165102070826.3922526.7040761074869734523.stgit@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=deDjYVbe c=1 sm=1 tr=0 ts=6268c4e9
        a=KhGSFSjofVlN3/cgq4AT7A==:117 a=KhGSFSjofVlN3/cgq4AT7A==:17
        a=kj9zAlcOel0A:10 a=z0gMJWrwH1QA:10 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8
        a=7-415B0cAAAA:8 a=2xjroBjGqIGoqAn_wkcA:9 a=CjuIK1q_8ugA:10
        a=AjGcO6oz07-iQ99wixmX:22 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Apr 26, 2022 at 05:51:48PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Reverse mapping on a reflink-capable filesystem has some pretty high
> overhead when performing file operations.  This is because the rmap
> records for logically and physically adjacent extents might not be
> adjacent in the rmap index due to data block sharing.  As a result, we
> use expensive overlapped-interval btree search, which walks every record
> that overlaps with the supplied key in the hopes of finding the record.
> 
> However, profiling data shows that when the index contains a record that
> is an exact match for a query key, the non-overlapped btree search
> function can find the record much faster than the overlapped version.
> Try the non-overlapped lookup first when we're trying to find the left
> neighbor rmap record for a given file mapping, which makes unwritten
> extent conversion and remap operations run faster if data block sharing
> is minimal in this part of the filesystem.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>

Looks good now.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
