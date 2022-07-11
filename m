Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29AEEC43334
	for <linux-xfs@archiver.kernel.org>; Mon, 11 Jul 2022 23:54:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229616AbiGKXyA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 11 Jul 2022 19:54:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229477AbiGKXx7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 11 Jul 2022 19:53:59 -0400
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 087792BB01
        for <linux-xfs@vger.kernel.org>; Mon, 11 Jul 2022 16:53:59 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 4A29D62C8CD;
        Tue, 12 Jul 2022 09:53:58 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1oB3Dx-00HODa-Lv; Tue, 12 Jul 2022 09:53:57 +1000
Date:   Tue, 12 Jul 2022 09:53:57 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/8] xfs: track log space pinned by the AIL
Message-ID: <20220711235357.GG3861211@dread.disaster.area>
References: <20220708015558.1134330-1-david@fromorbit.com>
 <20220708015558.1134330-6-david@fromorbit.com>
 <YsvJG8hnX/L6YMq8@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YsvJG8hnX/L6YMq8@infradead.org>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=VuxAv86n c=1 sm=1 tr=0 ts=62ccb816
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=kj9zAlcOel0A:10 a=RgO8CyIxsXoA:10 a=7-415B0cAAAA:8
        a=_s3VfvJXPF5cNFTmwgYA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Jul 10, 2022 at 11:54:19PM -0700, Christoph Hellwig wrote:
> Hmm.  How does a patch to just update the new field, but not actually
> use it make much sense?

It's the commit message that requires it to be a separate patch, not
the code. The commit message describes the architectural change that
the new grant head accounting is built on. While the code to
implement the accounting is simple, the reasons behind doing this
and how the new reservation accounting will work is anything but
simple.

IOWs, rather than try to explain all this in the already extremely
complex "use byte accounting for grant heads" changeover patch, I
separated this new accounting mechanism into it's own patch so it is
easier for people to understand how the log tail space is being
calculated and therefore determine if the mechanism is correct
without having to worry about it being hidden amongst all the other
changes that the grant head accounting require....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
