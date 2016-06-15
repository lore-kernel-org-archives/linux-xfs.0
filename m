Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 40EFC7CA0
	for <xfs@oss.sgi.com>; Wed, 15 Jun 2016 01:40:31 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id AF2A0AC002
	for <xfs@oss.sgi.com>; Tue, 14 Jun 2016 23:40:27 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	DrgHLIm54Dz3XHWG for <xfs@oss.sgi.com>;
	Tue, 14 Jun 2016 23:40:24 -0700 (PDT)
Date: Wed, 15 Jun 2016 16:40:22 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Something badly broken with the latest XFS changeset in all
	stable kernels?
Message-ID: <20160615064022.GD26977@dastard>
References: <75808782-835f-4bc9-5243-b25cab00d6f3@whissi.de>
	<20160615000241.GC26977@dastard> <20160615013056.GA23074@kroah.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160615013056.GA23074@kroah.com>
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
To: Greg KH <greg@kroah.com>
Cc: "Thomas D." <whissi@whissi.de>, spender@grsecurity.net, stable@vger.kernel.org, xfs@oss.sgi.com

On Tue, Jun 14, 2016 at 06:30:56PM -0700, Greg KH wrote:
> On Wed, Jun 15, 2016 at 10:02:41AM +1000, Dave Chinner wrote:
> > On Mon, Jun 13, 2016 at 11:57:53PM +0200, Thomas D. wrote:
> > > The bad commit according to grsec's statement is
> > > 
> > > > From b1438f477934f5a4d5a44df26f3079a7575d5946 Mon Sep 17 00:00:00 2001
> > > > From: Dave Chinner <dchinner@redhat.com>
> > > > Date: Wed, 18 May 2016 13:53:42 +1000
> > > > Subject: [PATCH] xfs: xfs_iflush_cluster fails to abort on error
> > > 
> > > Would be nice to get some clarification.
> > 
> > There's nothing wrong with that commit in the upstream kernel,
> > it's the backport that has a bug in it because it failed to take
> > into account changes outside the context of the upstream commit that
> > the older kernels don't have.
> 
> Thanks for letting me know about this.
> 
> As the patch was tagged with 3.10+, I assumed that it was safe to be
> merged to those older kernels, otherwise I would never have done so.  We
> do have ways to mark external things like this for stable patches, it's
> a great help when doing backports.

Little things like this are very easy to forget about - those error
sign changes are ancient history as far as upstream development is
concerned. This is why we have regression tests - the zero-day
kernel robot can run xfstests - perhaps stable kernels should be
submitted to a full round of testing before release to catch
subtle "patch applies but ends up wrong" issues like this...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
