Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n2OLtRdY048214 for <xfs@oss.sgi.com>; Tue, 24 Mar 2009 16:55:37 -0500
Received: from mx2.suse.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 503681C69D1E
	for <xfs@oss.sgi.com>; Tue, 24 Mar 2009 14:54:39 -0700 (PDT)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id ikNECLJNU0Vm5W2K for <xfs@oss.sgi.com>;
	Tue, 24 Mar 2009 14:54:39 -0700 (PDT)
From: Andreas Gruenbacher <agruen@suse.de>
Subject: Re: [patch] fix parallel build failures in xfsprogs-3.0.0
Date: Tue, 24 Mar 2009 19:18:39 +0100
References: <200902240010.25434.vapier@gentoo.org>
	<20090316210249.GA2641@infradead.org>
	<20090324131249.GA6964@infradead.org>
In-Reply-To: <20090324131249.GA6964@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200903241918.39649.agruen@suse.de>
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
Cc: Mike Frysinger <vapier@gentoo.org>, Eric Sandeen <sandeen@sandeen.net>, xfs-oss <xfs@oss.sgi.com>

On Tuesday, 24 March 2009 14:12:49 Christoph Hellwig wrote:
> > +	ltmain.sh m4/libtool.m4 m4/ltoptions.m4 m4/ltsugar.m4 \
> > +	m4/ltversion.m4 m4/lt~obsolete.m4 \
>
> Btw, where do these m4 files come from?

>From libtool via libtoolize. The AC_PROG_LIBTOOL macro pulls them in AFAICT.

> Is this another libtool version dependency?

It would seem so but the build system simply ignores files in the file list 
that don't exist. This is all rather ugly, but at least the result works...

Andreas 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
