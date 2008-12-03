Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mB3AsMlF011152 for <xfs@oss.sgi.com>; Wed, 3 Dec 2008 04:54:23 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 67C9C1B8B5D1
	for <xfs@oss.sgi.com>; Wed,  3 Dec 2008 02:54:22 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id csSXivfu6zHKAJQ5 for
	<xfs@oss.sgi.com>; Wed, 03 Dec 2008 02:54:22 -0800 (PST)
Date: Wed, 3 Dec 2008 05:53:51 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [patch 05/22] cleanup the inode reclaim path
Message-ID: <20081203105351.GJ15485@infradead.org>
References: <20081202160430.775774000@bombadil.infradead.org>
	<20081202160650.198364000@bombadil.infradead.org>
	<20081203022950.GD18236@disturbed>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20081203022950.GD18236@disturbed>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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
To: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Wed, Dec 03, 2008 at 01:29:50PM +1100, Dave Chinner wrote:
> On Tue, Dec 02, 2008 at 11:04:35AM -0500, Christoph Hellwig wrote:
> > Merge xfs_iextract and xfs_idestory into xfs_ireclaim as they are never
>                          xfs_idestroy
> > called individually.  Also rewrite most comments in this area as they
> > were serverly out of date.
>        severely

Thanks, updated the comments.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
