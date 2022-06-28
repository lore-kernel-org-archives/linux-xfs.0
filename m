Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C62D3C43334
	for <linux-xfs@archiver.kernel.org>; Tue, 28 Jun 2022 22:44:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229535AbiF1Wo5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 28 Jun 2022 18:44:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbiF1Wo4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 28 Jun 2022 18:44:56 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D3B0227CF6
        for <linux-xfs@vger.kernel.org>; Tue, 28 Jun 2022 15:44:55 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 08AC010E7829;
        Wed, 29 Jun 2022 08:44:54 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1o6Jwz-00CF6v-5M; Wed, 29 Jun 2022 08:44:53 +1000
Date:   Wed, 29 Jun 2022 08:44:53 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Ayushman Dutta <ayushman999@gmail.com>, chandanrlinux@gmail.com,
        linux-xfs <linux-xfs@vger.kernel.org>
Subject: Re: syzkaller@googlegroups.com
Message-ID: <20220628224453.GL227878@dread.disaster.area>
References: <CA+6OtaVMKW=K2mfbi=3A7fuPw2BmHv-zcx2jVKg9yEEY4wab3g@mail.gmail.com>
 <Yrt7t2Y1tsgAUFAr@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yrt7t2Y1tsgAUFAr@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=VuxAv86n c=1 sm=1 tr=0 ts=62bb8467
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=4RBUngkUAAAA:8 a=kj9zAlcOel0A:10 a=iWYZZVQfT40A:10 a=JPEYwPQDsx4A:10
        a=7-415B0cAAAA:8 a=YJYnwHNeAZZscAt-6PAA:9 a=CjuIK1q_8ugA:10
        a=_sbA2Q-Kp09kWB8D3iXc:22 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jun 28, 2022 at 03:07:51PM -0700, Darrick J. Wong wrote:
> [+linux-xfs]
> 
> On Tue, Jun 28, 2022 at 02:27:36PM -0500, Ayushman Dutta wrote:
> > Kernel Version: 5.10.122
> > 
> > Kernel revision: 58a0d94cb56fe0982aa1ce9712e8107d3a2257fe
> > 
> > Syzkaller Dashboard report:
> > 
> > ------------[ cut here ]------------
> > WARNING: CPU: 1 PID: 8503 at mm/util.c:618 kvmalloc_node+0x15a/0x170
> > mm/util.c:618
> 
> No.  Do not DM your syzbot reports to random XFS developers.
> 
> Especially do not send me *three message* with 300K of attachments; even
> the regular syzbot runners dump all that stuff into a web portal.
> 
> If you are going to run some scripted tool to randomly
> corrupt the filesystem to find failures, then you have an
> ethical and moral responsibility to do some of the work to
> narrow down and identify the cause of the failure, not just
> throw them at someone else to do all the work.

/me reads the stack trace, takes 30s to look at the change log,
finds commit 29d650f7e3ab ("xfs: reject crazy array sizes being fed
to XFS_IOC_GETBMAP*").

-Dave.
-- 
Dave Chinner
david@fromorbit.com
