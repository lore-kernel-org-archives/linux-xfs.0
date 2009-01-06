Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	n062U1Nv003473 for <xfs@oss.sgi.com>; Mon, 5 Jan 2009 20:30:01 -0600
Received: from smtp1.linux-foundation.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 99D5563C7D
	for <xfs@oss.sgi.com>; Mon,  5 Jan 2009 18:30:00 -0800 (PST)
Received: from smtp1.linux-foundation.org (smtp1.linux-foundation.org
	[140.211.169.13]) by cuda.sgi.com with ESMTP id
	wSfTksiHgGOwT059 for <xfs@oss.sgi.com>;
	Mon, 05 Jan 2009 18:30:00 -0800 (PST)
Date: Mon, 5 Jan 2009 18:29:41 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [patch] mm: fix lockless pagecache reordering bug (was Re: BUG:
	soft lockup - is this XFS problem?)
In-Reply-To: <20090106020550.GA819@wotan.suse.de>
Message-ID: <alpine.LFD.2.00.0901051829080.3057@localhost.localdomain>
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
MIME-Version: 1.0
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
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org, Roman Kononov <kernel@kononov.ftml.net>, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, Linux Memory Management List <linux-mm@kvack.org>, Andrew Morton <akpm@linux-foundation.org>, Peter Klotz <peter.klotz@aon.at>, stable@kernel.org



On Tue, 6 Jan 2009, Nick Piggin wrote:
> 
> Sticking an rcu_dereference in radix_tree_deref_slot seems to fix the
> assembly for me too, I grafted the changelog onto that. Linus probably
> you are using -Os?

Ahh, yes. I am. That explains why I can't see any difference.

		Linus

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
