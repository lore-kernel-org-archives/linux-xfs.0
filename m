Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p3RJCbUp227772 for <xfs@oss.sgi.com>; Wed, 27 Apr 2011 14:12:38 -0500
Received: from busoni.debian.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 99D6E417766
	for <xfs@oss.sgi.com>; Wed, 27 Apr 2011 12:16:09 -0700 (PDT)
Received: from busoni.debian.org (busoni.debian.org [140.211.15.34]) by
	cuda.sgi.com with ESMTP id 7AhE0Y2Xl8LgEtNz for
	<xfs@oss.sgi.com>; Wed, 27 Apr 2011 12:16:09 -0700 (PDT)
Subject: Bug#553875: libreadline5-dev removal pending,
	please update to readline6
Resent-To: debian-bugs-dist@lists.debian.org
Resent-Message-ID: <handler.553875.B553875.130393156326842@bugs.debian.org>
From: Matthias Klose <doko@debian.org>
Message-Id: <E1QFAAE-0001W1-Sr@ravel.debian.org>
Date: Wed, 27 Apr 2011 19:12:42 +0000
Reply-To: Matthias Klose <doko@debian.org>, 553875@bugs.debian.org
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: 553875@bugs.debian.org

The package still build-depends on libreadline5-dev. Please
change the dependency to libreadline-dev, before libreadline5-dev
isn't built anymore.

Packages which cannot use readline6 (GPLv3) should build-depend
on libreadline-gplv2-dev instead.


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
