Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id D59817F53
	for <xfs@oss.sgi.com>; Thu, 29 Aug 2013 22:29:47 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 715A1AC008
	for <xfs@oss.sgi.com>; Thu, 29 Aug 2013 20:29:47 -0700 (PDT)
Received: from slmp-550-94.slc.westdc.net (slmp-550-94.slc.westdc.net
	[50.115.112.57]) by cuda.sgi.com with ESMTP id lSCtcJyysywrITs4
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 29 Aug 2013 20:29:44 -0700 (PDT)
Mime-Version: 1.0 (Mac OS X Mail 6.5 \(1508\))
Subject: Re: higher agcount on LVM2 thinp volumes
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <289A5A42-9879-4A2A-9284-4B8529A1488D@colorremedies.com>
Date: Thu, 29 Aug 2013 21:29:14 -0600
Message-Id: <EA62E90A-6DBB-4C03-B479-BE336ED36AC6@colorremedies.com>
References: <321D1F95-5603-4571-A445-A267DA5F670F@colorremedies.com>
	<52200BAE.1060501@sandeen.net>
	<4393C3B8-8C46-41ED-B9F3-BC7B37C2681F@colorremedies.com>
	<52200F5A.9050702@sandeen.net>
	<289A5A42-9879-4A2A-9284-4B8529A1488D@colorremedies.com>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: "stan@hardwarefreak.com Hoeppner" <stan@hardwarefreak.com>, xfs@oss.sgi.com


On Aug 29, 2013, at 9:24 PM, Chris Murphy <lists@colorremedies.com> wrote:

> 
> On Aug 29, 2013, at 9:19 PM, Eric Sandeen <sandeen@sandeen.net> wrote:
>> 
>> Argh sorry, how did I type THAT?
>> 
>> # blockdev --getiomin --getioopt /dev/mapper/vg1-data
> 
> conventional LV:
> [root@f19s ~]# blockdev --getiomin --getioopt /dev/mapper/vg1-data
> 512
> 0
> 
> thinp LV:
> 
> [root@f19s ~]# blockdev --getiomin --getioopt /dev/mapper/vg1-data
> 512
> 262144


It's tied to the chunk size of the thinp. If I create a 4MB chunk size, ioopt goes up to match it. The default is 256KB, which reflects the values above.


[root@f19s ~]# lvcreate -L 400G --type thin-pool -c 4M --thinpool thinp vg1
  device-mapper: remove ioctl on  failed: Device or resource busy
  Logical volume "thinp" created
[root@f19s ~]# lvcreate -V 100G -T vg1/thinp --name data
  Logical volume "data" created
[root@f19s ~]# blockdev --getiomin --getioopt /dev/mapper/vg1-data
512
4194304


Chris Murphy
_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
