Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 762487D1F
	for <xfs@oss.sgi.com>; Wed, 27 Apr 2016 17:30:03 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 36C958F8039
	for <xfs@oss.sgi.com>; Wed, 27 Apr 2016 15:30:00 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	cAK37qvg2ybAxhuW for <xfs@oss.sgi.com>;
	Wed, 27 Apr 2016 15:29:53 -0700 (PDT)
Date: Thu, 28 Apr 2016 08:29:50 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: idle aild if the AIL is pushed up to the target LSN
Message-ID: <20160427222950.GI26977@dastard>
References: <1461570163-4083-1-git-send-email-dev@lynxeye.de>
	<20160425142444.GC33882@bfoster.bfoster>
	<1461607897.2364.27.camel@lynxeye.de>
	<20160425230833.GC18496@dastard>
	<1461781898.2516.10.camel@lynxeye.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1461781898.2516.10.camel@lynxeye.de>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Lucas Stach <dev@lynxeye.de>
Cc: Brian Foster <bfoster@redhat.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Wed, Apr 27, 2016 at 08:31:38PM +0200, Lucas Stach wrote:
> Am Dienstag, den 26.04.2016, 09:08 +1000 schrieb Dave Chinner:
> [...]
> > > =

> > > > =

> > > > That said, I'm not sure whether there's a notable benefit of
> > > > idling
> > > > for
> > > > 50ms over just scheduling out when we've hit the target lsn. It
> > > > seems
> > > > like that anybody who pushes the target forward again is going to
> > > > wake
> > > > up the thread anyways. On the other hand, if the fs is idle the
> > > > thread
> > > > will eventually schedule out indefinitely.=A0
> > > Is this a problem? The patch tries to do exactly that: schedule out
> > > aild indefinitely when there is no more work to do as nobody is
> > > pushing
> > > the target LSN forward.
> > If the filesystem is slowly being dirtied, then the aild should't
> > really idle at all.i
> > =

> > Keep in mind that the xfsaild has multiple functions, one of which
> > is a watchdog that catches log space stalls that would otherwise
> > hang the filesystem. Every time we've removed the watchdog function
> > (i.e.=A0=A0agressively idle the aild) we've had users report random,
> > unreproducable hangs/stalls that have gone away when the watchdog
> > function (i.e. don't idle until the log is covered and completely
> > idle) was re-instated...
> > =

> I can only see=A0xfsaild_push() doing any work after it has hit the
> target LSN if something moves the target LSN forward. You say that
> aggressively idling aild might produce log stalls, which would imply
> there are races in the code where a code path that moves the target LSN
> forward doesn't properly wake up aild.

Well, yes. The code is horrifically complex, there's a heap of
lockless operations along with cross-subsystem co-ordinated
operations done under different locks amongst other things to
provide scalability. History tells me that no matter whether we
*think* we've got it right, there's always another bug lurking.

> Wouldn't this problem also be present when doing non-aggressive idle of
> aild, just the probability of hitting the issue being reduced
> significantly?

Welcome to Risk Management 101.

I've got better things to do with my time than remove a safety net
and the be forced to spend days or even weeks trying to solve all
the subtle, deeply hidden problems that have been around for 20
years that are now exposed to users. That's not a productive use of
the limited amount of XFS developer's time we have available. If you
want to go ahead and do all this, I'll be happy to spend a year
teaching you about how all the log space reservation code works...

> The commit that re-enabled non-aggressive aild idle
> especially mentions some races that have been fixed and I think those
> fixes should allow for agressive aild idle. If they are insufficient it
> wouldn't be safe to idle aild at all, right?

No - the log state machine that covers (idles) the log is the one we
really care about and it guarantees that the AIL is empty. i.e. The
AIL has active items in it until the log is covered and hence, by
definition, it can't be idle until the log is covered.

Cheers,

Dave.
-- =

Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
