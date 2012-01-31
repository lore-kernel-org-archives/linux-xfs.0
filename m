Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0VGQGjj056764 for <xfs@oss.sgi.com>; Tue, 31 Jan 2012 10:26:17 -0600
Date: Tue, 31 Jan 2012 10:26:17 -0600
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH] xfs_quota: remove calls to XFS_QSYNC
Message-ID: <20120131162617.GF7762@sgi.com>
References: <20120130115024.GA884@infradead.org>
	<CAAp5ZgNKsY-OrWyDNU70KUKYCZUX_EvzngAvBsBTgrgkK6KyMA@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAAp5ZgNKsY-OrWyDNU70KUKYCZUX_EvzngAvBsBTgrgkK6KyMA@mail.gmail.com>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: Nathan Scott <nathans@debian.org>, xfs@oss.sgi.com

On Tue, Jan 31, 2012 at 06:57:04AM +1100, Nathan Scott wrote:
> On 30 January 2012 22:50, Christoph Hellwig <hch@infradead.org> wrote:
> > ...
> > Nathan, I've cced you in case you still remember anything about this,
> > although it's fairly unlikely after 6.5 years. =A0Also if anyone at SGI
> > can find anything about the above commits in BugWorks additional feedba=
ck
> > would be welcome.
> =

> I can't recall - but usually there was greater detail in the bugworks ent=
ry,
> I think thats your best source now.
> =

> Patch looks OK to me FWIW, assuming nothing comes of the bugworks
> archeology exercise.

I'm not a ptools expert so I had to ask around.  This turned out to be

PV942815 - XFS quota reporting interacts badly with delalloc

"We get a constant trickle of confused people who've found that the used
space reported by repquota/quota does not get immediately updated after
creating new files / extending existing ones.  The problem is a result
of buffered IO in XFS doing delayed allocation - if we have not done an
allocation, the quota accounting has not been updated, so we end up with
effectively stale data being reported.

This affects CXFS too, of course.  After discussion a few weeks back on
the XFS conf. call, it was decided to not change CXFS (too expensive to
do a flush on all nodes) but that we can make some simple XFS changes to
make this less of a problem - i.e. flushing delalloc data just before we
extract quota information." -Nathan


Patch looks good to me.

Reviewed-by: Ben Myers <bpm@sgi.com>

-Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
