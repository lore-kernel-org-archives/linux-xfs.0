Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nB2F4l6t007664 for <xfs@oss.sgi.com>; Wed, 2 Dec 2009 09:04:47 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id AA044190FA85
	for <xfs@oss.sgi.com>; Wed,  2 Dec 2009 07:05:18 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id RDlCT0sSTR0UkpR9 for
	<xfs@oss.sgi.com>; Wed, 02 Dec 2009 07:05:18 -0800 (PST)
Date: Wed, 2 Dec 2009 10:05:17 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfstests: fix for lazy-sb
Message-ID: <20091202150517.GB16338@infradead.org>
References: <4B156ED2.9000209@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4B156ED2.9000209@sandeen.net>
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
Cc: xfs-oss <xfs@oss.sgi.com>

On Tue, Dec 01, 2009 at 01:30:26PM -0600, Eric Sandeen wrote:
> Fix tests which would be affected by a change to lazy-sb
> by default.
> 
> All tests now explicitly -specify- -l lazy-sb=1 where appropriate,
> so this can go in prior to a userspace change.
> 
> Unfortunately many of the logprint outputs must just be taken on faith.
> 
> Also, the irix flavors for e.g. 018.op.irix will need fixing up
> if anyone cares.
> 
> This also needs the patch I just sent for xfs_db clearing attr2
> in bad_features2 to complete w/o error.
> 
> Signed-off-by: Eric Sandeen <sandeen@sandeen.net>

Looks good to me,

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
