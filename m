Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n9P7jeKh094172 for <xfs@oss.sgi.com>; Sun, 25 Oct 2009 02:45:40 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 60F2D1777A37
	for <xfs@oss.sgi.com>; Sun, 25 Oct 2009 00:47:16 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id qZnv8QwhynhOpKpH for
	<xfs@oss.sgi.com>; Sun, 25 Oct 2009 00:47:16 -0700 (PDT)
Date: Sun, 25 Oct 2009 03:47:15 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfsprogs: simplify and unify source package generation
Message-ID: <20091025074715.GC9482@infradead.org>
References: <20091011024504.GA16725@infradead.org>
	<1205635767.11581255391391231.JavaMail.root@mail-au.aconex.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1205635767.11581255391391231.JavaMail.root@mail-au.aconex.com>
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
To: Nathan Scott <nscott@aconex.com>
Cc: xfs@oss.sgi.com

On Tue, Oct 13, 2009 at 10:49:51AM +1100, Nathan Scott wrote:
> >From looking through the patch it seems OK to me.  I haven't had a chance
> to test it out yet, though - but from just eyeballing it, and if noone
> pipes up complaining about the auto-rpm-build removal (I don't expect
> they will, at this stage of xfsprogs life) it all looks good and correct.

Thanks.  Does this count as a reviewed-by?

Btw, one other thing I'm pondering is removing the automatic call to
./configure from make if it's not configured yet.  It causes lots of 
pain for the toplevel makefile and the makefile snipplets in include/.
We'd have to replace the .deb building makefile snipplet with a
build-debs.sh shell script, but that might be cleaner anyway.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
