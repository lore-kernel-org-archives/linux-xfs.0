Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0D7BC433F5
	for <linux-xfs@archiver.kernel.org>; Wed, 20 Apr 2022 23:50:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243537AbiDTXxM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 20 Apr 2022 19:53:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241097AbiDTXxM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 20 Apr 2022 19:53:12 -0400
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 606E52AC4A
        for <linux-xfs@vger.kernel.org>; Wed, 20 Apr 2022 16:50:24 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-115-138.pa.nsw.optusnet.com.au [49.181.115.138])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 7E0CF534798;
        Thu, 21 Apr 2022 09:50:22 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nhK5U-002ZWc-Pk; Thu, 21 Apr 2022 09:50:20 +1000
Date:   Thu, 21 Apr 2022 09:50:20 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     bugzilla-daemon@kernel.org
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [Bug 215851] New: gcc 12.0.1 LATEST: -Wdangling-pointer= triggers
Message-ID: <20220420235020.GP1544202@dread.disaster.area>
References: <bug-215851-201763@https.bugzilla.kernel.org/>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <bug-215851-201763@https.bugzilla.kernel.org/>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=VuxAv86n c=1 sm=1 tr=0 ts=62609c3e
        a=/kVtbFzwtM2bJgxRVb+eeA==:117 a=/kVtbFzwtM2bJgxRVb+eeA==:17
        a=IkcTkHD0fZMA:10 a=z0gMJWrwH1QA:10 a=VwQbUJbxAAAA:8 a=UqCG9HQmAAAA:8
        a=7-415B0cAAAA:8 a=xMvW3ejOwVgTIqPl5YgA:9 a=QEXdDO2ut3YA:10
        a=AjGcO6oz07-iQ99wixmX:22 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Apr 18, 2022 at 08:02:41AM +0000, bugzilla-daemon@kernel.org wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=215851
> 
>             Bug ID: 215851
>            Summary: gcc 12.0.1 LATEST: -Wdangling-pointer= triggers
>            Product: File System
>            Version: 2.5
>     Kernel Version: 5.17.3
>           Hardware: All
>                 OS: Linux
>               Tree: Mainline
>             Status: NEW
>           Severity: normal
>           Priority: P1
>          Component: XFS
>           Assignee: filesystem_xfs@kernel-bugs.kernel.org
>           Reporter: Erich.Loew@outlook.com
>         Regression: No
> 
> Date:    20220415
> Kernel:  5.17.3
> Compiler gcc.12.0.1
> File:    linux-5.17.3/fs/xfs/libxfs/xfs_attr_remote.c
> Line:    141
> Issue:   Linux kernel compiling enables all warnings, this has consequnces:
>          -Wdangling-pointer= triggers because assignment of an address pointing
>          to something inside of the local stack 
>          of a function/method is returned to the caller.
>          Doing such things is tricky but legal, however gcc 12.0.1 complains
>          deeply on this.
>          Mitigation: disabling with pragmas temporarily inlined the compiler
>          triggered advises.
> Interesting: clang-15.0.0 does not complain.
> Remark: this occurence is reprsentative; the compiler warns at many places

The actual warning message is this:

fs/xfs/libxfs/xfs_attr_remote.c: In function ‘__xfs_attr3_rmt_read_verify’:
fs/xfs/libxfs/xfs_attr_remote.c:140:35: warning: storing the address of local variable ‘__here’ in ‘*failaddr’ [-Wdangling-pointer=]
  140 |                         *failaddr = __this_address;
In file included from ./fs/xfs/xfs.h:22,
                 from fs/xfs/libxfs/xfs_attr_remote.c:7:
./fs/xfs/xfs_linux.h:133:46: note: ‘__here’ declared here
  133 | #define __this_address  ({ __label__ __here; __here: barrier(); &&__here; })
      |                                              ^~~~~~
fs/xfs/libxfs/xfs_attr_remote.c:140:37: note: in expansion of macro ‘__this_address’
  140 |                         *failaddr = __this_address;
      |                                     ^~~~~~~~~~~~~~
./fs/xfs/xfs_linux.h:133:46: note: ‘failaddr’ declared here
  133 | #define __this_address  ({ __label__ __here; __here: barrier(); &&__here; })
      |                                              ^~~~~~
fs/xfs/libxfs/xfs_attr_remote.c:140:37: note: in expansion of macro ‘__this_address’
  140 |                         *failaddr = __this_address;
      |                                     ^~~~~~~~~~~~~~

I think this is a compiler bug. __here is declared as a *label*, not
a local variable:

#define __this_address ({ __label__ __here; __here: barrier(); &&__here; })

and it is valid to return the address of a label in the code as the
address must be a constant instruction address and not a local stack
variable. If the compiler is putting *executable code* on the stack,
we've got bigger problems...

We use __this_address extensively in XFS (indeed, there
are 8 separate uses in __xfs_attr3_rmt_read_verify() and
xfs_attr3_rmt_verify() alone) and it is the same as _THIS_IP_ used
across the rest of the kernel for the same purpose. The above is the
only warning that gets generated for any of (the hundreds of) sites
that use either _THIS_IP_ or __this_address is the only warning that
gets generated like this, it points to the problem being compiler
related, not an XFS problem.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
