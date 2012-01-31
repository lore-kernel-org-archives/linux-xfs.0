Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0VL1ELu100004 for <xfs@oss.sgi.com>; Tue, 31 Jan 2012 15:01:14 -0600
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	lfG3lGd0jqu9JQcD for <xfs@oss.sgi.com>;
	Tue, 31 Jan 2012 13:01:12 -0800 (PST)
Date: Wed, 1 Feb 2012 08:01:10 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs_quota: remove calls to XFS_QSYNC
Message-ID: <20120131210110.GN9090@dastard>
References: <20120130115024.GA884@infradead.org>
	<CAAp5ZgNKsY-OrWyDNU70KUKYCZUX_EvzngAvBsBTgrgkK6KyMA@mail.gmail.com>
	<20120131162617.GF7762@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120131162617.GF7762@sgi.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Ben Myers <bpm@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, Nathan Scott <nathans@debian.org>, xfs@oss.sgi.com

On Tue, Jan 31, 2012 at 10:26:17AM -0600, Ben Myers wrote:
> On Tue, Jan 31, 2012 at 06:57:04AM +1100, Nathan Scott wrote:
> > On 30 January 2012 22:50, Christoph Hellwig <hch@infradead.org> wrote:
> > > ...
> > > Nathan, I've cced you in case you still remember anything about this,
> > > although it's fairly unlikely after 6.5 years. =A0Also if anyone at S=
GI
> > > can find anything about the above commits in BugWorks additional feed=
back
> > > would be welcome.
> > =

> > I can't recall - but usually there was greater detail in the bugworks e=
ntry,
> > I think thats your best source now.
> > =

> > Patch looks OK to me FWIW, assuming nothing comes of the bugworks
> > archeology exercise.
> =

> I'm not a ptools expert so I had to ask around.  This turned out to be
> =

> PV942815 - XFS quota reporting interacts badly with delalloc
> =

> "We get a constant trickle of confused people who've found that the used
> space reported by repquota/quota does not get immediately updated after
> creating new files / extending existing ones.  The problem is a result
> of buffered IO in XFS doing delayed allocation - if we have not done an
> allocation, the quota accounting has not been updated, so we end up with
> effectively stale data being reported.
> =

> This affects CXFS too, of course.  After discussion a few weeks back on
> the XFS conf. call, it was decided to not change CXFS (too expensive to
> do a flush on all nodes) but that we can make some simple XFS changes to
> make this less of a problem - i.e. flushing delalloc data just before we
> extract quota information." -Nathan

So effectively what that says to me is that quota only exports the
real block usage, even though it internally tracks delalloc
reservations. Perhaps an additionaly change to make in this case is
to fold the reserved blocks into what is reported to the quota
utilities?

Indeed, what is exported to userspace via xfs_qm_export_dquot() is
the information in the dquot core - the on-disk information - so
perhaps all we need to do is export dqp->q_res_bcount (the count of
real + reserved blocks) instead of the on-disk info?

Cheers,

Dave.
-- =

Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
