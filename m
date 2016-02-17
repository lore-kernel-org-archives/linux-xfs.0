Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 76F897CA4
	for <xfs@oss.sgi.com>; Wed, 17 Feb 2016 14:05:00 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 579DC8F8033
	for <xfs@oss.sgi.com>; Wed, 17 Feb 2016 12:04:57 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id oh1WgLh2NKTOoqVT (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 17 Feb 2016 12:04:56 -0800 (PST)
Date: Wed, 17 Feb 2016 15:04:54 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 0/4] xfs: fixes for XFS_DIFLAG2_DAX support
Message-ID: <20160217200454.GC4065@bfoster.bfoster>
References: <1455513734-15192-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1455513734-15192-1-git-send-email-david@fromorbit.com>
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
Cc: ross.zwisler@linux.intel.com, jack@suse.cz, xfs@oss.sgi.com

On Mon, Feb 15, 2016 at 04:22:10PM +1100, Dave Chinner wrote:
> Hi folks,
> 
> This is a series to add the correct constraints to using the on-disk
> inode flag to enable DAX on per-file basis. The same constraints are
> placed on setting the flag on directories for inheritance purposes.
> 
> These constraints are:
> 	- the inode flag is limited to regular files or directory
> 	  inodes.
> 	- the S_DAX flag is only ever set on regular files
> 	- the flag can only ever be set on filesystems which have
> 	  blocksize == PAGE_SIZE (for now)
> 	- When the flag is set or cleared, the current mapping
> 	  contents are flushed and then invalidated so that the new
> 	  access mode starts with an empty mapping.
> 	- Setting or clearing the flag is atomic w.r.t. IO and
> 	  page faults.
> 
> I've tested these manually with xfs_io (patchset for supporting
> chattr +x/-x to be sent soon), and it all appears to work as
> expected. I'd like to push these for 4.5-rc6 so the initial kernel
> with support for this flag doesn't do silly things, so comments,
> testing and review woul dbe appreciated.
> 

The commit log description for patch 3 (v2) looks like it needs to be
fixed up (multiple title lines and extraneous From: header), but
otherwise the series looks good to me:

Reviewed-by: Brian Foster <bfoster@redhat.com>

> Cheers,
> 
> Dave.
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
