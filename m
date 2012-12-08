Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qB8C4WmR029704 for <xfs@oss.sgi.com>; Sat, 8 Dec 2012 06:04:32 -0600
Date: Sat, 8 Dec 2012 07:06:56 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [3.0-stable PATCH 00/36] Proposed 3.0-stable bug patches
Message-ID: <20121208120656.GA8780@infradead.org>
References: <20121203144208.143464631@sgi.com> <20121205214505.GG29399@dastard>
	<50C0D57A.9000704@sgi.com> <20121207100646.GJ27172@dastard>
	<20121207211536.GW27055@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20121207211536.GW27055@sgi.com>
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
To: Ben Myers <bpm@sgi.com>
Cc: Mark Tinguely <tinguely@sgi.com>, Greg KH <gregkh@linuxfoundation.org>, stable@vger.kernel.org, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>

On Fri, Dec 07, 2012 at 03:15:36PM -0600, Ben Myers wrote:
> > > >So I'll ask the same question that Christoph asked me: If nobody is
> > > >reporting problems on 3.0.x, why do this and risk regression and
> > > >fallout that requires fixing?
> > > >
> > > >FWIW, what testing have you done?
> > > 
> > > Do you mean?
> > > 
> > > 	http://oss.sgi.com/archives/xfs/2012-09/msg00002.html
> > > 
> > > I read that message as a concern that your original Linux 3.0-stable
> > > patch series contained some items that did not meet the -stable
> > > criteria.
> > 
> > I read it as "why change something that no-one is reporting bugs
> > for?".
> 
> I guess we could all stop putting words in his mouth and let him speak for
> himself.  Christoph (cc'd), would you please clarify your position?

Well, both of the above applies.  A lot of the patches are defintively
above the normal -stable criteria.  If we have a reall good reason we
might be able to bend the criteria, but I'd really love to see
justificaton for that, preferably in form of user reports of grave
issues.

> Stable folk (cc'd Greg), what is your disposition with regard to proposing
> patches for -stable proactively?  Do we really need to have a bug report from a
> 3.0-stable user for every bug we propose for 3.0-stable?

I don't think we'll need any report for things that are

 a) obvious lingering big problems

and have

 b) non-invasive fixes

occasionally just one of the criteria should be enough.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
