Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o9PBG9O7225271 for <xfs@oss.sgi.com>; Mon, 25 Oct 2010 06:16:09 -0500
Received: from mail.sotech1.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 83A2D1218F0
	for <xfs@oss.sgi.com>; Mon, 25 Oct 2010 04:17:25 -0700 (PDT)
Received: from mail.sotech1.com (sl-speci32-137461-0.sprintlink.net
	[144.232.190.126]) by cuda.sgi.com with ESMTP id
	MPtfPYbEMBoQjJDz for <xfs@oss.sgi.com>;
	Mon, 25 Oct 2010 04:17:25 -0700 (PDT)
From: Andrew Debenham <adebenham@sotech1.com>
Date: Mon, 25 Oct 2010 07:17:24 -0400
Subject: Re: XFS Test Results Interpretation 
Message-ID: <3C5E029826A0704DB5998577FCFF46F0095A278CEB@dagobah>
Content-Language: en-US
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

Stan -

Thank you for your response and I apologize if my initial explanation wasn't clear.  The applications will be running on identical hardware (see specs. below) but each application will be running on a dedicated system.  My original spreadsheet had this information but it obviously didn't come through correctly.  I would like to tune the XFS file systems to accommodate the two different applications.  As I mentioned before, I experimented with various parameters (e.g. sunit, swidth, log size, etc.) and different mounting options (e.g. logbufs, logbsize, etc.), but it sounds like I may have been wasting my time attempting to benchmark the file systems.  Any information or recommendations you can provide would be greatly appreciated.  Also, can you recommend a tool that would be good for benchmarking an XFS file system (if one exists)?  Thanks again!

- Andy


System Specs
-----------------
Motherboard:  Supermicro X8DTU
Chipset:  Intel 5520 (Tylersburg)
Processors:  Dual Intel Xeon E5540 @2.53GHz
RAM:  32GB PC3-8500 1066MHz
OS:  CentOS 5.3
Kernel:  2.6.18-128.el5
RAID Controller:  3ware 9650SE-12M
Disk Type:  SATA
Disk Size:  1.82 TB
RAID Level:  6
# of disks:  11
Stripe Size:  256 KB
File System Size:  16.37 TB
XFS Info:  kmod-xfs-0.4-2, xfsprogs-2.9.4-1.el5.centos



> ----------------------------------------------------------------------
> Message: 1
> Date: Sat, 23 Oct 2010 22:38:25 -0500
> From: Stan Hoeppner <stan@hardwarefreak.com>
> Subject: Re: XFS Test Results Interpretation
> To: xfs@oss.sgi.com
> Message-ID: <4CC3AA31.2000101@hardwarefreak.com>
> Content-Type: text/plain; charset=ISO-8859-1

> Andrew Debenham put forth on 10/23/2010 9:59 PM:
> > I am in the process of trying to determine the best parameters to use when creating and mounting an XFS file system on some new hardware we are going to be using.  My company has two separate applications that will
> > be running on the same hardware (but on separate systems).  One application is the PostgreSQL database and the other is a custom application that does writes to many (~1,000) relatively small (~672MB) files
>> concurrently.

> Post the detailed hardware specs (server, local RAID or SAN, number of disks in stripe set, RAID level, etc), and if both applications are running on the same physical machine or different machines.  Are both apps writing to > the same XFS filesystem or two different filesystems?
> Your description of "what is where" was very confusing.

> Oh, and Bonnie++ test results are usually useless, as well as IOZone, etc.  Next time ask before taking the time to run benchmarks and jump through hoops to get the data onto the list. :)

> -- Stan


This email and any attachments may be confidential and are intended solely for the use of the individual to whom it is addressed.

If you are not the intended recipient of this email, the following stipulations govern the use of this information:  You may not take any action based upon its contents.  You may not copy or show this message or attachments to anyone. You should contact the sender and subsequently delete this message and all attachments.

Any views or opinions expressed are solely those of the author and do not necessarily represent those of Special Operations Technology, Incorporated.

While antivirus software has been applied, you should perform due diligence to check this email and attachments for the presence of viruses.  No warranties or assurances are made in relation to the safety and content of this email and attachments.  Special Operations Technology, Incorporated accepts no liability for any damages caused by any virus transmitted by or contained in this email and attachments.

No liability is accepted for any consequences arising from this email transmission whatsoever.

Special Operations Technology, Incorporated is a premier IT professional services firm focused in the government and law enforcement space.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
