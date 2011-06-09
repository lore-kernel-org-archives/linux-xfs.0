Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p591TBaD129589 for <xfs@oss.sgi.com>; Wed, 8 Jun 2011 20:29:11 -0500
Received: from ipmail06.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9CEB114E9735
	for <xfs@oss.sgi.com>; Wed,  8 Jun 2011 18:29:09 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	uxRDgd56Y4KMJWc6 for <xfs@oss.sgi.com>;
	Wed, 08 Jun 2011 18:29:09 -0700 (PDT)
Date: Thu, 9 Jun 2011 11:29:07 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Small files perform much faster on newly formatted fs?
Message-ID: <20110609012907.GR32466@dastard>
References: <20110607163742.GH28625@pyre.virge.net> <201106080911.11286@zmi.at>
	<20110608122638.GQ28625@pyre.virge.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110608122638.GQ28625@pyre.virge.net>
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
To: Norbert Veber <nveber@pyre.virge.net>
Cc: Michael Monnerie <michael.monnerie@is.it-management.at>, xfs@oss.sgi.com

On Wed, Jun 08, 2011 at 08:26:38AM -0400, Norbert Veber wrote:
> On Wed, Jun 08, 2011 at 09:11:10AM +0200, Michael Monnerie wrote:
> > On Dienstag, 7. Juni 2011 Norbert Veber wrote:
> > > 20 seconds vs 3+ minutes?!  The only difference I can see is
> > > lazy-count=1 and a larger agcount.  Sunit and swidth were also set
> > > automatically by mkfs this time.
> > 
> > Then retry mounting the old fs with sunit= and swidth= parameters. Are 
> > they on the same disks? What are your disks (number, kind)?
> 
> Yes its already mounted this way as I mentioned in my original message:
> /dev/mapper/vg0-shared on /shared type xfs (rw,noatime,sunit=128,swidth=256)

Those mount options are ignored if the filesystem doesn't have the
superblock feature bit set for aligned allocations. A filesystem
with 0/0 for sunit/swidth does not have the superblock bit set....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
