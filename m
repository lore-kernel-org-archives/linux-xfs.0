Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 3E95C7F53
	for <xfs@oss.sgi.com>; Sun, 23 Feb 2014 23:28:19 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 1EED1304059
	for <xfs@oss.sgi.com>; Sun, 23 Feb 2014 21:28:19 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	Wypsi6PMLGZP416E for <xfs@oss.sgi.com>;
	Sun, 23 Feb 2014 21:28:17 -0800 (PST)
Date: Mon, 24 Feb 2014 16:28:02 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfstests: add test btrfs/042 for btrfs incremental send
Message-ID: <20140224052801.GK4317@dastard>
References: <1392940976-1790-1-git-send-email-fdmanana@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1392940976-1790-1-git-send-email-fdmanana@gmail.com>
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
To: Filipe David Borba Manana <fdmanana@gmail.com>
Cc: linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

On Fri, Feb 21, 2014 at 12:02:56AM +0000, Filipe David Borba Manana wrote:
> Regression test for a btrfs incremental send issue where invalid paths for
> utimes, chown and chmod operations were sent to the send stream, causing
> btrfs receive to fail.
> 
> If a directory had a move/rename operation delayed, and none of its parent
> directories, except for the immediate one, had delayed move/rename operations,
> after processing the directory's references, the incremental send code would
> issue invalid paths for utimes, chown and chmod operations.
> 
> This issue is fixed by the following linux kernel btrfs patch:
> 
>    Btrfs: fix send issuing outdated paths for utimes, chown and chmod
> 
> Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
....
> +FSSUM_PROG=$here/src/fssum
> +[ -x $FSSUM_PROG ] || _notrun "fssum not built"

Helper...

.....
> +_scratch_unmount
> +_check_btrfs_filesystem $SCRATCH_DEV

And _check_scratch_fs....

> +_scratch_mkfs >/dev/null 2>&1
> +_scratch_mount
> +
> +_run_btrfs_util_prog receive $SCRATCH_MNT -f $tmp/1.snap
> +run_check $FSSUM_PROG -r $tmp/1.fssum $SCRATCH_MNT/mysnap1 2>> $seqres.full
> +
> +_run_btrfs_util_prog receive $SCRATCH_MNT -f $tmp/2.snap
> +run_check $FSSUM_PROG -r $tmp/2.fssum $SCRATCH_MNT/mysnap2 2>> $seqres.full

And the redirection....

I'm happy to see you write your tests consistently, Filipe :)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
