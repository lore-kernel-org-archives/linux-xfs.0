Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n2OLOXnS046619 for <xfs@oss.sgi.com>; Tue, 24 Mar 2009 16:24:48 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4D91B1C009C
	for <xfs@oss.sgi.com>; Tue, 24 Mar 2009 14:24:07 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id y74Mzq8V34guhcAp for
	<xfs@oss.sgi.com>; Tue, 24 Mar 2009 14:24:07 -0700 (PDT)
Date: Tue, 24 Mar 2009 09:12:49 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [patch] fix parallel build failures in xfsprogs-3.0.0
Message-ID: <20090324131249.GA6964@infradead.org>
References: <200902240010.25434.vapier@gentoo.org>
	<20090316070550.GA628@infradead.org>
	<200903160331.53142.vapier@gentoo.org>
	<200903161053.32745.agruen@suse.de>
	<20090316210249.GA2641@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20090316210249.GA2641@infradead.org>
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
To: Andreas Gruenbacher <agruen@suse.de>
Cc: Christoph Hellwig <hch@infradead.org>, Mike Frysinger <vapier@gentoo.org>, Eric Sandeen <sandeen@sandeen.net>, xfs-oss <xfs@oss.sgi.com>

> +	ltmain.sh m4/libtool.m4 m4/ltoptions.m4 m4/ltsugar.m4 \
> +	m4/ltversion.m4 m4/lt~obsolete.m4 \

Btw, where do these m4 files come from?  Is this another libtool
version dependency?  I can't find them anywhere for either acl/attr
or the patched xfsprogs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
