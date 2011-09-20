Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8KAwKT3054878 for <xfs@oss.sgi.com>; Tue, 20 Sep 2011 05:58:20 -0500
Received: from hall.aurel32.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 87A8A13FDCC4
	for <xfs@oss.sgi.com>; Tue, 20 Sep 2011 04:03:35 -0700 (PDT)
Received: from hall.aurel32.net (hall.aurel32.net [88.191.126.93]) by
	cuda.sgi.com with ESMTP id w3xGDiQk4uBMzo5E for
	<xfs@oss.sgi.com>; Tue, 20 Sep 2011 04:03:35 -0700 (PDT)
Date: Tue, 20 Sep 2011 12:58:08 +0200
From: Aurelien Jarno <aurel32@debian.org>
Subject: Re: The xfsprogs debian package
Message-ID: <20110920105808.GA20601@hall.aurel32.net>
References: <20110919170936.GA27014@infradead.org>
	<20110919171047.GA3092@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110919171047.GA3092@infradead.org>
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
Cc: nathans@debian.org, xfs@oss.sgi.com, anibal@debian.org

On Mon, Sep 19, 2011 at 01:10:47PM -0400, Christoph Hellwig wrote:
> [and now with the correct Cc list]
> 
> On Mon, Sep 19, 2011 at 01:09:36PM -0400, Christoph Hellwig wrote:
> > Hi Aurelien, Nathan & Anibal,
> > 
> > is there any chance we can get to a defintive agreement on how to
> > maintain the xfsprogs package?  So far the idea of releasing the
> > upstream releases as Debian packages at the same time has worked
> > great for both Debian, and us xfs developers (which to a large
> > extents are heavy Debian users), but "inner" Debian circles heave
> > always complained about it.
> > 
> > Can we please get an explanation of why it is so in proper written
> > englush, instead of doing by forced nmus?

First of all I have to point here that there is no issue in having the
debian/ directory present in upstream, as long as the people doing the
development upstream and in debian are usually the same (this condition
is actually not true anymore with the latest dpkg format, which can
ignore an existing debian/ directory, but that's not the point here).

The problem is on the point of having a native package, that is not
having a .diff.gz or a debian.tar.gz. Not doing so causes a few issues:
- Native packages are supposed to be Debian specific, not doing means 
  they are wrongly identified by various scripts running in the archive.
  For example the translation of the Debian native packages done by 
  Debian. In this case it means that Debian translators receive a mail
  each time a string is changed in xfsprogs in order to translate it.
  It's great if xfsprogs can be translated in other language, but the
  priority is given first to Debian specific packages.
- Making xfsprogs a native package also means that the upstream version
  needs to match the version in Debian. If there is a need to do a
  change in xfsprogs directly in Debian like for the recent NMU, we end
  up with a version in Debian that has never existed upstream.
- For archive space reason, if one upload only needs a small change in
  the debian/ directory, it means a full .tar.gz has to be uploaded
  instead of a small .diff.gz or debian.tar.gz.

Again I don't ask for not putting the debian/ directory, it's totally
possible to have a non-native package with an empty .diff.gz or
.debian.tar.gz.

Aurelien

-- 
Aurelien Jarno	                        GPG: 1024D/F1BCDB73
aurelien@aurel32.net                 http://www.aurel32.net

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
