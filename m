Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BDF4C433EF
	for <linux-xfs@archiver.kernel.org>; Mon,  6 Jun 2022 21:46:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233509AbiFFVqU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 6 Jun 2022 17:46:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232897AbiFFVqR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 6 Jun 2022 17:46:17 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 452F97A817
        for <linux-xfs@vger.kernel.org>; Mon,  6 Jun 2022 14:46:16 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 21C7610E7203;
        Tue,  7 Jun 2022 07:46:14 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nyKY9-003WTk-Pe; Tue, 07 Jun 2022 07:46:13 +1000
Date:   Tue, 7 Jun 2022 07:46:13 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     zhanchengbin <zhanchengbin1@huawei.com>, djwong@kernel.org,
        liuzhiqiang26@huawei.com, linfeilong <linfeilong@huawei.com>,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/3] mkfs/proto.c: avoid to use NULL pointer
Message-ID: <20220606214613.GT227878@dread.disaster.area>
References: <7f4abf2a-5ea5-e2ee-786e-88d871d29475@huawei.com>
 <44ef0950-791d-e17e-1fe8-f58d3148603f@huawei.com>
 <cadc327b-2370-1b1d-6822-ae8a1da6d58c@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <cadc327b-2370-1b1d-6822-ae8a1da6d58c@sandeen.net>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=629e75a7
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=IkcTkHD0fZMA:10 a=JPEYwPQDsx4A:10 a=7-415B0cAAAA:8
        a=QdrhV5ciU5Slyw6CrLYA:9 a=QEXdDO2ut3YA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jun 06, 2022 at 09:29:27AM -0500, Eric Sandeen wrote:
> On 6/6/22 7:33 AM, zhanchengbin wrote:
> > Change malloc to xmalloc.
> 
> The commit log and cover letter say nothing about this, but apparently
> "xmalloc" is often defined locally to abort() on a memory failure, so I
> guess you are trying to make (some of?) xfsprogs do that.
> 
> First, this doesn't seem to build....
> 
> Building mkfs
>     [CC]     proto.o
> proto.c: In function ‘setup_proto’:
> proto.c:73:15: warning: implicit declaration of function ‘xmalloc’; did you mean ‘malloc’? [-Wimplicit-function-declaration]
>    73 |         buf = xmalloc(size + 1);
>       |               ^~~~~~~
>       |               malloc
> proto.c:73:13: warning: assignment to ‘char *’ from ‘int’ makes pointer from integer without a cast [-Wint-conversion]
>    73 |         buf = xmalloc(size + 1);
>       |             ^
> proto.c: In function ‘newregfile’:
> proto.c:306:21: warning: assignment to ‘char *’ from ‘int’ makes pointer from integer without a cast [-Wint-conversion]
>   306 |                 buf = xmalloc(size);
>       |                     ^
>     [LD]     mkfs.xfs
> /usr/bin/ld: proto.o: in function `setup_proto':
> /src/git/xfsprogs-dev/mkfs/proto.c:73: undefined reference to `xmalloc'
> /usr/bin/ld: proto.o: in function `newregfile':
> /src/git/xfsprogs-dev/mkfs/proto.c:306: undefined reference to `xmalloc'
> collect2: error: ld returned 1 exit status
> gmake[2]: *** [../include/buildrules:65: mkfs.xfs] Error 1
> gmake[1]: *** [include/buildrules:36: mkfs] Error 2
> make: *** [Makefile:92: default] Error 2
> 
> Second, we have calls to malloc all over the codebase, including around
> 100 outside of the internal libraries in the various userspace utilities.
> Why change only mkfs/db/repair?

xmalloc is local to xfs_db (db/malloc.c), it's not part of libxfs.
It's local to xfs_db because it is the tool that always runs out of
memory on large filesystems. It's just a wrapper that prints "out of
memory" and then exits immediately with no chance to recover.  So,
essentially, it's no different to immediately SEGV on a NULL pointer
and dying.

> Third, what problem are you solving? Granted, we should be checking every
> malloc call, and it seems that we don't.

In general, that's because we can't do anything useful to free
memory when we fail memory allocation - we generally exit
immediately on memory allocation failure, so checking for failure is
almost redundant....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
