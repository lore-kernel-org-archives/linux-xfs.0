Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o3JDwk37220679 for <xfs@oss.sgi.com>; Mon, 19 Apr 2010 08:58:46 -0500
Received: from mx1.suse.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5A0FD15435FD
	for <xfs@oss.sgi.com>; Mon, 19 Apr 2010 07:00:44 -0700 (PDT)
Received: from mx1.suse.de (cantor.suse.de [195.135.220.2]) by cuda.sgi.com
	with ESMTP id 2yMvFonQMp7GaphP for <xfs@oss.sgi.com>;
	Mon, 19 Apr 2010 07:00:44 -0700 (PDT)
Date: Tue, 20 Apr 2010 00:00:39 +1000
From: Nick Piggin <npiggin@suse.de>
Subject: Re: [PATCH 1/2] mm: add context argument to shrinker callback
Message-ID: <20100419140039.GQ5683@laptop>
References: <1271118255-21070-1-git-send-email-david@fromorbit.com>
	<1271118255-21070-2-git-send-email-david@fromorbit.com>
	<20100418001514.GA26575@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100418001514.GA26575@infradead.org>
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
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>

On Sat, Apr 17, 2010 at 08:15:14PM -0400, Christoph Hellwig wrote:
> Any chance we can still get this into 2.6.34?  It's really needed to fix
> a regression in XFS that would be hard to impossible to work around
> inside the fs.  While it touches quite a few places the changes are
> trivial and well understood.

Why do you even need this context argument?  Reclaim is not doing anything
smart about this, it would just call each call shrinker in turn.

Do you not have an easily traversable list of mountpoints? Can you just
make a list of them? It would be cheaper than putting a whole shrinker
structure into them anyway.

The main reason I would be against proliferation of dynamic shrinker
registration would be that it could change reclaim behaviour depending
on how they get ordered (in the cache the caches are semi-dependent,
like inode cache and dentry cache).

Unless there is a reason I missed, I would much prefer not to do this
like this.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
