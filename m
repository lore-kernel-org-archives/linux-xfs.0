Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 562AF7F3F
	for <xfs@oss.sgi.com>; Wed,  6 Feb 2013 14:25:22 -0600 (CST)
Message-ID: <5112BC31.8040001@sgi.com>
Date: Wed, 06 Feb 2013 14:25:21 -0600
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH v2 2/2] xfs: disable log force in xfs_buf_item_push()
	to avoid xa_lock recursion
References: <1360154681-28246-1-git-send-email-bfoster@redhat.com>
	<1360154681-28246-3-git-send-email-bfoster@redhat.com>
In-Reply-To: <1360154681-28246-3-git-send-email-bfoster@redhat.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

On 02/06/13 06:44, Brian Foster wrote:
> If the trylock fails and the buffer is pinned and stale, the
> resulting xfs_log_force() can lead to lock recursion on the ailp
> xa_lock. Call __xfs_buf_trylock() to attempt the buf lock with
> xa_lock held, but to avoid the log force. If the trylock had raced
> with the buffer being pinned, return XFS_ITEM_PINNED such that
> xfsaild will pend up a log force on the next scan.
>
> Signed-off-by: Brian Foster<bfoster@redhat.com>
> ---
>   fs/xfs/xfs_buf_item.c |   14 +++++++++++++-
>   1 files changed, 13 insertions(+), 1 deletions(-)

Looks good.

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
