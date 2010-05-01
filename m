Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o41JjOC2019250 for <xfs@oss.sgi.com>; Sat, 1 May 2010 14:45:24 -0500
Received: from thunker.thunk.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E07601DE2210
	for <xfs@oss.sgi.com>; Sat,  1 May 2010 12:47:30 -0700 (PDT)
Received: from thunker.thunk.org (thunk.org [69.25.196.29]) by cuda.sgi.com
	with ESMTP id vdVaK8oPWRT2YIM7 for <xfs@oss.sgi.com>;
	Sat, 01 May 2010 12:47:30 -0700 (PDT)
Date: Sat, 1 May 2010 15:47:10 -0400
From: tytso@mit.edu
Subject: Re: [PATCH 3/4] writeback: pay attention to wbc->nr_to_write in
	write_cache_pages
Message-ID: <20100501194710.GV14986@thunk.org>
References: <1271731314-5893-1-git-send-email-david@fromorbit.com>
	<1271731314-5893-4-git-send-email-david@fromorbit.com>
	<20100429143931.331c2bab.akpm@linux-foundation.org>
	<87sk6dwka6.fsf@linux.vnet.ibm.com>
	<20100430124329.10a4c02b.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100430124329.10a4c02b.akpm@linux-foundation.org>
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
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com, "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org

On Fri, Apr 30, 2010 at 12:43:29PM -0700, Andrew Morton wrote:
> 
> Maybe that fs shouldn't be calling write_cache_pages() at all.  After
> all, write_cache_pages() is a wrapper which emits a sequence of calls
> to ->writepage(), and ->writepage() writes a page.

On my todo list is to fix ext4 to not call write_cache_pages() at all.
We are seriously abusing that function ATM, since we're not actually
writing the pages when we call write_cache_pages().  I won't go into
what we're doing, because it's too embarassing, but suffice it to say
that we end up calling pagevec_lookup() or pagevec_lookup_tag()
*four*, count them *four* times while trying to do writeback.

I have a simple patch that gives ext4 our own copy of
write_cache_pages(), and then simplifies it a lot, and fixes a bunch
of problems, but then I discarded it in favor of fundamentally redoing
how we do writeback at all, but it's going to take a while to get
things completely right.  But I am working to try to fix this.

If it would help, I can ressurect the "fork write_cache_pages() and
simplify" patch, so ext4 isn't dependent on the mm/page-writeback.c's
write_cache_pages(), if there is an immediate, short-term need to fix
that function.

						- Ted

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
