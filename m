Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5C7BC43461
	for <linux-xfs@archiver.kernel.org>; Sat,  1 May 2021 22:07:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BA50861029
	for <linux-xfs@archiver.kernel.org>; Sat,  1 May 2021 22:07:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231266AbhEAWI1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 1 May 2021 18:08:27 -0400
Received: from mail110.syd.optusnet.com.au ([211.29.132.97]:50842 "EHLO
        mail110.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229912AbhEAWI1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 1 May 2021 18:08:27 -0400
Received: from dread.disaster.area (pa49-179-143-157.pa.nsw.optusnet.com.au [49.179.143.157])
        by mail110.syd.optusnet.com.au (Postfix) with ESMTPS id BEBC410C582;
        Sun,  2 May 2021 08:07:33 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lcxlr-00Gq2c-UV; Sun, 02 May 2021 08:07:32 +1000
Date:   Sun, 2 May 2021 08:07:31 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "EuroDomenii .Eu .Ro Accredited Registrar" <info@euro-domenii.eu>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: Roadmap for XFS Send/Receive
Message-ID: <20210501220731.GH63242@dread.disaster.area>
References: <CADw2znDxTQX4+GzrYqc6RefL5tcDwdKb0Ppyen8sFMn2fDr1zg@mail.gmail.com>
 <CADw2znDLs6_yky6EHoxmE2P7fRcjoKmYamWnNWj=V+9C_OyD6w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CADw2znDLs6_yky6EHoxmE2P7fRcjoKmYamWnNWj=V+9C_OyD6w@mail.gmail.com>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=F8MpiZpN c=1 sm=1 tr=0
        a=I9rzhn+0hBG9LkCzAun3+g==:117 a=I9rzhn+0hBG9LkCzAun3+g==:17
        a=kj9zAlcOel0A:10 a=5FLXtPjwQuUA:10 a=7-415B0cAAAA:8
        a=RlEFw-u51uJGMTri20UA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, May 01, 2021 at 03:32:52AM +0300, EuroDomenii .Eu .Ro Accredited Registrar wrote:
> Hello,
> 
> What is the roadmap for implementing  Send/Receive in XFS?  I'm
> talking about the send/receive feature between snapshots via ssh, from
> ZFS/BTRFS.

None really to speak of. XFS doesn't support snapshots and there's
no plan to do so any time soon...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
