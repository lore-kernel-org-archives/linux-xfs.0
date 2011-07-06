Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p663cdMU063868 for <xfs@oss.sgi.com>; Tue, 5 Jul 2011 22:38:40 -0500
Subject: Re: [PATCH 19/27] xfs: kill struct xfs_dir2_data
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20110701094606.199361663@bombadil.infradead.org>
References: <20110701094321.936534538@bombadil.infradead.org>
	<20110701094606.199361663@bombadil.infradead.org>
Date: Tue, 5 Jul 2011 22:38:35 -0500
Message-ID: <1309923515.3381.36.camel@doink>
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

On Fri, 2011-07-01 at 05:43 -0400, Christoph Hellwig wrote:
> Remove the confusing xfs_dir2_data structure.  It is supposed to describe
> an XFS dir2 data btree block, but due to the variable sized nature of
> almost all elements in it it can't actuall do anything close to that
> job.  In addition to accessing the fixed offset header structure it was
> only used to get a pointer to the first dir or unused entry after it,
> which can be trivially replaced by pointer arithmetics on the header
> pointer.  For most users that is actually more natural anyway, as they
> don't use a typed pointer but rather a character pointer for further
> arithmetics.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good.  I like the diagrams.

Reviewed-by: Alex Elder <aelder@sgi.com>


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
