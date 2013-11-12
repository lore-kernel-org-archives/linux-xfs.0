Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id D99E87F57
	for <xfs@oss.sgi.com>; Mon, 11 Nov 2013 23:02:57 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id B62F98F8033
	for <xfs@oss.sgi.com>; Mon, 11 Nov 2013 21:02:54 -0800 (PST)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	kaG0o1A4Ykb9GXUX for <xfs@oss.sgi.com>;
	Mon, 11 Nov 2013 21:02:52 -0800 (PST)
Date: Tue, 12 Nov 2013 16:02:50 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2 RESEND] xfstests generic/320: heavy rm workload test
Message-ID: <20131112050249.GZ6188@dastard>
References: <1384229890-30733-1-git-send-email-eguan@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1384229890-30733-1-git-send-email-eguan@redhat.com>
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
To: Eryu Guan <eguan@redhat.com>
Cc: xfs@oss.sgi.com

On Tue, Nov 12, 2013 at 12:18:10PM +0800, Eryu Guan wrote:
> This test is based on generic/273, a regression test for commit
> 
> 9a3a5da xfs: check for stale inode before acquiring iflock on push
> 
> On unpatched kernel, rm processes would hang.
....
> +threads=50
> +count=2
> +fs_size=$((2 * 1024 * 1024 * 1024))
> +ORIGIN=$SCRATCH_MNT/origin
> +
> +threads_set()
> +{
> +	cpu_num=`grep -c processor /proc/cpuinfo`

Please us src/feature for this. See commit:

2dcf4a5 xfstests: src/feature.c: print a number of online CPUs

> +	threads=$(($cpu_num * 50))
> +	if [ $threads -gt 200 ]
> +	then
> +		threads=200
> +	fi
> +}

Didn't we go through this before? Or was that the review that lead
to the above commit? i.e. to use $LOAD_FACTOR to scale the workload,
not the number of CPUs....

> +
> +file_create()
> +{
> +	i=0
> +	mkdir $ORIGIN
> +
> +	disksize=$(($fs_size / 3))
> +	num=$(($disksize / $count / $threads / 4096))
> +	while [ $i -lt $num ]; do
> +		$XFS_IO_PROG -f -c "pwrite 0 $((4096*count))" $ORIGIN/file_$i >>$seqres.full 2>&1

Line too long.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
