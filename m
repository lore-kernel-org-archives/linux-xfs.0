Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:37956 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726194AbeKGQRG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 7 Nov 2018 11:17:06 -0500
Date: Wed, 7 Nov 2018 17:48:04 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 0/7] xfs_repair: scale to 150,000 iops
Message-ID: <20181107064804.GW19305@dastard>
References: <20181030112043.6034-1-david@fromorbit.com>
 <d025a410-bd8d-03c7-e738-5da019dfe818@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <d025a410-bd8d-03c7-e738-5da019dfe818@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Arkadiusz =?utf-8?Q?Mi=C5=9Bkiewicz?= <a.miskiewicz@gmail.com>
Cc: linux-xfs@vger.kernel.org

On Wed, Nov 07, 2018 at 06:44:54AM +0100, Arkadiusz Miśkiewicz wrote:
> On 30/10/2018 12:20, Dave Chinner wrote:
> > Hi folks,
> > 
> > This patchset enables me to successfully repair a rather large
> > metadump image (~500GB of metadata) that was provided to us because
> > it crashed xfs_repair. Darrick and Eric have already posted patches
> > to fix the crash bugs, and this series is built on top of them.
> 
> I was finally able to repair my big fs using for-next + these patches.
> 
> But it wasn't as easy as just running repair.
> 
> With default bhash OOM killed repair in ~1/3 of phase6 (128GB of ram +
> 50GB of ssd swap). bhash=256000 worked.

Yup, we need to work on the default bhash sizing. it comes out at
about 750,000 for 128GB ram on your fs. It needs to be much smaller.

> Sometimes segfault happens but I don't have any stack trace
> unfortunately and trying to reproduce on my other test machine
> gave me no luck.
> 
> One time I got:
> xfs_repair: workqueue.c:142: workqueue_add: Assertion `wq->item_count ==
> 0' failed.

Yup, I think i've fixed that - a throttling wakeup related race
condition - but I'm still trying to reproduce it to confirm I've
fixed it...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
