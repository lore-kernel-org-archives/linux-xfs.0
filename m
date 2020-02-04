Return-Path: <SRS0=4Qc2=3Y=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F4157C35247
	for <linux-xfs@archiver.kernel.org>; Tue,  4 Feb 2020 00:28:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C47732087E
	for <linux-xfs@archiver.kernel.org>; Tue,  4 Feb 2020 00:28:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726474AbgBDA2f (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 3 Feb 2020 19:28:35 -0500
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:39894 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726369AbgBDA2f (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 3 Feb 2020 19:28:35 -0500
Received: from dread.disaster.area (pa49-181-161-120.pa.nsw.optusnet.com.au [49.181.161.120])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 12A9F3A2923;
        Tue,  4 Feb 2020 11:28:33 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1iym4t-0006yU-Ih; Tue, 04 Feb 2020 11:28:31 +1100
Date:   Tue, 4 Feb 2020 11:28:31 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Alan Latteri <alan@instinctualsoftware.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: su & sw for HW-RAID60
Message-ID: <20200204002831.GK20628@dread.disaster.area>
References: <2CE21042-5F18-4642-BF48-AF8416FB9199@instinctualsoftware.com>
 <20200203225914.GB20628@dread.disaster.area>
 <03E9DDCF-9395-4E8A-A228-E8E5B004B111@instinctualsoftware.com>
 <B41F5F0B-1A6F-4089-8AC3-F3A39830CDA7@instinctualsoftware.com>
 <20200203235501.GJ20628@dread.disaster.area>
 <9F0A2193-755E-4304-96EE-8F16FA7B0FBB@instinctualsoftware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9F0A2193-755E-4304-96EE-8F16FA7B0FBB@instinctualsoftware.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=LYdCFQXi c=1 sm=1 tr=0
        a=SkgQWeG3jiSQFIjTo4+liA==:117 a=SkgQWeG3jiSQFIjTo4+liA==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=l697ptgUJYAA:10
        a=7-415B0cAAAA:8 a=k9BHAetM4ShrMsW1Nj0A:9 a=CjuIK1q_8ugA:10
        a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Feb 03, 2020 at 04:08:16PM -0800, Alan Latteri wrote:
> You are correct.  There is an LVM layer on top made with the following commands:
> 
> pvcreate /dev/sda
> vgcreate chwumbo /dev/sda
> lvcreate -l 100%FREE -n data chwumbo 
> 
> Running mkfs.xfs against raw block device produces the following result.
> 
> mkfs.xfs -f -d su=2560k,sw=5 /dev/sda
> mkfs.xfs: Specified data stripe unit 5120 is not the same as the volume stripe unit 512
> mkfs.xfs: Specified data stripe width 25600 is not the same as the volume stripe width 512

Ok, so the device firmware is ... lacking in functionality. It's not
telling the OS it's layout information through the VPD inquiry page
that specified to provide this info to the OS. That's a vendor
issue, nothing we can do about it.

What it means, though, is that LVM doesn't know it's suppose to
align itself to the underlying device, and neither does mkfs.xfs.

So if you are going to use LVM, you need to configure it with the
correct physical layout information, and then it should export that
to the filesystem automatically. If you can't configure the LVM
layout exactly, then you'll have to ensure that the LVM devices
are correctly aligned yourself and then manually configure the
filesystem (as per above).

You may end up being better off exporting 5 RAID-6 luns from the
hardware RAID and then RAID-0 striping them in the OS using md, dm or
lvm...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
