Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 14 Mar 2007 14:20:19 -0700 (PDT)
Received: from mx2.netapp.com (mx2.netapp.com [216.240.18.37])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l2ELK96p024067
	for <xfs@oss.sgi.com>; Wed, 14 Mar 2007 14:20:13 -0700
Date: Wed, 14 Mar 2007 17:19:20 -0400
From: "Talpey, Thomas" <Thomas.Talpey@netapp.com>
Subject: Re: Strange XFS issue on tiny-NAS ARM NFS server
In-Reply-To: <45F85BFA.1070505@sandeen.net>
References: <EXNANE01iR9Odutox7n000000c6@exnane01.hq.netapp.com>
 <45F85BFA.1070505@sandeen.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <EXNANE01yeKzGZuNY1S000000cb@exnane01.hq.netapp.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: "Talpey, Thomas" <Thomas.Talpey@netapp.com>, xfs@oss.sgi.com

Wow good memory, 3 years ago:
<http://lists.arm.linux.org.uk/pipermail/linux-arm-kernel/2004-March/020287.html>

I'm compiling with gcc4.1.1 for arm5t big endian, patched for multiple
arm ports (OpenEmbedded) and it still botches that code today.
Works fine with the arithmetic decomposition in the message.
And I never blame the compiler! ;-)

Thanks!

BTW, XFS gives this little machine a nice bump in NFS write
bandwidth. Goes from ~6MB/sec to ~7MB/s. CPU limited, mainly.

Tom.

At 04:32 PM 3/14/2007, Eric Sandeen wrote:
>Talpey, Thomas wrote:
>> This might be pilot error, but a *very* strange thing happens with
>> an XFS filesystem on an NFS server I'm experimenting with. This is
>> an NSLU2 ARM-based machine, running 2.6.20.1 and an XFS filesystem
>> freshly built on a usb-attached 2.5" drive.
>> 
>> Running Connectathon 04 basic tests against the server, things are
>> fine with an EXT-formatted filesystem. However, reformatting the
>> export as a default XFS filesystem (mkfs.xfs -f /dev/sda3), the
>> following occurs:
>
>arm compiler has bugs that miscompile xfs... I think if you google arm + 
>xfs and maybe search the list archives, you'll find a possible workaround.
>
>-Eric
>
>
