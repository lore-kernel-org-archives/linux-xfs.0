Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	n08Fb9S5002732 for <xfs@oss.sgi.com>; Thu, 8 Jan 2009 09:37:13 -0600
Date: Thu, 8 Jan 2009 10:37:08 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfsdump support for 64K page size
Message-ID: <20090108153708.GA30563@infradead.org>
References: <4964C5EF.3060308@sgi.com> <4965629C.2000703@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4965629C.2000703@sgi.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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
To: Mark Goodwin <markgw@sgi.com>
Cc: xfs-dev <xfs-dev@sgi.com>, xfs@oss.sgi.com

On Thu, Jan 08, 2009 at 01:19:08PM +1100, Mark Goodwin wrote:
> 
> 
> Bill Kendall wrote:
> > Various fixes to allow xfsdump/xfsrestore to work with 64K
> > page size. This is essentially Chinner's patch from a while
> > back.
> >
> > Signed-off-by: Bill Kendall <wkendall@sgi.com>
> 
> Lachlan reviewed and ack'd this on an internal list and I've committed
> it (on Bill's behalf) as follows :
> 
> git://oss.sgi.com/xfs/cmds/xfsdump.git
> 	commit 9502587dbbfdd465958889a568dc2842f10b1ff9
> 	Author: Mark Goodwin <markgw@sgi.com>
> 	Date:   Thu Jan 8 12:37:53 2009 +1100
> 
> 	    Various fixes to allow xfsdump/xfsrestore to work with 64K
> 	    page size. This is essentially Chinner's patch from a while
> 	    back.
> 	
> 	    Signed-off-by: Bill Kendall <wkendall@sgi.com>
> 	    Signed-off-by: Lachlan McIlroy <lachlan@sgi.com>
> 	    Signed-off-by: Mark Goodwin <markgw@sgi.com>
> 
> and for the libhandle changes :

If you commit something on someone else's behalf please use the --author
argument to git-commit so that it shows up as coming from that author
in the git version history.  Or just use git-am on the patch mail which
will sort out all this by itself.

> This introduces a dependency between xfsdump and libhandle (in xfsprogs),
> which may or may not be an issue now that the cmds are in split trees.

It's not a new depdency.  xfsdump depended on libhandle for a long time
(and before it did depend on dmapi IIRC).  Just to actually get dump
properly working with 64k pages you need the most uptodate version
of both packages.

> I guess maybe xfsdump/restore should rightfully be part of xfsprogs?

I think having them split makes a lot of sense as many people don't
need dump.  What we should eventually do is to move xfs_fsr over to
xfsprogs.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
