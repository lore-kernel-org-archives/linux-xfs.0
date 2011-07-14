Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6EH4oJG148578 for <xfs@oss.sgi.com>; Thu, 14 Jul 2011 12:04:50 -0500
Subject: Re: [PATCH 1/1] Fix the ltp Makefile to allow for installation of
	all non-c (scripts) files
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20110714145809.GB23587@infradead.org>
References: <CAP57jx5TWxwaDhp6yY+b_tBb8_WTBaRPDCfdQ3pV4Bs-S869QQ@mail.gmail.com>
	<20110713121320.GA28126@infradead.org> <1310581564.1998.38.camel@doink>
	<20110714034336.GA30541@infradead.org> <20110714040326.GB31294@dastard>
	<20110714145809.GB23587@infradead.org>
Date: Thu, 14 Jul 2011 12:04:45 -0500
Message-ID: <1310663085.2067.18.camel@doink>
MIME-Version: 1.0
Reply-To: aelder@sgi.com
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
Cc: alal@google.com, xfs@oss.sgi.com

On Thu, 2011-07-14 at 10:58 -0400, Christoph Hellwig wrote:
> On Thu, Jul 14, 2011 at 02:03:26PM +1000, Dave Chinner wrote:
> > On Wed, Jul 13, 2011 at 11:43:36PM -0400, Christoph Hellwig wrote:
> > > I'm fine with enabling 080 by default, it passes for me.
> > 
> > It needs /bin/sh -> /bin/bash conversion first - the current version
> > fails miserably without that on all my test systems....
> 
> Does the simple s/sh/bash/ fix it for you?

Dave, I figured out that you must have been talking about
ltp/rwtest.sh needing to be converted to bash.

I got rid of my /bin/sh and /usr/bin/sh symlinks and tried it
out.  Turns out I can make some progress on it, but I now
find that /usr/sbin/xfs_check specifies /bin/sh as its interpreter.

I got around that by using "xfs_repair -n" for XFS_CHECK_PROG,
and outside of it producing different output the test seems
to work OK.

What else, specifically are you running into?  And if you
have trouble with the /bin/sh in rwtest.sh, why are you not
running into similar trouble with xfs_check?  I don't mind
doing the fix, but now I'm not sure what's required.

					-Alex

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
