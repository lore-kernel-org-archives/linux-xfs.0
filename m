Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3EFFAC433FE
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Jan 2022 20:08:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231422AbiAYUIH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 25 Jan 2022 15:08:07 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:59286 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231396AbiAYUH6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Jan 2022 15:07:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643141277;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=CT4LYvH45/Alq1wDcBaDP4ycKsdqJNKxJgixR6bTR7E=;
        b=BSNFM2x1IpQJWcrLftmkqc0KYqbCbBloUQWlkQKNdrmKouWqkibdaP7W7Uz72v7x+1cN2+
        2oKmNz5IGAWJFHXD61wlO4ZCwKVuQLM15q1aFVahnTgFIQ31RJKPcwTcSnAZ1RLGTDvgI6
        L2UyewwNEfkdGXIMkNCKS1Kzxs64vcw=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-660-8QeN_x_JPnqbz-HmsJ2zeA-1; Tue, 25 Jan 2022 15:07:56 -0500
X-MC-Unique: 8QeN_x_JPnqbz-HmsJ2zeA-1
Received: by mail-qv1-f71.google.com with SMTP id kl20-20020a056214519400b0042382bf37f2so6819606qvb.5
        for <linux-xfs@vger.kernel.org>; Tue, 25 Jan 2022 12:07:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=CT4LYvH45/Alq1wDcBaDP4ycKsdqJNKxJgixR6bTR7E=;
        b=MFhHyyBvgylp2MLUqe/b8BNlqHPN7DAEvsdB1QFB8kjz3nVWzHRPnkleHsrMR9u/kS
         R6clf1oZ/XtiZ+IdhIF8F1m1uxPFB22JfnDxYienvOTtWOAgDFvKOx6vscOBTk0N+7Iy
         T32jXqUG4g8rlAS6L+Una8oCEwIXSrxg2sUIDFlZDnRbOyedYprmK437GBIwWocvMaqI
         ISFErZHb6i8gYfhhwS6cg+RH9njVXSnd0YAJ37aIUU8rBn2+6F3+rLgdmLWh7vaSngZ4
         7NKi9xt6MXXARStsTEFUF44KEe3SUsREOjr7gkvPH406WDfTHgskO/ViROoJ1KqWA3gG
         kruw==
X-Gm-Message-State: AOAM533tSryZ4WHFF8Wt9ulYAqQPfgt270/NKYzKMmuV2Kx3p0FaWmU1
        30a6P5SiLLJtGPx23bk96RORUX+B6U4/QFbF5CyV3BVkF58pCP3RPVnN/faaSrmDgc7Im1NSO+p
        9Q7TTgMdVaG/nQSXBJUgP
X-Received: by 2002:ac8:57c8:: with SMTP id w8mr18018383qta.630.1643141275705;
        Tue, 25 Jan 2022 12:07:55 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyzEcG92c+guKG7LgdaQ7EfKx+GVUDpsf98mpNRCwdSDw/CJ2newvyMhFVebHKypbaSZbX94w==
X-Received: by 2002:ac8:57c8:: with SMTP id w8mr18018227qta.630.1643141273872;
        Tue, 25 Jan 2022 12:07:53 -0800 (PST)
Received: from bfoster (c-24-61-119-116.hsd1.ma.comcast.net. [24.61.119.116])
        by smtp.gmail.com with ESMTPSA id h6sm3212606qko.7.2022.01.25.12.07.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Jan 2022 12:07:53 -0800 (PST)
Date:   Tue, 25 Jan 2022 15:07:51 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        Ian Kent <raven@themaw.net>, rcu@vger.kernel.org
Subject: Re: [PATCH] xfs: require an rcu grace period before inode recycle
Message-ID: <YfBYl583QOWtwJ74@bfoster>
References: <20220121142454.1994916-1-bfoster@redhat.com>
 <Ye6/g+XMSyp9vYvY@bfoster>
 <20220124220853.GN59729@dread.disaster.area>
 <Ye82TgBY0VmtTjMc@bfoster>
 <20220125003120.GO59729@dread.disaster.area>
 <YfBBzHascwVnefYY@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YfBBzHascwVnefYY@bfoster>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jan 25, 2022 at 01:30:36PM -0500, Brian Foster wrote:
> On Tue, Jan 25, 2022 at 11:31:20AM +1100, Dave Chinner wrote:
> > On Mon, Jan 24, 2022 at 06:29:18PM -0500, Brian Foster wrote:
> > > On Tue, Jan 25, 2022 at 09:08:53AM +1100, Dave Chinner wrote:
> > > > > FYI, I modified my repeated alloc/free test to do some batching and form
> > > > > it into something more able to measure the potential side effect / cost
> > > > > of the grace period sync. The test is a single threaded, file alloc/free
> > > > > loop using a variable per iteration batch size. The test runs for ~60s
> > > > > and reports how many total files were allocated/freed in that period
> > > > > with the specified batch size. Note that this particular test ran
> > > > > without any background workload. Results are as follows:
> > > > > 
> > > > > 	files		baseline	test
> > > > > 
> > > > > 	1		38480		38437
> > > > > 	4		126055		111080
> > > > > 	8		218299		134469
> > > > > 	16		306619		141968
> > > > > 	32		397909		152267
> > > > > 	64		418603		200875
> > > > > 	128		469077		289365
> > > > > 	256		684117		566016
> > > > > 	512		931328		878933
> > > > > 	1024		1126741		1118891
> > > > 
> > > > Can you post the test code, because 38,000 alloc/unlinks in 60s is
> > > > extremely slow for a single tight open-unlink-close loop. I'd be
> > > > expecting at least ~10,000 alloc/unlink iterations per second, not
> > > > 650/second.
> > > > 
> > > 
> > > Hm, Ok. My test was just a bash script doing a 'touch <files>; rm
> > > <files>' loop. I know there was application overhead because if I
> > > tweaked the script to open an fd directly rather than use touch, the
> > > single file performance jumped up a bit, but it seemed to wash away as I
> > > increased the file count so I kept running it with larger sizes. This
> > > seems off so I'll port it over to C code and see how much the numbers
> > > change.
> > 
> > Yeah, using touch/rm becomes fork/exec bound very quickly. You'll
> > find that using "echo > <file>" is much faster than "touch <file>"
> > because it runs a shell built-in operation without fork/exec
> > overhead to create the file. But you can't play tricks like that to
> > replace rm:
> > 
> 
> I had used 'exec' to open an fd (same idea) in the single file case and
> tested with that, saw that the increase was consistent and took that
> along with the increasing performance as batch sizes increased to mean
> that the application overhead wasn't a factor as the test scaled. That
> was clearly wrong, because if I port the whole thing to a C program the
> baseline numbers are way off. I think what also threw me off is that the
> single file test kernel case is actually fairly accurate between the two
> tests. Anyways, here's a series of (single run, no averaging, etc.) test
> runs with the updated test. Note that I reduced the runtime to 10s here
> since the test was running so much faster. Otherwise this is the same
> batched open/close -> unlink behavior:
> 
>                 baseline        test
> batch:  1       files:  893579  files:  41841
> batch:  2       files:  912502  files:  41922
> batch:  4       files:  930424  files:  42084
> batch:  8       files:  932072  files:  41536
> batch:  16      files:  930624  files:  41616
> batch:  32      files:  777088  files:  41120
> batch:  64      files:  567936  files:  57216
> batch:  128     files:  579840  files:  96256
> batch:  256     files:  548608  files:  174080
> batch:  512     files:  546816  files:  246784
> batch:  1024    files:  509952  files:  328704
> batch:  2048    files:  505856  files:  399360
> batch:  4096    files:  479232  files:  438272
> 
> So this shows that the performance delta is actually massive from the
> start. For reference, a single threaded, empty file, non syncing,
> fs_mark workload stabilizes at around ~55k files/sec on this fs. Both
> kernels sort of converge to that rate as the batch size increases, only
> the baseline kernel starts much faster and normalizes while the test
> kernel starts much slower and improves (and still really doesn't hit the
> mark even at a 4k batch size).
> 
> My takeaway from this is that we may need to find a way to mitigate this
> overhead somewhat better than what the current patch does. Otherwise,
> this is a significant dropoff from even a pure allocation workload in
> simple mixed workload scenarios...
> 
> > $ time for ((i=0;i<1000;i++)); do touch /mnt/scratch/foo; rm /mnt/scratch/foo ; done
> > 
> > real    0m2.653s
> > user    0m0.910s
> > sys     0m2.051s
> > $ time for ((i=0;i<1000;i++)); do echo > /mnt/scratch/foo; rm /mnt/scratch/foo ; done
> > 
> > real    0m1.260s
> > user    0m0.452s
> > sys     0m0.913s
> > $ time ./open-unlink 1000 /mnt/scratch/foo
> > 
> > real    0m0.037s
> > user    0m0.001s
> > sys     0m0.030s
> > $
> > 
> > Note the difference in system time between the three operations -
> > almost all the difference in system CPU time is the overhead of
> > fork/exec to run the touch/rm binaries, not do the filesystem
> > operations....
> > 
> > > > > That's just a test of a quick hack, however. Since there is no real
> > > > > urgency to inactivate an unlinked inode (it has no potential users until
> > > > > it's freed),
> > > > 
> > > > On the contrary, there is extreme urgency to inactivate inodes
> > > > quickly.
> > > > 
> > > 
> > > Ok, I think we're talking about slightly different things. What I mean
> > > above is that if a task removes a file and goes off doing unrelated
> > > $work, that inode will just sit on the percpu queue indefinitely. That's
> > > fine, as there's no functional need for us to process it immediately
> > > unless we're around -ENOSPC thresholds or some such that demand reclaim
> > > of the inode.
> > 
> > Yup, an occasional unlink sitting around for a while on an unlinked
> > list isn't going to cause a performance problem.  Indeed, such
> > workloads are more likely to benefit from the reduced unlink()
> > syscall overhead and won't even notice the increase in background
> > CPU overhead for inactivation of those occasional inodes.
> > 
> > > It sounds like what you're talking about is specifically
> > > the behavior/performance of sustained file removal (which is important
> > > obviously), where apparently there is a notable degradation if the
> > > queues become deep enough to push the inode batches out of CPU cache. So
> > > that makes sense...
> > 
> > Yup, sustained bulk throughput is where cache residency really
> > matters. And for unlink, sustained unlink workloads are quite
> > common; they often are something people wait for on the command line
> > or make up a performance critical component of a highly concurrent
> > workload so it's pretty important to get this part right.
> > 
> > > > Darrick made the original assumption that we could delay
> > > > inactivation indefinitely and so he allowed really deep queues of up
> > > > to 64k deferred inactivations. But with queues this deep, we could
> > > > never get that background inactivation code to perform anywhere near
> > > > the original synchronous background inactivation code. e.g. I
> > > > measured 60-70% performance degradataions on my scalability tests,
> > > > and nothing stood out in the profiles until I started looking at
> > > > CPU data cache misses.
> > > > 
> > > 
> > > ... but could you elaborate on the scalability tests involved here so I
> > > can get a better sense of it in practice and perhaps observe the impact
> > > of changes in this path?
> > 
> > The same conconrrent fsmark create/traverse/unlink workloads I've
> > been running for the past decade+ demonstrates it pretty simply. I
> > also saw regressions with dbench (both op latency and throughput) as
> > the clinet count (concurrency) increased, and with compilebench.  I
> > didn't look much further because all the common benchmarks I ran
> > showed perf degradations with arbitrary delays that went away with
> > the current code we have.  ISTR that parts of aim7/reaim scalability
> > workloads that the intel zero-day infrastructure runs are quite
> > sensitive to background inactivation delays as well because that's a
> > CPU bound workload and hence any reduction in cache residency
> > results in a reduction of the number of concurrent jobs that can be
> > run.
> > 
> 
> Ok, so if I (single threaded) create (via fs_mark), sync and remove 5m
> empty files, the remove takes about a minute. If I just bump out the
> current queue and block thresholds by 10x and repeat, that time
> increases to about ~1m24s. If I hack up a kernel to disable queueing
> entirely (i.e. fully synchronous inactivation), then I'm back to about a
> minute again. So I'm not producing any performance benefit with
> queueing/batching in this single threaded scenario, but I suspect the
> 10x threshold delta is at least measuring the negative effect of poor
> caching..? (Any decent way to confirm that..?).
> 
> And of course if I take the baseline kernel and stick a
> cond_synchronize_rcu() in xfs_inactive_ifree() it brings the batch test
> numbers right back but slows the removal test way down. What I find
> interesting however is that if I hack up something more mild like invoke
> cond_synchronize_rcu() on the oldest inode in the current inactivation
> batch, bump out the blocking threshold as above (but leave the queueing
> threshold at 32), and leave the iget side cond_sync_rcu() to catch
> whatever falls through, my 5m file remove test now completes ~5-10s
> faster than baseline and I see the following results from the batched
> alloc/free test:
> 
> batch:  1       files:  731923
> batch:  2       files:  693020
> batch:  4       files:  750948
> batch:  8       files:  743296
> batch:  16      files:  738720
> batch:  32      files:  746240
> batch:  64      files:  598464
> batch:  128     files:  672896
> batch:  256     files:  633856
> batch:  512     files:  605184
> batch:  1024    files:  569344
> batch:  2048    files:  555008
> batch:  4096    files:  524288
> 

This experiment had a bug that was dropping some inactivations on the
floor. With that fixed, the numbers aren't quite as good. The batch test
numbers still improve significantly from the posted patch (i.e. up in
the range of 38-45k files/sec), but still lag the normal allocation
rate, and the large rm test goes up to 1m40s (instead of 1m on
baseline).

Brian

> Hm?
> 
> Brian
> 
> > Cheers,
> > 
> > Dave.
> > -- 
> > Dave Chinner
> > david@fromorbit.com
> > 

