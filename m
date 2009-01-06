Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	n06GGbld027474 for <xfs@oss.sgi.com>; Tue, 6 Jan 2009 10:16:38 -0600
Received: from out2.smtp.messagingengine.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7B87766470
	for <xfs@oss.sgi.com>; Tue,  6 Jan 2009 08:16:37 -0800 (PST)
Received: from out2.smtp.messagingengine.com (out2.smtp.messagingengine.com
	[66.111.4.26]) by cuda.sgi.com with ESMTP id hLcMKdbhTChIBAJO
	for <xfs@oss.sgi.com>; Tue, 06 Jan 2009 08:16:37 -0800 (PST)
Message-ID: <496383E0.50102@ftml.net>
Date: Tue, 06 Jan 2009 10:16:32 -0600
From: Roman Kononov <kononov@ftml.net>
MIME-Version: 1.0
Subject: Re: [patch] mm: fix lockless pagecache reordering bug (was Re: BUG:
	soft lockup - is this XFS problem?)
References: <20090105041959.GC367@wotan.suse.de>
	<20090105064838.GA5209@wotan.suse.de> <49623384.2070801@aon.at>
	<20090105164135.GC32675@wotan.suse.de>
	<alpine.LFD.2.00.0901050859430.3057@localhost.localdomain>
	<20090105180008.GE32675@wotan.suse.de>
	<alpine.LFD.2.00.0901051027011.3057@localhost.localdomain>
	<20090105201258.GN6959@linux.vnet.ibm.com>
	<alpine.LFD.2.00.0901051224110.3057@localhost.localdomain>
	<20090105215727.GQ6959@linux.vnet.ibm.com>
	<20090106020550.GA819@wotan.suse.de>
In-Reply-To: <20090106020550.GA819@wotan.suse.de>
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
To: Nick Piggin <npiggin@suse.de>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org, Roman Kononov <kernel@kononov.ftml.net>, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, Linux Memory Management List <linux-mm@kvack.org>, Andrew Morton <akpm@linux-foundation.org>, Peter Klotz <peter.klotz@aon.at>, Linus Torvalds <torvalds@linux-foundation.org>, stable@kernel.org

On 2009-01-05 20:05 Nick Piggin said the following:
> Subject: mm lockless pagecache barrier fix
>  static inline void *radix_tree_deref_slot(void **pslot)
>  {
> -	void *ret = *pslot;
> +	void *ret = rcu_dereference(*pslot);
>  	if (unlikely(radix_tree_is_indirect_ptr(ret)))
>  		ret = RADIX_TREE_RETRY;
>  	return ret;

3 systems are working fine for a few hours with the patch. They would 
fail within 20 minutes without it.

Thanks.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
