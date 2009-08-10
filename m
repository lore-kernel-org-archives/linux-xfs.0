Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n7AE8g9G062222 for <xfs@oss.sgi.com>; Mon, 10 Aug 2009 09:08:43 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 56914B218F6
	for <xfs@oss.sgi.com>; Mon, 10 Aug 2009 07:19:31 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id sr728IDC2n43q1EO for
	<xfs@oss.sgi.com>; Mon, 10 Aug 2009 07:19:31 -0700 (PDT)
Date: Mon, 10 Aug 2009 10:09:30 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH V2] xfstests 218: very basic defragmentation testing
	for xfs & ext4
Message-ID: <20090810140930.GA24174@infradead.org>
References: <4A5E3A37.5050306@redhat.com> <4A7A5CA8.8040702@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4A7A5CA8.8040702@sandeen.net>
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
Cc: Eric Sandeen <sandeen@redhat.com>, ext4 development <linux-ext4@vger.kernel.org>, xfs mailing list <xfs@oss.sgi.com>

On Wed, Aug 05, 2009 at 11:31:36PM -0500, Eric Sandeen wrote:
> Test a few very basic defragmentation scenarios.
> 
> This test creates some files, runs defrag on them,
> and compares the before/after fragmentation as well
> as file md5sums and timestamps.
> 
> The test currently expects to find e4defrag in
> /usr/bin
> 
> It should be relatively easy to add more interestingly
> fragmented files to the tests, as well as to test
> that memory-mapped files aren't touched, etc - 
> but this gives us a framework.
> 
> V2: remount before checking file contents, and create
> common.defrag.

The patch loks good to me,


Reviewed-by: Christoph Hellwig <hch@lst.de>

Unfortunately it still fails on my Debian testing system with:

 QA output created by 218
 zero-length file:
-Before: 0
-After: 0
+Before: 1
+After: 1
 Sparse file (no blocks):
-Before: 0
-After: 0
+Before: 1
+After: 1

But that's due to a bug in filefrag that I have already reported to the
Debian BTS.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
