Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q85LXUYx135611 for <xfs@oss.sgi.com>; Wed, 5 Sep 2012 16:33:30 -0500
Date: Wed, 5 Sep 2012 16:34:26 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 11/10] xfstests: rework large filesystem testing - add
	golden output
Message-ID: <20120905213426.GL3274@sgi.com>
References: <20120831194326.741195404@sgi.com>
	<1343291989-14987-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1343291989-14987-1-git-send-email-david@fromorbit.com>
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
To: rjohnston@sgi.com
Cc: xfs@oss.sgi.com

Hey Rich,

On Fri, Aug 31, 2012 at 02:43:27PM -0500, rjohnston@sgi.com wrote:
> Patch "rework large filesystem testing" introduces a new option --large-fs
> which creates a new file $SCRATCH_MNT/.use_space.  If this 10 part patchset is
> applied, the following tests will fail:
> 	019 026 027 028 046 047 050 056 059 060 062 063 064 065 066
> 
> This patch accounts for the following new output when testing xfs filesystems with
> the --large-fs option by creating new output file to compare against
> ($seq.largefs.out):
> 
> 1. The following four lines appear in test 019. 
> 	 File: "./.use_space"
> 	 Size: 6312890368 Filetype: Regular File
> 	Mode: (0600/-rw-------) Uid: (0) Gid: (0)
> 	Device: <DEVICE> Inode: <INODE> Links: 1
> 
> 2. When the nodump attribute is set, the xfsdump -e option will cause the
>    following additional lines to appear.
> 	xfsdump: NOTE: pruned 1 files: skip attribute set
> 	Only in SCRATCH_MNT: .use_space
> 	SCRATCH_MNT/.use_space
> 
> 3. Number of files off by one.
> 	xfsrestore: # directories and (off by 1) entries processed
> 	[ROOT] 0 0 0 00 [--------] (off by 1) 0 0 00 [--------] 0 0 0 00 [--------]
> 
> This patch also modifies check and common.quota to use the new output file
> $seq.largefs.out when the --large-fs option is used (LARGE_SCRATCH_DEV = yes)
> or  $seq.out when the --large-fs option is NOT used (LARGE_SCRATCH_DEV != yes).
> 
> Signed-off-by: Rich Johnston <rjohnston@sgi.com>

This looks pretty good to me.  .use_space changed some golden output and you've
fixed that up by adding additional output files for when this --large-fs option
is used.  Dave will probably want to take a look too.

Reviewed-by: Ben Myers <bpm@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
