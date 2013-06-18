Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 6F23B29DF8
	for <xfs@oss.sgi.com>; Tue, 18 Jun 2013 00:54:02 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 0A2F3AC006
	for <xfs@oss.sgi.com>; Mon, 17 Jun 2013 22:53:58 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	U7GV5Kv97geMfmry for <xfs@oss.sgi.com>;
	Mon, 17 Jun 2013 22:53:56 -0700 (PDT)
Date: Tue, 18 Jun 2013 15:53:51 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: fix sgid inheritance for subdirectories inheriting
	default acls
Message-ID: <20130618055351.GR29338@dastard>
References: <1371238877-5722-1-git-send-email-cmaiolino@redhat.com>
	<20130618044931.GQ29338@dastard>
	<20130618045529.GA20365@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130618045529.GA20365@infradead.org>
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

On Mon, Jun 17, 2013 at 09:55:29PM -0700, Christoph Hellwig wrote:
> On Tue, Jun 18, 2013 at 02:49:31PM +1000, Dave Chinner wrote:
> > 	xfs_set_mode()
> > 	{
> > 		setup iattr
> > 		return xfs_setattr_nonsize_nomodecheck()
> > 	}
> 
> I'd rather opencode updating the mode here, it's really just a tiny bit
> of boilerplate code.

Needs a transaction, though. Right now, there's no transaction code
at all in xfs_acl.c and I'd kind of like to keep it that way as it's
just a translation layer....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
