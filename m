Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id BC9487F4E
	for <xfs@oss.sgi.com>; Mon, 13 Oct 2014 05:05:59 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 935A6304059
	for <xfs@oss.sgi.com>; Mon, 13 Oct 2014 03:05:56 -0700 (PDT)
Received: from st11p01mm-asmtp002.mac.com (st11p01mm-asmtp002.mac.com
	[17.172.204.237]) by cuda.sgi.com with ESMTP id
	3IRZZxkYyjaLsYCL (version=TLSv1 cipher=RC4-MD5 bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Mon, 13 Oct 2014 03:05:53 -0700 (PDT)
Received: from [192.168.142.67] (unknown [82.71.189.231])
	by st11p01mm-asmtp002.mac.com
	(Oracle Communications Messaging Server 7u4-27.10(7.0.4.27.9) 64bit
	(built Jun
	6 2014)) with ESMTPSA id <0NDD004OUO1PQM50@st11p01mm-asmtp002.mac.com>
	for xfs@oss.sgi.com; Mon, 13 Oct 2014 10:05:52 +0000 (GMT)
References: <1413103408756-35026.post@n7.nabble.com>
	<20141012142008.GB35667@bfoster.bfoster>
	<DUB113-W9BCC0D296AF7CD5D9D02FB6AF0@phx.gbl>
	<DUB113-W8015EC9E74D26138852F2FB6AF0@phx.gbl>
	<20141012231001.GC5267@dastard>
In-reply-to: <20141012231001.GC5267@dastard>
MIME-version: 1.0 (1.0)
Message-id: <A78F010F-2624-465E-8D16-0D89D39FD093@me.com>
From: Tom Mason <tom_mason@me.com>
Subject: Re: Mount: Structure needs cleaning
Date: Mon, 13 Oct 2014 11:05:49 +0100
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
To: Dave Chinner <david@fromorbit.com>
Cc: Brian Foster <bfoster@redhat.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>





> On 13 Oct 2014, at 00:10, Dave Chinner <david@fromorbit.com> wrote:
> 
> [ please don't top post. ]
> 
> On Sun, Oct 12, 2014 at 10:48:36PM +0000, tom mason wrote:
>>> Date: Sun, 12 Oct 2014 10:20:08 -0400
>>> From: bfoster@redhat.com
>>> To: tom_in_canada@hotmail.com
>>> CC: xfs@oss.sgi.com
>>> Subject: Re: Mount: Structure needs cleaning
>>> 
>>>> On Sun, Oct 12, 2014 at 01:43:28AM -0700, tommason wrote:
>>>> Hi,
>>>> 
>>>> First up - my knowledge of linux is pretty sparse - I've used it a few times
>>>> before, so please be gentle!
>>>> 
>>>> I've had a neil poulton network space for some time now - it freaked out a
>>>> while ago and I managed to rig it up to a Ubuntu liveCD via a SATA dock and
>>>> rescue the files.
>>>> 
>>>> This has now happened again - the drive would not get out of a cycle and was
>>>> not spinning properly. Bring out the dock and liveCD (this time Knoppix).
>>>> All good. This time however as I eagerly copied files to another drive (a
>>>> USB powered lacie rugged thing) and left it overnight i woke up to an error.
>>>> I was copying around 500GB in a few diffferent chunks. The first error it
>>>> reported was I think error 15? mount structure needs cleaning...
>> 
>> 
>>> Logs? Kernel version? etc.
>> 
>> Hey Brian,
>> Apologies! I'm pretty new to all this so you'll have to walk me through it if possible - how do I check the logs?
>> 
>> - Linux ubuntu 3.13.0-32-generic #57-Ubuntu SMP Tue Jul 15 03:51:08 UTC 2014 x86_64 x86_64 x86_64 GNU/Linux
>> - xfs_repair version 3.1.9
>> 
>> ok - so I worked out & tried the xfs_repair command:
>> 
>> root@ubuntu:~# xfs_repair -n /dev/sdc2
>> Phase 1 - find and verify superblock...
>> superblock read failed, offset 62448377856, size 131072, ag 2, rval -1
>> 
>> fatal error -- Input/output error
> 
> Which means the filesystem tried to read the offset at 62GB and the
> underlying device failed it with EIO. That's not an XFS failure.
> What error is there in dmesg when you run that xfs_repair command?

What's EIO?
'Error in dmesg' How would I report this info to you? 





> 
>>> http://xfs.org/index.php/XFS_FAQ#Q:_What_information_should_I_include_when_reporting_a_problem.3F
> 
> This asks you to post the contents of /proc/partitions, which is
> what the kernel thinks are the partition sizes.

How do I do this?


> 
>> Yes it's a NAS drive and so I assume had some kind of proprietary
>> OS on the other partitions (this is where i might have messed up
>> by deleting?!) I'm pretty sure that the drive in bold below (sdc2)
>> is the one I'm after which is xfs...
> 
> Ummm, exactly what are you trying to do with this drive/filesystem?
> What device did the drive come from in the first place?

It's a lacie 'Neil poulton' network space1 1tb NAS drive (see first paragraph of post) - it recently stopped working and was stuck in a 'spin cycle' - it contains my music and video backups. I'm trying to recover the files...

Cheers,

Tom



> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
