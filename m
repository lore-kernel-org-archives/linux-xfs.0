Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n8MC1ETD188910 for <xfs@oss.sgi.com>; Tue, 22 Sep 2009 07:01:14 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0D4D3470463
	for <xfs@oss.sgi.com>; Tue, 22 Sep 2009 05:02:31 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id Uwiwba7TW9gBEvxr for
	<xfs@oss.sgi.com>; Tue, 22 Sep 2009 05:02:31 -0700 (PDT)
Date: Tue, 22 Sep 2009 08:02:31 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH V2] xfs_repair: fix record_allocation list manipulation
Message-ID: <20090922120231.GB8143@infradead.org>
References: <4AB300CC.5020707@sandeen.net> <4AB4EDBC.9050609@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4AB4EDBC.9050609@sandeen.net>
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

On Sat, Sep 19, 2009 at 09:42:04AM -0500, Eric Sandeen wrote:
> clang found this one too as a "Dead assignment"
>
> Unless my pointer-fu is totally messed up, this function
> was never actually updating the list head.
>
> This would mean that the later free_allocations() calls in
> incore_ext_teardown() and free_rt_dup_extent_tree() don't
> actually free any items, and therefore leak memory.
>
> V2: now with correct pointer-fu.

Barry already had this in his repair speedups patchkit, but I left it
out for now because I wasn't too sure how this could work at all.
After reviewing it again I noticed that it can actually work because the
addr pointer in the ba_rec_t is unused, and we make use of the fact that
the ba_rec_t is the first field in the structure to be tacked.  Entirely
to subtile for my taste.  Id' prefer to just put a list_head into the
extent_alloc_rec_t and rt_extent_alloc_rec_t and openconde the
tracking/freeing of the beast.  The list_head if just as large as the
ba_rec_t and make sure the list handlinjg is right, and the openconding
gets rid of the annoying assumption that the ba_rec_t is the first thing
in the structure to be tracked.  It should also be a net-removal of
code.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
