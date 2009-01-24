Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n0O5ufDS251516 for <xfs@oss.sgi.com>; Fri, 23 Jan 2009 23:56:41 -0600
Received: from postoffice2.aconex.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 85F2E1BA88C3
	for <xfs@oss.sgi.com>; Fri, 23 Jan 2009 21:55:56 -0800 (PST)
Received: from postoffice2.aconex.com (mail.aconex.com [203.89.202.182]) by
	cuda.sgi.com with ESMTP id yczAjuzDWAYtjPX7 for
	<xfs@oss.sgi.com>; Fri, 23 Jan 2009 21:55:56 -0800 (PST)
Subject: Re: [PATCH] xfsprogs: update doc/CHANGES
From: Nathan Scott <nscott@aconex.com>
In-Reply-To: <20090124052859.GA32606@infradead.org>
References: <20090123005648.GA3194@infradead.org>
	<1232774578.13684.5.camel@verge.scott.net.au>
	<20090124052859.GA32606@infradead.org>
Date: Sat, 24 Jan 2009 16:52:51 +1100
Message-Id: <1232776371.13684.12.camel@verge.scott.net.au>
Mime-Version: 1.0
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Sat, 2009-01-24 at 00:28 -0500, Christoph Hellwig wrote:
> > > +	- Addition of the xfs_fsr and xfs_estimate tools previous found
> > > +	  in the xfsdump package
> > 
> > rpm magic is probably needed in build/rpm/rpm.spec.in to prevent
> > old versions of xfsdump from being installed alongside the new
> > xfsprogs ... else rpm will report file conflicts, I think?  Same
> > will be needed in debian/control... hmm, both should be pretty
> > easy - just change "Conflicts: xfsdump < 2.0.0" to "3.0.0" (and
> > we should make xfsdump v3 at this time too, so its very clear).
> 
> Agreed.  I think it's better to leave the debian part to you, and
> I'll look into the rpm part later.

Both files just need the above-mentioned change.  I'll send a
patch.

> Any chance you could also review the fsr and estimate manpage
> patches as they should go in before this one?

No worries - the estimate man page move looks fine (as long as
its also removed from xfsdump package, of course).

+//#include "config.h"
shouldn't be there in the final fsr checkin I guess - there is
no config.h in xfsprogs.

> +             if (fsetxattr(tfd, "X", "X", 1, XATTR_CREATE) != 0) {
the name needs to be namespace prefixed, so that would be:
    fsetxattr(tfd, "user.X", "X", ...);


cheers.

--
Nathan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
