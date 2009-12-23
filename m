Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nBNDUrGZ237967 for <xfs@oss.sgi.com>; Wed, 23 Dec 2009 07:30:53 -0600
Date: Wed, 23 Dec 2009 08:31:36 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] use time32_t consistently in xfsdump tree
Message-ID: <20091223133136.GA10345@infradead.org>
References: <4B300389.7020905@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4B300389.7020905@sgi.com>
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
To: Bill Kendall <wkendall@sgi.com>
Cc: xfs@oss.sgi.com

On Mon, Dec 21, 2009 at 05:23:53PM -0600, Bill Kendall wrote:
> xfsdump stores time_t as 32-bits in its dump and inventory
> structures for portability/historical reasons. xfsinvutil
> uses time_t directly, leading to some strange results on
> systems which have a 64-bit time_t.
>
> The 32-bit time-related functions were factored out into
> their own file since they are now used by xfsinvutil, and
> their original file (util.c) could not easily be linked
> with xfsinvutil due to dependencies on many other
> dump/restore modules.

The newly created timeutil.[ch] did not get included into the patch,
so I can't easily review them, and the rest of the patch also seems
whitespace mangled to me.

The changes in it looks good, just the time_t to time32_t conversions
plus overflow checks.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
