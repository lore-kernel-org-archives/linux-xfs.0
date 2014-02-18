Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 92E347FAA
	for <xfs@oss.sgi.com>; Mon, 17 Feb 2014 19:01:51 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 789D7304048
	for <xfs@oss.sgi.com>; Mon, 17 Feb 2014 17:01:48 -0800 (PST)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	gNr3ioIupcLm2FTT for <xfs@oss.sgi.com>;
	Mon, 17 Feb 2014 17:01:43 -0800 (PST)
Date: Tue, 18 Feb 2014 12:01:38 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 0/6][RFC] Introduce FALLOC_FL_ZERO_RANGE flag for fallocate
Message-ID: <20140218010138.GE13997@dastard>
References: <1392649703-10772-1-git-send-email-lczerner@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1392649703-10772-1-git-send-email-lczerner@redhat.com>
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
To: Lukas Czerner <lczerner@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, tytso@mit.edu, xfs@oss.sgi.com

On Mon, Feb 17, 2014 at 04:08:17PM +0100, Lukas Czerner wrote:
> Introduce new FALLOC_FL_ZERO_RANGE flag for fallocate. This has the same
> functionality as xfs ioctl XFS_IOC_ZERO_RANGE.
> 
> It can be used to convert a range of file to zeros preferably without
> issuing data IO. Blocks should be preallocated for the regions that span
> holes in the file, and the entire range is preferable converted to
> unwritten extents - even though file system may choose to zero out the
> extent or do whatever which will result in reading zeros from the range
> while the range remains allocated for the file.
> 
> This can be also used to preallocate blocks past EOF in the same way as
> with fallocate. Flag FALLOC_FL_KEEP_SIZE which should cause the inode
> size to remain the same.
> 
> You can test this feature yourself using xfstests, of fallocate(1) however
> you'll need patches for util_linux, xfsprogs and xfstests which you
> can find here:
> 
> http://people.redhat.com/lczerner/zero_range/
> 
> I'll post the patches after we agree and merge the kernel functionality.
> 
> I tested this mostly with a subset of xfstests using fsx and fsstress and
> even with new generic/290 which is just a copy of xfs/290 usinz fzero
> command for xfs_io instead of zero (which uses ioctl). I was testing on
> x86_64 and ppc64 with block sizes of 1024, 2048 and 4096.

You also want to convert xfs/242 to be a generic test - it uses the
_generic_test_punch helper to test all the corner cases across
different extent type transitions.

> ./check generic/076 generic/232 generic/013 generic/070 generic/269 generic/083 generic/117 generic/068 generic/231 generic/127 generic/091 generic/075 generic/112 generic/263 generic/091 generic/075 generic/256 generic/255 generic/316 generic/300 generic/290;
> 
> Note that there is a work in progress on FALLOC_FL_COLLAPSE_RANGE which
> touches the same area as this pach set does, so we should figure out
> which one should go first and modify the other on top of it.

I was going to push the FALLOC_FL_COLLAPSE_RANGE stuff through
the XFS tree once it was done - perhaps you and Namjae can get
together and work out which order the patch series should go.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
