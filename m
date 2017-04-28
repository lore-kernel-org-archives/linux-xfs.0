Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:51686 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1031192AbdD1U4g (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 28 Apr 2017 16:56:36 -0400
MIME-Version: 1.0
In-Reply-To: <CAF1ivSbjdixqDo663wvAEkzRk-ctOX+y5UYxq4UdPA-=JVufyw@mail.gmail.com>
References: <CAF1ivSZeYhnzh6CPZViYUNFXdm33hhTA_CzP7V745QociEEnKg@mail.gmail.com>
 <CAF1ivSbjdixqDo663wvAEkzRk-ctOX+y5UYxq4UdPA-=JVufyw@mail.gmail.com>
From: Ming Lin <mlin@kernel.org>
Date: Fri, 28 Apr 2017 13:56:30 -0700
Message-ID: <CAF1ivSbEfhTYxcBx1dafK9TD3VdeXbJrNMzWJmXY8kyU0ibkUw@mail.gmail.com>
Subject: Re: xlog_write: reservation ran out
Content-Type: text/plain; charset=UTF-8
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org, Ceph Development <ceph-devel@vger.kernel.org>, "LIU, Fei" <james.liu@alibaba-inc.com>, xiongwei.jiang@alibaba-inc.com, boqian.zy@alibaba-inc.com, sheng.qiu@alibaba-inc.com, Sage Weil <sweil@redhat.com>

On Fri, Apr 28, 2017 at 1:24 PM, Ming Lin <mlin@kernel.org> wrote:
> -  xfs@oss.sgi.com
> + linux-xfs@vger.kernel.org
>
> On Fri, Apr 28, 2017 at 1:15 PM, Ming Lin <mlin@kernel.org> wrote:
>> Hi Dave & Christoph,
>>
>> I run into below error during a pre-production ceph cluster test with
>> xfs backend.
>> Kernel version: CentOS 7.2 3.10.0-327.el7.x86_64
>>
>> [146702.392840] XFS (nvme9n1p1): xlog_write: reservation summary:
>>   trans type  = INACTIVE (3)
>>   unit res    = 83812 bytes
>>   current res = -9380 bytes
>>   total reg   = 0 bytes (o/flow = 0 bytes)
>>   ophdrs      = 0 (ophdr space = 0 bytes)
>>   ophdr + reg = 0 bytes
>>   num regions = 0
>> [146702.428729] XFS (nvme9n1p1): xlog_write: reservation ran out. Need
>> to up reservation
>> [146702.436917] XFS (nvme9n1p1): xfs_do_force_shutdown(0x2) called
>> from line 2070 of file fs/xfs/xfs_log.c.  Return address =
>> 0xffffffffa0651738
>> [146702.449969] XFS (nvme9n1p1): Log I/O Error Detected.  Shutting
>> down filesystem
>> [146702.457590] XFS (nvme9n1p1): Please umount the filesystem and
>> rectify the problem(s)
>> [146702.467903] XFS (nvme9n1p1): xfs_log_force: error -5 returned.
>> [146732.324308] XFS (nvme9n1p1): xfs_log_force: error -5 returned.
>> [146762.436923] XFS (nvme9n1p1): xfs_log_force: error -5 returned.
>> [146792.549545] XFS (nvme9n1p1): xfs_log_force: error -5 returned.
>>
>> Each XFS fs is 1.7T.
>> The cluster was written about 80% full then we delete the ceph rbd
>> image, which actually delete a lot of files in the backend xfs.
>>
>> I'm going to have a try below quick hack and see if it helps.
>>
>> diff --git a/fs/xfs/libxfs/xfs_trans_resv.c b/fs/xfs/libxfs/xfs_trans_resv.c
>> index 1b754cb..b2702f5 100644
>> --- a/fs/xfs/libxfs/xfs_trans_resv.c
>> +++ b/fs/xfs/libxfs/xfs_trans_resv.c
>> @@ -800,7 +800,7 @@ xfs_trans_resv_calc(
>>         resp->tr_link.tr_logcount = XFS_LINK_LOG_COUNT;
>>         resp->tr_link.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
>>
>> -       resp->tr_remove.tr_logres = xfs_calc_remove_reservation(mp);
>> +       resp->tr_remove.tr_logres = xfs_calc_remove_reservation(mp) * 2;
>>         resp->tr_remove.tr_logcount = XFS_REMOVE_LOG_COUNT;
>>         resp->tr_remove.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
>>

+ Sage

I'm new to xfs code.

Search  XFS_TRANS_INACTIVE and the usage is like below,

xfs_trans_alloc(mp, XFS_TRANS_INACTIVE);
xfs_trans_reserve(tp, &M_RES(mp)->tr_itruncate, 0, 0);

xfs_trans_alloc(mp, XFS_TRANS_INACTIVE);
xfs_trans_reserve(tp, &M_RES(mp)->tr_ifree, XFS_IFREE_SPACE_RES(mp), 0);

seems tr_remove is not related.
I'll just try to enlarge the reservation for tr_itruncate and tr_ifree.

diff --git a/fs/xfs/libxfs/xfs_trans_resv.c b/fs/xfs/libxfs/xfs_trans_resv.c
index 1b754cb..4087c39 100644
--- a/fs/xfs/libxfs/xfs_trans_resv.c
+++ b/fs/xfs/libxfs/xfs_trans_resv.c
@@ -788,7 +788,7 @@ xfs_trans_resv_calc(
        resp->tr_write.tr_logcount = XFS_WRITE_LOG_COUNT;
        resp->tr_write.tr_logflags |= XFS_TRANS_PERM_LOG_RES;

-       resp->tr_itruncate.tr_logres = xfs_calc_itruncate_reservation(mp);
+       resp->tr_itruncate.tr_logres = xfs_calc_itruncate_reservation(mp) * 2;
        resp->tr_itruncate.tr_logcount = XFS_ITRUNCATE_LOG_COUNT;
        resp->tr_itruncate.tr_logflags |= XFS_TRANS_PERM_LOG_RES;

@@ -821,7 +821,7 @@ xfs_trans_resv_calc(
        resp->tr_mkdir.tr_logcount = XFS_MKDIR_LOG_COUNT;
        resp->tr_mkdir.tr_logflags |= XFS_TRANS_PERM_LOG_RES;

-       resp->tr_ifree.tr_logres = xfs_calc_ifree_reservation(mp);
+       resp->tr_ifree.tr_logres = xfs_calc_ifree_reservation(mp) * 2;
        resp->tr_ifree.tr_logcount = XFS_INACTIVE_LOG_COUNT;
        resp->tr_ifree.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
