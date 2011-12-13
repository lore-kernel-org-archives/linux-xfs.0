Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pBD2laJC134057 for <xfs@oss.sgi.com>; Mon, 12 Dec 2011 20:47:36 -0600
Received: from ipmail04.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id CABB21B451F0
	for <xfs@oss.sgi.com>; Mon, 12 Dec 2011 18:36:55 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	FOJra66KkGKLzj2c for <xfs@oss.sgi.com>;
	Mon, 12 Dec 2011 18:36:55 -0800 (PST)
Date: Tue, 13 Dec 2011 13:36:48 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 08/12] repair: handle filesystems with the log in
	allocation group 0
Message-ID: <20111213023648.GB14273@dastard>
References: <20111202174619.179530033@bombadil.infradead.org>
	<20111202174742.515301323@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20111202174742.515301323@bombadil.infradead.org>
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

On Fri, Dec 02, 2011 at 12:46:27PM -0500, Christoph Hellwig wrote:
> Sindre Skogen reported that repair chokes on a very small filesystem created
> by mkfs.xfs from xfsprogs 2.9.4.  It turned out that for some reason this
> filesystem had the log in allocation group 0 and thus repairs validation
> of the root inode number was off.  Fix this by adding the log blocks if
> the log is allocated in allocation group 0.
> 
> Reported-by: Sindre Skogen <sindre@workzone.no>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good - handling all occurrences of the log in AG 0 is much
nicer.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
