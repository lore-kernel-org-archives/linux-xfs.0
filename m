Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 3BFDE7F4E
	for <xfs@oss.sgi.com>; Fri, 30 May 2014 14:10:37 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 0BD6F8F8070
	for <xfs@oss.sgi.com>; Fri, 30 May 2014 12:10:36 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id hrAwQtSYlsS8jHv9 for
	<xfs@oss.sgi.com>; Fri, 30 May 2014 12:10:36 -0700 (PDT)
Date: Fri, 30 May 2014 15:05:35 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 00/16 V3] xfs: introduce struct xfs_da_geometry
Message-ID: <20140530190534.GC3146@laptop.bfoster>
References: <1401257083-13433-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1401257083-13433-1-git-send-email-david@fromorbit.com>
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
Cc: xfs@oss.sgi.com

On Wed, May 28, 2014 at 04:04:27PM +1000, Dave Chinner wrote:
> Hi folks, 
> 
> Version three of the patchset first posted here:
> 
> http://oss.sgi.com/pipermail/xfs/2014-May/036125.html
> 
> This version addresses the review comments so far.
> 
> Changelog:
> 
> Version 3:
> - added xfs_da_unmount
> - moved dir2 conversion functions to xfs_dir2_priv.h
> - converted xfs_dir2_readdir.c to use local geo variables
> - added a patch to remove newly redundant geometry fields
>   from the struct xfs_da_state

I don't see this bit anywhere in the series...

Brian

> 
> Version 2:
> - patch removing checks from xfs_da_read_buf() sent separately
> - dropped patch adding xfs_da_geometry to the inode forks as it's
>   not currently needed
> - cleared up all the "XXX" notations added in the RFC series
> - fixed several bugs in different patches as a result of incorrect
>   conversions
> - ensured each patch compiled and passes xfstests individually
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
