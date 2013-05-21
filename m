Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id E21DE7F4C
	for <xfs@oss.sgi.com>; Mon, 20 May 2013 19:34:06 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id CB9AF304032
	for <xfs@oss.sgi.com>; Mon, 20 May 2013 17:34:06 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	rXUUrvhK4dAGsntj for <xfs@oss.sgi.com>;
	Mon, 20 May 2013 17:34:05 -0700 (PDT)
Date: Tue, 21 May 2013 10:33:26 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfstests: btrfs 308: regression test for btrfs send
Message-ID: <20130521003326.GJ24543@dastard>
References: <1369070434-20852-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1369070434-20852-1-git-send-email-jbacik@fusionio.com>
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
To: Josef Bacik <jbacik@fusionio.com>
Cc: linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

On Mon, May 20, 2013 at 01:20:34PM -0400, Josef Bacik wrote:
> I'm not sure how the numbering is supposed to work now that we've split
> everything out so I'm just going with the next number in the directory.  This is
> a regression test for btrfs send, we had a problem where we'd try to send a file
> that had been deleted in the source snapshot.  This is just to make sure we
> don't have the same problem in the future.  Thanks,

You are holding open an unlinked file? You want to use
src/multi_open_unlink, then.

/*
 * multi_open_unlink path_prefix num_files sleep_time
 * e.g.
 *   $ multi_open_unlink file 100 60
 *   Creates 100 files: file.1, file.2, ..., file.100
 *   unlinks them all but doesn't close them all until after 60 seconds.
 */

If you need to hold open existing files, add support for that into
multi_open_unlink.c (i.e. allow it to ignore EEXIST when trying to
create files).

> +# need this so that tail doesn't error out racing with the rm
> +sleep 1
> +rm -f $SCRATCH_MNT/foo
> +$BTRFS_UTIL_PROG subvol snap -r $SCRATCH_MNT $SCRATCH_MNT/snap1 > /dev/null 2>&1
> +$BTRFS_UTIL_PROG send -f /dev/null -p $SCRATCH_MNT/snap $SCRATCH_MNT/snap1 >/dev/null 2>&1

I'd send this output to $seqres.full, so if the test fails there's
debug output to look at...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
