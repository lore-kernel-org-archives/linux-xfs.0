Return-Path: <SRS0=4PMG=ZG=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0FC9DC432C3
	for <linux-xfs@archiver.kernel.org>; Thu, 14 Nov 2019 22:21:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D9CF3206E6
	for <linux-xfs@archiver.kernel.org>; Thu, 14 Nov 2019 22:21:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726818AbfKNWVA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 14 Nov 2019 17:21:00 -0500
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:53896 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726613AbfKNWVA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 14 Nov 2019 17:21:00 -0500
Received: from dread.disaster.area (pa49-181-255-80.pa.nsw.optusnet.com.au [49.181.255.80])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 8F0613A16B5;
        Fri, 15 Nov 2019 09:20:56 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1iVNTy-0003tb-JA; Fri, 15 Nov 2019 09:20:54 +1100
Date:   Fri, 15 Nov 2019 09:20:54 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Pavel Reichl <preichl@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v4 3/5] xfs: remove the xfs_dq_logitem_t typedef
Message-ID: <20191114222054.GK4614@dread.disaster.area>
References: <20191112213310.212925-1-preichl@redhat.com>
 <20191112213310.212925-4-preichl@redhat.com>
 <20191114013049.GY4614@dread.disaster.area>
 <CAJc7PzUGiTSUTWGRMBSKfbgPjmGLs7GJM3RW3EhhZ5Sa2MjOYw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJc7PzUGiTSUTWGRMBSKfbgPjmGLs7GJM3RW3EhhZ5Sa2MjOYw@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=P6RKvmIu c=1 sm=1 tr=0
        a=XqaD5fcB6dAc7xyKljs8OA==:117 a=XqaD5fcB6dAc7xyKljs8OA==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=MeAgGD-zjQ4A:10
        a=7-415B0cAAAA:8 a=JuDxSlhT3OO6blO4plAA:9 a=CjuIK1q_8ugA:10
        a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Nov 14, 2019 at 06:30:25AM +0100, Pavel Reichl wrote:
> Yes Dave, but IIRC the patch failed to apply cleanly so I had to use
> the -3way option and I got the idea that me  merging code manually
> voids your ACK :-)

It depends. If the code itself is unchanged and it's just merge
noise, then updating doesn't invalidate the review. If you had to
change the code/logic because it no longer worked, then it's fair to
ask for it to be reviewed again. :)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
