Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:19593 "EHLO
        ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S938629AbcKKW2d (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 11 Nov 2016 17:28:33 -0500
Date: Sat, 12 Nov 2016 09:28:24 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] shared/006: improve the speed of case running
Message-ID: <20161111222824.GJ28922@dastard>
References: <1478795242-14022-1-git-send-email-zlang@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1478795242-14022-1-git-send-email-zlang@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Zorro Lang <zlang@redhat.com>
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org

On Fri, Nov 11, 2016 at 12:27:22AM +0800, Zorro Lang wrote:
> There're three problems of this case:
> 1. Thousands of threads will be created to create lots of files, then
>    kernel need to waste lots of system resource to schedule these
>    threads. Some poor performance machines will take long long time
>    on that.
> 2. Per thread try to create 1000 files by run 1000 times "echo >file".
> 
> For the 1st problem, I limit 2 threads per cpu, and the maximum is 20.
> For the 2nd problem, use "sed 1 1000 | xargs touch" to instead of
> the old way.
> 
> With this change, this case can run over in 2 mins on my x86_64
> virtual machine with 1 cpu and 1G memory. Before that, it was still
> running even a quarter passed.
> 
> Signed-off-by: Zorro Lang <zlang@redhat.com>
> ---
> 
> Hi,
> 
> The performance of this case affect the test time of xfstests,
> especially on poor performance VM. I always doubt it hangs there,
> because it has run too long time.
> 
> After this improvement:
> It ran 105s on my virtual machine with 1 cpu and 1G memory.
> It ran 60s on my real machine with 8 cpu and 64G memory.
> 
> The difference of "for ((i=0;i<1000;i++)); echo -n > file$i;done"
> and "touch file{1..1000}" is:
> The 1st one will run 1000 times execve, open, close and so on. The
> execve() will take much time, especially on VM.
> But the 2nd one will run once execve, 1000 times open and once close.
> open() take much less time than execve().
> 
> Too many threads really waste too much time. For example, on my VM,
> when I use $((ncpus * 2)) threads to run this case, it ran 100s. But
> if I use $((ncpus * 4)) threads, the time increase to 130s. So too
> many threads is not helpful, in contrast it wastes more time.

If the only aim is to create inodes faster, then going above 4
threads making inodes concurrently isn't going to increase speed.
Most small filesystems don't have the configuration necessary to
scale much past this (e.g. journal size, AG/BG count, etc all will
limit concurrency on typical test filesystems.

There's a reason that the tests that create hundreds of thousands of
inodes are quite limited in the amount of concurrency they support...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
