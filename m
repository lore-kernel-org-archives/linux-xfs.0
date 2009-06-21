Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n5LJH7oX182121 for <xfs@oss.sgi.com>; Sun, 21 Jun 2009 14:17:08 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id DE0471493645
	for <xfs@oss.sgi.com>; Sun, 21 Jun 2009 12:25:45 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id tTuCNk8K0pCxH0VL for
	<xfs@oss.sgi.com>; Sun, 21 Jun 2009 12:25:45 -0700 (PDT)
Date: Sun, 21 Jun 2009 15:17:32 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/3] xfstests: fallocate + read/write tests, ext4
	regression tests
Message-ID: <20090621191732.GB19596@infradead.org>
References: <4A370DD2.6080204@sandeen.net>
	<20090620175953.GC3984@infradead.org>
	<58093.76.66.127.206.1245531627.squirrel@www.sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <58093.76.66.127.206.1245531627.squirrel@www.sandeen.net>
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
Cc: Christoph Hellwig <hch@infradead.org>, ext4 development <linux-ext4@vger.kernel.org>, xfs-oss <xfs@oss.sgi.com>

On Sat, Jun 20, 2009 at 04:00:27PM -0500, Eric Sandeen wrote:
> Christoph Hellwig wrote:
> > On Mon, Jun 15, 2009 at 10:13:22PM -0500, Eric Sandeen wrote:
> >> New test to test basic mixed fallocate + read & write,
> >> includes a couple regression tests for bugs that ext4
> >> hit.  Uses xfs_io to generate fallocate calls, so requires
> >> git xfsprogs and very recent glibc at this point.
> >
> > Looks good to me, and again does the correct notrun for my 32-bit
> > VM.  Guess I need to do the raw syscall wireup i xfsprogs eventually..
> 
> I don't mind doing it either ... how many arches? :)

Most important is x86 I think.  arm might be the other really important
candidate.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
