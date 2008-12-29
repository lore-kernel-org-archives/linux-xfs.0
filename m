Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mBTBbcGC001118 for <xfs@oss.sgi.com>; Mon, 29 Dec 2008 05:37:38 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 22EA94E323
	for <xfs@oss.sgi.com>; Mon, 29 Dec 2008 03:37:38 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id 52I445TWfZtSYBPt for
	<xfs@oss.sgi.com>; Mon, 29 Dec 2008 03:37:38 -0800 (PST)
Date: Mon, 29 Dec 2008 06:37:06 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfstests: test 194, test tricky mapping/conversion
	around holes
Message-ID: <20081229113706.GA10891@infradead.org>
References: <4942C6E2.4040506@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4942C6E2.4040506@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs mailing list <xfs@oss.sgi.com>

On Fri, Dec 12, 2008 at 02:17:38PM -0600, Eric Sandeen wrote:
> Related to 
> http://oss.sgi.com/bugzilla/show_bug.cgi?id=801
> 
> Latest patch posted on that bug makes this testcase pass...
> 
> (are we at 194 now?)
> 
> first 2 tests are simple buffred writ tests making sure stale
> data isn't exposed, and hole-blocks aren't mapped.
> 
> 2nd 2 tests are more related to the above bug, tricky testcase
> uncovered by fsx on ppc64 which actually re-maps a block
> which should be a hole, bringing stale data back into existence.

The testcase requires awk --asign, which my debian lenny testbox
(mawk 1.3.3-11.1) doesn't have.  Any chance you could rework it
to work with the posix awk features?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
