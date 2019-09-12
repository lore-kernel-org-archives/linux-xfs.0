Return-Path: <SRS0=88Vy=XH=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C79E6C4CEC7
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Sep 2019 23:52:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A5AB620663
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Sep 2019 23:52:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726899AbfILXws (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 12 Sep 2019 19:52:48 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:48066 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726586AbfILXwr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 12 Sep 2019 19:52:47 -0400
Received: from dread.disaster.area (pa49-181-255-194.pa.nsw.optusnet.com.au [49.181.255.194])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 80C4A43E482;
        Fri, 13 Sep 2019 09:52:45 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.2)
        (envelope-from <david@fromorbit.com>)
        id 1i8YtI-0007x7-Az; Fri, 13 Sep 2019 09:52:44 +1000
Date:   Fri, 13 Sep 2019 09:52:44 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/4] xfs_spaceman: remove open-coded per-ag bulkstat
Message-ID: <20190912235244.GS16973@dread.disaster.area>
References: <156774093859.2644581.13218735172589605186.stgit@magnolia>
 <156774095455.2644581.13226600292393218725.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <156774095455.2644581.13226600292393218725.stgit@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=FNpr/6gs c=1 sm=1 tr=0
        a=YO9NNpcXwc8z/SaoS+iAiA==:117 a=YO9NNpcXwc8z/SaoS+iAiA==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=J70Eh1EUuV4A:10
        a=yPCof4ZbAAAA:8 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8 a=JuDxSlhT3OO6blO4plAA:9
        a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Sep 05, 2019 at 08:35:54PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Now that xfrog_bulkstat supports per-AG bulkstat, we can get rid of the
> open coded one in spaceman.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
