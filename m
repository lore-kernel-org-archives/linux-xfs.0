Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0PCceds054352 for <xfs@oss.sgi.com>; Mon, 25 Jan 2010 06:38:41 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A4BCA135E674
	for <xfs@oss.sgi.com>; Mon, 25 Jan 2010 04:39:44 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id L9lF38MiziAEQbeB for
	<xfs@oss.sgi.com>; Mon, 25 Jan 2010 04:39:44 -0800 (PST)
Date: Mon, 25 Jan 2010 07:39:44 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [patch 2/2] xfs: use scalable vmap API
Message-ID: <20100125123943.GA7394@infradead.org>
References: <20081021082542.GA6974@wotan.suse.de>
	<20081021082735.GB6974@wotan.suse.de>
	<20081021120932.GB13348@infradead.org>
	<20081022093018.GD4359@wotan.suse.de>
	<20100119121505.GA9428@infradead.org>
	<20100125075445.GD19664@laptop>
	<20100125081750.GA20012@infradead.org>
	<20100125083309.GF19664@laptop> <20100125123746.GA24406@laptop>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100125123746.GA24406@laptop>
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
To: Nick Piggin <npiggin@suse.de>
Cc: Christoph Hellwig <hch@infradead.org>, linux-mm@kvack.org, xfs@oss.sgi.com

On Mon, Jan 25, 2010 at 11:37:46PM +1100, Nick Piggin wrote:
> On Mon, Jan 25, 2010 at 07:33:09PM +1100, Nick Piggin wrote:
> > > Any easy way to get them?  Sorry, not uptodate on your new vmalloc
> > > implementation anymore.
> > 
> > Let me try writing a few (tested) patches here first that I can send you.
> 
> Well is it easy to reproduce the vmap failure? Here is a better tested
> patch if you can try it. It fixes a couple of bugs and does some purging
> of fragmented blocks.
> 
> If it does not help, can you tell me how many CPUs in your system?

The simplest one to reproduce it is a 1 cpu kvm virtual machine.  Will
give your patch a try ASAP - while it's easy to reproduce it takes some
time as I appears only when doing a second xfstests run after a first
finished fine, which makes it look like a leak to me.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
