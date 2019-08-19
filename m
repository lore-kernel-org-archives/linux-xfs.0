Return-Path: <SRS0=Z/aa=WP=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0037AC3A59B
	for <linux-xfs@archiver.kernel.org>; Mon, 19 Aug 2019 04:16:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BFE1F2146E
	for <linux-xfs@archiver.kernel.org>; Mon, 19 Aug 2019 04:16:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726149AbfHSEQ4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 19 Aug 2019 00:16:56 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:60425 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725946AbfHSEQ4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 19 Aug 2019 00:16:56 -0400
Received: from dread.disaster.area (pa49-195-190-67.pa.nsw.optusnet.com.au [49.195.190.67])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 7298043CE46;
        Mon, 19 Aug 2019 14:16:53 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92)
        (envelope-from <david@fromorbit.com>)
        id 1hzZ58-00024w-1f; Mon, 19 Aug 2019 14:15:46 +1000
Date:   Mon, 19 Aug 2019 14:15:46 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "hch@lst.de" <hch@lst.de>
Cc:     "Verma, Vishal L" <vishal.l.verma@intel.com>,
        "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "darrick.wong@oracle.com" <darrick.wong@oracle.com>
Subject: Re: 5.3-rc1 regression with XFS log recovery
Message-ID: <20190819041546.GY6129@dread.disaster.area>
References: <e49a6a3a244db055995769eb844c281f93e50ab9.camel@intel.com>
 <20190818071128.GA17286@lst.de>
 <20190818074140.GA18648@lst.de>
 <20190818173426.GA32311@lst.de>
 <20190819000831.GX6129@dread.disaster.area>
 <20190819034948.GA14261@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190819034948.GA14261@lst.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=P6RKvmIu c=1 sm=1 tr=0
        a=TR82T6zjGmBjdfWdGgpkDw==:117 a=TR82T6zjGmBjdfWdGgpkDw==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=FmdZ9Uzk2mMA:10
        a=7-415B0cAAAA:8 a=sj5Ut0oYOAz_IFZk6OgA:9 a=CjuIK1q_8ugA:10
        a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Aug 19, 2019 at 05:49:48AM +0200, hch@lst.de wrote:
> On Mon, Aug 19, 2019 at 10:08:31AM +1000, Dave Chinner wrote:
> > > So I can also reproduce the same issue with the ramdisk driver, but not
> > > with any other 4k sector size device (nvmet, scsi target, scsi_debug,
> > > loop).
> > 
> > How did you reproduce it? I tried with indentical pmem config to
> > what Vishal was using and couldn't hit it...
> 
> Just mkfs and mount the pmem device.

Ran that in a loop overnight, no failures.

> The fake pmem was create by the following kernel command line sniplet:
> "memmap=2000M!1024M,2000M!4096M" and my kernel config is attached.  I

Very similar to what I'm using, just 2x8GB pmem instead of the
smaller 1/4GB pair you are using. I even tried manually making it
smaller w/ -d size= and changing log sizes, etc. I tried squeezing
down memory to only 256MB unused (via mlock) but that didn't seem to
change anything, either...

> suspect you'll need CONFIG_SLUB to create the woes, but let me confirm
> that..

Yup, that's what I have configured in my kernel, too.

It's still a mystery to me why I'm not able to reproduce it
easily. If it was just pmem, then I should have found it back when I
tripped over the chaining bug, because the two VMs I were running
testing on at the time were an iscsi test rig and an pmem test rig.
The iscsi one tripped over the chaining bug, the pmem one has had no
problems....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
