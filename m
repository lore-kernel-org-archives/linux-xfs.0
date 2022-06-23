Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7B7EC43334
	for <linux-xfs@archiver.kernel.org>; Thu, 23 Jun 2022 22:13:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229473AbiFWWNQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 23 Jun 2022 18:13:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229464AbiFWWNP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 23 Jun 2022 18:13:15 -0400
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A03BF1182B
        for <linux-xfs@vger.kernel.org>; Thu, 23 Jun 2022 15:13:12 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 442255ECD9D;
        Fri, 24 Jun 2022 08:13:11 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1o4V4X-00AG7a-MU; Fri, 24 Jun 2022 08:13:09 +1000
Date:   Fri, 24 Jun 2022 08:13:09 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Clay Gerrard <clay.gerrard@gmail.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: ENODATA on list/stat directory
Message-ID: <20220623221309.GU227878@dread.disaster.area>
References: <CA+_JKzo7V5PZkWGFPB5hP0pAtWrOsi0TomxHaO5W+ViEF8ctwQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+_JKzo7V5PZkWGFPB5hP0pAtWrOsi0TomxHaO5W+ViEF8ctwQ@mail.gmail.com>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=OJNEYQWB c=1 sm=1 tr=0 ts=62b4e577
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=kj9zAlcOel0A:10 a=JPEYwPQDsx4A:10 a=sVK2kaBsAAAA:8 a=7-415B0cAAAA:8
        a=Jue3FdvqcnXuxoIEujIA:9 a=CjuIK1q_8ugA:10 a=bM7yYgFJnCk8bKsWy3o2:22
        a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jun 23, 2022 at 02:52:22PM -0500, Clay Gerrard wrote:
> I work on an object storage system, OpenStack Swift, that has always
> used xfs on the storage nodes.  Our system has encountered many
> various disk failures and occasionally apparent file system corruption
> over the years, but we've been noticing something lately that might be
> "new" and I'm considering how to approach the problem.  I'm interested
> to solicit critique on my current thinking/process - particularly from
> xfs experts.
> 
> [root@s8k-sjc3-d01-obj-9 ~]# xfs_bmap
> /srv/node/d21865/quarantined/objects-1/e53/f0418758de4baaa402eb301c5bae3e53
> /srv/node/d21865/quarantined/objects-1/e53/f0418758de4baaa402eb301c5bae3e53:
> No data available
> [root@s8k-sjc3-d01-obj-9 ~]# xfs_db
> /srv/node/d21865/quarantined/objects-1/e53/f0418758de4baaa402eb301c5bae3e53
> /srv/node/d21865/quarantined/objects-1/e53/f0418758de4baaa402eb301c5bae3e53:
> No data available

ENODATA implies that it's trying to access an xattr that doesn't
exist.

> fatal error -- couldn't initialize XFS library
> [root@s8k-sjc3-d01-obj-9 ~]# ls -alhF /srv/node/d21865/quarantined/objects-1/e53
> ls: cannot access
> /srv/node/d21865/quarantined/objects-1/e53/f0418758de4baaa402eb301c5bae3e53:
> No data available
> total 4.0K
> drwxr-xr-x  9 swift swift  318 Jun  7 00:57 ./
> drwxr-xr-x 33 swift swift 4.0K Jun 23 16:10 ../
> d?????????  ? ?     ?        ?            ? f0418758de4baaa402eb301c5bae3e53/

That's the typical ls output when it couldn't stat() an inode. This
typically occurs when the inode has been corrupted. On XFS, at
least, this should result in a corruption warning in the kernel log.

Did you check dmesg for errors?

> drwxr-xr-x  2 swift swift   47 May 27 00:43 f04193c31edc9593007471ee5a189e53/
> drwxr-xr-x  2 swift swift   47 May 27 00:43 f0419c711a5a5d01dac6154970525e53/
> drwxr-xr-x  2 swift swift   47 May 27 00:43 f041a2548b9255493d16ba21c19b6e53/
> drwxr-xr-x  2 swift swift   47 Jun  7 00:57 f041aa09d40566d6915a706a22886e53/
> drwxr-xr-x  2 swift swift   39 May 27 00:43 f041ac88bf13e5458a049d827e761e53/
> drwxr-xr-x  2 swift swift   47 May 27 00:43 f041bfd1c234d44b591c025d459a7e53/
> [root@s8k-sjc3-d01-obj-9 ~]# python
> Python 2.7.5 (default, Nov 16 2020, 22:23:17)
> [GCC 4.8.5 20150623 (Red Hat 4.8.5-44)] on linux2
> Type "help", "copyright", "credits" or "license" for more information.
> >>> import os
> >>> os.stat('/srv/node/d21865/quarantined/objects-1/e53/f0418758de4baaa402eb301c5bae3e53')
> Traceback (most recent call last):
>   File "<stdin>", line 1, in <module>
> OSError: [Errno 61] No data available:
> '/srv/node/d21865/quarantined/objects-1/e53/f0418758de4baaa402eb301c5bae3e53'
> >>> os.listdir('/srv/node/d21865/quarantined/objects-1/e53/f0418758de4baaa402eb301c5bae3e53')
> Traceback (most recent call last):
>   File "<stdin>", line 1, in <module>
> OSError: [Errno 61] No data available:
> '/srv/node/d21865/quarantined/objects-1/e53/f0418758de4baaa402eb301c5bae3e53'
> >>>

Use strace, not the python debugger, to find what syscall returned
the error.

> [root@s8k-sjc3-d01-obj-9 ~]# uname -a
> Linux s8k-sjc3-d01-obj-9.nsv.sjc3.nvmetal.net
> 3.10.0-1160.62.1.el7.x86_64 #1 SMP Tue Apr 5 16:57:59 UTC 2022 x86_64
> x86_64 x86_64 GNU/Linux

That's a RHEL7 kernel. Upstream developers really can't help you
diagnose random weird problems with these kernels - they are
completely custom kernels and so only the vendor can really help you
with diagnosing to root cause of problems such as this. You should
talk to your RH support contact.

> I'd also like to be able to "simulate" this kind of corruption on a
> healthy filesystem so we can test our "quarantine/auditor" code that's
> trying to move these filesystem problems out of the way for the
> consistency engine.  Does anyone have any guess how I could MAKE an
> xfs filesystem produce this kind of behavior on purpose?

Use xfs_db to corrupt a directory inode, then try to read it.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
