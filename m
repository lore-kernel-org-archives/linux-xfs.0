Return-Path: <SRS0=8CmW=W6=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63305C3A5A2
	for <linux-xfs@archiver.kernel.org>; Tue,  3 Sep 2019 22:53:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 357BF21883
	for <linux-xfs@archiver.kernel.org>; Tue,  3 Sep 2019 22:53:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726090AbfICWxs (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 3 Sep 2019 18:53:48 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:39733 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726009AbfICWxs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 3 Sep 2019 18:53:48 -0400
Received: from dread.disaster.area (pa49-181-255-194.pa.nsw.optusnet.com.au [49.181.255.194])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id D595243FC52;
        Wed,  4 Sep 2019 08:53:46 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92)
        (envelope-from <david@fromorbit.com>)
        id 1i5HgH-0004oq-Rq; Wed, 04 Sep 2019 08:53:45 +1000
Date:   Wed, 4 Sep 2019 08:53:45 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/9] libfrog: introduce xfs_fd to wrap an fd to a file on
 an xfs filesystem
Message-ID: <20190903225345.GW1119@dread.disaster.area>
References: <156713882070.386621.8501281965010809034.stgit@magnolia>
 <156713884740.386621.17037456340127194067.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <156713884740.386621.17037456340127194067.stgit@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=D+Q3ErZj c=1 sm=1 tr=0
        a=YO9NNpcXwc8z/SaoS+iAiA==:117 a=YO9NNpcXwc8z/SaoS+iAiA==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=J70Eh1EUuV4A:10
        a=yPCof4ZbAAAA:8 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8 a=zJl6l-YMHCcGJHEHl9oA:9
        a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Aug 29, 2019 at 09:20:47PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Introduce a new "xfs_fd" context structure where we can store a file
> descriptor and all the runtime fs context (geometry, which ioctls work,
> etc.) that goes with it.  We're going to create wrappers for the
> bulkstat and inumbers ioctls in subsequent patches; and when we
> introduce the v5 bulkstat/inumbers ioctls we'll need all that context to
> downgrade gracefully on old kernels.  Start the transition by adopting
> xfs_fd natively in scrub.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Definitely more readable than the previous version.:)

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
