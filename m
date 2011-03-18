Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p2IELgRR038911 for <xfs@oss.sgi.com>; Fri, 18 Mar 2011 09:21:47 -0500
Received: from zene.cmpxchg.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id BE00312AFD35
	for <xfs@oss.sgi.com>; Fri, 18 Mar 2011 07:24:27 -0700 (PDT)
Received: from zene.cmpxchg.org (zene.cmpxchg.org [85.214.230.12]) by
	cuda.sgi.com with ESMTP id sbup2GqSiXbh4bV8 for
	<xfs@oss.sgi.com>; Fri, 18 Mar 2011 07:24:27 -0700 (PDT)
Date: Fri, 18 Mar 2011 15:24:14 +0100
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH] xfs: flush vmap aliases when mapping fails
Message-ID: <20110318142414.GV2140@cmpxchg.org>
References: <1299713876-7747-1-git-send-email-david@fromorbit.com>
	<20110310073751.GB25374@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110310073751.GB25374@infradead.org>
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
Cc: linux-mm@kvack.org, npiggin@kernel.dk, xfs@oss.sgi.com

On Thu, Mar 10, 2011 at 02:37:51AM -0500, Christoph Hellwig wrote:
> On Thu, Mar 10, 2011 at 10:37:56AM +1100, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > On 32 bit systems, vmalloc space is limited and XFS can chew through
> > it quickly as the vmalloc space is lazily freed. This can result in
> > failure to map buffers, even when there is apparently large amounts
> > of vmalloc space available. Hence, if we fail to map a buffer, purge
> > the aliases that have not yet been freed to hopefuly free up enough
> > vmalloc space to allow a retry to succeed.
> 
> IMHO this should be done by vm_map_ram internally.  If we can't get the
> core code fixes we can put this in as a last resort.

Agreed, this should be fixed in the vmalloc-ator.

It is already supposed to purge the lazy-freed mappings before it
fails an allocation, I am trying to figure out what's going on.

Your proposed workaround looks fine to me until vmalloc is fixed.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
