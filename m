Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 941A77CBF
	for <xfs@oss.sgi.com>; Tue, 18 Jun 2013 01:22:11 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 6A0EA304032
	for <xfs@oss.sgi.com>; Mon, 17 Jun 2013 23:22:11 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	CxEkAsi9IWols02C for <xfs@oss.sgi.com>;
	Mon, 17 Jun 2013 23:22:09 -0700 (PDT)
Date: Tue, 18 Jun 2013 16:21:54 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: fix sgid inheritance for subdirectories inheriting
	default acls
Message-ID: <20130618062154.GS29338@dastard>
References: <1371238877-5722-1-git-send-email-cmaiolino@redhat.com>
	<20130618044931.GQ29338@dastard>
	<20130618045529.GA20365@infradead.org>
	<20130618055351.GR29338@dastard>
	<20130618055709.GA11600@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130618055709.GA11600@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: Carlos Maiolino <cmaiolino@redhat.com>, xfs@oss.sgi.com

On Mon, Jun 17, 2013 at 10:57:09PM -0700, Christoph Hellwig wrote:
> On Tue, Jun 18, 2013 at 03:53:51PM +1000, Dave Chinner wrote:
> > > I'd rather opencode updating the mode here, it's really just a tiny bit
> > > of boilerplate code.
> > 
> > Needs a transaction, though. Right now, there's no transaction code
> > at all in xfs_acl.c and I'd kind of like to keep it that way as it's
> > just a translation layer....
> 
> True.  Maybe as a quick hack just extend the meaning of XFS_ATTR_NOACL
> to also not do the checks?  It's already the magic flag to mean that
> we are called from the ACL code.

That would work, too. I hadn't connected the dots with that flag,
but it's a good fit for this case. It's probably the least intrusive
fix....

> Alternatively move all of xfs_set_mode, or at least everything around
> the "if (mode != inode->i_mode) " to xfs_iops.c.

<shrug>

I'm don't really care that much where it is ;)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
