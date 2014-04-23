Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 2D4597F3F
	for <xfs@oss.sgi.com>; Wed, 23 Apr 2014 02:23:51 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id DFB5D8F804B
	for <xfs@oss.sgi.com>; Wed, 23 Apr 2014 00:23:47 -0700 (PDT)
Received: from mail-ee0-f46.google.com (mail-ee0-f46.google.com
	[74.125.83.46]) by cuda.sgi.com with ESMTP id DmBzMKhHRNx8JAXm
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 23 Apr 2014 00:23:46 -0700 (PDT)
Received: by mail-ee0-f46.google.com with SMTP id t10so400610eei.19
	for <xfs@oss.sgi.com>; Wed, 23 Apr 2014 00:23:44 -0700 (PDT)
Message-ID: <53576A7D.9020303@gmail.com>
Date: Wed, 23 Apr 2014 09:23:41 +0200
From: Ivan Pantovic <gyro.ivan@gmail.com>
MIME-Version: 1.0
Subject: Re: rm -f * on large files very slow on XFS + MD RAID 6 volume of
	15x 4TB of HDDs (52TB)
References: <CAHuzUScfp19c_th_pfsZs05+yDz34MuEH-P1f+FF1dcivfH=5Q@mail.gmail.com>
	<20140423021835.GI15995@dastard>
In-Reply-To: <20140423021835.GI15995@dastard>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: linux-kernel@vger.kernel.org, Speedy Milan <speedy.milan@gmail.com>, xfs@oss.sgi.com


> [root@drive-b ~]# xfs_db -r /dev/md0
> xfs_db> frag
> actual 11157932, ideal 11015175, fragmentation factor 1.28%
> xfs_db>

this is current level of fragmentation ... is it bad?

some say over 1% is candidate for defrag? ...

we can leave it like this and wait for a next full backup and then check 
on the fragmentation of that file.

On 04/23/2014 04:18 AM, Dave Chinner wrote:
> [cc xfs@oss.sgi.com]
>
> On Mon, Apr 21, 2014 at 10:58:53PM +0200, Speedy Milan wrote:
>> I want to report very slow deletion of 24 50GB files (in total 12 TB),
>> all present in the same folder.
> total = 1.2TB?
>
>> OS is CentOS 6.4, with upgraded kernel 3.13.1.
>>
>> The hardware is a Supermicro server with 15x 4TB WD Se drives in MD
>> RAID 6, totalling 52TB of free space.
>>
>> XFS is formated directly on the RAID volume, without LVM layers.
>>
>> Deletion was done with rm -f * command, and it took upwards of 1 hour
>> to delete the files.
>>
>> File system was filled completely prior to deletion.
> Oh, that's bad. it's likely you fragmented the files into
> millions of extents?
>
>> rm was mostly waiting (D state), probably for kworker threads, and
> No, waiting for IO.
>
>> iostat was showing big HDD utilization numbers and very low throughput
>> so it looked like a random HDD workload was in effect.
> Yup, smells like file fragmentation. Non-fragmented 50GB files
> should be removed in a few milliseconds. but if you've badly
> fragmented the files, there could be 10 million extents in a 50GB
> file. A few milliseconds per extent removal gives you....
>
> Cheers,
>
> Dave.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
