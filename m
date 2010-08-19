Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o7JLerhR198879 for <xfs@oss.sgi.com>; Thu, 19 Aug 2010 16:40:53 -0500
Received: from postoffice2.aconex.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id F195F14D6D67
	for <xfs@oss.sgi.com>; Thu, 19 Aug 2010 14:50:49 -0700 (PDT)
Received: from postoffice2.aconex.com (mail.aconex.com [203.89.202.182]) by
	cuda.sgi.com with ESMTP id EIQj71jq2uWzOHus for
	<xfs@oss.sgi.com>; Thu, 19 Aug 2010 14:50:49 -0700 (PDT)
Date: Fri, 20 Aug 2010 07:41:16 +1000 (EST)
From: Nathan Scott <nathans@aconex.com>
Message-ID: <1359964397.180811282254076015.JavaMail.root@mail-au.aconex.com>
In-Reply-To: <20100819121153.GB16045@infradead.org>
Subject: Re: Review: xfsprogs with libblkid enabled for Debian
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
Cc: xfs <xfs@oss.sgi.com>


----- "Christoph Hellwig" <hch@infradead.org> wrote:

> On Wed, Aug 18, 2010 at 03:06:28PM +1000, nathans@aconex.com wrote:
> > Hi guys,
> > 
> > Attached patch adds support for libblkid in Debian builds.
> > There's a couple of other trivial things fixed up while the
> > package was building - man page typos reported by lintian,
> > fix source tarball generation (and deb build) when libblkid
> > is enabled (*must* descend into libdisk to pick up sources)
> > ... but its all pretty straight forward.
> > 
> > I've checked that mkfs.xfs is linked as expected too. :)
> 
> All the changes in here look good, but I'd be much happier if you'd
> submit separate changes with separate changelogs for the manpage
> updates and the libdisk packaging fix.
> 

Yep, will do.

> As for the blkid-dev build-dep: we need at least version 2.17 of it
> as that introduced the symbols we need, I think a versioned
> dependency for this would be in order.

Good point, will do.

> The doc/CHANGES update should include the names of external
> contributors
> where applicable, and currently the release date for is set as part
> of the release.sh process.

Oh, OK - hmm, will go through the git logs again & see what I can find.

> I'm fine with pushing out a new 3.1.3 release as it's time anyway,
> but
> can we also include Dave's patch to add XFS_IOC_ZERO_RANGE support to
> xfs_io and the xfsctl manpage first?

Sure, will wait for that before I commit anything.

> Next week also has Alex back from vacation, so I'd suggest waiting if
> he has any input on this.

No worries.

cheers.

-- 
Nathan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
