Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q4R2eAQO047413 for <xfs@oss.sgi.com>; Sat, 26 May 2012 21:40:10 -0500
Received: from mail.sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com
	with ESMTP id UWzXjAQ1XUc8rJ8H for <xfs@oss.sgi.com>;
	Sat, 26 May 2012 19:40:09 -0700 (PDT)
Message-ID: <4FC19408.5020502@sandeen.net>
Date: Sat, 26 May 2012 21:40:08 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: very slow file deletion on an SSD
References: <4FBF60D1.80104@gmail.com> <20120526231838.GR25351@dastard>
	<4FC16683.9060800@gmail.com> <20120527000701.GS25351@dastard>
	<4FC18845.6030301@gmail.com>
In-Reply-To: <4FC18845.6030301@gmail.com>
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
To: Joe Landman <joe.landman@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>, xfs@oss.sgi.com

On 5/26/12 8:49 PM, Joe Landman wrote:
> On 05/26/2012 08:07 PM, Dave Chinner wrote:
>> On Sat, May 26, 2012 at 07:25:55PM -0400, Joe Landman wrote:
>>> [root@siFlash test]# ls -alF  | wc -l
>>> 59
>>> [root@siFlash test]# /usr/bin/time rm -f *
>>> ^C0.00user 8.46system 0:09.55elapsed 88%CPU (0avgtext+0avgdata
>>> 2384maxresident)k
>>> 25352inputs+0outputs (0major+179minor)pagefaults 0swaps
>>
>> It's burning an awful lot of CPU time during this remove.
>>
>>> [root@siFlash test]# ls -alF  | wc -l
>>> 48
>>
>> So, 48 files were removed, it was basically CPU bound and one took
>> 2.6 seconds.
>>
>> So, how big are the files, and does the one that took 2.6s have tens
>> of thousands of extents ('xfs_bmap -vp *' will dump the extent maps
>> for all the files)?
> 
> Getting some sort of out of memory error with bmap
> 
> [root@siFlash test]# ls -alF
> total 50466476
> drwxr-xr-x 2 root root       4096 May 26 21:40 ./
> drwxr-xr-x 3 root root         17 May 26 19:32 ../
> -rw------- 1 root root 1073741824 May 26 19:36 2.r.49.0
...

<snip>

> [root@siFlash test]# ls -alF > x
> 
> [root@siFlash test]# xfs_bmap -vp x
> x:
>  EXT: FILE-OFFSET      BLOCK-RANGE          AG AG-OFFSET          TOTAL FLAGS
>    0: [0..7]:          212681896..212681903  2 (7555752..7555759)     8 01111
> 
> [root@siFlash test]# xfs_bmap -vp 2.r.96.0
> xfs_bmap: xfsctl(XFS_IOC_GETBMAPX) iflags=0x4 ["2.r.96.0"]: Cannot allocate memory

Try filefrag -v maybe, if your e2fsprogs is new enough.

Trying to remember, ENOMEM in bmap rings a bell... but this is possibly indicative of an extremely fragmented file.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
