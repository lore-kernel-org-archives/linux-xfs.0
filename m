Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n3NHG0qN016595 for <xfs@oss.sgi.com>; Thu, 23 Apr 2009 12:16:00 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E3539236C2F
	for <xfs@oss.sgi.com>; Thu, 23 Apr 2009 10:15:57 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id qzwOrnyWVCYXiS8I for
	<xfs@oss.sgi.com>; Thu, 23 Apr 2009 10:15:57 -0700 (PDT)
Date: Thu, 23 Apr 2009 13:15:49 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfstests: fix up features2 tests for lazy-count=1
Message-ID: <20090423171535.GC11391@infradead.org>
References: <49EE2BBB.3070008@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <49EE2BBB.3070008@sandeen.net>
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
Cc: xfs mailing list <xfs@oss.sgi.com>

On Tue, Apr 21, 2009 at 03:25:31PM -0500, Eric Sandeen wrote:
> A few more tests are unhappy with a lazy-count=1 change;
> specify lazy-count=0 in them for these tests.

Again I'd prefer them to either deal with both cases and if that's
not feasible test the lazy-count=1 case.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
