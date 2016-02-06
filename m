Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 0ACC27CA2
	for <xfs@oss.sgi.com>; Sat,  6 Feb 2016 07:27:13 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id DF072304032
	for <xfs@oss.sgi.com>; Sat,  6 Feb 2016 05:27:09 -0800 (PST)
Received: from buxtehude.debian.org (buxtehude.debian.org [206.12.19.147]) by
	cuda.sgi.com with ESMTP id tbFKw5xhBanGdPMr (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Sat, 06 Feb 2016 05:27:07 -0800 (PST)
Subject: Bug#766811: spurious library links
Resent-To: debian-bugs-dist@lists.debian.org
Resent-Message-ID: <handler.766811.B766811.145476496816448@bugs.debian.org>
Date: Sat, 6 Feb 2016 14:22:41 +0100
From: Jakub Wilk <jwilk@debian.org>
Message-ID: <20160206132241.GA2869@jwilk.net>
References: <20141026004825.GA27863@bongo.bofh.it>
	<20160124151308.GA7620@jwilk.net>
	<20160206005821.GA11551@bongo.bofh.it>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160206005821.GA11551@bongo.bofh.it>
Reply-To: Jakub Wilk <jwilk@debian.org>, 766811@bugs.debian.org
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: 766811@bugs.debian.org
Cc: Marco d'Itri <md@linux.it>

* Marco d'Itri <md@linux.it>, 2016-02-06, 01:58:
>>I can still see them in the current version:
>You are right, I was fooled because the extra files disappear if you
>rebuild the package:
>
>md@bongo:/tmp/xfs/xfsprogs-4.3.0+nmu1$ find debian/|grep libhandle
>debian/xfslibs-dev/lib/libhandle.so
>debian/xfslibs-dev/usr/lib/libhandle.a
>debian/xfslibs-dev/usr/lib/libhandle.la
>debian/xfsprogs/lib/libhandle.so.1
>debian/xfsprogs/lib/libhandle.so.1.0.3

I can't reproduce this disappearance in a clean up-to-date sid chroot.

AFAICS this is the code responsible for creating /lib/libfoo <-> 
/usr/lib/libfoo symlinks (see include/buildmacros:79):

if [ "x$(shell readlink -f $(PKG_LIB_DIR))" != \
     "x$(shell readlink -f $(PKG_ROOT_LIB_DIR))" ]; then \
        ../$(INSTALL) -S $(PKG_LIB_DIR)/$(LIBNAME).a $(PKG_ROOT_LIB_DIR)/$(LIBNAME).a; \
        ../$(INSTALL) -S $(PKG_LIB_DIR)/$(LIBNAME).la $(PKG_ROOT_LIB_DIR)/$(LIBNAME).la; \
        ../$(INSTALL) -S $(PKG_ROOT_LIB_DIR)/$(LIBNAME).so $(PKG_LIB_DIR)/$(LIBNAME).so; \
fi

I guess the symlinks weren't created on your system only because your 
/lib is symlinked to /usr/lib.

-- 
Jakub Wilk

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
