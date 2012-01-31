Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0V54W4j211356 for <xfs@oss.sgi.com>; Mon, 30 Jan 2012 23:04:32 -0600
Received: from mail-ww0-f51.google.com (mail-ww0-f51.google.com
	[74.125.82.51]) by cuda.sgi.com with ESMTP id U3HMl8DxwqQ5o3ai
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 30 Jan 2012 21:04:31 -0800 (PST)
Received: by wgbdy1 with SMTP id dy1so4153651wgb.32
	for <xfs@oss.sgi.com>; Mon, 30 Jan 2012 21:04:30 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20120131013124.GE9090@dastard>
References: <CANs4eSBWLc4HxAbPZ8kOVOdJ7RKiA+-ai3Q2J+FAyuzHtUqfdg@mail.gmail.com>
	<20120131013124.GE9090@dastard>
From: Supratik Goswami <supratiksekhar@gmail.com>
Date: Tue, 31 Jan 2012 10:34:10 +0530
Message-ID: <CANs4eSBgmvJCR7vfFa1W5h8tUYFQi=LRPWDPQ1exB29D1o_RjA@mail.gmail.com>
Subject: Re: File system remain unresponsive until the system is rebooted.
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

We are using Amazon EC2 instances.

ubuntu@ip-10-0-0-10:~$ uname -aLinux ip-10-0-0-10 2.6.32-318-ec2
#38-Ubuntu SMP Thu Sep 1 18:09:30 UTC 2011 x86_64 GNU/Linux
On Tue, Jan 31, 2012 at 7:01 AM, Dave Chinner <david@fromorbit.com> wrote:
> On Mon, Jan 30, 2012 at 02:48:58PM +0530, Supratik Goswami wrote:
>> Hi
>>
>> We are using RAID-0 volumes as PV's in our LVM stack and XFS as the filesystem.
>>
>> The kernel logged the below call trace when the filesystem was being
>> expanded using "xfs_growfs" command.
>> We have used xfs_grofs at least 3 times earlier but did not cam across
>> this situation.
>>
>> The files system remained unresponsive until we rebooted the system
>> and again increased the size of the filesystem.
>> This time it worked fine. Can you please tell us why xfs_grofs hanged suddenly ?
>
> What kernel?
>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com



-- 
Warm Regards

Supratik

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
