Return-Path: <SRS0=NxuP=ZL=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A7C9C432C3
	for <linux-xfs@archiver.kernel.org>; Tue, 19 Nov 2019 20:25:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 29B722240E
	for <linux-xfs@archiver.kernel.org>; Tue, 19 Nov 2019 20:25:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726939AbfKSUZP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 19 Nov 2019 15:25:15 -0500
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:55115 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726711AbfKSUZP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 19 Nov 2019 15:25:15 -0500
Received: from dread.disaster.area (pa49-181-255-80.pa.nsw.optusnet.com.au [49.181.255.80])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 5D2D13A0A2D;
        Wed, 20 Nov 2019 07:25:12 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1iXA3j-0007Wa-LC; Wed, 20 Nov 2019 07:25:11 +1100
Date:   Wed, 20 Nov 2019 07:25:11 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Carlos Maiolino <cmaiolino@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: Forbid FIEMAP on RT devices
Message-ID: <20191119202511.GY4614@dread.disaster.area>
References: <20191119154453.312400-1-cmaiolino@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191119154453.312400-1-cmaiolino@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=D+Q3ErZj c=1 sm=1 tr=0
        a=XqaD5fcB6dAc7xyKljs8OA==:117 a=XqaD5fcB6dAc7xyKljs8OA==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=MeAgGD-zjQ4A:10
        a=7-415B0cAAAA:8 a=Vwfjni-8ZIzoL2IX15MA:9 a=CjuIK1q_8ugA:10
        a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Nov 19, 2019 at 04:44:53PM +0100, Carlos Maiolino wrote:
> By now, FIEMAP users have no way to identify which device contains the
> mapping being reported by the ioctl,

This is an incorrect assertion.

Users can call FS_IOC_FSGETXATTR and look at the FS_XFLAG_REALTIME
flag returned to determine what device the XFS data mapping points
at.

> so, let's forbid FIEMAP on RT
> devices/files until FIEMAP can properly report the device containing the
> returned mappings.

Also, fiemap on the attribute fork should work regardless of where
the data for the file is located.

So that's two reasons we shouldn't do this :P

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
