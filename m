Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n8QH34qm252323 for <xfs@oss.sgi.com>; Sat, 26 Sep 2009 12:03:07 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D8941481915
	for <xfs@oss.sgi.com>; Sat, 26 Sep 2009 10:04:24 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id QZAsMCSQBrlEjEJ7 for
	<xfs@oss.sgi.com>; Sat, 26 Sep 2009 10:04:24 -0700 (PDT)
Date: Sat, 26 Sep 2009 13:04:23 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH V2] fix readahead calculations in xfs_dir2_leaf_getdents()
Message-ID: <20090926170423.GA28387@infradead.org>
References: <4ABA5192.80509@sandeen.net> <4ABD1D22.2030002@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4ABD1D22.2030002@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: tobias@lists.yoper.com, xfs mailing list <xfs@oss.sgi.com>

On Fri, Sep 25, 2009 at 02:42:26PM -0500, Eric Sandeen wrote:
> V2: use min() as suggested by Jeff, it's tidier.

I disagree with that, with the cast it looks pretty horrible.
At least use min_t to avoid the case, but what's wrong with:

> +		/* bufsize may have just been a guess; don't go negative */
> +		bufsize = min((bufsize - length), (size_t)0);

		bufsize = bufsize - length > 0 ? bufsize - length : 0;

Anyway, takes this as a


Reviewed-by: Christoph Hellwig <hch@lst.de>

for any variant.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
