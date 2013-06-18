Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id F15EF29DF8
	for <xfs@oss.sgi.com>; Tue, 18 Jun 2013 00:57:13 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 85290AC003
	for <xfs@oss.sgi.com>; Mon, 17 Jun 2013 22:57:13 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id 5NMCJBVfYR9VwElE (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 17 Jun 2013 22:57:12 -0700 (PDT)
Date: Mon, 17 Jun 2013 22:57:09 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: fix sgid inheritance for subdirectories inheriting
	default acls
Message-ID: <20130618055709.GA11600@infradead.org>
References: <1371238877-5722-1-git-send-email-cmaiolino@redhat.com>
	<20130618044931.GQ29338@dastard>
	<20130618045529.GA20365@infradead.org>
	<20130618055351.GR29338@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130618055351.GR29338@dastard>
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
Cc: Christoph Hellwig <hch@infradead.org>, Carlos Maiolino <cmaiolino@redhat.com>, xfs@oss.sgi.com

On Tue, Jun 18, 2013 at 03:53:51PM +1000, Dave Chinner wrote:
> > I'd rather opencode updating the mode here, it's really just a tiny bit
> > of boilerplate code.
> 
> Needs a transaction, though. Right now, there's no transaction code
> at all in xfs_acl.c and I'd kind of like to keep it that way as it's
> just a translation layer....

True.  Maybe as a quick hack just extend the meaning of XFS_ATTR_NOACL
to also not do the checks?  It's already the magic flag to mean that
we are called from the ACL code.

Alternatively move all of xfs_set_mode, or at least everything around
the "if (mode != inode->i_mode) " to xfs_iops.c.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
