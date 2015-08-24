Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 4A25D7F37
	for <xfs@oss.sgi.com>; Sun, 23 Aug 2015 22:18:25 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 1BC06304039
	for <xfs@oss.sgi.com>; Sun, 23 Aug 2015 20:18:21 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id d6AeDc9WAA1ec7Zm (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sun, 23 Aug 2015 20:18:20 -0700 (PDT)
Date: Mon, 24 Aug 2015 11:18:16 +0800
From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH block/for-linus] writeback: fix syncing of I_DIRTY_TIME
	inodes
Message-ID: <20150824031816.GO17933@dhcp-13-216.nay.redhat.com>
References: <20150814111408.GB8710@quack.suse.cz>
	<20150817200254.GG21075@mtj.duckdns.org>
	<20150818091603.GA12317@quack.suse.cz>
	<20150818174718.GA15739@mtj.duckdns.org>
	<20150818195439.GB15739@mtj.duckdns.org>
	<20150818215611.GD3902@dastard>
	<20150821102053.GL17933@dhcp-13-216.nay.redhat.com>
	<20150822003025.GS3902@dastard>
	<20150822044609.GM17933@dhcp-13-216.nay.redhat.com>
	<20150824011123.GA714@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150824011123.GA714@dastard>
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
Cc: Jens Axboe <axboe@kernel.dk>, Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, axboe@fb.com, linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.com>, Tejun Heo <tj@kernel.org>, kernel-team@fb.com

On Mon, Aug 24, 2015 at 11:11:23AM +1000, Dave Chinner wrote:
> 
> Eryu, can you change the way you run the event trace to be:
> 
> $ sudo trace-cmd <options> -o <outfile location> ./check <test options>
> 
> rather than running the trace as a background operation elsewhere?
> Maybe that will give better results.

The results are here

http://128.199.137.77/writeback-v3/

> 
> Also, it would be informative to us if you can reproduce this with a
> v5 filesystem (i.e. mkfs.xfs -m crc=1) because it has much better
> on-disk information for sequence-of-event triage like this. If you
> can reproduce it with a v5 filesystem, can you post the trace and
> metadump?

This seems to be harder to reproduce with tracepoints enabled, but I'll
keep trying, and the tests below.

Thanks,
Eryu

> 
> Other things to check (separately):
> 
> 	- change godown to godown -f
> 	- add a "sleep 5" before running godown after sync
> 	- add a "sleep 5; sync" before running godown
> 
> i.e. I'm wondering if sync is not waiting for everything, and so we
> aren't capturing the IO completions because the filesystem is
> already shut down by the time they are delivered...
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
