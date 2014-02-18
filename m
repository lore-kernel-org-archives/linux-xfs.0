Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id D0A337FB8
	for <xfs@oss.sgi.com>; Tue, 18 Feb 2014 03:09:55 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 9819F8F804B
	for <xfs@oss.sgi.com>; Tue, 18 Feb 2014 01:09:55 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id FAp60CbFqIBpwjZW for
	<xfs@oss.sgi.com>; Tue, 18 Feb 2014 01:09:54 -0800 (PST)
Date: Tue, 18 Feb 2014 10:09:48 +0100 (CET)
From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH 0/6][RFC] Introduce FALLOC_FL_ZERO_RANGE flag for fallocate
In-Reply-To: <20140218083324.GB28666@dastard>
Message-ID: <alpine.LFD.2.00.1402181006250.2216@localhost.localdomain>
References: <1392649703-10772-1-git-send-email-lczerner@redhat.com>
	<20140218010138.GE13997@dastard> <20140218083324.GB28666@dastard>
MIME-Version: 1.0
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
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, tytso@mit.edu, xfs@oss.sgi.com

On Tue, 18 Feb 2014, Dave Chinner wrote:

> Date: Tue, 18 Feb 2014 19:33:24 +1100
> From: Dave Chinner <david@fromorbit.com>
> To: Lukas Czerner <lczerner@redhat.com>
> Cc: linux-ext4@vger.kernel.org, tytso@mit.edu, linux-fsdevel@vger.kernel.org,
>     xfs@oss.sgi.com
> Subject: Re: [PATCH 0/6][RFC] Introduce FALLOC_FL_ZERO_RANGE flag for
>     fallocate
> 
> On Tue, Feb 18, 2014 at 12:01:38PM +1100, Dave Chinner wrote:
> > On Mon, Feb 17, 2014 at 04:08:17PM +0100, Lukas Czerner wrote:
> > > Introduce new FALLOC_FL_ZERO_RANGE flag for fallocate. This has the same
> > > functionality as xfs ioctl XFS_IOC_ZERO_RANGE.
> > > 
> > > It can be used to convert a range of file to zeros preferably without
> > > issuing data IO. Blocks should be preallocated for the regions that span
> > > holes in the file, and the entire range is preferable converted to
> > > unwritten extents - even though file system may choose to zero out the
> > > extent or do whatever which will result in reading zeros from the range
> > > while the range remains allocated for the file.
> > > 
> > > This can be also used to preallocate blocks past EOF in the same way as
> > > with fallocate. Flag FALLOC_FL_KEEP_SIZE which should cause the inode
> > > size to remain the same.
> > > 
> > > You can test this feature yourself using xfstests, of fallocate(1) however
> > > you'll need patches for util_linux, xfsprogs and xfstests which you
> > > can find here:
> > > 
> > > http://people.redhat.com/lczerner/zero_range/
> > > 
> > > I'll post the patches after we agree and merge the kernel functionality.
> > > 
> > > I tested this mostly with a subset of xfstests using fsx and fsstress and
> > > even with new generic/290 which is just a copy of xfs/290 usinz fzero
> > > command for xfs_io instead of zero (which uses ioctl). I was testing on
> > > x86_64 and ppc64 with block sizes of 1024, 2048 and 4096.
> > 
> > You also want to convert xfs/242 to be a generic test - it uses the
> > _generic_test_punch helper to test all the corner cases across
> > different extent type transitions.

That was the plan originally, however it uses xfs bmap which is not
supported for other file systems. But I can take a better look and
possibly port it to generic as well.

> > 
> > > ./check generic/076 generic/232 generic/013 generic/070 generic/269 generic/083 generic/117 generic/068 generic/231 generic/127 generic/091 generic/075 generic/112 generic/263 generic/091 generic/075 generic/256 generic/255 generic/316 generic/300 generic/290;
> 
> FWIW. if that's a group of tests you consider good for testing
> extent tree modifications, then can you create a test group for
> these by adding "extent" to each of the tests in the group file?

I've made patches adding support for FALLOC_FL_ZERO_RANGE into fsx
and fsstress so those tests are mostly tests which are using fsx and
fsstress.

It would require more careful look to identify tests which are
useful for extent tree modification. I'll see what I can do.
> 
> Cheers,
> 
> Dave.
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
