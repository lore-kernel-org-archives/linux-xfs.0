Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 948A1C433F5
	for <linux-xfs@archiver.kernel.org>; Tue, 12 Apr 2022 05:04:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237550AbiDLFGm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 12 Apr 2022 01:06:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231319AbiDLFGk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 12 Apr 2022 01:06:40 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 083B3DF93
        for <linux-xfs@vger.kernel.org>; Mon, 11 Apr 2022 22:04:23 -0700 (PDT)
Received: from dread.disaster.area (pa49-186-233-190.pa.vic.optusnet.com.au [49.186.233.190])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 1B0F410C7BAC;
        Tue, 12 Apr 2022 15:04:22 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1ne8hQ-00Ghie-Js; Tue, 12 Apr 2022 15:04:20 +1000
Date:   Tue, 12 Apr 2022 15:04:20 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org, allison.henderson@oracle.com
Subject: Re: [PATCH 00/10] xfs: LARP - clean up xfs_attr_set_iter state
 machine
Message-ID: <20220412050420.GD1544202@dread.disaster.area>
References: <20220412042543.2234866-1-david@fromorbit.com>
 <YlUEhMlr5g7uirBW@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YlUEhMlr5g7uirBW@infradead.org>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=62550856
        a=bHAvQTfMiaNt/bo4vVGwyA==:117 a=bHAvQTfMiaNt/bo4vVGwyA==:17
        a=kj9zAlcOel0A:10 a=z0gMJWrwH1QA:10 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8
        a=7-415B0cAAAA:8 a=8AM28QXGh2fuSL6DJA8A:9 a=CjuIK1q_8ugA:10
        a=AjGcO6oz07-iQ99wixmX:22 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Apr 11, 2022 at 09:48:04PM -0700, Christoph Hellwig wrote:
> On Tue, Apr 12, 2022 at 02:25:33PM +1000, Dave Chinner wrote:
> > Hi Allison,
> > 
> > This is first patchset for fixing up stuff in the LARP code. I've
> > based this on my current 5.19-compose branch here:
> 
> What is "LARP"?

Logged Attribute RePlay.

https://lore.kernel.org/linux-xfs/20220323210715.201009-1-allison.henderson@oracle.com/

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
