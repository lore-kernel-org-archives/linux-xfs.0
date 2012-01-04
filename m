Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q04NHUnH172403 for <xfs@oss.sgi.com>; Wed, 4 Jan 2012 17:17:30 -0600
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	1PZA4WN34LayLAQF for <xfs@oss.sgi.com>;
	Wed, 04 Jan 2012 15:17:28 -0800 (PST)
Date: Thu, 5 Jan 2012 10:17:25 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH V2] xfstests: make 275 pass
Message-ID: <20120104231725.GB24466@dastard>
References: <4F04A6E6.1090304@redhat.com>
 <4F04BC81.1000207@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4F04BC81.1000207@redhat.com>
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
Cc: ext4 development <linux-ext4@vger.kernel.org>, Eryu Guan <eguan@redhat.com>, xfs-oss <xfs@oss.sgi.com>

On Wed, Jan 04, 2012 at 02:54:25PM -0600, Eric Sandeen wrote:
> Ok, this is a significant rework of 275, which made too many
> assumptions about details of space usage and failed on several
> filesystems (it passed on xfs, but only by accident).
> 
> This new version tries to leave about 256k free, then tries
> a single 1M IO, and fails only if 0 bytes are written.
> 
> It also sends a lot more to $seq.full for debugging on failure
> and fixes a few other stylistic things.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

I just had another thought about this, Eric....

> +# And at least some of it should succeed.
> +_filesize=`du $SCRATCH_MNT/tmp1 | awk '{print $1}'`
> +[ $_filesize -eq 0 ] && _fail "write file err: Partial write until enospc failed; wrote 0 bytes."

The question that just came to mind was this assumes that allocation
succeeded so therefore the partial write succeeded. But that's not
necessary the case. The partial write might not succeed leaving the
file size as zero, but the underlying FS might not remove all the
blocks it allocated (nothing says that it has to). Hence to
determine if a partial write succeeded, we also need to check that
the file size itself is greater than zero....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
