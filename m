Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 1D2D77F3F
	for <xfs@oss.sgi.com>; Tue, 15 Oct 2013 16:33:20 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id C8E288F8074
	for <xfs@oss.sgi.com>; Tue, 15 Oct 2013 14:33:08 -0700 (PDT)
Received: from buxtehude.debian.org (buxtehude.debian.org [140.211.166.26]) by
	cuda.sgi.com with ESMTP id p4yMG3bAqtgrjPPq (version=TLSv1
	cipher=AES128-SHA bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 15 Oct 2013 14:33:06 -0700 (PDT)
Subject: Bug#725971: xfsprogs: config.guess/config.sub out of date for arm64
Resent-To: debian-bugs-dist@lists.debian.org
Resent-Message-ID: <handler.725971.B725971.138187257918219@bugs.debian.org>
Date: Tue, 15 Oct 2013 14:29:30 -0700
From: Christoph Hellwig <hch@infradead.org>
Message-ID: <20131015212930.GA5874@infradead.org>
References: <20131010133811.GK32337@riva.ucam.org>
	<20131015194211.GA32095@infradead.org>
	<20131015212448.GM32337@riva.ucam.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131015212448.GM32337@riva.ucam.org>
Reply-To: Christoph Hellwig <hch@infradead.org>, 725971@bugs.debian.org
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Colin Watson <cjwatson@ubuntu.com>
Cc: Christoph Hellwig <hch@infradead.org>, 725971@bugs.debian.org

On Tue, Oct 15, 2013 at 10:24:48PM +0100, Colin Watson wrote:
> I looked, but there's nothing to send; the xfsprogs repository doesn't
> contain those files.  They're updated by the configure target in
> Makefile, which is run as part of ./release.sh via "make dist".  (Good;
> this should be as automatic as possible.)

Oh, forgot about that.

> IOW, any new upstream release will contain updated files as long as the
> developer who built the release has current libtool etc. installed.  But
> of course this should be fixed to auto-update at build time in the
> Debian packaging anyway, since we want to be able to port to new
> architectures without having to upload lots of new source packages or
> take lots of new upstream releases at the same time; it makes life so
> much easier.

As said, I don't disagree with your patch at all, I was just asking for
an additional patch which turned out not to be nessecary.

Thanks a lot!

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
