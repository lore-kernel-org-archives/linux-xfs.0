Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q6482NCq182008 for <xfs@oss.sgi.com>; Wed, 4 Jul 2012 03:02:23 -0500
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	voV2oAisDSyx3Sdb for <xfs@oss.sgi.com>;
	Wed, 04 Jul 2012 01:02:21 -0700 (PDT)
Date: Wed, 4 Jul 2012 18:02:17 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Backporting the concurrent direct IO write fix to 3.4
Message-ID: <20120704080217.GF19223@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120704055419.GA27500@infradead.org>
	<CA+sTkh4jk5wAoD32jfe2stzhKpSyB_GCXHSZSp9zjPc+ZfR5Hw@mail.gmail.com>
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
To: Igor M Podlesny <for.poige+xfs@gmail.com>, Christoph Hellwig <hch@infradead.org>
Cc: Kerin Millar <kerframil@gmail.com>, xfs@oss.sgi.com

On Wed, Jul 04, 2012 at 12:09:06PM +0800, Igor M Podlesny wrote:
> On 4 July 2012 07:11, Dave Chinner <david@fromorbit.com> wrote:
> [...]
> >> On the one hand I'd love to see these patches go into 3.4-stable as it's
> >> going to be a long term release,
> >
> > Is it? So we will have long term support kernels for 3.0.x, 3.2.x
> > and now 3.4.x? 3.0.x is the long term stable kernel I'm targetting
> > for backports and there's no way I can really handle more than
> > that...
> 
>    That's quite a pity! In production there's often even 2.6.32 since
> it's chosen as RHEL6's kernel.

RHEL6 is using a 2.6.32 kernel only in name. The XFS code in RHEL6
is only a few commits short of 3.0 in terms of functionality (i.e.
RHEL 6.2 has full delaylog functionality), and most other supported
subsystems and drivers are similarly advanced well past 2.6.32.
Hence I'm looking at 3.0.x for long term stable maintenance of XFS,
not 2.6.32.x...

On Wed, Jul 04, 2012 at 01:54:19AM -0400, Christoph Hellwig wrote:
> On Wed, Jul 04, 2012 at 09:11:22AM +1000, Dave Chinner wrote:
> > Is it? So we will have long term support kernels for 3.0.x, 3.2.x
> > and now 3.4.x? 3.0.x is the long term stable kernel I'm targetting
> > for backports and there's no way I can really handle more than
> > that...
> 
> I remember Greg announced 3.4 to be long term in addition to 3.0
> recently.

I missed that announcement - lost in the noise of lkml I guess...

> 3.2 only is the Debian release kernel, for which the
> maintainers offered to maintain it as a formal stable release
> on kernel.org

I know, but we're already seeing bug reports from people using that
kernel...

> And yes, it's getting not only confusing but also way to much work
> for subsystem maintainers.
> 
> I'm still happy to backport fixes to 3.0, but for more invasive work
> it's getting a bit too old now.

As RHEL6 and 3.0.x XFS code bases are almost the same I effectively
have to maintain a 3.0 tree and backport the necessary (invasive,
even) fixes to it.  It is comparitively little extra work for me to
test and push fixes to both, and I'll get much earlier and wider
deployment of the backports by pushing them to 3.0.x as well. It's a
no-brainer AFAIC.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
