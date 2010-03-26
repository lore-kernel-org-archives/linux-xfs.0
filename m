Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o2Q7Osxf208253 for <xfs@oss.sgi.com>; Fri, 26 Mar 2010 02:24:54 -0500
Received: from omr15.networksolutionsemail.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4871E279D58
	for <xfs@oss.sgi.com>; Fri, 26 Mar 2010 00:26:36 -0700 (PDT)
Received: from omr15.networksolutionsemail.com
	(omr15.networksolutionsemail.com [205.178.146.65]) by
	cuda.sgi.com with ESMTP id 6syl7dY8fgEsZzTM for
	<xfs@oss.sgi.com>; Fri, 26 Mar 2010 00:26:36 -0700 (PDT)
Received: from cm-omr1 (mail.networksolutionsemail.com [205.178.146.50])
	by omr15.networksolutionsemail.com (8.13.6/8.13.6) with ESMTP id
	o2Q7Qapw002859 for <xfs@oss.sgi.com>; Fri, 26 Mar 2010 03:26:36 -0400
Message-ID: <4BAC61A4.6030607@chaven.com>
Date: Fri, 26 Mar 2010 02:26:28 -0500
From: Steve Costaras <stevecs@chaven.com>
MIME-Version: 1.0
Subject: Re: 128TB filesystem limit?
References: <alpine.DEB.2.00.1003251609160.12435@asgard.lang.hm>	<20100325235433.GM3335@dastard>	<alpine.DEB.2.00.1003251702190.12435@asgard.lang.hm>	<20100326003511.GN3335@dastard>	<alpine.DEB.2.00.1003251900110.12435@asgard.lang.hm>	<4BAC3990.30403@sandeen.net>
	<alpine.DEB.2.00.1003252152350.16138@asgard.lang.hm>
In-Reply-To: <alpine.DEB.2.00.1003252152350.16138@asgard.lang.hm>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com



On 03/25/2010 23:56, david@lang.hm wrote:
> On Thu, 25 Mar 2010, Eric Sandeen wrote:
>
>> david@lang.hm wrote:
>>> On Fri, 26 Mar 2010, Dave Chinner wrote:
>>
>> ...
>>
>>>> Is there any reason for putting partitions on these block devices?
>>>> You could just use the block devices without partitions, and that
>>>> will avoid alignment potential problems....
>>>
>>> I would like to raid to auto-assemble and I can't do that without
>>> partitions, can I
>>
>> I think you can.... it's not like MD is putting anything in the 
>> partition
>> table; you just give it block devices, I doubt it cares if it's a whole
>> disk or some partition.
>>
>> Worth a check anyway ;)
>
> I know that md will work on raw devices, but the auto-assembly stuff 
> looks for the right partition type, I would have to maintain a conf 
> file across potential system rebuilds if I used the raw partitions.
>
>> ...
>>
>>
>>> the next fun thing is figuring out what sort of stride, etc 
>>> parameters I
>>> should have used for this filesystem.
>>
>> mkfs.xfs should suss that out for you automatically based on talking 
>> to md;
>> of course you'd want to configure md to line up well with the hardware
>> alignment.
>
> in this case md thinks it's working with 10 12.8TB drives, I really 
> doubt that it's going to do the right thing.
>
> I'm not exactly sure what the right thing is in this case. the 
> hardware raid is useing 64K chunks across 16 drives (so 14 * 64K worth 
> of data per stripe), but there are 10 of these stripes before you get 
> back to hitting the same drive again.
>
> David Lang
>

It does here at least, I never use partition tables on any of the arrays 
here just use LVM against what it sees as the 'raw' disk.    I haven't 
tried it w/ a 128TB array but with smaller ones that's what I've used in 
the past (hw raid, md raid-0, file system).   Recently for systems now I 
just use HW raid; LVM; and then filesystem (lvm does the striping/raid-0 
function).    when you create the physical volume w/ lvm just make sure 
you allign it (older versions use --metadatasize to 'pad' the start 
offset), newer versions have the dataalignment option.


Steve

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
