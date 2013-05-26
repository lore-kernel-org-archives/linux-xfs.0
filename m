Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 0350B7F37
	for <xfs@oss.sgi.com>; Sun, 26 May 2013 12:35:07 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 7717FAC008
	for <xfs@oss.sgi.com>; Sun, 26 May 2013 10:35:03 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id E4HY56oVcG3H1F8P for <xfs@oss.sgi.com>;
	Sun, 26 May 2013 10:35:01 -0700 (PDT)
Message-ID: <51A247C4.4050606@sandeen.net>
Date: Sun, 26 May 2013 12:35:00 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests 276: fix error 'FIBMAP: Invalid argument'
References: <512DB284.1090806@gmail.com> <51363CE6.1010807@sgi.com>
	<CAEH94LhbYShu5Q7K=G=10G6X3jUM68VL4rBBuS4zvdQsifsKGw@mail.gmail.com>
In-Reply-To: <CAEH94LhbYShu5Q7K=G=10G6X3jUM68VL4rBBuS4zvdQsifsKGw@mail.gmail.com>
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
To: Zhi Yong Wu <zwu.kernel@gmail.com>
Cc: Wang Sheng-Hui <shhuiw@gmail.com>, Rich Johnston <rjohnston@sgi.com>, list.btrfs@jan-o-sch.net, linux-btrfs@vger.kernel.org, xfstests <xfs@oss.sgi.com>

On 5/26/13 4:35 AM, Zhi Yong Wu wrote:
> HI,
> 
>   This issue still exists when xfstests is run on debian although
> xfstests has contained this patch.

"this issue" must be different, then; same error ("Invalid argument")
but it can no longer be due to the -x option to filefrag.  There
must be some other root cause.

Needs investigation on the btrfs side.  IOWs, this looks like
it could be a regression in btrfs?

-Eric

> root@debian-i386:/home/zwu/xfstests# git describe
> linux-v3.8-122-gdc75401
> root@debian-i386:/home/zwu/xfstests# uname -a
> Linux debian-i386 3.10.0-rc2+ #3 SMP Sun May 26 14:04:13 CST 2013
> x86_64 GNU/Linux
> root@debian-i386:/home/zwu/xfstests#
> 
>  - output mismatch (see /home/zwu/xfstests/results/btrfs/276.out.bad)
>     --- tests/btrfs/276.out    2013-05-25 15:09:01.000000000 +0000
>     +++ /home/zwu/xfstests/results/btrfs/276.out.bad    2013-05-26
> 09:31:49.962876905 +0000
>     @@ -1,3 +1,32393 @@
>      QA output created by 276
>      *** test backref walking
>     +FIBMAP: Invalid argument
>     +FIBMAP: Invalid argument
>     +FIBMAP: Invalid argument
>     +FIBMAP: Invalid argument
>     +FIBMAP: Invalid argument
>      ...
>      (Run 'diff -u tests/btrfs/276.out
> /home/zwu/xfstests/results/btrfs/276.out.bad' to see the entire diff)
> [ 3877.215268] device fsid 8367602a-14fa-49eb-aff0-44da1faa3b45 devid
> 1 transid 239 /dev/vdb
> [ 3877.218417] btrfs: disk space caching is enabled
> Ran: btrfs/276
> Failures: btrfs/276
> Failed 1 of 1 tests
> 
> On Wed, Mar 6, 2013 at 2:43 AM, Rich Johnston <rjohnston@sgi.com> wrote:
>> This patch has been committed.
>>
>> --Rich
>>
>> commit eba3a5206cd7f8df73d6e6dbf2bb0afca677fca8
>> Author: Wang Sheng-Hui <shhuiw@gmail.com>
>> Date:   Thu Feb 28 02:05:56 2013 +0000
>>
>>     xfstests 276: fix error 'FIBMAP: Invalid argument'
>>
>>
>>     Commit 05dadc0 ("Btrfs: add fiemap's flag check") added validity
>>     checks to the fiemap flags and hence invalid flags are now being
>>     rejected. Test 276 passes an invalid fiemap flag to btrfs, and so
>>     that test fails since this commit was added.
>>
>>     Btrfs doesn't support FIEMAP_FLAG_XATTR, which is enabled by -x option
>>     of filefrag, and will fail with
>>         'FIBMAP: Invalid argument'
>>     for 'filefrag -vx'. 'filefrag -vx' fails on btrfs with
>>          'FIEMAP failed with unsupported flags 2'
>>     Remove the '-x' option.
>>
>> _______________________________________________
>> xfs mailing list
>> xfs@oss.sgi.com
>> http://oss.sgi.com/mailman/listinfo/xfs
> 
> 
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
