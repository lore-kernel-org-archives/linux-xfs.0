Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 3FCBA29DF8
	for <xfs@oss.sgi.com>; Tue,  7 May 2013 02:37:22 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 31A9430407F
	for <xfs@oss.sgi.com>; Tue,  7 May 2013 00:37:22 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	Owo8ZGI9OCZDFcsZ for <xfs@oss.sgi.com>;
	Tue, 07 May 2013 00:37:19 -0700 (PDT)
Date: Tue, 7 May 2013 17:37:17 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [problem] xfstests generic/311 unreliable...
Message-ID: <20130507073717.GB24635@dastard>
References: <20130507071102.GA24635@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130507071102.GA24635@dastard>
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
To: xfs@oss.sgi.com
Cc: jbacik@fusionio.com

Argh, add the cc to Josef...

On Tue, May 07, 2013 at 05:11:02PM +1000, Dave Chinner wrote:
> Hi Josef,
> 
> I was just looking at a generic/311, and I think there's something
> fundamentally wrong with the way it is checking the scratch device.
> 
> You reported it was failing for internal test 19 on XFS, but I'm
> seeing is fail after the first test or 2, randomly. It has never
> made it past test 3. So I had a little bit of a closer look at it's
> structure. Essentially it is doing this (and the contents seen by
> each step:
> 
> scratch dev + mkfs
> 	+-------------------------------+
> overlay dm-flakey
> 	D-------------------------------D
> mount/write/kill/unmount dm-flakey
> 	Dx-x-x-x-x-x-x------------------D
> 
> All good up to here. Now, you can _check_scratch_fs which sees:
> 
> scratch dev + check
> 	+-------------------------------+
> 
> i.e. it's not seeing all the changes written to dm-flakey and so
> xfs-check it seeing corruption.
> 
> After I realised this was stacking block devices and checking the
> underlying block device, the cause was pretty obvious: scratch-dev
> and dm-flakey have different address spaces, so changes written
> throughone address space will not be seen through the other address
> space if there is stale cached data in the original address space.
> 
> And that's exactly what is happening. This patch:
> 
> --- a/tests/generic/311
> +++ b/tests/generic/311
> @@ -79,6 +79,7 @@ _mount_flakey()
>  _unmount_flakey()
>  {
>         $UMOUNT_PROG $SCRATCH_MNT
> +       echo 3 > /proc/sys/vm/drop_caches
>  }
>  
>  _load_flakey_table()
> 
> Makes the problem go away for xfs_check. But really, I don't like
> the assumption that the test is built on - that writes through one
> block device are visible through another. It's just asking for weird
> problems.
> 
> Is there some way that you can restructure this test so it doesn't
> have this problem (e.g. do everything on dm-flakey)?
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
> 

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
