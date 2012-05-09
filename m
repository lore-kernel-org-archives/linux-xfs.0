Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q497nu8r080851 for <xfs@oss.sgi.com>; Wed, 9 May 2012 02:49:57 -0500
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id dhGXMM1KZeh9q43N
	for <xfs@oss.sgi.com>; Wed, 09 May 2012 00:49:54 -0700 (PDT)
Message-ID: <4FAA21A4.9070104@hardwarefreak.com>
Date: Wed, 09 May 2012 02:49:56 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: suddenly slow writes on XFS Filesystem
References: <4FA63DDA.9070707@profihost.ag> <20120507013456.GW5091@dastard>
	<4FA76E11.1070708@profihost.ag> <20120507071713.GZ5091@dastard>
	<4FA77842.5010703@profihost.ag>
	<4FA7FA14.6080700@hardwarefreak.com>
	<4FA82B07.1020102@profihost.ag>
	<4FAA153D.1030606@hardwarefreak.com>
	<20120509070450.GP5091@dastard>
In-Reply-To: <20120509070450.GP5091@dastard>
Reply-To: stan@hardwarefreak.com
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
To: Dave Chinner <david@fromorbit.com>
Cc: Stefan Priebe <s.priebe@profihost.ag>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On 5/9/2012 2:04 AM, Dave Chinner wrote:
> On Wed, May 09, 2012 at 01:57:01AM -0500, Stan Hoeppner wrote:
>> On 5/7/2012 3:05 PM, Stefan Priebe wrote:
>>> Am 07.05.2012 18:36, schrieb Stan Hoeppner:
> ....
>>>> What I would suggest is doing an xfsdump to a filesystem on another LUN
>>>> or machine, expand the size of this LUN by 50% or more (I gather this is
>>>> an external RAID), format it appropriately, then xfsrestore.  This will
>>>> eliminate your current free space fragmentation, and the 50% size
>>>> increase will delay the next occurrence of this problem.  If you can't
>>>> expand the LUN, simply do the xfsdump/format/xfsrestore, which will give
>>>> you contiguous free space.
>>> But this will only help for a few month or perhaps a year.
>>
>> So you are saying your backup solution will fill up an additional 2.3TB
>> in less than a year?  In that case I'd say you have dramatically
>> undersized your backup storage and/or are not using file compression to
>> your advantage.  And you're obviously not using archiving to your
>> advantage or you'd not have the free space fragmentation issue because
>> you'd be dealing with much larger files.
>>
>> So the best solution to your current problem, and one that will save you
>> disk space and thus $$, is to use a backup solution that makes use of
>> both tar and gzip/bzip2.
> 
> Why use the slow method? xfsdump will be much faster than tar. :)

Certainly faster.  I've assumed Stefan is backing up heterogeneous
systems so xfsdump is probably not an option across the board.  My
thinking directly above related to the possibility that his current
software may have integrated functions for tar'ing then compressing at
the directory level.  This would save space, cause less free space
fragmentation when old files are deleted, and allow decompressing files
that aren't insanely large in the even a single file needs to be
restored from a compressed tar file.  Of course the latter can be
accomplished with xfsdump/restore, but not on heterogeneous systems.
And AFAIK there isn't any nifty FOSS backup software that makes use of
xfsdump/restore, requiring some serious custom scripting.  If there
exists such backup software please do share. :)

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
