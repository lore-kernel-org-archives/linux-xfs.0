Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:59418 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727421AbfDLAWA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 11 Apr 2019 20:22:00 -0400
Date: Thu, 11 Apr 2019 17:21:52 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: =?utf-8?B?5Zue5aSN?= =?utf-8?Q?=3A?= [PATCH] xfs,fstrim: fix to
 return correct minlen
Message-ID: <20190412002152.GH1019523@magnolia>
References: <1554885748-7071-1-git-send-email-wshilong1991@gmail.com>
 <20190411015446.GC1019523@magnolia>
 <BYAPR19MB27582F4FC44A885242364A78D42F0@BYAPR19MB2758.namprd19.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BYAPR19MB27582F4FC44A885242364A78D42F0@BYAPR19MB2758.namprd19.prod.outlook.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Wang Shilong <wshilong@ddn.com>
Cc: Wang Shilong <wangshilong1991@gmail.com>, "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>

On Thu, Apr 11, 2019 at 02:05:08AM +0000, Wang Shilong wrote:
> Hi Darrick,
> 
> 
> On Wed, Apr 10, 2019 at 05:42:28PM +0900, Wang Shilong wrote:
> > From: Wang Shilong <wshilong@ddn.com>
> >
> > This patch tries to address two problems:
> >
> > 1) return @minlen we used to trim to
> > user space.
> >
> > 2) return EINVAL if granularity is larger than
> > avg size, even most of cases, granularity is small(4K),
> > but if devices return a lager granularity for some reaons
> > (testing, bugs etc), fstrim should return failure directly.
> 
> It really is a pity^W^Wannoying that there's no manual page for FITRIM,
> because I have no idea if this is the right or desired behavior for this
> ioctl.
> 
> Do the other filesystems update @minlen so that userspace knows the
> granularity?
> 
> --D
> 
> --------->
> As far as I checked ext4, f2fs, Btrfs did so,

Fair enough.

> I think it makes sense we return this value to userspace, we'd better
> to doc it somewhere 'man fstrim'?

Ok, please cc me when you send the documentation update.

--D

> thanks,
> Shilong
