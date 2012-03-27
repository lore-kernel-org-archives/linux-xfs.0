Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2R1Iwqk141777 for <xfs@oss.sgi.com>; Mon, 26 Mar 2012 20:18:58 -0500
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	h473nSGxXdEaFnAj for <xfs@oss.sgi.com>;
	Mon, 26 Mar 2012 18:18:56 -0700 (PDT)
Date: Tue, 27 Mar 2012 12:18:34 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfstests 235: do smaller test IO
Message-ID: <20120327011834.GT5091@dastard>
References: <4F70C3D9.80708@redhat.com> <20120326220926.GO5091@dastard>
	<4F70EBD8.9030006@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4F70EBD8.9030006@redhat.com>
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

On Mon, Mar 26, 2012 at 05:21:12PM -0500, Eric Sandeen wrote:
> On 3/26/12 5:09 PM, Dave Chinner wrote:
> > On Mon, Mar 26, 2012 at 02:30:33PM -0500, Eric Sandeen wrote:
> >> Test 235 fails on ext2/ext3 with 1024 fs block size because a
> >> 16k write uses an extra metadata block.  If we do a smaller write
> >> this won't happen.
> > .....
> >>  
> >> -$XFS_IO_PROG -F -c 'pwrite 0 16k' -c 'fsync' \
> >> +$XFS_IO_PROG -F -c 'pwrite 0 8k' -c 'fsync' \
> > 
> > So now it fails only on 512 byte block size filesystems?
> 
> ext[23] don't do 512 byte block filesystems, so no.  ;)

Oh, I forgot about that. Well, just ignore me.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
