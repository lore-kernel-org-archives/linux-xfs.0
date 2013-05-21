Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 1A65329DF8
	for <xfs@oss.sgi.com>; Tue, 21 May 2013 13:35:48 -0500 (CDT)
Date: Tue, 21 May 2013 13:35:44 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 01/11] xfs: avoid nesting transactions in
	xfs_qm_scall_setqlim()
Message-ID: <20130521183544.GK20028@sgi.com>
References: <1369123330-9579-1-git-send-email-david@fromorbit.com>
	<1369123330-9579-2-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1369123330-9579-2-git-send-email-david@fromorbit.com>
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

On Tue, May 21, 2013 at 06:02:00PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Lockdep reports:
> 
> =============================================
> [ INFO: possible recursive locking detected ]
> 3.9.0+ #3 Not tainted
> ---------------------------------------------
> setquota/28368 is trying to acquire lock:
>  (sb_internal){++++.?}, at: [<c11e8846>] xfs_trans_alloc+0x26/0x50
> 
> but task is already holding lock:
>  (sb_internal){++++.?}, at: [<c11e8846>] xfs_trans_alloc+0x26/0x50
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
> Reported-by: Michael L. Semon <mlsemon35@gmail.com>
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Looks good.

Reviewed-by: Ben Myers <bpm@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
