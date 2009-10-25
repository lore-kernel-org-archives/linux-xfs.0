Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n9PMZQbc164386 for <xfs@oss.sgi.com>; Sun, 25 Oct 2009 17:35:26 -0500
Received: from postoffice2.aconex.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 30573C53054
	for <xfs@oss.sgi.com>; Sun, 25 Oct 2009 15:37:01 -0700 (PDT)
Received: from postoffice2.aconex.com (mail.aconex.com [203.89.202.182]) by
	cuda.sgi.com with ESMTP id CC8gwynljdE60x91 for
	<xfs@oss.sgi.com>; Sun, 25 Oct 2009 15:37:01 -0700 (PDT)
Date: Mon, 26 Oct 2009 09:36:45 +1100 (EST)
From: Nathan Scott <nscott@aconex.com>
Message-ID: <396549975.11101256510205184.JavaMail.root@mail-au.aconex.com>
In-Reply-To: <20091025074715.GC9482@infradead.org>
Subject: Re: [PATCH] xfsprogs: simplify and unify source package generation
MIME-Version: 1.0
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


----- "Christoph Hellwig" <hch@infradead.org> wrote:

> On Tue, Oct 13, 2009 at 10:49:51AM +1100, Nathan Scott wrote:
> > >From looking through the patch it seems OK to me.  I haven't had a
> chance
> > to test it out yet, though - but from just eyeballing it, and if
> noone
> > pipes up complaining about the auto-rpm-build removal (I don't
> expect
> > they will, at this stage of xfsprogs life) it all looks good and
> correct.
> 
> Thanks.  Does this count as a reviewed-by?

Yep, sorry - Reviewed-by: Nathan Scott <nathans@debian.org>

> Btw, one other thing I'm pondering is removing the automatic call to
> ./configure from make if it's not configured yet.  It causes lots of 
> pain for the toplevel makefile and the makefile snipplets in
> include/.
> We'd have to replace the .deb building makefile snipplet with a
> build-debs.sh shell script, but that might be cleaner anyway.

Its not so bad IMO & we seem to be getting into the realm of gratuitous
change, but - *shrug* - doesn't make much difference I guess, I'm sure
people will figure it out pretty quickly.

cheers.

-- 
Nathan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
