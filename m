Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p9BMavBc025467 for <xfs@oss.sgi.com>; Tue, 11 Oct 2011 17:36:57 -0500
Received: from ipmail05.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1A6E71BD840
	for <xfs@oss.sgi.com>; Tue, 11 Oct 2011 15:36:56 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	BsB3lrykcxS8nByJ for <xfs@oss.sgi.com>;
	Tue, 11 Oct 2011 15:36:56 -0700 (PDT)
Date: Wed, 12 Oct 2011 09:36:54 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/3] xfstests: fix 122 for recent xfsprogs
Message-ID: <20111011223654.GF3159@dastard>
References: <20111010182156.GA1323@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20111010182156.GA1323@infradead.org>
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

On Mon, Oct 10, 2011 at 02:21:56PM -0400, Christoph Hellwig wrote:
>  - filter out xfs_alloctype_t, this was an internal emum that got removed
>  - filter out xfs_bmbt_rec_32_t, this is a variant of the xfs_bmbt_rec_t
>    that had almost no users and was removed
>  - filter out xfs_dinode_core_t, the separate dinode core is gone, and just
>    checking the size of the full dinode is enough
>  - accept xfs_bmbt_rec_t as the new canonical name for xfs_bmbt_rec_64_t,
>    and replace the old name with the new one in the output stream.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
