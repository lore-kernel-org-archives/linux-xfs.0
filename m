Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n9CNmWWN062129 for <xfs@oss.sgi.com>; Mon, 12 Oct 2009 18:48:32 -0500
Received: from postoffice2.aconex.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D0D274BCFBD
	for <xfs@oss.sgi.com>; Mon, 12 Oct 2009 16:49:57 -0700 (PDT)
Received: from postoffice2.aconex.com (mail.aconex.com [203.89.202.182]) by
	cuda.sgi.com with ESMTP id DLd3ktlEiM4fddYm for
	<xfs@oss.sgi.com>; Mon, 12 Oct 2009 16:49:57 -0700 (PDT)
Date: Tue, 13 Oct 2009 10:49:51 +1100 (EST)
From: Nathan Scott <nscott@aconex.com>
Message-ID: <1205635767.11581255391391231.JavaMail.root@mail-au.aconex.com>
In-Reply-To: <20091011024504.GA16725@infradead.org>
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

> Currently the build/ directory can create rpm, debian and source /
> binary
> tar packages.  The RPM generation is not used as all distributions
> prefer,
> their own spec files, and the binary tarball not used at all as it's
> a not very useful format.  Reimplement the generation of the source
> tarballs to use the source-link method used for the debian packages
> and
> get rid of the whole old package generation machinery.  Also fix a
> small
> bug in the link-based source directory creation which was not
> including
> the .pot file for gettext.

>From looking through the patch it seems OK to me.  I haven't had a chance
to test it out yet, though - but from just eyeballing it, and if noone
pipes up complaining about the auto-rpm-build removal (I don't expect
they will, at this stage of xfsprogs life) it all looks good and correct.

cheers.

-- 
Nathan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
