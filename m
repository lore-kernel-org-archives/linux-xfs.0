Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 37B5C7F4E
	for <xfs@oss.sgi.com>; Wed, 30 Jan 2013 20:30:15 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id B76C4AC002
	for <xfs@oss.sgi.com>; Wed, 30 Jan 2013 18:30:14 -0800 (PST)
Received: from thunder.skymagik.net (thunder.skymagik.net [76.75.207.68]) by
	cuda.sgi.com with ESMTP id 2I8dZ6NUXosrxOMX for
	<xfs@oss.sgi.com>; Wed, 30 Jan 2013 18:30:10 -0800 (PST)
Message-ID: <45702.75.149.17.233.1359599410.squirrel@secure.skymagik.net>
Date: Wed, 30 Jan 2013 21:30:10 -0500 (EST)
Subject: Re: XFS appears to cause strange hang with md raid1 on reboot
From: "Tom" <storm9c1@skymagik.com>
In-Reply-To: <20130130234650.GE32297@disturbed.disaster>
References: <32271.192.104.24.222.1359415698.squirrel@secure.skymagik.net>
	<20130129151833.GF27055@sgi.com>
	<42720.75.149.17.233.1359515780.squirrel@secure.skymagik.net>
	<20130130234650.GE32297@disturbed.disaster>
MIME-Version: 1.0
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
To: xfs@oss.sgi.com

In a previous message, Dave Chinner wrote:
>
> And this says the filesystem is still mounted. Why?
>

Good question.

As mentioned in the CentOS bug report, this is a freshly Kickstarted
CentOS 5.9 system, staged with minimal packages.

I'm not running any third party daemons or anything like that.  I
could wipe the system and re-kickstart it again over and over, and
the problem will exist with 5.9 and the 348 kernel.  I can also repeat
this on any x86 based platform with nothing special, no hardware RAID
controllers, just generic SATA or SCSI disks.  Doesn't happen with any
previous CentOS kernels.

Also mentioned, if I take a 5.8 system, which is running correctly,
and upgrade the kernel from 308 to 348, the problem shows up with the
new kernel.  If I downgrade 5.9 to 308, the problem is resolved as well.
Also if I use ext3 with md raid1, there is no problem either.  That's
why in my mind, all roads lead to some interaction between XFS and md
raid.  Of course I could be off with that assessment.

My next email will contain the "sysrq t" output that Ben requested.

Thanks!

-- Tom



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
