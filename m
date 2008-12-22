Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mBMKp4fQ026533 for <xfs@oss.sgi.com>; Mon, 22 Dec 2008 14:51:05 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D9F2D400FC
	for <xfs@oss.sgi.com>; Mon, 22 Dec 2008 12:51:02 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id BdQHUnIBFfDPSRlP for
	<xfs@oss.sgi.com>; Mon, 22 Dec 2008 12:51:02 -0800 (PST)
Date: Mon, 22 Dec 2008 15:50:31 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: xfstests testcase 111: Infinite xfs_bulkstat bad-inode loop
	casefrom Roger Willcocks
Message-ID: <20081222205031.GB23453@infradead.org>
References: <20081222165848.GA17075@infradead.org>
	<C73606AC84514BE3B733F818ACCD281B@BODDINGTON>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <C73606AC84514BE3B733F818ACCD281B@BODDINGTON>
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
To: Roger Willcocks <roger@filmlight.ltd.uk>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Mon, Dec 22, 2008 at 08:28:59PM -0000, Roger Willcocks wrote:
> Hi Christoph,
>
> here are the relevant extracts from our in-house bugzilla (bug 3675). 
> Since the problem only occurs when the disk is corrupted, I don't see any 
> problem with skipping the test on debug kernels.

Thanks a lot, that's some very helpful notes.  I'll put a shortened
version of this into the testcase as a comment.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
