Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id A0168801F
	for <xfs@oss.sgi.com>; Fri, 26 Sep 2014 18:01:16 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 2DD6DAC007
	for <xfs@oss.sgi.com>; Fri, 26 Sep 2014 16:01:13 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	zBBNDChkALGE4IJZ for <xfs@oss.sgi.com>;
	Fri, 26 Sep 2014 16:01:10 -0700 (PDT)
Date: Sat, 27 Sep 2014 09:01:06 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/3] xfs: remove bitfield based superblock updates
Message-ID: <20140926230106.GO4945@dastard>
References: <1411647632-28240-1-git-send-email-david@fromorbit.com>
	<1411647632-28240-3-git-send-email-david@fromorbit.com>
	<20140926094550.GB10692@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140926094550.GB10692@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Fri, Sep 26, 2014 at 02:45:50AM -0700, Christoph Hellwig wrote:
> This breaks generic/230 for me on an x86-64 VM:
> 
> --- tests/generic/230.out	2013-11-11 10:38:59.000000000 +0000
> +++ /root/xfstests/results//generic/230.out.bad	2014-09-26 09:47:37.000000000 +0000
> @@ -23,11 +23,8 @@
>  Write 900k...
>  Rewrite 1001k...
>  Write 1000k...
> -pwrite64: Disk quota exceeded
>  Write 4096...
> -pwrite64: Disk quota exceeded
>  Touch 3+4
>  Touch 5+6
>  touch: cannot touch 'SCRATCH_MNT/file6': Disk quota exceeded
>  Touch 5
> -touch: cannot touch 'SCRATCH_MNT/file5': Disk quota exceeded

Curious, I haven't seen any change in quota behaviour on any test as
a result of these changes. What's the config of your VM and xfstests
run?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
