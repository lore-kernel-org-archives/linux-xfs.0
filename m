Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p954A2HV084236 for <xfs@oss.sgi.com>; Tue, 4 Oct 2011 23:10:02 -0500
Subject: Re: [PATCH] xfs: simplify xfs_trans_ijoin* again
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20110919150054.GA21382@infradead.org>
References: <20110919150054.GA21382@infradead.org>
Date: Tue, 4 Oct 2011 23:09:57 -0500
Message-ID: <1317787797.2270.11.camel@doink>
MIME-Version: 1.0
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

On Mon, 2011-09-19 at 11:00 -0400, Christoph Hellwig wrote:
> There is no reason to keep a reference to the inode even if we unlock
> it during transaction commit because we never drop a reference between
> the ijoin and commit.  Also use this fact to merge xfs_trans_ijoin_ref
> back into xfs_trans_ijoin - the third argument decides if an unlock
> is needed now.
> 
> I'm actually starting to wonder if allowing inodes to be unlocked
> at transaction commit really is worth the effort.  The only real
> benefit is that they can be unlocked earlier when commiting a
> synchronous transactions, but that could be solved by doing the
> log force manually after the unlock, too.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good.

Reviewed-by: Alex Elder <aelder@sgi.com>


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
