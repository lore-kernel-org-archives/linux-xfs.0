Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0JCE5pe190847 for <xfs@oss.sgi.com>; Tue, 19 Jan 2010 06:14:06 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0F1FB1C5EB1D
	for <xfs@oss.sgi.com>; Tue, 19 Jan 2010 04:15:05 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id 5BNdNOB17EYV0eWB for
	<xfs@oss.sgi.com>; Tue, 19 Jan 2010 04:15:05 -0800 (PST)
Date: Tue, 19 Jan 2010 07:15:05 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [patch 2/2] xfs: use scalable vmap API
Message-ID: <20100119121505.GA9428@infradead.org>
References: <20081021082542.GA6974@wotan.suse.de>
	<20081021082735.GB6974@wotan.suse.de>
	<20081021120932.GB13348@infradead.org>
	<20081022093018.GD4359@wotan.suse.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20081022093018.GD4359@wotan.suse.de>
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
To: Nick Piggin <npiggin@suse.de>
Cc: Christoph Hellwig <hch@infradead.org>, linux-mm@kvack.org, xfs@oss.sgi.com

Hi Nick,

I've looked into retesting and re-enabling the swithc to your
scalabale vmap API (original commit 95f8e302c04c0b0c6de35ab399a5551605eeb006).

The good thing is that I can't reproduce the original regressions in
xfstests I've seen.  The bad news is that starting from the second
consequitive xfstests run we're not able to vmalloc the log buffers
anymore.  It seems the use of this API introduces some leak of vmalloc
space.  Any idea how to debug this further?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
