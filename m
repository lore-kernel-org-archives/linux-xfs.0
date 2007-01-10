Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 10 Jan 2007 05:30:15 -0800 (PST)
Received: from service.eng.exegy.net (68-191-203-42.static.stls.mo.charter.com [68.191.203.42])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l0ADU9qw029849
	for <linux-xfs@oss.sgi.com>; Wed, 10 Jan 2007 05:30:10 -0800
Message-ID: <45A4EA2B.5050505@exegy.com>
Date: Wed, 10 Jan 2007 07:29:15 -0600
From: "Mr. Berkley Shands" <bshands@exegy.com>
MIME-Version: 1.0
Subject: Re: XFS and 2.6.18 -> 2.6.20-rc3
References: <45A27BC7.2020709@exegy.com> <20070109012212.GG44411608@melbourne.sgi.com>
	<20070109072535.GH44411608@melbourne.sgi.com>
In-Reply-To: <20070109072535.GH44411608@melbourne.sgi.com>
Content-Type: text/plain
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, Dave Lloyd <dlloyd@exegy.com>, linux-xfs@oss.sgi.com

With a fresh install of the O/S on a non-broken motherboard, the change to

/proc/sys/vm/dirty_ratio

restores most of the lost performance from 2.6.18,
as of 2.6.20-rc4. The difference is 10% to 15% without the dirty_ratio
change (40 is the default, 10 gives the old performance).

Data: Writing, 8192 MB, Buffer: 128 KB, Time: 33571 MS, Rate:   244.020, to /s0/GigaData.0
Data: Writing, 8192 MB, Buffer: 128 KB, Time: 33480 MS, Rate:   244.683, to /s2/GigaData.0
Data: Writing, 8192 MB, Buffer: 128 KB, Time: 33570 MS, Rate:   244.027, to /s1/GigaData.0
Data: Writing, 8192 MB, Buffer: 128 KB, Time: 33579 MS, Rate:   243.962, to /s3/GigaData.0
Data: Writing, 8192 MB, Buffer: 128 KB, Time: 31486 MS, Rate:   260.179, to /s0/GigaData.1
Data: Writing, 8192 MB, Buffer: 128 KB, Time: 31537 MS, Rate:   259.758, to /s2/GigaData.1
Data: Writing, 8192 MB, Buffer: 128 KB, Time: 31538 MS, Rate:   259.750, to /s3/GigaData.1
Data: Writing, 8192 MB, Buffer: 128 KB, Time: 31549 MS, Rate:   259.660, to /s1/GigaData.1
Data: Writing, 8192 MB, Buffer: 128 KB, Time: 32205 MS, Rate:   254.370, to /s2/GigaData.2
Data: Writing, 8192 MB, Buffer: 128 KB, Time: 32205 MS, Rate:   254.370, to /s1/GigaData.2
Data: Writing, 8192 MB, Buffer: 128 KB, Time: 32218 MS, Rate:   254.268, to /s3/GigaData.2
Data: Writing, 8192 MB, Buffer: 128 KB, Time: 32220 MS, Rate:   254.252, to /s0/GigaData.2
Data: Writing, 8192 MB, Buffer: 128 KB, Time: 33536 MS, Rate:   244.275, to /s0/GigaData.3
Data: Writing, 8192 MB, Buffer: 128 KB, Time: 33583 MS, Rate:   243.933, to /s3/GigaData.3
Data: Writing, 8192 MB, Buffer: 128 KB, Time: 34016 MS, Rate:   240.828, to /s1/GigaData.3
Data: Writing, 8192 MB, Buffer: 128 KB, Time: 34018 MS, Rate:   240.814, to /s2/GigaData.3
Data: Writing, 8192 MB, Buffer: 128 KB, Time: 34121 MS, Rate:   240.087, to /s1/GigaData.4
Data: Writing, 8192 MB, Buffer: 128 KB, Time: 34123 MS, Rate:   240.073, to /s0/GigaData.4
Data: Writing, 8192 MB, Buffer: 128 KB, Time: 34114 MS, Rate:   240.136, to /s2/GigaData.4
Data: Writing, 8192 MB, Buffer: 128 KB, Time: 34122 MS, Rate:   240.080, to /s3/GigaData.4
Data: Writing, 8192 MB, Buffer: 128 KB, Time: 30386 MS, Rate:   269.598, to /s0/GigaData.9
Data: Writing, 8192 MB, Buffer: 128 KB, Time: 30384 MS, Rate:   269.616, to /s1/GigaData.9
Data: Writing, 8192 MB, Buffer: 128 KB, Time: 30717 MS, Rate:   266.693, to /s3/GigaData.9
Data: Writing, 8192 MB, Buffer: 128 KB, Time: 30726 MS, Rate:   266.615, to /s2/GigaData.9
Data: Writing, 8192 MB, Buffer: 128 KB, Time: 30088 MS, Rate:   272.268, to /s0/GigaData.10
Data: Writing, 8192 MB, Buffer: 128 KB, Time: 30079 MS, Rate:   272.349, to /s2/GigaData.10
Data: Writing, 8192 MB, Buffer: 128 KB, Time: 30086 MS, Rate:   272.286, to /s1/GigaData.10
Data: Writing, 8192 MB, Buffer: 128 KB, Time: 29989 MS, Rate:   273.167, to /s3/GigaData.10

So whatever needs to be tweaked in the VM system seems to be the key.

Thanks to all for getting this regression repaired.

Berkley


David Chinner wrote:
> On Tue, Jan 09, 2007 at 12:22:12PM +1100, David Chinner wrote:
>   
>> On Mon, Jan 08, 2007 at 11:13:43AM -0600, Mr. Berkley Shands wrote:
>>     
>>> My testbench is a 4 core Opteron (dual 275's) into
>>> two LSI8408E SAS controllers, into 16 Seagate 7200.10 320GB satas.
>>> Redhat ES4.4 (Centos 4.4). A slightly newer parted is needed
>>> than the contemporary of Moses that is shipped with the O/S.
>>>
>>> I have a standard burn in script that takes the 4 4-drive raid0's
>>> and puts a GPT label on them, aligns the partitions to stripe
>>> boundary's. It then proceeds to write 8GB files concurrently
>>> onto all 4 raid drives.
>>>       
>
> I just ran up a similar test - single large file per device on a 4
> core Xeon (woodcrest) with 16GB RAM, a single PCI-X SAS HBA and
> 12x10krpm 300GB SAS disks split into 3x4 disk dm raid zero stripes
> on 2.6.18 and 2.6.20-rc3.
>
> I see the same thing - 2.6.20-rc3 is more erractic and quite a
> bit slower than 2.6.18 when going through XFS.
>
> I suggest trying this on 2.6.20-rc3:
>
> # echo 10 > /proc/sys/vm/dirty_ratio
>
> That restored most of the lost performance and consistency
> in my testing....
>
> Cheers,
>
> Dave.
>   


-- 

//E. F. Berkley Shands, MSc//

**Exegy Inc.**

3668 S. Geyer Road, Suite 300

St. Louis, MO  63127

Direct:  (314) 450-5348

Cell:  (314) 303-2546

Office:  (314) 450-5353

Fax:  (314) 450-5354

 

This e-mail and any documents accompanying it may contain legally 
privileged and/or confidential information belonging to Exegy, Inc.  
Such information may be protected from disclosure by law.  The 
information is intended for use by only the addressee.  If you are not 
the intended recipient, you are hereby notified that any disclosure or 
use of the information is strictly prohibited.  If you have received 
this e-mail in error, please immediately contact the sender by e-mail or 
phone regarding instructions for return or destruction and do not use or 
disclose the content to others.

 



[[HTML alternate version deleted]]
