Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n75FH46A250985 for <xfs@oss.sgi.com>; Wed, 5 Aug 2009 10:17:10 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0327C1458AEF
	for <xfs@oss.sgi.com>; Wed,  5 Aug 2009 08:17:55 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id oHCxcAp98DBZOaFI for
	<xfs@oss.sgi.com>; Wed, 05 Aug 2009 08:17:55 -0700 (PDT)
Date: Wed, 5 Aug 2009 11:17:50 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/1] XFS: xfs_iformat realtime device target pointer check
Message-ID: <20090805151750.GA16080@infradead.org>
References: <1249329808.7686.26.camel@logos>
	<20090803214929.GB3167@infradead.org>
	<1249351241.7513.18.camel@logos> <4A786110.8090404@sandeen.net>
	<1249411898.7576.19.camel@logos>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1249411898.7576.19.camel@logos>
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
To: Ramon de Carvalho Valle <ramon@risesecurity.org>
Cc: Eric Sandeen <sandeen@sandeen.net>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, mszeredi@novell.com, hch@lst.de

On Tue, Aug 04, 2009 at 03:51:38PM -0300, Ramon de Carvalho Valle wrote:
> The xfs_iformat function does not check if the realtime device target pointer
> is valid when the XFS_DIFLAG_REALTIME flag is set on the ondisk inode
> structure.

Same as Eric I don't think there's much of a point renumbering the error
cases.  Instead I'll do another patch with a couple of cleanups in this
function replacing all the numbers with short alphabetic tags.

I don't really see the point of printing the flags either, if we have
this bit flipped it's pretty clear that we had random corruption of this
dinode.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
