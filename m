Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o9C1Ps8G039032 for <xfs@oss.sgi.com>; Mon, 11 Oct 2010 20:25:55 -0500
Received: from greer.hardwarefreak.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id EB5F0EEDB20
	for <xfs@oss.sgi.com>; Mon, 11 Oct 2010 18:41:15 -0700 (PDT)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id TC9qEHDtO2xiL55o
	for <xfs@oss.sgi.com>; Mon, 11 Oct 2010 18:41:15 -0700 (PDT)
Received: from [192.168.100.53] (gffx.hardwarefreak.com [192.168.100.53])
	by greer.hardwarefreak.com (Postfix) with ESMTP id 957EC6C121
	for <xfs@oss.sgi.com>; Mon, 11 Oct 2010 20:27:00 -0500 (CDT)
Message-ID: <4CB3B964.40109@hardwarefreak.com>
Date: Mon, 11 Oct 2010 20:27:00 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: ENOSPC at 90% with plenty of inodes
References: <AANLkTinwnOm0V=9WwbXiUGFnyjCwT3GUHo0hiQahQNUV@mail.gmail.com>	<20101008225146.GJ4681@dastard>	<AANLkTikLyEuSoFRVwirKLws97Vemz4ScNHOqu2Jc5sWR@mail.gmail.com>
	<20101011223507.GB32255@dastard>
In-Reply-To: <20101011223507.GB32255@dastard>
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

Dave Chinner put forth on 10/11/2010 5:35 PM:
> On Mon, Oct 11, 2010 at 03:03:28PM +0100, James Braid wrote:
>> On Fri, Oct 8, 2010 at 23:51, Dave Chinner <david@fromorbit.com> wrote:
>>> Sounds like fragmented free space. What is the output of:
>>>
>>> # xfs_db -r -c "freesp -s" <device>
>>
>> # xfs_db -r -c "freesp -s" /dev/sdb
>>    from      to extents  blocks    pct
>>       1       1 2298052 2298052  40.52
>>       2       3 1568338 3337017  58.84
>>       4       7    8432   35716   0.63
>>       8      15      50     423   0.01
>> total free extents 3874872
>> total free blocks 5671208
>> average free extent size 1.46359
>>
>> Which seems to say there are a few tiny pieces of free space
>> available? The files that were failing to be written were a few
>> hundred bytes in size.
> 
> The error has nothing to do with the size of the files, but
> everything to do with being able to allocate more inodes. Inode
> allocation requires 4 contiguous blocks (for 256 byte inodes, more
> for larger inodes) with alignment constraints. That means when you
> run out of 8 block or larger free extents, inode allocation will
> start failing and you'll get ENOSPC being reported.
> 
>> We haven't seen any errors so far today, but xfs_fsr ran over the
>> weekend, so perhaps I guess it's reorganized the filesystem.
> 
> Only a little. xfs_fsr will not improve fragmented free space
> conditions (indeed, it normally fragments free space more). The only
> way to reduce the fragmentation of free space is to remove a
> significant amount of data and inodes from the filesystem...

Hay Dave, would a "backup/reformat/restore" help with free space
fragmentation in this case?  If so, could/should the OP specify anything
during the mkfs.xfs reformat that may help alleviate or mitigate his
problem in the future?

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
