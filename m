Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48829C433FE
	for <linux-xfs@archiver.kernel.org>; Sat, 25 Sep 2021 23:05:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3000960F3A
	for <linux-xfs@archiver.kernel.org>; Sat, 25 Sep 2021 23:05:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230078AbhIYXHb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 25 Sep 2021 19:07:31 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:55213 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230200AbhIYXHb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 25 Sep 2021 19:07:31 -0400
Received: from dread.disaster.area (pa49-195-238-16.pa.nsw.optusnet.com.au [49.195.238.16])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 999D688391F;
        Sun, 26 Sep 2021 09:05:52 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1mUGjv-00GirU-A4; Sun, 26 Sep 2021 09:05:51 +1000
Date:   Sun, 26 Sep 2021 09:05:51 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     Chandan Babu R <chandan.babu@oracle.com>,
        linux-xfs@vger.kernel.org, Dave Chinner <dchinner@redhat.com>,
        djwong@kernel.org
Subject: Re: [PATCH V2 1/5] xfsprogs: introduce liburcu support
Message-ID: <20210925230551.GY1756565@dread.disaster.area>
References: <20210924140912.201481-1-chandan.babu@oracle.com>
 <20210924140912.201481-2-chandan.babu@oracle.com>
 <41a4a5e6-c58e-97e7-666b-d1205ed0604f@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <41a4a5e6-c58e-97e7-666b-d1205ed0604f@sandeen.net>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=F8MpiZpN c=1 sm=1 tr=0
        a=DzKKRZjfViQTE5W6EVc0VA==:117 a=DzKKRZjfViQTE5W6EVc0VA==:17
        a=kj9zAlcOel0A:10 a=7QKq2e-ADPsA:10 a=20KFwNOVAAAA:8 a=yPCof4ZbAAAA:8
        a=7-415B0cAAAA:8 a=Y5oyGSg1vFo__DxSxOcA:9 a=CjuIK1q_8ugA:10
        a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Sep 24, 2021 at 04:51:32PM -0500, Eric Sandeen wrote:
> On 9/24/21 9:09 AM, Chandan Babu R wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > The upcoming buffer cache rework/kerenl sync-up requires atomic
> > variables. I could use C++11 atomics build into GCC, but they are a
> > pain to work with and shoe-horn into the kernel atomic variable API.
> > 
> > Much easier is to introduce a dependency on liburcu - the userspace
> > RCU library. This provides atomic variables that very closely match
> > the kernel atomic variable API, and it provides a very similar
> > memory model and memory barrier support to the kernel. And we get
> > RCU support that has an identical interface to the kernel and works
> > the same way.
> > 
> > Hence kernel code written with RCU algorithms and atomic variables
> > will just slot straight into the userspace xfsprogs code without us
> > having to think about whether the lockless algorithms will work in
> > userspace or not. This reduces glue and hoop jumping, and gets us
> > a step closer to having the entire userspace libxfs code MT safe.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > [chandan.babu@oracle.com: Add m4 macros to detect availability of liburcu]
> 
> Thanks for fixing that up. I had tried to use rcu_init like Dave originally
> had, and I like that better in general, but I had trouble with it - I guess
> maybe it gets redefined based on memory model magic and the actual symbol
> "rcu_init" maybe isn't available? I didn't dig very much.

Ah, so I just checked where the m4/package_urcu.m4 file went -
forgot to re-add it after it rejected on apply. The diff is this:

diff --git a/m4/package_urcu.m4 b/m4/package_urcu.m4
new file mode 100644
index 000000000000..9b0dee35d9a1
--- /dev/null
+++ b/m4/package_urcu.m4
@@ -0,0 +1,22 @@
+AC_DEFUN([AC_PACKAGE_NEED_URCU_H],
+  [ AC_CHECK_HEADERS(urcu.h)
+    if test $ac_cv_header_urcu_h = no; then
+       AC_CHECK_HEADERS(urcu.h,, [
+       echo
+       echo 'FATAL ERROR: could not find a valid urcu header.'
+       exit 1])
+    fi
+  ])
+
+AC_DEFUN([AC_PACKAGE_NEED_RCU_INIT],
+  [ AC_MSG_CHECKING([for liburcu])
+    AC_TRY_COMPILE([
+#define _GNU_SOURCE
+#include <urcu.h>
+    ], [
+       rcu_init();
+    ], liburcu=-lurcu
+       AC_MSG_RESULT(yes),
+       AC_MSG_RESULT(no))
+    AC_SUBST(liburcu)
+  ])

And this ends up with the output on a current debian system of:

checking urcu.h usability... yes
checking urcu.h presence... yes
checking for urcu.h... yes
checking for liburcu... yes

IOWs, the package check I was using directly probed for rcu_init()
being present in liburcu. Hence if liburcu is not providing this
function via the default linking like we use with xfsprogs, then
we fail at the configure step.

So it liburcu is not providing rcu_init(), then the configure step
should fail, and you need to work out what is different about the
liburcu that is installed on the distro you are building on....

> Also, dumb question from me - how do we know where we need the
> rcu_[un]register_thread() calls? Will it be obvious if we miss it
> in the future?  "each thread must invoke this function before its
> first call to rcu_read_lock() or call_rcu()."

urcu should fire an assert on any attempt to access urcu TLS storage
because the "urcu.registered" flag in the TLS area has not been
initialised.  IOWs, if we miss register/unregister then things will
go bad in urcu calls and it should be noticed.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com


