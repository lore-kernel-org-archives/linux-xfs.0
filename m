Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD35FC433EF
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Mar 2022 22:37:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238760AbiCIWiQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 9 Mar 2022 17:38:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238834AbiCIWiI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 9 Mar 2022 17:38:08 -0500
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 438DB1216AA
        for <linux-xfs@vger.kernel.org>; Wed,  9 Mar 2022 14:37:09 -0800 (PST)
Received: from dread.disaster.area (pa49-186-150-27.pa.vic.optusnet.com.au [49.186.150.27])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 45A4210E2B3D;
        Thu, 10 Mar 2022 09:37:08 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nS4vb-003Yaa-Ht; Thu, 10 Mar 2022 09:37:07 +1100
Date:   Thu, 10 Mar 2022 09:37:07 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     David Dal Ben <dalben@gmail.com>,
        Eric Sandeen <esandeen@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: Inconsistent "EXPERIMENTAL online shrink feature in use. Use at
 your own risk" alert
Message-ID: <20220309223707.GL661808@dread.disaster.area>
References: <YiYIO2lJf123LA2c@B-P7TQMD6M-0146.local>
 <CALwRca2bZD5tXmL5kzCdL97LpqWGVhYXMNSWSvqn=FkMuMrbjQ@mail.gmail.com>
 <9f957f7a-0f08-9cb4-d8ff-76440a488184@redhat.com>
 <CALwRca2Xdp8F_xjXSFXxO-Ra96W685o2qY1xoo=Ko9OWF4oRvw@mail.gmail.com>
 <20220307233132.GA661808@dread.disaster.area>
 <YiaajBcdSgOyIamT@B-P7TQMD6M-0146.local>
 <CALwRca0TqcKnBkLm=sOjQdvagBjd12m_7uYOhkMt8LjxsmiEtA@mail.gmail.com>
 <95ed03a8-e49b-d109-baba-86a190345102@sandeen.net>
 <20220309211904.GE661808@dread.disaster.area>
 <06ce8d7f-db56-d742-26d4-ced82185ab94@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <06ce8d7f-db56-d742-26d4-ced82185ab94@sandeen.net>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=VuxAv86n c=1 sm=1 tr=0 ts=62292c14
        a=sPqof0Mm7fxWrhYUF33ZaQ==:117 a=sPqof0Mm7fxWrhYUF33ZaQ==:17
        a=q2rpgJM3of3wzYv4:21 a=kj9zAlcOel0A:10 a=o8Y5sQTvuykA:10 a=7-415B0cAAAA:8
        a=JoelFCkZeuPD_wC6vb8A:9 a=CjuIK1q_8ugA:10 a=aujFQpqGlDxcc9pqpD-7:22
        a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Mar 09, 2022 at 04:18:54PM -0600, Eric Sandeen wrote:
> On 3/9/22 3:19 PM, Dave Chinner wrote:
> > On Wed, Mar 09, 2022 at 12:22:00PM -0600, Eric Sandeen wrote:
> 
> ...
> 
> >> I'm wondering if we have some path through xfs_growfs_data_private() that calculates
> >> a delta < 0 unintentionally, or if we get there with delta == 0 and generate the
> >> warning message.
> > 
> > Nope, we're not even getting there for the delta == 0 case...
> 
> Ok, thanks - I should have checked that.
> 
> Soooo how is a no-argument xfs_growfs, with size calculated by the tool based on the
> disk size, failing immediately after a mount? Makes no sense to me.

Remember, unraid is an out of tree MD block device driver, so
there's every chance that XFS is just the messenger telling us that
the device driver has bugs in it's size handling or
discovery/recovery/assembly behaviour. Until we get an actual
command line reproducer for this problem on an in-tree block device,
I would not spend any more time worrying about it.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
