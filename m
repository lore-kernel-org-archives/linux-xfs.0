Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59157C433F5
	for <linux-xfs@archiver.kernel.org>; Thu, 10 Feb 2022 04:09:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230412AbiBJEJU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 9 Feb 2022 23:09:20 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:46178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233037AbiBJEJT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 9 Feb 2022 23:09:19 -0500
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B4B151EADF
        for <linux-xfs@vger.kernel.org>; Wed,  9 Feb 2022 20:09:20 -0800 (PST)
Received: from dread.disaster.area (pa49-180-69-7.pa.nsw.optusnet.com.au [49.180.69.7])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 8620652CDF8;
        Thu, 10 Feb 2022 15:09:18 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nI0lh-00AD2c-GS; Thu, 10 Feb 2022 15:09:17 +1100
Date:   Thu, 10 Feb 2022 15:09:17 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Paul E. McKenney" <paulmck@kernel.org>
Cc:     Brian Foster <bfoster@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>, linux-xfs@vger.kernel.org,
        Ian Kent <raven@themaw.net>, rcu@vger.kernel.org
Subject: Re: [PATCH] xfs: require an rcu grace period before inode recycle
Message-ID: <20220210040917.GN59729@dread.disaster.area>
References: <YfBBzHascwVnefYY@bfoster>
 <20220125224551.GQ59729@dread.disaster.area>
 <YfIdVq6R6xEWxy0K@zeniv-ca.linux.org.uk>
 <20220127052609.GR59729@dread.disaster.area>
 <YfLsBdPBSsyPFgHJ@bfoster>
 <20220128213911.GO4285@paulmck-ThinkPad-P17-Gen-1>
 <Yffioz+t9cjZbIBv@bfoster>
 <20220201220028.GH4285@paulmck-ThinkPad-P17-Gen-1>
 <YgEe21z+WUvpQa0N@bfoster>
 <20220207163621.GC4285@paulmck-ThinkPad-P17-Gen-1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220207163621.GC4285@paulmck-ThinkPad-P17-Gen-1>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=62048ff0
        a=NB+Ng1P8A7U24Uo7qoRq4Q==:117 a=NB+Ng1P8A7U24Uo7qoRq4Q==:17
        a=kj9zAlcOel0A:10 a=oGFeUVbbRNcA:10 a=7-415B0cAAAA:8
        a=C9m1K0M7fvvbcdc01KQA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Feb 07, 2022 at 08:36:21AM -0800, Paul E. McKenney wrote:
> On Mon, Feb 07, 2022 at 08:30:03AM -0500, Brian Foster wrote:
> Another approach is to use SLAB_TYPESAFE_BY_RCU.  This allows immediate
> reuse of freed memory, but also requires pointer traversals to the memory
> to do a revalidation operation.  (Sorry, no free lunch here!)

Can't do that with inodes - newly allocated/reused inodes have to go
through inode_init_always() which is the very function that causes
the problems we have now with path-walk tripping over inodes in an
intermediate re-initialised state because we recycled it inside a
RCU grace period.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
