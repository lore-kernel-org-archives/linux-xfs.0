Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n2RIWmlT260879 for <xfs@oss.sgi.com>; Fri, 27 Mar 2009 13:33:04 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id CEC0F1CDE8F
	for <xfs@oss.sgi.com>; Fri, 27 Mar 2009 11:32:03 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id K8HytACGxGoGOWBp for
	<xfs@oss.sgi.com>; Fri, 27 Mar 2009 11:32:03 -0700 (PDT)
Date: Fri, 27 Mar 2009 14:31:56 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [patch] fix parallel build failures in xfsprogs-3.0.0
Message-ID: <20090327183156.GA20588@infradead.org>
References: <200902240010.25434.vapier@gentoo.org>
	<200903081409.28808.agruen@suse.de>
	<20090327160204.GA9306@infradead.org>
	<200903271231.01055.vapier@gentoo.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <200903271231.01055.vapier@gentoo.org>
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
To: Mike Frysinger <vapier@gentoo.org>
Cc: Christoph Hellwig <hch@infradead.org>, nathans@debian.org, xfs-oss <xfs@oss.sgi.com>, Eric Sandeen <sandeen@sandeen.net>

On Fri, Mar 27, 2009 at 12:30:59PM -0400, Mike Frysinger wrote:
> On Friday 27 March 2009 12:02:04 Christoph Hellwig wrote:
> > I did some make dist and build the tarball tests with
> > acl,attr,xfsprogs & co.
> >
> > We still run libtoolize, aclocal and autoconf when building a clean
> > tree.  I wonder if we should just get rid of the whole configure target
> > and require a manual ./configure like most tools?
> 
> `make dist` should produce a tarball that, when unpacked, people can run:
> ./configure && make && make install

Yes.  The added complication is that the various xfs-cmds derived tools
also run ./configure from a default target make which complicates the
build system.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
