Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 25 May 2007 04:25:06 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l4PBOtWt017634
	for <xfs@oss.sgi.com>; Fri, 25 May 2007 04:24:57 -0700
Date: Fri, 25 May 2007 21:24:41 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: RESVSP problems
Message-ID: <20070525112441.GQ85884050@sgi.com>
References: <200705241324.53283.lucke@o2.pl> <20070525050632.GG86004887@sgi.com> <200705251224.23624.lucke@o2.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200705251224.23624.lucke@o2.pl>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: =?iso-8859-1?Q?=C5=81ukasz?= Fibinger <lucke@o2.pl>
Cc: David Chinner <dgc@sgi.com>, xfs@oss.sgi.com

On Fri, May 25, 2007 at 12:24:23PM +0200, Å?ukasz Fibinger wrote:
> On Friday 25 of May 2007, you wrote:
> > On Thu, May 24, 2007 at 01:24:52PM +0200, Å?ukasz Fibinger wrote:
> > > >>> You've probably hit:
> > > >>> http://oss.sgi.com/bugzilla/show_bug.cgi?id=418
> > > >>> unwritten extents remain unwritten after mmap() modifies them
> > > >>>
> > > >>> Bug dchinner about it... ;-)
> > > >>
> > > >> Dave, consider it a bugging from my humble self :-)
> > > >
> > > > Yeah, yeah ;)
> > > >
> > > > I'm waiting to see what happens with Nick's patches in .22 before
> > > > going any further. If they are not merged into .22, then I think we
> > > > should push the XFS specific fix in....
> > >
> > > I wonder, what's the status of it, Dave?
> >
> > A couple of days ago:
> >
> > http://marc.info/?l=linux-mm&m=117988295814519&w=2
> >
> 
> I see. If that's the case, would sharing your 2.6.21 XFS specific fixes (you 
> have them, right?) with me be any problem for you?

The original XFS specific code was here:

http://marc.info/?l=linux-fsdevel&m=117080251026985&w=2

But if you want to patch your own kernel, I suggest that
you use the latest generic version I posted here:

http://marc.info/?l=linux-fsdevel&m=117426058311029&w=2
http://marc.info/?l=linux-fsdevel&m=117426070111133&w=2

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
