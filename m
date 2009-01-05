Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	n054K4Ve021201 for <xfs@oss.sgi.com>; Sun, 4 Jan 2009 22:20:04 -0600
Received: from mx2.suse.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 042455F2ED
	for <xfs@oss.sgi.com>; Sun,  4 Jan 2009 20:20:02 -0800 (PST)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) by cuda.sgi.com with
	ESMTP id BMldiPia0hvLJWvx for <xfs@oss.sgi.com>;
	Sun, 04 Jan 2009 20:20:02 -0800 (PST)
Date: Mon, 5 Jan 2009 05:19:59 +0100
From: Nick Piggin <npiggin@suse.de>
Subject: Re: BUG: soft lockup - is this XFS problem?
Message-ID: <20090105041959.GC367@wotan.suse.de>
References: <gifgp1$8ic$1@ger.gmane.org> <20081223171259.GA11945@infradead.org>
	<20081230042333.GC27679@wotan.suse.de>
	<20090103214443.GA6612@infradead.org>
	<20090105014821.GA367@wotan.suse.de>
Mime-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20090105014821.GA367@wotan.suse.de>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: Peter Klotz <peter.klotz@aon.at>, linux-kernel@vger.kernel.org, Roman Kononov <kernel@kononov.ftml.net>, xfs@oss.sgi.com

On Mon, Jan 05, 2009 at 02:48:21AM +0100, Nick Piggin wrote:
> On Sat, Jan 03, 2009 at 04:44:43PM -0500, Christoph Hellwig wrote:
> > On Tue, Dec 30, 2008 at 05:23:33AM +0100, Nick Piggin wrote:
> > > On Tue, Dec 23, 2008 at 12:12:59PM -0500, Christoph Hellwig wrote:
> > > > 
> > > > Nick, I've seen various reports like this by Roman.  It seems to be
> > > > caused by an interaction of the lockless pagecache with the xfs
> > > > I/O code.  Any idea what might be wrong here:
> > > 
> > > Hmm, it could get into a loop here if there is a page in the pagecache
> > > with a zero refcount, which might be a problem with XFS... other looping
> > > conditions might indicate a problem iwth lockless pagecache or radix
> > > tree. It would be very helpful to know what condition it is looping on...
> > 
> > See http://oss.sgi.com/bugzilla/show_bug.cgi?id=805
> 
> OK.. Hmm, well here is a modification to your patch which might help further.
> I'll see if I can reproduce it here meanwhile.

I have reproduced it. It seems like it might be a livelock condition
because the system ended up recovering after I terminated the dd (and
did so before I collected any real info, oops, hopefully I can
reproduce it again).

This would fit with the problem going away when the debugging patch
was applied. Timing changes...

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
