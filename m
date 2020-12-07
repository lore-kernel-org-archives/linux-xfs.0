Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46FB6C433FE
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Dec 2020 20:50:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 107E2238A0
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Dec 2020 20:50:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727470AbgLGUt7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 7 Dec 2020 15:49:59 -0500
Received: from mail109.syd.optusnet.com.au ([211.29.132.80]:57279 "EHLO
        mail109.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727416AbgLGUt7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 7 Dec 2020 15:49:59 -0500
X-Greylist: delayed 379 seconds by postgrey-1.27 at vger.kernel.org; Mon, 07 Dec 2020 15:49:57 EST
Received: from dread.disaster.area (pa49-179-6-140.pa.nsw.optusnet.com.au [49.179.6.140])
        by mail109.syd.optusnet.com.au (Postfix) with ESMTPS id 8289B6168E;
        Tue,  8 Dec 2020 07:49:16 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1kmNRb-001ZDp-P0; Tue, 08 Dec 2020 07:49:15 +1100
Date:   Tue, 8 Dec 2020 07:49:15 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Casey Schaufler <casey@schaufler-ca.com>,
        linux-xfs@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: Re: [PATCH] [RFC] xfs: initialise attr fork on inode create
Message-ID: <20201207204915.GV3913616@dread.disaster.area>
References: <20201202232724.1730114-1-david@fromorbit.com>
 <20201203084012.GA32480@infradead.org>
 <20201203214426.GE3913616@dread.disaster.area>
 <20201204075405.GA30060@infradead.org>
 <f39eb0d7-e437-5dae-303a-bae399e4bada@schaufler-ca.com>
 <20201207172545.GA20743@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201207172545.GA20743@infradead.org>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=F8MpiZpN c=1 sm=1 tr=0 cx=a_idp_d
        a=uDU3YIYVKEaHT0eX+MXYOQ==:117 a=uDU3YIYVKEaHT0eX+MXYOQ==:17
        a=kj9zAlcOel0A:10 a=zTNgK-yGK50A:10 a=7-415B0cAAAA:8
        a=JA0O7BOTeYuo50mApJEA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Dec 07, 2020 at 05:25:45PM +0000, Christoph Hellwig wrote:
> On Mon, Dec 07, 2020 at 09:22:13AM -0800, Casey Schaufler wrote:
> > Only security modules should ever look at what's in the security blob.
> > In fact, you can't assume that the presence of a security blob
> > (i.e. ...->s_security != NULL) implies "need_xattr", or any other
> > state for the superblock.
> 
> Maybe "strongly suggests that an xattr will be added" is the better
> wording.

Right, I did this knowing that only selinux and smack actually use
sb->s_security so it's not 100% reliable. However, these are also
the only two security modules that hook inode_init_security and
create xattrs.

So it seems like peeking at ->s_security here gives us a fairly
reliable indicator that we're going to have to create xattrs on this
new inode before we complete the create process...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
