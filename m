Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id DE35E29E04
	for <xfs@oss.sgi.com>; Mon, 18 Nov 2013 14:31:15 -0600 (CST)
Date: Mon, 18 Nov 2013 14:31:12 -0600
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH v4] xfs: fix unlock in xfs_bmap_add_attrfork
Message-ID: <20131118203112.GI1935@sgi.com>
References: <20131107204358.901127238@.sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131107204358.901127238@.sgi.com>
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
To: Mark Tinguely <tinguely@sgi.com>
Cc: xfs@oss.sgi.com


On Thu, Nov 07, 2013 at 03:43:28PM -0600, Mark Tinguely wrote:
> xfs_trans_ijoin() activates the inode in a transaction and
> also can specify which lock to free when the transaction is
> committed or canceled.
> 
> xfs_bmap_add_attrfork call locks and adds the lock to the
> transaction but also manually removes the lock. Change the
> routine to not add the lock to the transaction and manually
> remove lock on completion.
> 
> While here, clean up the xfs_trans_cancel flags and goto names.
> 
> Signed-off-by: Mark Tinguely <tinguely@sgi.com>

Applied.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
