Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q8R1E6tN021250 for <xfs@oss.sgi.com>; Wed, 26 Sep 2012 20:14:06 -0500
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	EB2d9t4LLLhu8QIU for <xfs@oss.sgi.com>;
	Wed, 26 Sep 2012 18:15:24 -0700 (PDT)
Date: Thu, 27 Sep 2012 11:15:22 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 6/6] add defragmentation stress test for ext4
Message-ID: <20120927011522.GH15236@dastard>
References: <1348496601-32637-1-git-send-email-dmonakhov@openvz.org>
	<1348496601-32637-6-git-send-email-dmonakhov@openvz.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1348496601-32637-6-git-send-email-dmonakhov@openvz.org>
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
To: Dmitry Monakhov <dmonakhov@openvz.org>
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, hch@lst.de, xfs@oss.sgi.com

On Mon, Sep 24, 2012 at 06:23:21PM +0400, Dmitry Monakhov wrote:
> Perform various regression tests for ext4defrag  subsystem
> 
>  Test1: Defragment file while other task does direct AIO
>  Test2: Perform defragmentation on file under buffered AIO
>  	while third task does direct AIO to donor file
>  Test3: Two defrag tasks use common donor file.
>  Test4: Stress defragmentation. Several threads pefrorm
>  	fragmentation at random position use inplace=1 will
> 	allocate and free blocks inside defrag event improve
> 	load pressure.

Please do these as 4 separate tests so that it is easy to
isolate/reproduce failures caused by a specific test that is being
run.

Same comments as previous two patches, as well.

> +_workout()
> +{
> +	echo ""
> +	echo " Start defragment activity "
> +	echo ""
> +	cat $tmp-$seq.fio >>  $seq.full
> +	run_check $FIO_PROG $tmp-$seq.fio >>  $seq.full
> +}
> +
> +# real QA test starts here
> +_supported_fs generic
> +_supported_os Linux
> +_supported_fs ext4
> +_need_to_be_root
> +_require_scratch
> +_require_fio $tmp-$seq.fio

Even though e4defrag is not used, it's probably still a good idea to
call _require_defrag to check for systems that have a recent enough
ext4 to run defrag on. e.g. a recent fio on an old distro might
result in fio saying "I understand this job file" but then not be
able to run defrag...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
