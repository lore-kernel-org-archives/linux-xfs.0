Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id F41BB7F3F
	for <xfs@oss.sgi.com>; Wed, 23 Apr 2014 04:22:03 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 854ADAC00A
	for <xfs@oss.sgi.com>; Wed, 23 Apr 2014 02:22:00 -0700 (PDT)
Received: from mail-we0-f171.google.com (mail-we0-f171.google.com
	[74.125.82.171]) by cuda.sgi.com with ESMTP id Nyj2DUAxlz2LBL42
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 23 Apr 2014 02:21:58 -0700 (PDT)
Received: by mail-we0-f171.google.com with SMTP id t61so573851wes.2
	for <xfs@oss.sgi.com>; Wed, 23 Apr 2014 02:21:57 -0700 (PDT)
Message-ID: <53578632.1060005@gmail.com>
Date: Wed, 23 Apr 2014 11:21:54 +0200
From: Ivan Pantovic <gyro.ivan@gmail.com>
MIME-Version: 1.0
Subject: Re: rm -f * on large files very slow on XFS + MD RAID 6 volume of
	15x 4TB of HDDs (52TB)
References: <CAHuzUScfp19c_th_pfsZs05+yDz34MuEH-P1f+FF1dcivfH=5Q@mail.gmail.com>
	<20140423021835.GI15995@dastard> <53576A7D.9020303@gmail.com>
	<20140423082538.GR18672@dastard>
In-Reply-To: <20140423082538.GR18672@dastard>
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

Hi Dave,

> xfs_db> freesp
>    from      to extents  blocks    pct
>       1       1   52463   52463   0.00
>       2       3   73270  181394   0.01
>       4       7  134526  739592   0.03
>       8      15  250469 2870193   0.12
>      16      31  581572 13465403   0.58
>      32      63  692386 32096932   1.37
>      64     127 1234204 119157757   5.09
>     128     255   91015 16690243   0.71
>     256     511   18977 6703895   0.29
>     512    1023   12821 8611576   0.37
>    1024    2047   23209 33177541   1.42
>    2048    4095   43282 101126831   4.32
>    4096    8191   12726 55814285   2.39
>    8192   16383    2138 22750157   0.97
>   16384   32767    1033 21790120   0.93
>   32768   65535     433 19852497   0.85
>   65536  131071     254 23052185   0.99
>  131072  262143     204 37833000   1.62
>  262144  524287     229 89970969   3.85
>  524288 1048575     164 124210580   5.31
> 1048576 2097151     130 173193687   7.40
> 2097152 4194303      22 61297862   2.62
> 4194304 8388607      16 97070435   4.15
> 8388608 16777215      26 320475332  13.70
> 16777216 33554431       6 133282461   5.70
> 33554432 67108863      12 616939026  26.37
> 134217728 268435328       1 207504563   8.87
> xfs_db>

well now it is quite obvious that file fragmentation was actually the issue.

this is what munin has to say about that time frame when files were deleted.

http://picpaste.com/df_inode-pinpoint_1397768678_1397876678-kpwd9loR.png
http://picpaste.com/df-pinpoint_1397768678_1397876678-pQ7ZCTPu.png

although the drives were "only" 50% busy while deleting all those inodes.

it's quite interesting how we got there in the first place thanks to 
bacula backup and some other hardware failure not related to the backup 
server.

On 04/23/2014 10:25 AM, Dave Chinner wrote:
> On Wed, Apr 23, 2014 at 09:23:41AM +0200, Ivan Pantovic wrote:
>>> [root@drive-b ~]# xfs_db -r /dev/md0
>>> xfs_db> frag
>>> actual 11157932, ideal 11015175, fragmentation factor 1.28%
>>> xfs_db>
>> this is current level of fragmentation ... is it bad?
> http://xfs.org/index.php/XFS_FAQ#Q:_The_xfs_db_.22frag.22_command_says_I.27m_over_50.25._Is_that_bad.3F
>
>> some say over 1% is candidate for defrag? ...
> Some say that over 70% is usually not a problem:
>
> http://www.mythtv.org/wiki/XFS_Filesystem#Defragmenting_XFS_Partitions
>
> i.e. the level that becomes are problem is highly workload specific.
> So, you can't read *anything* in that number without know exactly
> what is in your filesystem, how the application(s) interact with it
> and so on.
>
> Besides, I was asking specifically about the files you removed, not
> the files that remain in the filesystem. Given that you have 11
> million inodes in the filesystem, you probably removed the only
> significantly large files in the filesystem....
>
> So, the files your removed are now free space, so free space
> fragmentation is what we need to look at.  i.e. use the freesp
> command to dump the histogram and summary of the free space...
>
> Cheers,
>
> Dave.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
