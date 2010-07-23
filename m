Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o6N3TcIR176796 for <xfs@oss.sgi.com>; Thu, 22 Jul 2010 22:29:38 -0500
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B8D881B8E985
	for <xfs@oss.sgi.com>; Thu, 22 Jul 2010 20:32:40 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id VT4xKwBg3tihTkyW for
	<xfs@oss.sgi.com>; Thu, 22 Jul 2010 20:32:40 -0700 (PDT)
Message-ID: <4C490D4D.603@redhat.com>
Date: Thu, 22 Jul 2010 22:32:29 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests 240: test non-aligned AIO hole-filling
References: <4C489676.2000605@redhat.com> <20100723024938.GD32635@dastard>
In-Reply-To: <20100723024938.GD32635@dastard>
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
Cc: ext4 development <linux-ext4@vger.kernel.org>, xfs-oss <xfs@oss.sgi.com>

Dave Chinner wrote:

> On Thu, Jul 22, 2010 at 02:05:26PM -0500, Eric Sandeen wrote:
>   
>> This replicates file corruption we've seen with qemu-kvm when
>> we use if=virtio,cache=none,aio=native for IO to a sparse
>> ext4- or xfs-hosted file, and the partitions/filesystems
>> within that file image are not block-aligned.  (think sector
>> 63 here...)  This results in AIO IOs not aligned to the
>> filesystem blocks.
>>
>> This test modifies aiodio_sparse2.c to add an option to start
>> the file IO at an offset.
>>
>> When we do 4k writes to a 16k file in 2 threads, starting
>> at offset 512, we get 0s interspersed in the file where they
>> should not be:
>>
>> 00000000  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
>> *
>> 00000200  01 01 01 01 01 01 01 01  01 01 01 01 01 01 01 01  |................|
>> *
>> 00001000  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
>> *
>> 00001200  01 01 01 01 01 01 01 01  01 01 01 01 01 01 01 01  |................|
>> ....
>>
>> Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
>>     
>
> looks good - it needs to remove the $TEST_DIR/aiodio_sparse file
> before the test starts, though, so that repeated tests fail
> correctly. Otherwise:
>
>   
hm, but:

+rm -f "$TEST_DIR/aiodio_sparse*"
+
+# 2 threads, 4k writes, 16k filesize, stride throug file by 4k, start at 512 offset
+$here/src/aio-dio-regress/aiodio_sparse2 -i 2 -w 4k -s 16k -n 4k -o 512 "$TEST_DIR/aiodio_sparse"

It does remove it ... no?


> Reviewed-by: Dave Chinner <dchinner@redhat.com>
>
>   
thanks

> Also, Eric, can you run this proof-of-concept test branch (on top of
> the current XFS for-2.6.36 branch) and see if QEMU is happy with it?
> It passes this test on my machine....
>
>   
Absolutely, thanks!

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
