Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p65Mat6e044817 for <xfs@oss.sgi.com>; Tue, 5 Jul 2011 17:36:55 -0500
Subject: Re: [PATCH 13/27] xfs: cleanup shortform directory inode number
	handling
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20110701094604.976400061@bombadil.infradead.org>
References: <20110701094321.936534538@bombadil.infradead.org>
	<20110701094604.976400061@bombadil.infradead.org>
Date: Tue, 5 Jul 2011 17:36:53 -0500
Message-ID: <1309905413.1950.55.camel@doink>
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
> Refactor the shortform directory helpers that deal with the 32-bit vs
> 64-bit wide inode numbers into more sensible helpers, and kill the
> xfs_intino_t typedef that is now superflous.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Dave Chinner <dchinner@redhat.com>

Looking at XFS_{GET,PUT}_DIR_INO{4,8}(), they could
maybe benefit from conversion to cpu_to_be32() and
friends.  They're only used in these few spots.

Looks good though.

Reviewed-by: Alex Elder <aelder@sgi.com>



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
