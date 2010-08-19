Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o7JCBNmH170309 for <xfs@oss.sgi.com>; Thu, 19 Aug 2010 07:11:23 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3CA909202
	for <xfs@oss.sgi.com>; Thu, 19 Aug 2010 05:11:54 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id Hzf8k4KvyJpPIcO3 for
	<xfs@oss.sgi.com>; Thu, 19 Aug 2010 05:11:54 -0700 (PDT)
Date: Thu, 19 Aug 2010 08:11:53 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Review: xfsprogs with libblkid enabled for Debian
Message-ID: <20100819121153.GB16045@infradead.org>
References: <472498892.114291282107960876.JavaMail.root@mail-au.aconex.com>
	<86828409.114311282107988740.JavaMail.root@mail-au.aconex.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <86828409.114311282107988740.JavaMail.root@mail-au.aconex.com>
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
To: nathans@aconex.com
Cc: xfs <xfs@oss.sgi.com>

On Wed, Aug 18, 2010 at 03:06:28PM +1000, nathans@aconex.com wrote:
> Hi guys,
> 
> Attached patch adds support for libblkid in Debian builds.
> There's a couple of other trivial things fixed up while the
> package was building - man page typos reported by lintian,
> fix source tarball generation (and deb build) when libblkid
> is enabled (*must* descend into libdisk to pick up sources)
> ... but its all pretty straight forward.
> 
> I've checked that mkfs.xfs is linked as expected too. :)

All the changes in here look good, but I'd be much happier if you'd
submit separate changes with separate changelogs for the manpage
updates and the libdisk packaging fix.

As for the blkid-dev build-dep: we need at least version 2.17 of it
as that introduced the symbols we need, I think a versioned dependency
for this would be in order.

The doc/CHANGES update should include the names of external contributors
where applicable, and currently the release date for is set as part
of the release.sh process.

I'm fine with pushing out a new 3.1.3 release as it's time anyway, but
can we also include Dave's patch to add XFS_IOC_ZERO_RANGE support to
xfs_io and the xfsctl manpage first?

Next week also has Alex back from vacation, so I'd suggest waiting if
he has any input on this.


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
