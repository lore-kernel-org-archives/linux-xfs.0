Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 074D57F83
	for <xfs@oss.sgi.com>; Thu, 13 Aug 2015 20:57:13 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id E5EB2304043
	for <xfs@oss.sgi.com>; Thu, 13 Aug 2015 18:57:12 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	61pNvxdGsdlOaedq for <xfs@oss.sgi.com>;
	Thu, 13 Aug 2015 18:57:10 -0700 (PDT)
Date: Fri, 14 Aug 2015 11:57:05 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] mkfs.xfs: fix ftype-vs-crc option combination testing
Message-ID: <20150814015704.GV3902@dastard>
References: <55C43FBA.1080408@sandeen.net>
	<20150807113742.GB8322@bfoster.bfoster>
	<55C4E007.90709@sandeen.net>
	<CACj3i72_w6fKaJyDhaHb-vEA056kSSQnucWkWfO2LsVxci+yfA@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CACj3i72_w6fKaJyDhaHb-vEA056kSSQnucWkWfO2LsVxci+yfA@mail.gmail.com>
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
To: Jan Tulak <jtulak@redhat.com>
Cc: Brian Foster <bfoster@redhat.com>, Eric Sandeen <sandeen@sandeen.net>, xfs-oss <xfs@oss.sgi.com>

On Thu, Aug 13, 2015 at 01:14:25PM +0200, Jan Tulak wrote:
> On Fri, Aug 7, 2015 at 6:42 PM, Eric Sandeen <sandeen@sandeen.net> wrote:
> >
> > >
> > > IIRC, I think this is one of the core problems the big mkfs option
> > > parsing rework that Jan is working on is supposed to fix.
> >
> > Yeah, I think so - Jan, if this gets in your way, let us know -
> > I didn't mean to make your life difficult by fixing little
> > things while you work.  :)
> 
> Well, I would not mind if the entire codebase froze... :-D
> But realistically, every time I do git fetch I get so many collisions that
> one
> more or less changes nothing. :-)

Well, I'm hoping all the big changes getting libxfs up to date with
the kernel code are now done, and things will settle down for the
next few months so this will be less of a problem. Also having a
stable master branch and a moving for-next branch for xfsprogs
should help with this, too....

> And yes, in my tests I'm trying to cover the arguments order issue too.

The structure of the table-based parsing should make the order of
parsing irrelevant, as conflicts are defined in the table and so
will be detected regardless of the order in which the options appear
on the command line.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
