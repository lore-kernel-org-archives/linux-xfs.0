Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q5IETd9g194655 for <xfs@oss.sgi.com>; Mon, 18 Jun 2012 09:29:39 -0500
Message-ID: <4FDF3B4F.7050901@sgi.com>
Date: Mon, 18 Jun 2012 09:29:35 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs: check for stale inode before acquiring iflock on push
References: <1339425583-54949-1-git-send-email-bfoster@redhat.com>
In-Reply-To: <1339425583-54949-1-git-send-email-bfoster@redhat.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

On 06/11/12 09:39, Brian Foster wrote:
> An inode in the AIL can be flush locked and marked stale if
> a cluster free transaction occurs at the right time. The
> inode item is then marked as flushing, which causes xfsaild
> to spin and leaves the filesystem stalled. This is
> reproduced by running xfstests 273 in a loop for an
> extended period of time.
>
> Check for stale inodes before the flush lock. This marks
> the inode as pinned, leads to a log flush and allows the
> filesystem to proceed.
>
> Signed-off-by: Brian Foster<bfoster@redhat.com>
> ---
>
> This patch resolves the stall I was reproducing with the 273 loop test.
> I repeated the test pretty much throughout the weekend. I still hit one
> hung task timeout message, but the test proceeded through it.
>
> Dave, I know you mentioned you were sending a similar patch. Either you
> didn't get to it or I missed it, but here's what I've been testing....
>
> Brian
>
>   fs/xfs/xfs_inode_item.c |   17 ++++++++---------
>   1 files changed, 8 insertions(+), 9 deletions(-)
>

Your patch looks good. Considered it also:

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

As far as problem 2. Small logs can still get stuck. I have seen
hang B in 576K-1MB sized logs, I have not larger logs hard enough
to see where the problem will start to occur.

A) Test like the problem replicator
       (http://oss.sgi.com/bugzilla/show_bug.cgi?id=922)
    will quickly hang because the test can get into a situation where
    there are no new transactions to push the AIL and the sync
    worker's allocation of the dummy transaction is hung behind these
    requests.

    This is mostly a limit of the test. Any filesystem activity that is
    not related to the test will restart the filesystem. My earlier
    posted patch that restarts the AIL cleaning when there are still
    waiters after the last tail move will help this situation.

B) Keep pushing the log long enough and there will be a hard hang with
    an empty AIL
  1) Large request for log. (typically about 340K)
   a) some free space but not enough for first request
  2) AIL is empty
  3) Remaining space (not quite half the log) is in CIL
   a) current CTX is too small for passive CIL push (just less than log
      size / 8)
   b) remaining space is in the current CTX ticket and a previously
      pushed CTX sequence.
     i) No leaks.
     ii) I have not worked out why the previously pushed CTX has not
        been written out. The iclog looks unlocked and ACTIVE.
  4) The sync worker is blocked on the dummy transaction allocation and
     cannot not push the CIL again.

Sorry this machine will not kdump.

--Mark Tinguely

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
