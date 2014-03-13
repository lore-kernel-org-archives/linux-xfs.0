Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 70C9C7FA0
	for <xfs@oss.sgi.com>; Thu, 13 Mar 2014 05:15:08 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 515818F8039
	for <xfs@oss.sgi.com>; Thu, 13 Mar 2014 03:15:08 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id TuArwcGGnpY4hbCl for
	<xfs@oss.sgi.com>; Thu, 13 Mar 2014 03:15:07 -0700 (PDT)
Date: Thu, 13 Mar 2014 11:14:59 +0100 (CET)
From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH 0/6 v2] Introduce FALLOC_FL_ZERO_RANGE flag for fallocate
In-Reply-To: <20140313084936.GF4263@dastard>
Message-ID: <alpine.LFD.2.00.1403131113090.2114@localhost.localdomain>
References: <1393355679-11160-1-git-send-email-lczerner@redhat.com>
	<20140313084936.GF4263@dastard>
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

On Thu, 13 Mar 2014, Dave Chinner wrote:

> Date: Thu, 13 Mar 2014 19:49:36 +1100
> From: Dave Chinner <david@fromorbit.com>
> To: Lukas Czerner <lczerner@redhat.com>
> Cc: linux-ext4@vger.kernel.org, tytso@mit.edu, linux-fsdevel@vger.kernel.org,
>     xfs@oss.sgi.com
> Subject: Re: [PATCH 0/6 v2] Introduce FALLOC_FL_ZERO_RANGE flag for fallocate
> 
> On Tue, Feb 25, 2014 at 08:14:33PM +0100, Lukas Czerner wrote:
> > Introduce new FALLOC_FL_ZERO_RANGE flag for fallocate. This has the same
> > functionality as xfs ioctl XFS_IOC_ZERO_RANGE.
> > 
> > It can be used to convert a range of file to zeros preferably without
> > issuing data IO. Blocks should be preallocated for the regions that span
> > holes in the file, and the entire range is preferable converted to
> > unwritten extents - even though file system may choose to zero out the
> > extent or do whatever which will result in reading zeros from the range
> > while the range remains allocated for the file.
> > 
> > This can be also used to preallocate blocks past EOF in the same way as
> > with fallocate. Flag FALLOC_FL_KEEP_SIZE which should cause the inode
> > size to remain the same.
> > 
> > You can test this feature yourself using xfstests, of fallocate(1) however
> > you'll need patches for util_linux, xfsprogs and xfstests which are going to
> > follow soon.
> > 
> > I tested this mostly with a subset of xfstests using fsx and fsstress and
> > even with new generic/290 which is just a copy of xfs/290 using fzero
> > command for xfs_io instead of zero (which uses ioctl). I was testing on
> > x86_64 and ppc64 with block sizes of 1024, 2048 and 4096.
> > 
> > ./check generic/076 generic/232 generic/013 generic/070 generic/269 generic/083
> > generic/117 generic/068 generic/231 generic/127 generic/091 generic/075
> > generic/112 generic/263 generic/091 generic/075 generic/256 generic/255
> > generic/316 generic/300 generic/290 ext4/242;
> > 
> > Note that there is a work in progress on FALLOC_FL_COLLAPSE_RANGE which
> > touches the same area as this pach set does, so we should figure out
> > which one should go first and modify the other on top of it.
> > 
> > This has been based on top of xfs-collapse-range so it does not contain ext4
> > collapse range changes.
> 
> Lukas, I have merged patches 4 and 6 into the xfs-collapse-branch.
> That branch should now remain stable, so you can rebase all the ext4
> collapse range and zero range bits on top of tha branch and Ted can
> pull it into the ext4 tree if he wants to pull it in.
> 
> Cheers,
> 
> Dave.

Hi Dave,

that's great thanks! Btw you probably meant branch
xfs-collapse-range and those patches are already based on that
branch so it should apply cleanly. Now we have to figure out the
order in which we're going to take zero-range and collapse-range
into ext4.

Thanks!
-Lukas

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
