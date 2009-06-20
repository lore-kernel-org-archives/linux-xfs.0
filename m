Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n5KL03s8136833 for <xfs@oss.sgi.com>; Sat, 20 Jun 2009 16:00:03 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 868331492E9E
	for <xfs@oss.sgi.com>; Sat, 20 Jun 2009 14:08:34 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id I3nwi1DttKcmLDGm for
	<xfs@oss.sgi.com>; Sat, 20 Jun 2009 14:08:34 -0700 (PDT)
Message-ID: <58093.76.66.127.206.1245531627.squirrel@www.sandeen.net>
In-Reply-To: <20090620175953.GC3984@infradead.org>
References: <4A370DD2.6080204@sandeen.net>
	<20090620175953.GC3984@infradead.org>
Date: Sat, 20 Jun 2009 16:00:27 -0500 (CDT)
Subject: Re: [PATCH 3/3] xfstests: fallocate + read/write tests,
	ext4 regression tests
From: "Eric Sandeen" <sandeen@sandeen.net>
MIME-Version: 1.0
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
To: Christoph Hellwig <hch@infradead.org>
Cc: ext4 development <linux-ext4@vger.kernel.org>, Eric Sandeen <sandeen@sandeen.net>, xfs-oss <xfs@oss.sgi.com>

Christoph Hellwig wrote:
> On Mon, Jun 15, 2009 at 10:13:22PM -0500, Eric Sandeen wrote:
>> New test to test basic mixed fallocate + read & write,
>> includes a couple regression tests for bugs that ext4
>> hit.  Uses xfs_io to generate fallocate calls, so requires
>> git xfsprogs and very recent glibc at this point.
>
> Looks good to me, and again does the correct notrun for my 32-bit
> VM.  Guess I need to do the raw syscall wireup i xfsprogs eventually..

I don't mind doing it either ... how many arches? :)

-Eric

> Reviewed-by: Christoph Hellwig <hch@lst.de>
>
>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
