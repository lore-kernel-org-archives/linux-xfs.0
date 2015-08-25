Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id A3AAD7F47
	for <xfs@oss.sgi.com>; Tue, 25 Aug 2015 18:09:37 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 3D2BDAC007
	for <xfs@oss.sgi.com>; Tue, 25 Aug 2015 16:09:36 -0700 (PDT)
Received: from mail-lb0-f169.google.com (mail-lb0-f169.google.com
	[209.85.217.169]) by cuda.sgi.com with ESMTP id
	BrMgFfuGD5um7hlB (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 25 Aug 2015 16:09:35 -0700 (PDT)
Received: by lbbpu9 with SMTP id pu9so109622067lbb.3
	for <xfs@oss.sgi.com>; Tue, 25 Aug 2015 16:09:33 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <55DCE1CF.5030708@sandeen.net>
References: <CABppvi6GdaTQgqpYJi6RhkpjP9ydTV8-2VV8LF9tHSN63XzWtA@mail.gmail.com>
	<55DCE1CF.5030708@sandeen.net>
Date: Tue, 25 Aug 2015 16:09:33 -0700
Message-ID: <CABppvi6W5_1GBrb8x1wOAq3X6yraTtt1UYEFE+dBzcXj3yTzrg@mail.gmail.com>
Subject: Re: Performance impact of mkfs.xfs vs mkfs.xfs -f
From: Shrinand Javadekar <shrinand@maginatics.com>
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
Cc: xfs@oss.sgi.com

Thanks for the reply Eric. Please see my responses inline:

On Tue, Aug 25, 2015 at 2:44 PM, Eric Sandeen <sandeen@sandeen.net> wrote:
> On 8/25/15 3:32 PM, Shrinand Javadekar wrote:
>> Hi,
>>
>> I have 23 disks formatted with XFS on a single server. The workload is
>> Openstack Swift. See this email from a few months ago about the
>> details:
>>
>> http://oss.sgi.com/archives/xfs/2015-06/msg00108.html
>>
>> I am observing some strange behavior and would like to get some
>> feedback about why this is happening.
>>
>> I formatted the disks with xfs (mkfs.xfs) and deployed Openstack Swift
>> on it. Writing 100GB of data into Swift in batches of 20GB each gave
>> us the following throughput:
>>
>>  20 GB: 93MB/s
>>  40 GB: 65MB/s
>>  60 GB: 52MB/s
>>  80 GB: 50MB/s
>> 100 GB: 48MB/s
>>
>> I then re-formatted the disks with mkfs.xfs -f and ran the experiment
>> again. This time I got the following throughput:
>>
>>  20 GB: 118MB/s
>>  40 GB: 95MB/s
>>  60 GB: 74MB/s
>>  80 GB: 68MB/s
>> 100 GB: 63MB/s
>>
>> I've seen similar results twice.
>
> How did you do the above twice, out of curiosity?  If it's the same set of disks,
> the 3rd mkfs would require "-f" to overwrite the old format.

I did this on 2 different setups.

Formatted the new disks with mkfs.xfs. Ran the workload.
Reformatted the disks with mkfs.xfs -f. Ran the workload.

>
>> Any ideas why this might be happening?
>
> With the paucity of information you've provided, nope!

Apologies. What more information can I provide?

>
> What version of xfsprogs are you using?

# xfs_repair -V
xfs_repair version 3.1.9

> What was the output of mkfs.xfs each time; did the geometry differ?

I have the output of xfs_info /mount/point from the first experiment
and that of mkfs.xfs -f. One difference I see is that reformatting
adds projid32bit=0 for the inode section.

>
> -f sets force_overwrite, which only does 3 things:
>
> 1) overwrite existing filesystem signatures
> 3) zeros out old xfs structures on disk
> 2) allow mkfs to proceed on a misaligned device
>
> I don't see why any of those behaviors would change runtime behavior.
>
> Maybe you have other variables in your performance testing, and two
> tests isn't enough to sort out noise?

We have seen this again on a third setup of one of my colleagues.

What more data can I look at for identifying the differences?

>
> -Eric
>
>> Thanks in advance.
>> -Shri
>>
>> _______________________________________________
>> xfs mailing list
>> xfs@oss.sgi.com
>> http://oss.sgi.com/mailman/listinfo/xfs
>>
>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
