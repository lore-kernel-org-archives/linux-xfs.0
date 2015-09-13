Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 6517C7F37
	for <xfs@oss.sgi.com>; Sun, 13 Sep 2015 18:51:09 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 10F8AAC002
	for <xfs@oss.sgi.com>; Sun, 13 Sep 2015 16:51:05 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	RHXxYRie4Ho7PoRw for <xfs@oss.sgi.com>;
	Sun, 13 Sep 2015 16:51:03 -0700 (PDT)
Date: Mon, 14 Sep 2015 09:50:59 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [RT XFS] BUG from lockdep in xfs
Message-ID: <20150913235059.GU26895@dastard>
References: <CANGgnMa7jXARYkfCKOgvphunKvVaxRWZcSFgGC1b2m74Dgt+jQ@mail.gmail.com>
	<20150909114451.GA30015@bfoster.bfoster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150909114451.GA30015@bfoster.bfoster>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Brian Foster <bfoster@redhat.com>
Cc: Philipp Schrader <philipp@peloton-tech.com>, Brian Silverman <brian@peloton-tech.com>, rt-users <linux-rt-users@vger.kernel.org>, Austin Schuh <austin@peloton-tech.com>, xfs <xfs@oss.sgi.com>

On Wed, Sep 09, 2015 at 07:44:51AM -0400, Brian Foster wrote:
> On Tue, Sep 08, 2015 at 11:54:07PM -0700, Austin Schuh wrote:
> > I'm running xfstests and got the following BUG with lockdep enabled.
> > I'm running the 4.1.6-rt5 kernel from TI's tree on a TI ARM chip.
> > 
> > Any ideas on what could be causing it, or if it is a real problem?
> > 
> > I see some patches in Dave's latest 4.3 pull request that discuss
> > lockdep.  Are there any ones there that are worth backporting to my
> > 4.1.6 kernel?
> > 
> 
> I suspect Dave's recent rework of the lockdep namespace bits is what you
> want:
> 
> 	0952c818 xfs: clean up inode lockdep annotations

Yes, that works around the issue that causes this:

> > [ 4357.394974] BUG: looking up invalid subclass: 8

i.e. that we have about 15 different subclass annotations for
different inode locking situations we need to shoe horn into 8
subclasses...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
