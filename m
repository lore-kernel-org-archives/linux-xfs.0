Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o9KFIEoI083551 for <xfs@oss.sgi.com>; Wed, 20 Oct 2010 10:18:15 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B66E01E7F3DA
	for <xfs@oss.sgi.com>; Wed, 20 Oct 2010 08:19:28 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id NxWosBYNgDfubX47 for
	<xfs@oss.sgi.com>; Wed, 20 Oct 2010 08:19:28 -0700 (PDT)
Date: Wed, 20 Oct 2010 11:19:27 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: XFS bad inode magic/vsn daddr 64 #8 (magic=5858)
Message-ID: <20101020151927.GA21057@infradead.org>
References: <20101020082409.GA5415@amd>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20101020082409.GA5415@amd>
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
To: Nick Piggin <npiggin@kernel.dk>
Cc: xfs@oss.sgi.com

On Wed, Oct 20, 2010 at 07:24:09PM +1100, Nick Piggin wrote:
> Hi, I keep hitting this bug running xfstests, and managed to
> reproduce it several times on current vanilla upstream kernel
> too, below is one trace.
> 
> Nothing special about the xfstests run, except that it is run
> on brd device for both the test and the scratch mounts. No
> special mount options or mkfs flags. It seems pretty reproducable
> though, triggering every time I've run the tests like this.
> 
> I didn't narrow down the test that causes the bug because it
> keeps running other tests and then eventually hanging. Any hints
> to narrow it down?

Care to check if it goes away if you remove the special casing of
BLKFLSBUF in brd_ioctl?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
