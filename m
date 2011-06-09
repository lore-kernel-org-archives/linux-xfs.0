Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p598MaB6160504 for <xfs@oss.sgi.com>; Thu, 9 Jun 2011 03:22:37 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 583E216D43F2
	for <xfs@oss.sgi.com>; Thu,  9 Jun 2011 01:22:33 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	GqAJGjoqb8XPYtck for <xfs@oss.sgi.com>;
	Thu, 09 Jun 2011 01:22:33 -0700 (PDT)
Date: Thu, 9 Jun 2011 04:22:17 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Small files perform much faster on newly formatted fs?
Message-ID: <20110609082217.GA7129@infradead.org>
References: <20110607163742.GH28625@pyre.virge.net> <201106080911.11286@zmi.at>
	<20110608122638.GQ28625@pyre.virge.net>
	<20110609012907.GR32466@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110609012907.GR32466@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Michael Monnerie <michael.monnerie@is.it-management.at>, Norbert Veber <nveber@pyre.virge.net>, xfs@oss.sgi.com

On Thu, Jun 09, 2011 at 11:29:07AM +1000, Dave Chinner wrote:
> > > Then retry mounting the old fs with sunit= and swidth= parameters. Are 
> > > they on the same disks? What are your disks (number, kind)?
> > 
> > Yes its already mounted this way as I mentioned in my original message:
> > /dev/mapper/vg0-shared on /shared type xfs (rw,noatime,sunit=128,swidth=256)
> 
> Those mount options are ignored if the filesystem doesn't have the
> superblock feature bit set for aligned allocations. A filesystem
> with 0/0 for sunit/swidth does not have the superblock bit set....

The other thing that sticks out is the lack of lazy-count for the old
filesystem.  That will give a lot of additional superblock updates on
the old one.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
