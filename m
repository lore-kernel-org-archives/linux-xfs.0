Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61135C433EF
	for <linux-xfs@archiver.kernel.org>; Fri,  1 Apr 2022 20:32:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236380AbiDAUe0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 1 Apr 2022 16:34:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233141AbiDAUe0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 1 Apr 2022 16:34:26 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7A1BE10CF25
        for <linux-xfs@vger.kernel.org>; Fri,  1 Apr 2022 13:32:36 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-43-123.pa.nsw.optusnet.com.au [49.180.43.123])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 0C0F410E5938;
        Sat,  2 Apr 2022 07:32:33 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1naNwd-00CcKL-Ql; Sat, 02 Apr 2022 07:32:31 +1100
Date:   Sat, 2 Apr 2022 07:32:31 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/8] xfs: log shutdown triggers should only shut down the
 log
Message-ID: <20220401203231.GK1544202@dread.disaster.area>
References: <20220330011048.1311625-1-david@fromorbit.com>
 <20220330011048.1311625-5-david@fromorbit.com>
 <YkbpigVBgtcn3YkX@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YkbpigVBgtcn3YkX@infradead.org>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=62476162
        a=MV6E7+DvwtTitA3W+3A2Lw==:117 a=MV6E7+DvwtTitA3W+3A2Lw==:17
        a=kj9zAlcOel0A:10 a=z0gMJWrwH1QA:10 a=7-415B0cAAAA:8
        a=DH1ijS-HWXnDD3M_UfcA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Apr 01, 2022 at 05:01:14AM -0700, Christoph Hellwig wrote:
> >  	if (XFS_TEST_ERROR(error, log->l_mp, XFS_ERRTAG_IODONE_IOERR)) {
> >  		xfs_alert(log->l_mp, "log I/O error %d", error);
> > -		xfs_force_shutdown(log->l_mp, SHUTDOWN_LOG_IO_ERROR);
> > +		xlog_force_shutdown(log, SHUTDOWN_LOG_IO_ERROR);
> 
> The SHUTDOWN_LOG_IO_ERROR as an API to xlog_force_shutdown looks
> really weird now.  It s only used to do the xfs_log_force at the
> very beginning of the function.  I'd suggest to drop the argument
> and just do that manually in the two callers that do not have
> SHUTDOWN_LOG_IO_ERROR set unconditionally.  (This is a perfectly
> fine follow on patch, though).

Yeah, I noticed that as well, but deceided not to do anything about
it as it wasn't directly related to fixing the bugs that I was
tripping over. I think there's a few other cleanups w.r.t. shutdown
error types that can be made, too - I'll get to them when I'm stuck
on hard stuff and need to do somethign realtively easy to keep
things moving...

> Otherwise looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Thanks!

-Dave.
-- 
Dave Chinner
david@fromorbit.com
