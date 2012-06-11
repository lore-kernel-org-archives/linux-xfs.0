Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q5BIdVFb124785 for <xfs@oss.sgi.com>; Mon, 11 Jun 2012 13:39:31 -0500
Message-ID: <4FD63B60.3070708@sgi.com>
Date: Mon, 11 Jun 2012 13:39:28 -0500
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


Still hangs right away on Linux 3.5rc1 using a very small log and the 
perl test program.

I will investigate more.

Darn, the printk routines in Linux 3.5 added a "struct log" and crash is 
finding that definition.

--Mark.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
