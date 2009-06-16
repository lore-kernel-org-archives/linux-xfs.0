Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n5GE4ZHW163317 for <xfs@oss.sgi.com>; Tue, 16 Jun 2009 09:04:36 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E67B1917C47
	for <xfs@oss.sgi.com>; Tue, 16 Jun 2009 07:12:42 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id 5GxxwKBVox4AOhas for
	<xfs@oss.sgi.com>; Tue, 16 Jun 2009 07:12:42 -0700 (PDT)
Date: Tue, 16 Jun 2009 10:04:59 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: xfs_io: fix test for fallocate on 32bit boxes
Message-ID: <20090616140459.GA24783@infradead.org>
References: <4A36A448.4060406@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4A36A448.4060406@sandeen.net>
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
Cc: xfs-oss <xfs@oss.sgi.com>

On Mon, Jun 15, 2009 at 02:43:04PM -0500, Eric Sandeen wrote:
> xfs_io: fix test for fallocate on 32bit boxes
> 
> As per Red Hat bug 500487, fallocate64 is missing in glibc,
> so attempts to build with fallocate and _FILE_OFFSET_BITS=64
> will fail.
> 
> So, change the config to test the way we will build, and
> it'll fail properly on x86 until glibc gets fixed.

Yikes.  What's the status of actually getting it fixed in glibc?
Otherwise we might have to switch to the raw syscall as ugly
as it might be.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
