Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 1FA6B29DF8
	for <xfs@oss.sgi.com>; Thu,  9 May 2013 10:57:16 -0500 (CDT)
Message-ID: <518BC761.6050208@sgi.com>
Date: Thu, 09 May 2013 10:57:21 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: Rambling noise #1: generic/230 can trigger kernel debug lock
	detector
References: <518B08D9.1060906@gmail.com> <20130509031646.GN24635@dastard>
In-Reply-To: <20130509031646.GN24635@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: "Michael L. Semon" <mlsemon35@gmail.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On 05/08/13 22:16, Dave Chinner wrote:
> xfs: avoid nesting transactions in xfs_qm_scall_setqlim()
>
> From: Dave Chinner<dchinner@redhat.com>
>
> Lockdep reports:
>
> =============================================
> [ INFO: possible recursive locking detected ]
> 3.9.0+ #3 Not tainted
> ---------------------------------------------
> setquota/28368 is trying to acquire lock:
>   (sb_internal){++++.?}, at: [<c11e8846>] xfs_trans_alloc+0x26/0x50
>
> but task is already holding lock:
>   (sb_internal){++++.?}, at: [<c11e8846>] xfs_trans_alloc+0x26/0x50
>
> from xfs_qm_scall_setqlim()->xfs_dqread() when a dquot needs to be
> allocated.
>
> xfs_qm_scall_setqlim() is starting a transaction and then not
> passing it into xfs_qm_dqet() and so it starts it's own transaction
> when allocating the dquot.  Splat!
>
> Fix this by not allocating the dquot in xfs_qm_scall_setqlim()
> inside the setqlim transaction. This requires getting the dquot
> first (and allocating it if necessary) then dropping and relocking
> the dquot before joining it to the setqlim transaction.
>
> Reported-by: Michael L. Semon<mlsemon35@gmail.com>
> Signed-off-by: Dave Chinner<dchinner@redhat.com>
> ---
>   fs/xfs/xfs_qm_syscalls.c |   35 ++++++++++++++++++++---------------
>   1 file changed, 20 insertions(+), 15 deletions(-)

Looks good.

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
