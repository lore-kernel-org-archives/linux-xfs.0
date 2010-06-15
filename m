Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o5F0qBlW064050 for <xfs@oss.sgi.com>; Mon, 14 Jun 2010 19:52:11 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9C1693C7872
	for <xfs@oss.sgi.com>; Mon, 14 Jun 2010 17:54:46 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail12.adl6.internode.on.net
	[150.101.137.97]) by cuda.sgi.com with ESMTP id
	ASohuIhutP4RmIlx for <xfs@oss.sgi.com>;
	Mon, 14 Jun 2010 17:54:46 -0700 (PDT)
Date: Tue, 15 Jun 2010 10:54:42 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] XFS: Fix gcc 4.6 set but not read and unused statement
	warnings v2
Message-ID: <20100615005442.GL6590@dastard>
References: <20100614081356.GA27499@basil.fritz.box>
	<20100614083021.GA29354@lst.de> <4C15EF75.5080909@linux.intel.com>
	<20100614124804.GA8547@lst.de>
	<20100614133958.GH17092@basil.fritz.box>
	<20100614163122.GB369@basil.fritz.box>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100614163122.GB369@basil.fritz.box>
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
To: Andi Kleen <andi@firstfloor.org>
Cc: Andi Kleen <ak@linux.intel.com>, Christoph Hellwig <hch@lst.de>, dgc@fromorbit.com, xfs@oss.sgi.com

On Mon, Jun 14, 2010 at 06:31:22PM +0200, Andi Kleen wrote:
> On Mon, Jun 14, 2010 at 03:39:58PM +0200, Andi Kleen wrote:
> > On Mon, Jun 14, 2010 at 02:48:04PM +0200, Christoph Hellwig wrote:
> > > On Mon, Jun 14, 2010 at 10:59:33AM +0200, Andi Kleen wrote:
> > > > >How can this work?  bp->data is a void pointer.
> > > > 
> > > > It compiled with CONFIG_XFS_DEBUG enabled. Do I need to set some other
> > > > option to test this?
> > > 
> > > It fails for me in a normal CONFIG_XFS_DEBUG build:
> > > 
> > > fs/xfs/xfs_da_btree.c: In function 'xfs_da_root_join':
> > > fs/xfs/xfs_da_btree.c:737: warning: dereferencing 'void *' pointer
> > > fs/xfs/xfs_da_btree.c:737: error: request for member 'magic' in
> > > something not a structure or union
> > > fs/xfs/xfs_da_btree.c:737: warning: dereferencing 'void *' pointer
> > 
> > 
> > Hmm, it really compiled here (scratching head)
> 
> Never mind, it seems SUBDIRS doesn't set the DEBUG flag correctly. 
> 
> Anyways I just dropped those hunks and you'll have to live with 
> the warnings if you don't want QASSERT.

I'm still not happy with it.

We'll commit a modified version of one of your patches into the XFS
tree as you seem unable to accept that changes might be necessary to
get your code to pass review.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
