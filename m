Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n7K1dMqj241989 for <xfs@oss.sgi.com>; Wed, 19 Aug 2009 20:39:32 -0500
Received: from mail.rtr.ca (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 293A53E3FA9
	for <xfs@oss.sgi.com>; Wed, 19 Aug 2009 18:40:04 -0700 (PDT)
Received: from mail.rtr.ca (rtr.ca [76.10.145.34]) by cuda.sgi.com with ESMTP
	id Eq7wvFJ4TDYjzqzg for <xfs@oss.sgi.com>;
	Wed, 19 Aug 2009 18:40:04 -0700 (PDT)
Message-ID: <4A8CA956.2060406@rtr.ca>
Date: Wed, 19 Aug 2009 21:39:34 -0400
From: Mark Lord <liml@rtr.ca>
MIME-Version: 1.0
Subject: Re: [PATCH, RFC] xfs: batched discard support
References: <20090816004705.GA7347@infradead.org>
	<20090819203916.GA25296@elte.hu>
In-Reply-To: <20090819203916.GA25296@elte.hu>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, IDE/ATA development list <linux-ide@vger.kernel.org>, Paul Mackerras <paulus@samba.org>, jens.axboe@oracle.com, linux-fsdevel@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>

[resending, after fixing the Cc: list; somebody trimmed it earlier]

Jamie Lokier wrote:
..
> I don't remember - does TRIM guarantee the blocks read zeros afterwards?
..

No, it doesn't.

A drive can optionally support "deterministic TRIM", whereby it will return
consistent data for any given trimmed sector afterwards, but that doesn't mean zeros.

-ml

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
