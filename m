Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6DIQ9ST096073 for <xfs@oss.sgi.com>; Wed, 13 Jul 2011 13:26:09 -0500
Subject: Re: [PATCH 1/1] Fix the ltp Makefile to allow for installation of
	all non-c (scripts) files
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20110713121320.GA28126@infradead.org>
References: <CAP57jx5TWxwaDhp6yY+b_tBb8_WTBaRPDCfdQ3pV4Bs-S869QQ@mail.gmail.com>
	<20110713121320.GA28126@infradead.org>
Date: Wed, 13 Jul 2011 13:26:04 -0500
Message-ID: <1310581564.1998.38.camel@doink>
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
Cc: xfs@oss.sgi.com, alal@google.com

On Wed, 2011-07-13 at 08:13 -0400, Christoph Hellwig wrote:
> On Fri, Jul 01, 2011 at 01:52:43PM -0700, Akshay Lal wrote:
> > Current the Makefile only builds the .c files and installs
> > them in the $INSTALL path. However, the ltp directory contains a shell script,
> > which doen't get copied over (installed) when a "make install"is invoked.
> > 
> > This behaviour causes test 080 to fail since it requires rwtest.sh to be
> > present in the ltp/ directory.
> > 
> > Tested: Updated the Makefile and ran a static build script & test
> > 080.
> 
> Thanks, applied.  (after fixing up mailer induced whitespace issues)

I see that test 80 is not part of the "auto" group.  Anyone
know why not?  I'm not even sure what it does; it may just
be unnecessary because it duplicates what other tests do.

But it's really quick (under 10 seconds even without speedy
hardware) so I don't see any harm to adding it to "auto" as
well as "quick".

Any thoughts?

					-Alex

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
