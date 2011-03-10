Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with SMTP id
	p2AMl9tp126237 for <xfs@oss.sgi.com>; Thu, 10 Mar 2011 16:47:15 -0600
Received: from ipmail06.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 701381363CC2
	for <xfs@oss.sgi.com>; Thu, 10 Mar 2011 14:49:49 -0800 (PST)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	xEFcuBXo8LSwXwDG for <xfs@oss.sgi.com>;
	Thu, 10 Mar 2011 14:49:49 -0800 (PST)
Date: Fri, 11 Mar 2011 09:49:45 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: flush vmap aliases when mapping fails
Message-ID: <20110310224945.GA15097@dastard>
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

OK. The patch was done as part of the triage for this bug:

https://bugzilla.kernel.org/show_bug.cgi?id=27492

where the vmalloc space on 32 bit systems is getting exhausted. I
can easily move this flush-and-retry into the vmap code.

FWIW, while the VM folk might be paying attention about vmap realted
stuff, this vmap BUG() also needs triage:

https://bugzilla.kernel.org/show_bug.cgi?id=27002

And, finally, the mm-vmap-area-cache.patch in the current mmotm also
needs to be pushed forward because we've been getting reports of
excessive CPU time being spent walking the vmap area rbtree during
vm_map_ram operations and this patch supposedly fixes that
problem....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
