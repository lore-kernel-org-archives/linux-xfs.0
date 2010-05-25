Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o4PAUvTQ241662 for <xfs@oss.sgi.com>; Tue, 25 May 2010 05:30:57 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D23D836D444
	for <xfs@oss.sgi.com>; Tue, 25 May 2010 03:33:18 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id XbaElF4hN9Sx09Cz for
	<xfs@oss.sgi.com>; Tue, 25 May 2010 03:33:18 -0700 (PDT)
Date: Tue, 25 May 2010 06:33:17 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH (resend)] xfs: don't allow recursion into fs under
	write_begin
Message-ID: <20100525103317.GB2864@infradead.org>
References: <4BF8056E.8080900@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4BF8056E.8080900@sandeen.net>
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
Cc: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, linux-mm@kvack.org, Michael Monnerie <michael.monnerie@is.it-management.at>, xfs-oss <xfs@oss.sgi.com>

On Sat, May 22, 2010 at 11:25:18AM -0500, Eric Sandeen wrote:
> Michael Monnerie reported this fantastic stack overflow:

> I don't think we can afford to let write_begin recurse into the fs,
> so we can set AOP_FLAG_NOFS ... is this too big a hammer?

I don't really like it.  There's nothing XFS-specific here - it's the
same problem with direct reclaim calling back into the FS and causing
massive amounts of problems.  If we want to fix this class of problems
we just need to do the same thing ext4 and btrfs already do and refuse
to call the allocator from reclaim context.

Just curious, how much stack does the path up to generic_perform_write
use?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
