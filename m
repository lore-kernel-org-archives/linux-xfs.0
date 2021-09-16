Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1EF3DC433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Sep 2021 01:37:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0794B61165
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Sep 2021 01:37:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233615AbhIPBi3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 15 Sep 2021 21:38:29 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:60634 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232068AbhIPBi3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 15 Sep 2021 21:38:29 -0400
Received: from dread.disaster.area (pa49-195-238-16.pa.nsw.optusnet.com.au [49.195.238.16])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 3CD8F10506BB;
        Thu, 16 Sep 2021 11:37:08 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1mQgKp-00CyMC-7W; Thu, 16 Sep 2021 11:37:07 +1000
Date:   Thu, 16 Sep 2021 11:37:07 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 03/61] libfrog: create header file for mocked-up kernel
 data structures
Message-ID: <20210916013707.GQ2361455@dread.disaster.area>
References: <163174719429.350433.8562606396437219220.stgit@magnolia>
 <163174721123.350433.6338166230233894732.stgit@magnolia>
 <20210916004646.GO2361455@dread.disaster.area>
 <20210916005821.GC34899@magnolia>
 <20210916012916.GP2361455@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210916012916.GP2361455@dread.disaster.area>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=F8MpiZpN c=1 sm=1 tr=0
        a=DzKKRZjfViQTE5W6EVc0VA==:117 a=DzKKRZjfViQTE5W6EVc0VA==:17
        a=kj9zAlcOel0A:10 a=7QKq2e-ADPsA:10 a=7-415B0cAAAA:8
        a=I3Se4T2dm390UrnMgIAA:9 a=CjuIK1q_8ugA:10 a=igBNqPyMv6gA:10
        a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Sep 16, 2021 at 11:29:16AM +1000, Dave Chinner wrote:
> As it is, my longer term plan it to actually properly support things
> like spinlocks, atomics, rcu, etc in xfsprogs via pthread and
> liburcu wrappers defined in include/<foo.h> that are xfsprogs wide.
> At that point, the wrappers in libxfs/libxfs_priv.h then simply
> disappear.
> 
> I'd prefer we move towards proper support for these primitives
> rather than just rearranging how we mock them up...

Just dug some patches out of a series (not up to date so probably
won't apply, but...) so you can see what I'm suggesting. I'll post
them as a reply here...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
