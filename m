Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 44C9A7F3F
	for <xfs@oss.sgi.com>; Tue, 15 Oct 2013 16:27:10 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 13ADF8F8054
	for <xfs@oss.sgi.com>; Tue, 15 Oct 2013 14:27:06 -0700 (PDT)
Received: from buxtehude.debian.org (buxtehude.debian.org [140.211.166.26]) by
	cuda.sgi.com with ESMTP id 6oWAZiakfxLm5w5J (version=TLSv1
	cipher=AES128-SHA bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 15 Oct 2013 14:27:05 -0700 (PDT)
Subject: Bug#725971: xfsprogs: config.guess/config.sub out of date for arm64
Resent-To: debian-bugs-dist@lists.debian.org
Resent-Message-ID: <handler.725971.B725971.138187229415718@bugs.debian.org>
Date: Tue, 15 Oct 2013 22:24:48 +0100
From: Colin Watson <cjwatson@ubuntu.com>
Message-ID: <20131015212448.GM32337@riva.ucam.org>
References: <20131010133811.GK32337@riva.ucam.org>
	<20131015194211.GA32095@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131015194211.GA32095@infradead.org>
Reply-To: Colin Watson <cjwatson@ubuntu.com>, 725971@bugs.debian.org
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
To: Christoph Hellwig <hch@infradead.org>
Cc: 725971@bugs.debian.org

On Tue, Oct 15, 2013 at 12:42:11PM -0700, Christoph Hellwig wrote:
> While updating it in the debhelp is nice for the Debian package I'd also
> really like to see a patch updating the files in the repository.  Colin,
> would you mind sending that patch, too?

I looked, but there's nothing to send; the xfsprogs repository doesn't
contain those files.  They're updated by the configure target in
Makefile, which is run as part of ./release.sh via "make dist".  (Good;
this should be as automatic as possible.)

IOW, any new upstream release will contain updated files as long as the
developer who built the release has current libtool etc. installed.  But
of course this should be fixed to auto-update at build time in the
Debian packaging anyway, since we want to be able to port to new
architectures without having to upload lots of new source packages or
take lots of new upstream releases at the same time; it makes life so
much easier.

Cheers,

-- 
Colin Watson                                       [cjwatson@ubuntu.com]

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
