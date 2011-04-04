Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p34IB1wa179163 for <xfs@oss.sgi.com>; Mon, 4 Apr 2011 13:11:01 -0500
Subject: Re: [PATCH] xfs: fix xfs_debug warnings
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20110402181340.GA12639@infradead.org>
References: <20110402181340.GA12639@infradead.org>
Date: Mon, 04 Apr 2011 13:13:23 -0500
Message-ID: <1301940803.2630.58.camel@doink>
Mime-Version: 1.0
Reply-To: aelder@sgi.com
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Sat, 2011-04-02 at 14:13 -0400, Christoph Hellwig wrote:
> For a CONFIG_XFS_DEBUG=n build gcc complains about statements with no
> effect in xfs_debug:
> 
> fs/xfs/quota/xfs_qm_syscalls.c: In function 'xfs_qm_scall_trunc_qfiles':
> fs/xfs/quota/xfs_qm_syscalls.c:291:3: warning: statement with no effect
> 
> The reason for that is that the various new xfs message functions have a
> return value which is never used, and in case of the non-debug build
> xfs_debug the macro evaluates to a plain 0 which produces the above
> warnings.  This can be fixed by turning xfs_debug into an inline function
> instead of a macro, but in addition to that I've also changed all the
> message helpers to return void as we never use their return values.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good.

Reviewed-by: Alex Elder <aelder@sgi.com>

. . .

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
