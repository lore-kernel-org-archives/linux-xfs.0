Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p5U6oQ3K187385 for <xfs@oss.sgi.com>; Thu, 30 Jun 2011 01:50:26 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5FC254C2886
	for <xfs@oss.sgi.com>; Wed, 29 Jun 2011 23:50:25 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	T6vaQyri4BUCeJ5y for <xfs@oss.sgi.com>;
	Wed, 29 Jun 2011 23:50:25 -0700 (PDT)
Date: Thu, 30 Jun 2011 02:50:24 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 00/27] patch queue for Linux 3.1
Message-ID: <20110630065024.GA6566@infradead.org>
References: <20110629140109.003209430@bombadil.infradead.org>
	<20110630063658.GI561@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110630063658.GI561@dastard>
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
Cc: xfs@oss.sgi.com

On Thu, Jun 30, 2011 at 04:36:58PM +1000, Dave Chinner wrote:
> On Wed, Jun 29, 2011 at 10:01:09AM -0400, Christoph Hellwig wrote:
> > This is my current patch queue for Linux 3.1.  It includes the previously
> > all previously sent patches I'm planning for Linux 3.1 inclusion through
> > the XFS tree and a few new ones.  The most important new bits is a cleanup
> > of the structures describing the dir2 on-disk format, which got a bit
> > more urgent due to more recent gcc versions complaining about the hacks
> > used in the current version.
> > 
> > The sync lifelock fix is included only in a minimal version that removes
> > the data syncs.  I plan to sort out the iocount waiting via the i_alloc_sem
> > removal patches that have been sent for inclusion in the VFS tree.  I'll
> > cc the XFS list on the updated version with XFS chances.
> 
> With this series I'm seeing test 180 fail relatively frequently with
> 1k block size filesystem. I shall try to debug this given the other
> reports of 180 failing that have recently come to light...

Interesting.  I've not seen 180 fail any time recently, with either 4k
of 512 byte block size filesystems.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
