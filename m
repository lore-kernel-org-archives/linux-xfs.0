Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q170XoOM178265 for <xfs@oss.sgi.com>; Mon, 6 Feb 2012 18:33:50 -0600
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id ACgWIsMqtaxPGOOX
	for <xfs@oss.sgi.com>; Sun, 05 Feb 2012 19:29:37 -0800 (PST)
Received: from [192.168.100.53] (gffx.hardwarefreak.com [192.168.100.53])
	by greer.hardwarefreak.com (Postfix) with ESMTP id 28B646C058
	for <xfs@oss.sgi.com>; Sun,  5 Feb 2012 21:29:37 -0600 (CST)
Message-ID: <4F2F4925.5020406@hardwarefreak.com>
Date: Sun, 05 Feb 2012 21:29:41 -0600
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: Placing the root partition on an XFS filesystem is not supported
References: <loom.20120129T133929-288@post.gmane.org>
	<4F2B02C4.8070903@sandeen.net>
	<loom.20120203T152753-631@post.gmane.org>
	<4F2C2C69.5020103@sandeen.net> <20120206001123.GJ6922@dastard>
	<4F2F1B28.3060308@sandeen.net> <20120206015430.GK6922@dastard>
	<4F2F33A8.1050403@sandeen.net>
In-Reply-To: <4F2F33A8.1050403@sandeen.net>
Reply-To: stan@hardwarefreak.com
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
To: xfs@oss.sgi.com

On 2/5/2012 7:58 PM, Eric Sandeen wrote:
> On 2/5/12 7:54 PM, Dave Chinner wrote:

>> Oh, grub2 does worse things than that - grub_probe mounts any device
>> that appears to have a valid superblock so it can find out what
>> devices it needs to list in it's boot menu. I found this out when I
>> built a big DM stripe out of disks that used to have filesystems on
>> them.  grub-probe mounted every single device -inside- the stripe
>> and ran log recovery on them, corrupting the new filesystem and
>> quite a bit of data on the DM stripe they were part of....
> 
> Ok, your horror story wins from a pain POV ;)

What's the default bootloader of RHEL/Fedora?  I'm not asking
rhetorically.  I've never used either, and I'm curios if Red Hat went
the grub/grub2 route like SuSE and many/most other distros.

I use strictly Debian/LILO myself.  I was quite relieved when they
decided not to throw LILO out of the distro.  Apparently it had been
abandoned upstream.  Luckily another dev took ownership at the last minute.

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
