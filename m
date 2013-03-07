Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 4E0577F5D
	for <xfs@oss.sgi.com>; Thu,  7 Mar 2013 07:40:44 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 26EB830405F
	for <xfs@oss.sgi.com>; Thu,  7 Mar 2013 05:40:43 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id Els2XKrerIClCMfm for
	<xfs@oss.sgi.com>; Thu, 07 Mar 2013 05:40:43 -0800 (PST)
Message-ID: <513898D4.6030502@redhat.com>
Date: Thu, 07 Mar 2013 08:40:36 -0500
From: Ric Wheeler <rwheeler@redhat.com>
MIME-Version: 1.0
Subject: Re: XFS filesystem corruption
References: <CAPcwv6wZJSBtgF-L6KNSn6N6Y+wUZJFXdbcg+zYRwoaB2sDdjw@mail.gmail.com>
	<20130306161519.2c28d911@galadriel.home>
	<CAPcwv6wqv0b_CPqDpBfOwVDg23uBi=tpGQSy9XuH2uWS5oVMWQ@mail.gmail.com>
	<20130306232100.6286f640@galadriel.home>
	<5137CD46.6070909@redhat.com>
	<CAPcwv6wK7m5UbJZass5690N5UpXEMV+HVzJa5mn9KWtT9UPQ9w@mail.gmail.com>
In-Reply-To: <CAPcwv6wK7m5UbJZass5690N5UpXEMV+HVzJa5mn9KWtT9UPQ9w@mail.gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Julien FERRERO <jferrero06@gmail.com>
Cc: xfs@oss.sgi.com

On 03/07/2013 08:15 AM, Julien FERRERO wrote:
>> We actually test brutal "Power off" for xfs, ext4 and other file systems. If
>> your storage is configured properly and you have barriers enabled, they all
>> pass without corruption.
>>
>> What hardware raid cards can do is to hide a volatile write cache. Either on
>> the raid HBA itself or, even worse, on the backend disks behind the card.
>> S-ata disks tend to default to write cache enabled and need to be checked
>> especially careful (sas drives tend to be write cache disabled by default).
> Write cache is supposed to be disabled on the H/W RAID (according to
> hdparm) and barrier are correctly enabled since xfs does not report
> any warning at mount.

hdparm shows you the devices that the card shows, not the state of the write 
cache on the drives behind them.

You need special vendor tools to do....

The LSI controllers for example have megaraid tools.

Until your IO stack is properly configured, you really don't need to worry about 
the file system options :)

ric

>
> The odd thing is we never see this with kernel 2.6.18 where barriers
> weren't yet available. An other difference is the "unwritten extend"
> that was used to set to 0 by default. Now we cannot change this
> setting according to an old thread I've found: "unwritten extents on
> linux are generally a bad idea, this option should not be used.".
> Unfortunately, the engineer that chose this setting is no longer
> working with us...

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
