Return-Path: <SRS0=udUw=ZN=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F021CC432C0
	for <linux-xfs@archiver.kernel.org>; Thu, 21 Nov 2019 06:50:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C52BE20898
	for <linux-xfs@archiver.kernel.org>; Thu, 21 Nov 2019 06:50:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726170AbfKUGui (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 21 Nov 2019 01:50:38 -0500
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:35323 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726165AbfKUGui (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 21 Nov 2019 01:50:38 -0500
Received: from dread.disaster.area (pa49-181-174-87.pa.nsw.optusnet.com.au [49.181.174.87])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 8E39143FBC5;
        Thu, 21 Nov 2019 17:50:34 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1iXgIT-0006Xc-FC; Thu, 21 Nov 2019 17:50:33 +1100
Date:   Thu, 21 Nov 2019 17:50:33 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH V2] xfs: properly serialise fallocate against AIO+DIO
Message-ID: <20191121065033.GF4614@dread.disaster.area>
References: <20191029223752.28562-1-david@fromorbit.com>
 <20191120023821.GH6219@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191120023821.GH6219@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=P6RKvmIu c=1 sm=1 tr=0
        a=3v0Do7u/0+cnL2zxahI5mg==:117 a=3v0Do7u/0+cnL2zxahI5mg==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=MeAgGD-zjQ4A:10
        a=7-415B0cAAAA:8 a=NyTJ_P1X4VdJ6VOTK_wA:9 a=CjuIK1q_8ugA:10
        a=n3xvM8a_0i4A:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Nov 19, 2019 at 06:38:21PM -0800, Darrick J. Wong wrote:
> Hmm, do you think this is a reasonable backport of this patch for
> pre-5.5?

Seems reasonable to me.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
