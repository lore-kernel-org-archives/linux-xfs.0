Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0RE2Jm0180346 for <xfs@oss.sgi.com>; Fri, 27 Jan 2012 08:02:19 -0600
Message-ID: <4F22AE63.2020809@hitachi.com>
Date: Fri, 27 Jan 2012 23:02:11 +0900
From: HAYASAKA Mitsuo <mitsuo.hayasaka.hu@hitachi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 0/3] xfs: change available ranges in quota check
References: <20120123034513.3339.97432.stgit@ltc219.sdl.hitachi.co.jp>
	<20120124174612.GC9853@infradead.org>
	<4F22424E.8070407@hitachi.com>
	<20120127110238.GB31093@infradead.org>
In-Reply-To: <20120127110238.GB31093@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com, xfs-masters@oss.sgi.com, Ben Myers <bpm@sgi.com>, Alex Elder <aelder@sgi.com>, Christoph Hellwig <hch@lst.de>

Hi Christoph,

I'd like to explain the reason why I sent the patch series.

Here is an example where I activated user quota and set each softlimit and
hardlimit as follows.

       | softlimit | hardlimit 
-------------------------------
 block |    1M     |    2M
-------------------------------
 inode |     3     |     5

I succeeded to create files up to the inode hardlimit using touch command.
The quota information is shown as follows.

# xfs_quota -x -c 'report -u -b -i -h' /mnt/xfs2
User quota on /mnt/xfs2 (/dev/vdb)
                        Blocks                            Inodes              
User ID      Used   Soft   Hard Warn/Grace     Used   Soft   Hard Warn/Grace  
---------- --------------------------------- --------------------------------- 
root            0      0      0  00 [------]      3      0      0  00 [------]
xfstest01       0     1M     2M  00 [------]      5      3      5  00 [6 days]
						 ~~~~	        ~~

However, I failed to create and add another file due to the quota limitation.

$ touch /mnt/xfs2/dir00/file05
touch: cannot touch `/mnt/xfs2/dir00/file05': Disk quota exceeded

It seems the inode quota works well.

Regarding the block quota, I got the quota limitation message even if I
created a 2MB file which is equal to the hardlimit of disk quota.

$ dd if=/dev/zero of=/mnt/xfs2/dir00/file01 bs=2M count=1
dd: writing `/mnt/xfs2/dir00/file01': Disk quota exceeded
1+0 records in			     ~~~~~~~~~~~~~~~~~~~~~
0+0 records out
2093056 bytes (2.1 MB) copied, 0.00561516 s, 373 MB/s

I'd like to change the available range of the block quota, and
also change the inode quota check to the same way as the block check
introduced in PATCH 2/3 to make it more general.

Regards.


(2012/01/27 20:02), Christoph Hellwig wrote:
> On Fri, Jan 27, 2012 at 03:21:02PM +0900, HAYASAKA Mitsuo wrote:
>>> Can you send a testcase that reproduces issues with the old behaviour?
>>>
>>
>> Regarding (1) related to inode reservation, current xfs works well
>> because inode is reserved one by one if required.
>>
>> For example, when an new inode tries to be reserved in xfs_trans_dqresv(),
>> it checks quota as follows.
> 
> I'm just curious what the intent behdind the patches was.  They look
> good to me, but I wonder why we need to change it at all.
> 
>> To make it more general, this check should be the same way as the new
>> block quota check introduced in the PATCH 2/3 where the disk block can
>> be used up to the block quota limits.
> 
> So I guess that's the part we'd want a test case for if possible.
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
