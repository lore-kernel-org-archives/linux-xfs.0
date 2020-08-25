Return-Path: <SRS0=ldVD=CD=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60A6FC433DF
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Aug 2020 22:31:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3F92B206EB
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Aug 2020 22:31:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726303AbgHYWbR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 25 Aug 2020 18:31:17 -0400
Received: from mail109.syd.optusnet.com.au ([211.29.132.80]:34438 "EHLO
        mail109.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726466AbgHYWbR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Aug 2020 18:31:17 -0400
Received: from dread.disaster.area (pa49-181-146-199.pa.nsw.optusnet.com.au [49.181.146.199])
        by mail109.syd.optusnet.com.au (Postfix) with ESMTPS id 98DBDD7D4A7;
        Wed, 26 Aug 2020 08:31:11 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1kAhTC-0000VW-Dy; Wed, 26 Aug 2020 08:31:10 +1000
Date:   Wed, 26 Aug 2020 08:31:10 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Eric Sandeen <sandeen@sandeen.net>,
        Anthony Iliopoulos <ailiop@suse.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 0/6] xfsprogs: blockdev dax detection and warnings
Message-ID: <20200825223110.GQ12131@dread.disaster.area>
References: <20200824203724.13477-1-ailiop@suse.com>
 <20200824225533.GA12131@dread.disaster.area>
 <4aa834dd-5220-6312-e28f-1a94a56b1cc0@sandeen.net>
 <20200825144015.GB6096@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200825144015.GB6096@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=QKgWuTDL c=1 sm=1 tr=0 cx=a_idp_d
        a=GorAHYkI+xOargNMzM6qxQ==:117 a=GorAHYkI+xOargNMzM6qxQ==:17
        a=kj9zAlcOel0A:10 a=y4yBn9ojGxQA:10 a=7-415B0cAAAA:8
        a=tDArTbVnjOhj1pgSmKoA:9 a=iW2Ia2TNvcxNdp0J:21 a=GsDbAy2E_e3QRq6g:21
        a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Aug 25, 2020 at 07:40:15AM -0700, Darrick J. Wong wrote:
> Zooming out a bit, maybe we should instead introduce a new "tuning"
> parameter for -d and -r so that administrators could tune the filesystem
> for specific purposes:
> 
> 	-d tune=dax: Reject if device not dax, set daxinherit=1, set
> 	extsize/su/sw to match PMD
> 
> 	-d tune=ssd: Set agcount to match the number of CPUs if
> 	possible, make the log larger to support a large number of
> 	threads and iops.
> 
> 	-d tune=rotational: Probably does nothing. ;)
> 
> 	-d tune=auto: Query blkid to guess which of the above three
> 	profiles we should use.
> 
> 	-d tune=none: No tuning.
> 
> And then you'd do the same for the realtime device.

Please, no.

The problem with this is that a specific "tune" will need to vary
over time (e.g. when reflink is supported with DAX) and so now we
back to the same situation where the definition of "tune=dax"
changes depending on what version of mkfs you use. Hence you can
still make a filesystem that the kernel won't mount because you have
a xfsprogs that supports DAX+reflink and a kernel that doesn't.

I just don't see this as a viable way to produce filesystems that
work for specific situations because it doesn't solve the kernel vs
xfsprogs version support issue that requires tweaking mkfs
parameters manually to avoid...

> This would help us get rid of the seeeekret mkfs wrapper that we use to
> make it easier for our internal customers to use DAX since mkfs.xfs
> doesn't support config files.

Let's fix that, then. I've written a bunch of stuff in the past
couple of years that uses basic ini config files via a simple
library and it just works. If people are happy with ini format
config files via a library, then I'll just go do that, eh?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
