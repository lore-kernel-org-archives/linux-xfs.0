Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A993C433EF
	for <linux-xfs@archiver.kernel.org>; Mon, 11 Apr 2022 02:10:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240428AbiDKCNG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 10 Apr 2022 22:13:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237639AbiDKCNF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 10 Apr 2022 22:13:05 -0400
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1AAADB865
        for <linux-xfs@vger.kernel.org>; Sun, 10 Apr 2022 19:10:53 -0700 (PDT)
Received: from dread.disaster.area (pa49-186-233-190.pa.vic.optusnet.com.au [49.186.233.190])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 2BB9A53C244;
        Mon, 11 Apr 2022 12:10:51 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1ndjVx-00GG8Y-J8; Mon, 11 Apr 2022 12:10:49 +1000
Date:   Mon, 11 Apr 2022 12:10:49 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: Use generic_file_open()
Message-ID: <20220411021049.GX1544202@dread.disaster.area>
References: <20220409155220.2573777-1-willy@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220409155220.2573777-1-willy@infradead.org>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=62538e2c
        a=bHAvQTfMiaNt/bo4vVGwyA==:117 a=bHAvQTfMiaNt/bo4vVGwyA==:17
        a=kj9zAlcOel0A:10 a=z0gMJWrwH1QA:10 a=JfrnYn6hAAAA:8 a=20KFwNOVAAAA:8
        a=7-415B0cAAAA:8 a=DqY4fqtjGcd0DDGzx8YA:9 a=CjuIK1q_8ugA:10
        a=1CNFftbPRP8L7MoqJWF3:22 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Apr 09, 2022 at 04:52:20PM +0100, Matthew Wilcox (Oracle) wrote:
> Remove the open-coded check of O_LARGEFILE.  This changes the errno
> to be the same as other filesystems; it was changed generically in
> 2.6.24 but that fix skipped XFS.
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>

Looks good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
