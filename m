Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38784 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753537AbdLNRzG (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 14 Dec 2017 12:55:06 -0500
Date: Thu, 14 Dec 2017 18:55:03 +0100
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: Re: [PATCH 4/9] build: update AC_PACKAGE_WANT_GDBM() and
 src/dbtest.c to build
Message-ID: <20171214175503.GL16026@wotan.suse.de>
References: <20171213004519.29340-1-mcgrof@kernel.org>
 <20171213004519.29340-5-mcgrof@kernel.org>
 <20171214055102.GE2749@eguan.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171214055102.GE2749@eguan.usersys.redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eryu Guan <eguan@redhat.com>
Cc: "Luis R. Rodriguez" <mcgrof@kernel.org>, fstests@vger.kernel.org, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org

On Thu, Dec 14, 2017 at 01:51:02PM +0800, Eryu Guan wrote:
> On Tue, Dec 12, 2017 at 04:45:14PM -0800, Luis R. Rodriguez wrote:
> > Modern gdbm-devel packages bundle together gdbm.h and ndbm.h.
> > The old m4 macro had detection support for some old gdbm libraries
> > but not for new ones.
> > 
> > We fix compilation of src/dbtest.c by making the autoconf helper
> > check for this new arrangement:
> > 
> > If both gdbm.h and gdbm.h are found define set both gdbm_ndbm_=true,
>                      ^^^^^^ ndbm.h?
> > and have_db=true, and define HAVE_GDBM_H. The src/dbtest.c already
> > had a HAVE_GDBM_H but there was never a respective autoconf settter for
> > it. We can just re-use this and fix it for new arrangement.
> > 
> > Signed-off-by: Luis R. Rodriguez <mcgrof@kernel.org>
> 
> This looks fine to me.
> 
> The only system I have by hand that have both <gdbm.h> and <ndbm.h> but
> not any <gdbm/[gn]dbm.h> is openSUSE Tumbleweed.

Indeed, openSUSE and SLE releases.

> Without this patch,
> dbtest was not built on openSUSE, and was built successfully with this
> patch applied.

Yeap.

> And dbtest is still built on RHEL6/7 and Fedora.

Feel free to modify the commit log accordingly then. Curious, what packages
does Fedora/ RHEL6/7 use for the requirement here?

We just have one:

$ rpm -ql gdbm-devel-1.12-1.282.x86_64
/usr/bin/gdbm_dump
/usr/bin/gdbm_load
/usr/bin/gdbmtool
/usr/include/dbm.h
/usr/include/gdbm.h
/usr/include/ndbm.h
/usr/lib64/libgdbm.a
/usr/lib64/libgdbm.so
/usr/lib64/libgdbm_compat.a
/usr/lib64/libgdbm_compat.so
/usr/lib64/libndbm.a
/usr/lib64/libndbm.so
/usr/share/info/gdbm.info.gz
/usr/share/man/man1/gdbm_dump.1.gz
/usr/share/man/man1/gdbm_load.1.gz
/usr/share/man/man1/gdbmtool.1.gz
/usr/share/man/man3/gdbm.3.gz

> BTW, I'll queue patch 3 and this patch for next fstests release, while
> other patches seem not necessary,

I think patch 2 is fine too.

> I agreed with Dave that groups are not
> for excluding tests, the required tools and environments should be
> detected by tests and _notrun if not met.

Yeah makes sense now. I think we should also document when adding
a group makes sense as well.

> (The README change looks fine,
> but it doesn't apply due to the "fsgqa-381" change, so I drop it too for
> now.)

Feel free to modify it, its not a big deal.

  Luis
