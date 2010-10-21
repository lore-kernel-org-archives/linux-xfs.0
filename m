Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o9L1Nmpm156875 for <xfs@oss.sgi.com>; Wed, 20 Oct 2010 20:23:48 -0500
Received: from ipmail05.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5A1011956306
	for <xfs@oss.sgi.com>; Wed, 20 Oct 2010 18:25:00 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	WRhGNonRUCcaRfdz for <xfs@oss.sgi.com>;
	Wed, 20 Oct 2010 18:25:00 -0700 (PDT)
Date: Thu, 21 Oct 2010 12:24:56 +1100
From: Nick Piggin <npiggin@kernel.dk>
Subject: Re: XFS bad inode magic/vsn daddr 64 #8 (magic=5858)
Message-ID: <20101021012456.GA3459@amd>
References: <20101020082409.GA5415@amd> <20101020151927.GA21057@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20101020151927.GA21057@infradead.org>
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
Cc: Nick Piggin <npiggin@kernel.dk>, xfs@oss.sgi.com

On Wed, Oct 20, 2010 at 11:19:27AM -0400, Christoph Hellwig wrote:
> On Wed, Oct 20, 2010 at 07:24:09PM +1100, Nick Piggin wrote:
> > Hi, I keep hitting this bug running xfstests, and managed to
> > reproduce it several times on current vanilla upstream kernel
> > too, below is one trace.
> > 
> > Nothing special about the xfstests run, except that it is run
> > on brd device for both the test and the scratch mounts. No
> > special mount options or mkfs flags. It seems pretty reproducable
> > though, triggering every time I've run the tests like this.
> > 
> > I didn't narrow down the test that causes the bug because it
> > keeps running other tests and then eventually hanging. Any hints
> > to narrow it down?
> 
> Care to check if it goes away if you remove the special casing of
> BLKFLSBUF in brd_ioctl?

Ah yes that stupid special case is probably causing other problems
even if not this crash. I'll try your suggestions when I start some more
tests running later today.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
