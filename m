Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id C98CE7F3F
	for <xfs@oss.sgi.com>; Tue, 19 Aug 2014 14:25:05 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 8CACF30407A
	for <xfs@oss.sgi.com>; Tue, 19 Aug 2014 12:25:02 -0700 (PDT)
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com
	[67.231.145.42]) by cuda.sgi.com with ESMTP id r7vdAqk1BMDVxpov
	for <xfs@oss.sgi.com>; Tue, 19 Aug 2014 12:25:01 -0700 (PDT)
Message-ID: <53F3A480.6020000@fb.com>
Date: Tue, 19 Aug 2014 15:24:48 -0400
From: Chris Mason <clm@fb.com>
MIME-Version: 1.0
Subject: Re: [PATCH v2] xfs: don't zero partial page cache pages during
	O_DIRECT
References: <53E4E03A.7050101@fb.com> <53E61A9C.4020807@fb.com>
	<20140812011743.GU20518@dastard>
In-Reply-To: <20140812011743.GU20518@dastard>
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
Cc: Eric Sandeen <sandeen@redhat.com>, xfs@oss.sgi.com

On 08/11/2014 09:17 PM, Dave Chinner wrote:
> On Sat, Aug 09, 2014 at 08:57:00AM -0400, Chris Mason wrote:
>>
>> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
>> index 1f66779..023d575 100644
>> --- a/fs/xfs/xfs_file.c
>> +++ b/fs/xfs/xfs_file.c
>> @@ -295,7 +295,8 @@ xfs_file_read_iter(
>>  				xfs_rw_iunlock(ip, XFS_IOLOCK_EXCL);
>>  				return ret;
>>  			}
>> -			truncate_pagecache_range(VFS_I(ip), pos, -1);
>> +			invalidate_inode_pages2_range(VFS_I(ip)->i_mapping,
>> +					      pos >> PAGE_CACHE_SHIFT, -1);
>>  		}
>>  		xfs_rw_ilock_demote(ip, XFS_IOLOCK_EXCL);
>>  	}
> 
> I added the WARN_ON_ONCE(ret) check to this and I am seeing it fire
> occasionally. It always fires immediately before some other ASSERT()
> they fires with a block map/page cache inconsistency. It usually
> fires in a test that runs fsx or fsstress. The fsx failures are new
> regressions caused by this patch. e.g. generic/263 hasn't failed for
> months on any of my systems and this patch causes it to fail
> reliably on my 1k block size test config.
> 
> I'm going to assume at this point that this is uncovering some other
> existing bug, but it means I'm not going to push this fix until I
> understand what is actually happening here. It is possible that what
> I'm seeing is related to Brian's collapse range bug fixes, but until
> I applied this direct IO patch I'd never seen fsx throw ASSERTs in
> xfs_bmap_shift_extents()....
> 
> Either way, more testing and understanding is needed.

Do you have the output from xfs and the command line args it used?  For
my device, it picks:

-r 4096 -t 512 -w 512 -Z

And for a blocksize 1024 test I did mkfs.xfs -b size=1024

But I can't trigger failures with or without the invalidate_inode_pages2
change.  I was hoping to trigger on 3.16, and then jump back to 3.10 +
my patch to see if the patch alone was at fault.

-chris

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
