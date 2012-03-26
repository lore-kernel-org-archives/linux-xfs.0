Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2QM9UqZ102524 for <xfs@oss.sgi.com>; Mon, 26 Mar 2012 17:09:30 -0500
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	XYxp87kDxcFhNhaA for <xfs@oss.sgi.com>;
	Mon, 26 Mar 2012 15:09:29 -0700 (PDT)
Date: Tue, 27 Mar 2012 09:09:26 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfstests 235: do smaller test IO
Message-ID: <20120326220926.GO5091@dastard>
References: <4F70C3D9.80708@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4F70C3D9.80708@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>
Cc: Eryu Guan <eguan@redhat.com>, xfs-oss <xfs@oss.sgi.com>

On Mon, Mar 26, 2012 at 02:30:33PM -0500, Eric Sandeen wrote:
> Test 235 fails on ext2/ext3 with 1024 fs block size because a
> 16k write uses an extra metadata block.  If we do a smaller write
> this won't happen.
.....
>  
> -$XFS_IO_PROG -F -c 'pwrite 0 16k' -c 'fsync' \
> +$XFS_IO_PROG -F -c 'pwrite 0 8k' -c 'fsync' \

So now it fails only on 512 byte block size filesystems?

Perhaps rather than an exact match, a "within_tolerance" match could
be done on the relevant fields?

i.e something like:

blksused=`{requota cmd} | awk '/fsgqa/ { print $3 }'`
_within_tolerance "blocks used" $blksused 16 1

If you wanted to get really fancy, the tolerance could be set
depending on filesystem type and block size, but I don't think that
is really necessary....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
