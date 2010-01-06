Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o06GmrdX095149 for <xfs@oss.sgi.com>; Wed, 6 Jan 2010 10:48:53 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B2E73ED8067
	for <xfs@oss.sgi.com>; Wed,  6 Jan 2010 08:49:45 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id 4XbGzUuY1eSBmZE9 for
	<xfs@oss.sgi.com>; Wed, 06 Jan 2010 08:49:45 -0800 (PST)
Date: Wed, 6 Jan 2010 11:49:44 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfstests: add another fallocate test to 214
Message-ID: <20100106164944.GA20137@infradead.org>
References: <4B427731.9080801@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4B427731.9080801@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>
Cc: ext4 development <linux-ext4@vger.kernel.org>, Theodore Tso <tytso@mit.edu>, xfs mailing list <xfs@oss.sgi.com>

On Mon, Jan 04, 2010 at 05:18:09PM -0600, Eric Sandeen wrote:
> ext4 had a regression where it double-accounted used blocks
> if you fallocated on top of delalloc blocks.  Ted sent a
> c program to exploit it (see "fsstress-induced corruption reproduced"
> on linux-ext4 on 12/31/2009) and it's trivial to do the same thing
> within the xfstests framework using xfs_io.
> 
> This also changes the handcrafted xfs_io tests to use the
> _require_xfs_io_falloc helper, not sure how that got missed.

Looks good,


Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
