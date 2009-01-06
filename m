Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	n068hH2g032338 for <xfs@oss.sgi.com>; Tue, 6 Jan 2009 02:43:17 -0600
Received: from mx2.suse.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 207D264B72
	for <xfs@oss.sgi.com>; Tue,  6 Jan 2009 00:43:16 -0800 (PST)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id GAnE9kwK3ytWqW3A for <xfs@oss.sgi.com>;
	Tue, 06 Jan 2009 00:43:16 -0800 (PST)
Date: Tue, 6 Jan 2009 09:43:12 +0100
From: Nick Piggin <npiggin@suse.de>
Subject: Re: [patch] mm: fix lockless pagecache reordering bug (was Re: BUG:
	soft lockup - is this XFS problem?)
Message-ID: <20090106084312.GC16738@wotan.suse.de>
References: <49623384.2070801@aon.at> <20090105164135.GC32675@wotan.suse.de>
	<alpine.LFD.2.00.0901050859430.3057@localhost.localdomain>
	<20090105180008.GE32675@wotan.suse.de>
	<alpine.LFD.2.00.0901051027011.3057@localhost.localdomain>
	<20090105201258.GN6959@linux.vnet.ibm.com>
	<alpine.LFD.2.00.0901051224110.3057@localhost.localdomain>
	<20090105215727.GQ6959@linux.vnet.ibm.com>
	<20090106020550.GA819@wotan.suse.de> <49631877.3090803@aon.at>
Mime-Version: 1.0
Content-Disposition: inline
In-Reply-To: <49631877.3090803@aon.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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
To: Peter Klotz <peter.klotz@aon.at>
Cc: linux-kernel@vger.kernel.org, Roman Kononov <kernel@kononov.ftml.net>, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, Linux Memory Management List <linux-mm@kvack.org>, Andrew Morton <akpm@linux-foundation.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Linus Torvalds <torvalds@linux-foundation.org>, stable@kernel.org

On Tue, Jan 06, 2009 at 09:38:15AM +0100, Peter Klotz wrote:
> >Index: linux-2.6/include/linux/radix-tree.h
> >===================================================================
> >--- linux-2.6.orig/include/linux/radix-tree.h
> >+++ linux-2.6/include/linux/radix-tree.h
> >@@ -136,7 +136,7 @@ do {						 \
> >  */
> > static inline void *radix_tree_deref_slot(void **pslot)
> > {
> >-	void *ret = *pslot;
> >+	void *ret = rcu_dereference(*pslot);
> > 	if (unlikely(radix_tree_is_indirect_ptr(ret)))
> > 		ret = RADIX_TREE_RETRY;
> > 	return ret;
> >
> >
> 
> The patch above fixes my problem. I did two complete test runs that 
> normally fail rather quickly.

OK, thanks for reporting and testing. 

I think this patch is a candidate for -stable too.

Thanks,
Nick

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
