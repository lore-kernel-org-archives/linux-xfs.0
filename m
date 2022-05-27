Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91123C433F5
	for <linux-xfs@archiver.kernel.org>; Fri, 27 May 2022 23:55:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355196AbiE0XzM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 27 May 2022 19:55:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244378AbiE0XzM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 27 May 2022 19:55:12 -0400
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 95E5B66AD2;
        Fri, 27 May 2022 16:55:11 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id CE065538A2A;
        Sat, 28 May 2022 09:55:10 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nujnR-00HD7K-5X; Sat, 28 May 2022 09:55:09 +1000
Date:   Sat, 28 May 2022 09:55:09 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        linux-block@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] f2fs: add sysfs entry to avoid FUA
Message-ID: <20220527235509.GW1098723@dread.disaster.area>
References: <20220527205955.3251982-1-jaegeuk@kernel.org>
 <YpFDw3mQjN1LBd2j@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YpFDw3mQjN1LBd2j@gmail.com>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=VuxAv86n c=1 sm=1 tr=0 ts=629164de
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=kj9zAlcOel0A:10 a=oZkIemNP1mAA:10 a=VwQbUJbxAAAA:8 a=7-415B0cAAAA:8
        a=SVjUjkoNg4n66X4JJ_kA:9 a=CjuIK1q_8ugA:10 a=AjGcO6oz07-iQ99wixmX:22
        a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, May 27, 2022 at 09:33:55PM +0000, Eric Biggers wrote:
> [+Cc linux-block for FUA, and linux-xfs for iomap]

linux-fsdevel should really be used for iomap stuff...

> 
> On Fri, May 27, 2022 at 01:59:55PM -0700, Jaegeuk Kim wrote:
> > Some UFS storage gives slower performance on FUA than write+cache_flush.
> > Let's give a way to manage it.
> > 
> > Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
> 
> Should the driver even be saying that it has FUA support in this case?  If the
> driver didn't claim FUA support, that would also solve this problem.

Agreed, this is a hardware problem that need to addressed with a
driver quirk to stop it advertising FUA support. The high level
fs/iomap code should always issue FUA writes where possible and
the lower layers tell the block layer whether to issue the FUA as
a FUA or write+cache flush pair.

And, quite frankly, exposing this sort of "hardware needs help" knob
as a sysfs variable is exactly the sort of thing we should never do.

Users have no idea how to tune stuff like this correctly (even if
they knew it existed!), yet we know exactly what hardware has this
problem and the kernel already has mechanisms that would allow it to
just Do The Right Thing. IOWs, we can fix this without the user even
having to know that they have garbage hardware that needs special
help....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
