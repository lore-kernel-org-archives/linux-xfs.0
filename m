Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id EED6A7FBA
	for <xfs@oss.sgi.com>; Thu,  7 Mar 2013 07:15:33 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id C774C30405F
	for <xfs@oss.sgi.com>; Thu,  7 Mar 2013 05:15:33 -0800 (PST)
Received: from mail-bk0-f54.google.com (mail-bk0-f54.google.com
	[209.85.214.54]) by cuda.sgi.com with ESMTP id ctrWvHOMsjDaGEU4
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 07 Mar 2013 05:15:32 -0800 (PST)
Received: by mail-bk0-f54.google.com with SMTP id w5so214206bku.13
	for <xfs@oss.sgi.com>; Thu, 07 Mar 2013 05:15:31 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <5137CD46.6070909@redhat.com>
References: <CAPcwv6wZJSBtgF-L6KNSn6N6Y+wUZJFXdbcg+zYRwoaB2sDdjw@mail.gmail.com>
	<20130306161519.2c28d911@galadriel.home>
	<CAPcwv6wqv0b_CPqDpBfOwVDg23uBi=tpGQSy9XuH2uWS5oVMWQ@mail.gmail.com>
	<20130306232100.6286f640@galadriel.home>
	<5137CD46.6070909@redhat.com>
Date: Thu, 7 Mar 2013 14:15:31 +0100
Message-ID: <CAPcwv6wK7m5UbJZass5690N5UpXEMV+HVzJa5mn9KWtT9UPQ9w@mail.gmail.com>
Subject: Re: XFS filesystem corruption
From: Julien FERRERO <jferrero06@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Ric Wheeler <rwheeler@redhat.com>
Cc: xfs@oss.sgi.com

> We actually test brutal "Power off" for xfs, ext4 and other file systems. If
> your storage is configured properly and you have barriers enabled, they all
> pass without corruption.
>
> What hardware raid cards can do is to hide a volatile write cache. Either on
> the raid HBA itself or, even worse, on the backend disks behind the card.
> S-ata disks tend to default to write cache enabled and need to be checked
> especially careful (sas drives tend to be write cache disabled by default).

Write cache is supposed to be disabled on the H/W RAID (according to
hdparm) and barrier are correctly enabled since xfs does not report
any warning at mount.

The odd thing is we never see this with kernel 2.6.18 where barriers
weren't yet available. An other difference is the "unwritten extend"
that was used to set to 0 by default. Now we cannot change this
setting according to an old thread I've found: "unwritten extents on
linux are generally a bad idea, this option should not be used.".
Unfortunately, the engineer that chose this setting is no longer
working with us...

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
