Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id ED7BF7F58
	for <xfs@oss.sgi.com>; Mon,  5 Jan 2015 21:21:05 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id CD0398F8033
	for <xfs@oss.sgi.com>; Mon,  5 Jan 2015 19:21:01 -0800 (PST)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id 2ptjHPEcXdn8qQBA
	for <xfs@oss.sgi.com>; Mon, 05 Jan 2015 19:21:00 -0800 (PST)
Message-ID: <54AB54B5.1020902@hardwarefreak.com>
Date: Mon, 05 Jan 2015 21:21:25 -0600
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: What is a recommended XFS sector size for hybrid (512e) advanced
	format hard drives?
References: <1806495.BCZcrVVEOf@shtub-cm> <54AA0A93.2010204@hardwarefreak.com>
	<11099415.8G4MDk5SIC@shtub-cm>
In-Reply-To: <11099415.8G4MDk5SIC@shtub-cm>
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
To: Hillel Lubman <shtetldik@gmail.com>
Cc: xfs@oss.sgi.com

On 01/05/2015 08:23 PM, Hillel Lubman wrote:
> On Sunday, January 04, 2015 21:52:51 Stan Hoeppner wrote:
> 
>> On 01/04/2015 06:56 PM, Hillel Lubman wrote:
> 
>> ...
> 
>> > when creating XFS partitions on hybrid (512e)
> 
>> ...
> 
>> > Can you please clarify what after all is the recommended sector size for
> 
>> > such drives
> 
>> ...
> 
>>
> 
>> XFS sectsz is unimportant with these drives. What matters is that any
> 
>> partitions you create start and end on 4KB boundaries.
> 
>  
> 
> Thanks. So there shouldn't be any negative impact either if sectz is set
> to 4 KB? 

Again, as long as your partitions are 4KB aligned.

> In one particular case I experience some perceived slowness on
> 2 TB WD drive (and I created XFS partition on that drive using sectz as
> 4 KB). 

Likely due to a misaligned partition.  In this case many XFS IOs are
going to cause RMW in two adjacent hardware (4KB) disk sectors as each
XFS block overlaps two sectors.  This may significantly hamper drive
performance.

> I didn't test however how it compares to default settings on the
> same drive which would set it to 512 B.

As long as your underlying partition is 4KB aligned the only advantage
you'll likely see with 4B sectsz is a little faster log IO.  So for non
metadata heavy workloads you won't see any difference between 512B and
4KB sectsz.

Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
