Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7FFE8C433EF
	for <linux-xfs@archiver.kernel.org>; Tue, 26 Apr 2022 04:29:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238178AbiDZEci (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 26 Apr 2022 00:32:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244116AbiDZEcf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 26 Apr 2022 00:32:35 -0400
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7BB2A60DA9
        for <linux-xfs@vger.kernel.org>; Mon, 25 Apr 2022 21:29:29 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-115-138.pa.nsw.optusnet.com.au [49.181.115.138])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 0F4345345E1;
        Tue, 26 Apr 2022 14:29:28 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1njCpL-004cf2-0S; Tue, 26 Apr 2022 14:29:27 +1000
Date:   Tue, 26 Apr 2022 14:29:27 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Eric Sandeen <sandeen@sandeen.net>,
        Catherine Hoang <catherine.hoang@oracle.com>,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH v1 0/2] xfs: remove quota warning limits
Message-ID: <20220426042927.GN1544202@dread.disaster.area>
References: <20220421165815.87837-1-catherine.hoang@oracle.com>
 <43e8df67-5916-5f4a-ce85-8521729acbb2@sandeen.net>
 <20220425222140.GI1544202@dread.disaster.area>
 <20220426024331.GR17025@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220426024331.GR17025@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=62677528
        a=/kVtbFzwtM2bJgxRVb+eeA==:117 a=/kVtbFzwtM2bJgxRVb+eeA==:17
        a=kj9zAlcOel0A:10 a=z0gMJWrwH1QA:10 a=7-415B0cAAAA:8
        a=KuIg5vS0DuhQU977sNcA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Apr 25, 2022 at 07:43:31PM -0700, Darrick J. Wong wrote:

[snip yukky stuff that makes Darrick's life hell :(]

> That attr fork UAF thing -- adding smp_wmb/rmb made the symptoms go
> away, but as I was writing up the commit message I realized that the
> race window is still there.  Maybe I'll come up with a way to make the
> incore attr fork stick around, though both attempts so far have exploded
> on impact.

Can you post the patch so I can have a look at it?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
