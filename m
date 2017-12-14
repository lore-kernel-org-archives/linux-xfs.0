Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42760 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751763AbdLNFvE (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 14 Dec 2017 00:51:04 -0500
Date: Thu, 14 Dec 2017 13:51:02 +0800
From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH 4/9] build: update AC_PACKAGE_WANT_GDBM() and
 src/dbtest.c to build
Message-ID: <20171214055102.GE2749@eguan.usersys.redhat.com>
References: <20171213004519.29340-1-mcgrof@kernel.org>
 <20171213004519.29340-5-mcgrof@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171213004519.29340-5-mcgrof@kernel.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Luis R. Rodriguez" <mcgrof@kernel.org>
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org

On Tue, Dec 12, 2017 at 04:45:14PM -0800, Luis R. Rodriguez wrote:
> Modern gdbm-devel packages bundle together gdbm.h and ndbm.h.
> The old m4 macro had detection support for some old gdbm libraries
> but not for new ones.
> 
> We fix compilation of src/dbtest.c by making the autoconf helper
> check for this new arrangement:
> 
> If both gdbm.h and gdbm.h are found define set both gdbm_ndbm_=true,
                     ^^^^^^ ndbm.h?
> and have_db=true, and define HAVE_GDBM_H. The src/dbtest.c already
> had a HAVE_GDBM_H but there was never a respective autoconf settter for
> it. We can just re-use this and fix it for new arrangement.
> 
> Signed-off-by: Luis R. Rodriguez <mcgrof@kernel.org>

This looks fine to me.

The only system I have by hand that have both <gdbm.h> and <ndbm.h> but
not any <gdbm/[gn]dbm.h> is openSUSE Tumbleweed. Without this patch,
dbtest was not built on openSUSE, and was built successfully with this
patch applied. And dbtest is still built on RHEL6/7 and Fedora.

BTW, I'll queue patch 3 and this patch for next fstests release, while
other patches seem not necessary, I agreed with Dave that groups are not
for excluding tests, the required tools and environments should be
detected by tests and _notrun if not met. (The README change looks fine,
but it doesn't apply due to the "fsgqa-381" change, so I drop it too for
now.)

Thanks,
Eryu
