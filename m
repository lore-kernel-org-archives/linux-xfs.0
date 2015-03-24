Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 155057F47
	for <xfs@oss.sgi.com>; Tue, 24 Mar 2015 14:41:22 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id EFFC48F8033
	for <xfs@oss.sgi.com>; Tue, 24 Mar 2015 12:41:21 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id ZDAPA7suha9BtoK0 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 24 Mar 2015 12:41:21 -0700 (PDT)
Date: Tue, 24 Mar 2015 15:41:18 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 0/5 V2] xfs: RENAME_WHITEOUT support
Message-ID: <20150324194117.GA15973@bfoster.bfoster>
References: <1427194771-3105-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1427194771-3105-1-git-send-email-david@fromorbit.com>
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

On Tue, Mar 24, 2015 at 09:59:26PM +1100, Dave Chinner wrote:
> Hi folks,
> 
> This is the second version of the RENAME_WHITEOUT patchset that I
> originally posted here:
> 
> http://oss.sgi.com/pipermail/xfs/2015-February/040378.html
> 
> This is mainly the breakup and restructuring of the patchset I
> mention that needed to be done, as well as addressing the comments
> that were made at the time (e.g. wino -> wip).
> 
> The patchset has been split into 5 patches, the first four are
> really cleanup and factoring patches to make the rename and inode
> locking code a bit simpler and easier to understand. The last patch
> then introduces the RENAME_WHITEOUT functionality, which ends up
> being surprisingly little code....
> 
> The changes pass xfstests, but I have not run them on overlayfs at
> all yet, so I don't know if that's going to result in smoke and
> tears yet. Still, getting the patch set out for review now is more
> important that waiting for testing because there is relatively
> little time left before the 4.1 merge window opens up....
> 
> So, comments, thoughts and flames are more than welcome.
> 

These all look pretty good to me. I ran a quick rename test on top of
overlayfs as well and it seems to do what it's supposed to (e.g., rename
of a file on the lower dir is hidden via whiteout on the upper). For the
set...

Reviewed-by: Brian Foster <bfoster@redhat.com>

> -Dave.
> 
> Diffstat:
> 
> fs/xfs/xfs_inode.c | 408 ++++++++++++++++++++++++++++++++-----------------------
> fs/xfs/xfs_iops.c  |   2 +-
> 2 files changed, 239 insertions(+), 171 deletions(-)
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
