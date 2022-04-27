Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5563FC433F5
	for <linux-xfs@archiver.kernel.org>; Wed, 27 Apr 2022 01:27:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356654AbiD0Bav (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 26 Apr 2022 21:30:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240661AbiD0Bav (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 26 Apr 2022 21:30:51 -0400
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1C3E849F08
        for <linux-xfs@vger.kernel.org>; Tue, 26 Apr 2022 18:27:41 -0700 (PDT)
Received: from dread.disaster.area (pa49-195-62-197.pa.nsw.optusnet.com.au [49.195.62.197])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 27CCA536C3B;
        Wed, 27 Apr 2022 11:27:41 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1njWSx-004y9Y-J0; Wed, 27 Apr 2022 11:27:39 +1000
Date:   Wed, 27 Apr 2022 11:27:39 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/4] metadump: be careful zeroing corrupt inode forks
Message-ID: <20220427012739.GC1098723@dread.disaster.area>
References: <20220426234453.682296-1-david@fromorbit.com>
 <20220426234453.682296-3-david@fromorbit.com>
 <20220427004027.GX17025@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220427004027.GX17025@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=62689c0d
        a=KhGSFSjofVlN3/cgq4AT7A==:117 a=KhGSFSjofVlN3/cgq4AT7A==:17
        a=kj9zAlcOel0A:10 a=z0gMJWrwH1QA:10 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8
        a=7-415B0cAAAA:8 a=RnhrbhDYIGdK5DkWPgEA:9 a=CjuIK1q_8ugA:10
        a=AjGcO6oz07-iQ99wixmX:22 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Apr 26, 2022 at 05:40:27PM -0700, Darrick J. Wong wrote:
> On Wed, Apr 27, 2022 at 09:44:51AM +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > When a corrupt inode fork is encountered, we can zero beyond the end
> > of the inode if the fork pointers are sufficiently trashed. We
> > should not trust the fork pointers when corruption is detected and
> > skip the zeroing in this case. We want metadump to capture the
> > corruption and so skipping the zeroing will give us the best chance
> > of preserving the corruption in a meaningful state for diagnosis.
> > 
> > Reported-by: Sean Caron <scaron@umich.edu>
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> 
> Hmm.  I /think/ the only real change here is the addition of the
> DFORK_DSIZE > LITINO warning, right?  The rest is just reindenting the
> loop body?

Yes.

> If so, LGTM.
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>

Thanks!

-Dave.
-- 
Dave Chinner
david@fromorbit.com
