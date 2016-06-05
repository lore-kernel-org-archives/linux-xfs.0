Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 3E6027CA0
	for <xfs@oss.sgi.com>; Sun,  5 Jun 2016 00:17:08 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id C72E7AC004
	for <xfs@oss.sgi.com>; Sat,  4 Jun 2016 22:17:04 -0700 (PDT)
Received: from 1wt.eu (wtarreau.pck.nerim.net [62.212.114.60]) by cuda.sgi.com
	with ESMTP id wlPbwhlMC4POCPfm for <xfs@oss.sgi.com>;
	Sat, 04 Jun 2016 22:17:01 -0700 (PDT)
Date: Sun, 5 Jun 2016 07:16:54 +0200
From: Willy Tarreau <w@1wt.eu>
Subject: Re: XFS hole punch races
Message-ID: <20160605051654.GA20713@1wt.eu>
References: <20160322155740.GB28772@quack.suse.cz>
	<1465060270.2847.149.camel@decadent.org.uk>
	<20160604232800.GW26977@dastard>
	<1465089572.2847.180.camel@decadent.org.uk>
	<20160605021654.GX26977@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160605021654.GX26977@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Jan Kara <jack@suse.cz>, Ben Hutchings <ben@decadent.org.uk>, stable@vger.kernel.org, xfs@oss.sgi.com

Dave,

On Sun, Jun 05, 2016 at 12:16:54PM +1000, Dave Chinner wrote:
> On Sun, Jun 05, 2016 at 02:19:32AM +0100, Ben Hutchings wrote:
> > On Sun, 2016-06-05 at 09:28 +1000, Dave Chinner wrote:
> > > You do realise that this sort of backport effectively makes the
> > > stable kernels unsupportable by the upstream XFS developers? You're
> > > taking random changes from the upstream kernel until the kernel
> > > compiles, and then mostly hoping that it works.
> > 
> > I'm applying slightly more intelligence than that, but of course I'm
> > not an XFS developer.
> 
> Sorry, Ben, I didn't mean to imply you hadn't done your due diligence
> properly. It's more a case of lots of things around these patches
> also changed, and from that perspective the changes are effective a
> random selection of changes spread across several years of
> development.
> 
> It's subtle things, like changes to how IO completion is processed
> (especially for AIO), etc that the backported code might depend on
> for correct behaviour but aren't in the older kernels. These sorts
> of subtle problems are typically only discovered by users with
> uncommon applications and/or load....

Does this mean that as a rule of thumb we'd rather avoid backporting
XFS fixes unless they seem really obvious (or at all) ?

Thanks,
Willy

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
