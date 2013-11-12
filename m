Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 55D807F82
	for <xfs@oss.sgi.com>; Tue, 12 Nov 2013 11:36:58 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 3F0018F8049
	for <xfs@oss.sgi.com>; Tue, 12 Nov 2013 09:36:58 -0800 (PST)
Date: Tue, 12 Nov 2013 09:36:56 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v4] xfs: fix unlock in xfs_bmap_add_attrfork
Message-ID: <20131112173656.GE19554@infradead.org>
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

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
