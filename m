Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p663lkoC064267 for <xfs@oss.sgi.com>; Tue, 5 Jul 2011 22:47:46 -0500
Subject: Re: [PATCH 22/27] xfs: use generic get_unaligned_beXX helpers
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20110701094606.763430916@bombadil.infradead.org>
References: <20110701094321.936534538@bombadil.infradead.org>
	<20110701094606.763430916@bombadil.infradead.org>
Date: Tue, 5 Jul 2011 22:47:45 -0500
Message-ID: <1309924065.3381.45.camel@doink>
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
> Switch the shortform directory code over to use the generic
> get_unaligned_beXX helpers instead of reinventing them.  As a result
> kill off xfs_arch.h and move the setting of XFS_NATIVE_HOST into
> xfs_linux.h.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Huh, good thinking!  (Just what I suggested in reviewing
patch 13 in this series, but even better.)

Reviewed-by: Alex Elder <aelder@sgi.com>


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
