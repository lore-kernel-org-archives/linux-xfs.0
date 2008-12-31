Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mBVAWhao023001 for <xfs@oss.sgi.com>; Wed, 31 Dec 2008 04:32:44 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id F100A179A80F
	for <xfs@oss.sgi.com>; Wed, 31 Dec 2008 02:32:42 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id TD5fGbxRLaIpGANF for
	<xfs@oss.sgi.com>; Wed, 31 Dec 2008 02:32:42 -0800 (PST)
Date: Wed, 31 Dec 2008 04:31:00 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 5/5] xfstests: test 197, add a testcase for d_off
	truncation
Message-ID: <20081231093100.GB2120@infradead.org>
References: <20081230230810.986105000@bombadil.infradead.org>
	<20081230230913.619447000@bombadil.infradead.org>
	<495AEE51.9030805@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <495AEE51.9030805@sandeen.net>
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
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Tue, Dec 30, 2008 at 10:00:17PM -0600, Eric Sandeen wrote:
> So can this test only fail on a 32-bit arch?  I haven't paid enough
> attention to the original bug... sorry if that's a dumb question.  :)

Yes, on 64 bit it will always succeed.  I'll add a comment explaining
that.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
