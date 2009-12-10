Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nBANNojw125526 for <xfs@oss.sgi.com>; Thu, 10 Dec 2009 17:23:50 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4E2F9195603E
	for <xfs@oss.sgi.com>; Thu, 10 Dec 2009 15:24:26 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id BIjEgEqbF99HpQeH for
	<xfs@oss.sgi.com>; Thu, 10 Dec 2009 15:24:26 -0800 (PST)
Date: Thu, 10 Dec 2009 18:24:26 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 4/6] [XFS] convert remaining direct references to m_perag
Message-ID: <20091210232426.GD6389@infradead.org>
References: <1259734299-20306-1-git-send-email-david@fromorbit.com>
	<1259734299-20306-5-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1259734299-20306-5-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Wed, Dec 02, 2009 at 05:11:37PM +1100, Dave Chinner wrote:
> Convert the remaining direct lookups of the per ag structures
> to use get/put accesses.
> 
> Signed-off-by: Dave Chinner <david@fromorbit.com>
> ---
>  fs/xfs/xfs_bmap.c   |    4 +++-
>  fs/xfs/xfs_ialloc.c |   35 +++++++++++++++++++++++++----------
>  fs/xfs/xfs_mount.c  |    9 ++++++---
>  3 files changed, 34 insertions(+), 14 deletions(-)

Looks correct to me from looking over these sites.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
