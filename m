Return-Path: <SRS0=dAFJ=7I=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 539ADC433E0
	for <linux-xfs@archiver.kernel.org>; Tue, 26 May 2020 22:16:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 32EB920870
	for <linux-xfs@archiver.kernel.org>; Tue, 26 May 2020 22:16:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390953AbgEZWQu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 26 May 2020 18:16:50 -0400
Received: from mail106.syd.optusnet.com.au ([211.29.132.42]:38995 "EHLO
        mail106.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389638AbgEZWQu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 26 May 2020 18:16:50 -0400
Received: from dread.disaster.area (pa49-195-157-175.pa.nsw.optusnet.com.au [49.195.157.175])
        by mail106.syd.optusnet.com.au (Postfix) with ESMTPS id 715E85AB177;
        Wed, 27 May 2020 08:16:47 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jdhsJ-0000dt-Uz; Wed, 27 May 2020 08:16:43 +1000
Date:   Wed, 27 May 2020 08:16:43 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     kbuild test robot <lkp@intel.com>
Cc:     kbuild-all@lists.01.org, linux-xfs@vger.kernel.org
Subject: Re: [dgc-xfs:xfs-async-inode-reclaim 28/30]
 fs/xfs/xfs_inode.c:3432:1: warning: no previous prototype for 'xfs_iflush'
Message-ID: <20200526221643.GZ2040@dread.disaster.area>
References: <202005261941.GNNi105g%lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202005261941.GNNi105g%lkp@intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=X6os11be c=1 sm=1 tr=0
        a=ONQRW0k9raierNYdzxQi9Q==:117 a=ONQRW0k9raierNYdzxQi9Q==:17
        a=kj9zAlcOel0A:10 a=sTwFKg_x9MkA:10 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8
        a=7-415B0cAAAA:8 a=HJ1Vpct1UyRcpP7KzgEA:9 a=CjuIK1q_8ugA:10
        a=AjGcO6oz07-iQ99wixmX:22 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, May 26, 2020 at 07:46:45PM +0800, kbuild test robot wrote:
> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/dgc/linux-xfs.git xfs-async-inode-reclaim

Hiya kbuild robot!

Can you drop all the list cc's from build failures for this repo?
Nobody but me really needs to see all the breakage in this tree...

> :::::: The code at line 3432 was first introduced by commit
> :::::: 30ebf34422da6206608b0c6fba84b424f174b8c5 xfs: rename xfs_iflush_int()
> 
> :::::: TO: Dave Chinner <dchinner@redhat.com>
> :::::: CC: Dave Chinner <david@fromorbit.com>

Also, I don't think this is doing what you expect, either, because
this build error was only sent to david@fromorbit.com and was not
CC'd to the author of the commit which is dchinner@redhat.com....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
