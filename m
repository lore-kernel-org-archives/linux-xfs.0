Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0851C433F5
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Mar 2022 02:19:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244331AbiCQCUY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 16 Mar 2022 22:20:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233729AbiCQCUY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 16 Mar 2022 22:20:24 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 627BB1BE92
        for <linux-xfs@vger.kernel.org>; Wed, 16 Mar 2022 19:19:09 -0700 (PDT)
Received: from dread.disaster.area (pa49-186-150-27.pa.vic.optusnet.com.au [49.186.150.27])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id DD3D710E48A5;
        Thu, 17 Mar 2022 13:19:07 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nUfjH-006NLU-80; Thu, 17 Mar 2022 13:19:07 +1100
Date:   Thu, 17 Mar 2022 13:19:07 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Brian Foster <bfoster@redhat.com>, xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: don't include bnobt blocks when reserving free
 block pool
Message-ID: <20220317021907.GW3927073@dread.disaster.area>
References: <20220314180847.GM8224@magnolia>
 <YjHJ0qOUnmAUEgoV@bfoster>
 <20220316163216.GU8224@magnolia>
 <YjIeXX6XeX36bmXx@bfoster>
 <20220316181726.GV8224@magnolia>
 <YjIxC5i/LQhA9lhW@bfoster>
 <YjI3x4Qp7bCwP1DS@bfoster>
 <20220316211526.GW8224@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220316211526.GW8224@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=deDjYVbe c=1 sm=1 tr=0 ts=62329a9c
        a=sPqof0Mm7fxWrhYUF33ZaQ==:117 a=sPqof0Mm7fxWrhYUF33ZaQ==:17
        a=kj9zAlcOel0A:10 a=o8Y5sQTvuykA:10 a=VwQbUJbxAAAA:8 a=7-415B0cAAAA:8
        a=lVvqVMhI5g-Tm_2J42YA:9 a=CjuIK1q_8ugA:10 a=AjGcO6oz07-iQ99wixmX:22
        a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Mar 16, 2022 at 02:15:26PM -0700, Darrick J. Wong wrote:
> Yeah, I at least like the idea of having a function that estimates how
> much free space we can try to reserve without using reserve pool blocks.
> I also am warming to the idea of telling users they can't have /any/ of
> those reserved blocks... particularly since I haven't even gotten to the
> "I fill my fs to 99% full and only then buy one more gigabyte of space,
> wash, rinse, repeat" complaints.

Go look at what I considered for the "thinp aware" filesystems a few
years ago:

https://lore.kernel.org/linux-xfs/20171026083322.20428-1-david@fromorbit.com/

The available space the filesystem presented to the user is
completely divorced from the physical device block count and
internal filesystem metadata space usage. Users simply didn't see
any of the space we reserved for metadata as space they could
allocate. i.e. it split the superblock sb_dblocks value away from
the number of data blocks we present to the user that they can
allocate as user data.

(https://lore.kernel.org/linux-xfs/20171026083322.20428-10-david@fromorbit.com/)

So, yeah, moving towards a model that essentially hides all the
reserved space from users and only presenting them with the amount
of space that is available without dipping into any reserves would
make things an awful lot simpler from an architectural POV...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
