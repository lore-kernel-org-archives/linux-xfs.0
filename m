Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68DCFC433EF
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Jan 2022 18:30:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232228AbiAYSap (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 25 Jan 2022 13:30:45 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:28692 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232191AbiAYSan (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Jan 2022 13:30:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643135442;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/e0a+5HrKHOBNvI1PZDCmx3Xe//5Y7Jt5G2as4trqKw=;
        b=H84p083ZwiTDNN/X2xFyMtjDFH+iOCpswZvH0+R76uNfF9xFcPowAq7Q/2OJDyHtSVoaeY
        lbVqAQ5qJFjvmBgvAbqTmILNnDTxp3nYMAHSnRwVcoLll3eVHL28lGYGSfyOp571NHUUho
        v1xVdtMlKPQBAJXvudlQtvBE7/zcuUo=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-520-1G1S7UO_N4acGoqn978o2g-1; Tue, 25 Jan 2022 13:30:40 -0500
X-MC-Unique: 1G1S7UO_N4acGoqn978o2g-1
Received: by mail-qk1-f199.google.com with SMTP id h10-20020a05620a284a00b0047649c94bc7so15386312qkp.20
        for <linux-xfs@vger.kernel.org>; Tue, 25 Jan 2022 10:30:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=/e0a+5HrKHOBNvI1PZDCmx3Xe//5Y7Jt5G2as4trqKw=;
        b=lKdJu+YfmPPdL+iTtzdaR1ZcGAu/J+UZwiPE6Evdfp8jtJhm04SlSkram2/U0lCYUG
         eSD3KZYmkS0THcWpk9g6qs0EVYJNxAsMmlKKv/DrBZSki8PmUDoV+zfRZYbhLmEYpzAZ
         t7SYK/eVCoxi/aJP8JCNcct0ntn8eB+4/SLYK56IzpzjdDlYhwK+qrSFHcXvCos68RhF
         k30VwBuHz0psaTlsoo3keqo+h36s9jHIHV+4e3sYw64Nhq2W6s7/sIj9HVBLL1fBZwhr
         VWpReBjSgqM/QbayNQmDjL9+z40SmbokjXJ02jpfEAc8b5+EQCxOEA5GWV5FFuL/P+ae
         sjMg==
X-Gm-Message-State: AOAM532aFDlodrpslxTHmFL+oEhHTK+cNsb5DgkCQklfSKJSJXlBRV/h
        glIbIs9NnnPyAMloJm1XhKcMMVA7ijXyzl3BUa+b3803i20/IJv1iSX89Xv3MgQ1i6DMx6g5u70
        O0edDvsh2K9ljAyJA0bNP
X-Received: by 2002:a05:6214:e6c:: with SMTP id jz12mr12886531qvb.42.1643135439572;
        Tue, 25 Jan 2022 10:30:39 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxT/O4hH8WE0OaOC1Z3oBqKR/Zb+xiWOotm4QWB1TzUQoCCF7mrOEYRP+9cljNB25NisH90cQ==
X-Received: by 2002:a05:6214:e6c:: with SMTP id jz12mr12886497qvb.42.1643135439194;
        Tue, 25 Jan 2022 10:30:39 -0800 (PST)
Received: from bfoster (c-24-61-119-116.hsd1.ma.comcast.net. [24.61.119.116])
        by smtp.gmail.com with ESMTPSA id bs33sm1164242qkb.103.2022.01.25.10.30.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Jan 2022 10:30:38 -0800 (PST)
Date:   Tue, 25 Jan 2022 13:30:36 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        Ian Kent <raven@themaw.net>, rcu@vger.kernel.org
Subject: Re: [PATCH] xfs: require an rcu grace period before inode recycle
Message-ID: <YfBBzHascwVnefYY@bfoster>
References: <20220121142454.1994916-1-bfoster@redhat.com>
 <Ye6/g+XMSyp9vYvY@bfoster>
 <20220124220853.GN59729@dread.disaster.area>
 <Ye82TgBY0VmtTjMc@bfoster>
 <20220125003120.GO59729@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220125003120.GO59729@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jan 25, 2022 at 11:31:20AM +1100, Dave Chinner wrote:
> On Mon, Jan 24, 2022 at 06:29:18PM -0500, Brian Foster wrote:
> > On Tue, Jan 25, 2022 at 09:08:53AM +1100, Dave Chinner wrote:
> > > > FYI, I modified my repeated alloc/free test to do some batching and form
> > > > it into something more able to measure the potential side effect / cost
> > > > of the grace period sync. The test is a single threaded, file alloc/free
> > > > loop using a variable per iteration batch size. The test runs for ~60s
> > > > and reports how many total files were allocated/freed in that period
> > > > with the specified batch size. Note that this particular test ran
> > > > without any background workload. Results are as follows:
> > > > 
> > > > 	files		baseline	test
> > > > 
> > > > 	1		38480		38437
> > > > 	4		126055		111080
> > > > 	8		218299		134469
> > > > 	16		306619		141968
> > > > 	32		397909		152267
> > > > 	64		418603		200875
> > > > 	128		469077		289365
> > > > 	256		684117		566016
> > > > 	512		931328		878933
> > > > 	1024		1126741		1118891
> > > 
> > > Can you post the test code, because 38,000 alloc/unlinks in 60s is
> > > extremely slow for a single tight open-unlink-close loop. I'd be
> > > expecting at least ~10,000 alloc/unlink iterations per second, not
> > > 650/second.
> > > 
> > 
> > Hm, Ok. My test was just a bash script doing a 'touch <files>; rm
> > <files>' loop. I know there was application overhead because if I
> > tweaked the script to open an fd directly rather than use touch, the
> > single file performance jumped up a bit, but it seemed to wash away as I
> > increased the file count so I kept running it with larger sizes. This
> > seems off so I'll port it over to C code and see how much the numbers
> > change.
> 
> Yeah, using touch/rm becomes fork/exec bound very quickly. You'll
> find that using "echo > <file>" is much faster than "touch <file>"
> because it runs a shell built-in operation without fork/exec
> overhead to create the file. But you can't play tricks like that to
> replace rm:
> 

I had used 'exec' to open an fd (same idea) in the single file case and
tested with that, saw that the increase was consistent and took that
along with the increasing performance as batch sizes increased to mean
that the application overhead wasn't a factor as the test scaled. That
was clearly wrong, because if I port the whole thing to a C program the
baseline numbers are way off. I think what also threw me off is that the
single file test kernel case is actually fairly accurate between the two
tests. Anyways, here's a series of (single run, no averaging, etc.) test
runs with the updated test. Note that I reduced the runtime to 10s here
since the test was running so much faster. Otherwise this is the same
batched open/close -> unlink behavior:

                baseline        test
batch:  1       files:  893579  files:  41841
batch:  2       files:  912502  files:  41922
batch:  4       files:  930424  files:  42084
batch:  8       files:  932072  files:  41536
batch:  16      files:  930624  files:  41616
batch:  32      files:  777088  files:  41120
batch:  64      files:  567936  files:  57216
batch:  128     files:  579840  files:  96256
batch:  256     files:  548608  files:  174080
batch:  512     files:  546816  files:  246784
batch:  1024    files:  509952  files:  328704
batch:  2048    files:  505856  files:  399360
batch:  4096    files:  479232  files:  438272

So this shows that the performance delta is actually massive from the
start. For reference, a single threaded, empty file, non syncing,
fs_mark workload stabilizes at around ~55k files/sec on this fs. Both
kernels sort of converge to that rate as the batch size increases, only
the baseline kernel starts much faster and normalizes while the test
kernel starts much slower and improves (and still really doesn't hit the
mark even at a 4k batch size).

My takeaway from this is that we may need to find a way to mitigate this
overhead somewhat better than what the current patch does. Otherwise,
this is a significant dropoff from even a pure allocation workload in
simple mixed workload scenarios...

> $ time for ((i=0;i<1000;i++)); do touch /mnt/scratch/foo; rm /mnt/scratch/foo ; done
> 
> real    0m2.653s
> user    0m0.910s
> sys     0m2.051s
> $ time for ((i=0;i<1000;i++)); do echo > /mnt/scratch/foo; rm /mnt/scratch/foo ; done
> 
> real    0m1.260s
> user    0m0.452s
> sys     0m0.913s
> $ time ./open-unlink 1000 /mnt/scratch/foo
> 
> real    0m0.037s
> user    0m0.001s
> sys     0m0.030s
> $
> 
> Note the difference in system time between the three operations -
> almost all the difference in system CPU time is the overhead of
> fork/exec to run the touch/rm binaries, not do the filesystem
> operations....
> 
> > > > That's just a test of a quick hack, however. Since there is no real
> > > > urgency to inactivate an unlinked inode (it has no potential users until
> > > > it's freed),
> > > 
> > > On the contrary, there is extreme urgency to inactivate inodes
> > > quickly.
> > > 
> > 
> > Ok, I think we're talking about slightly different things. What I mean
> > above is that if a task removes a file and goes off doing unrelated
> > $work, that inode will just sit on the percpu queue indefinitely. That's
> > fine, as there's no functional need for us to process it immediately
> > unless we're around -ENOSPC thresholds or some such that demand reclaim
> > of the inode.
> 
> Yup, an occasional unlink sitting around for a while on an unlinked
> list isn't going to cause a performance problem.  Indeed, such
> workloads are more likely to benefit from the reduced unlink()
> syscall overhead and won't even notice the increase in background
> CPU overhead for inactivation of those occasional inodes.
> 
> > It sounds like what you're talking about is specifically
> > the behavior/performance of sustained file removal (which is important
> > obviously), where apparently there is a notable degradation if the
> > queues become deep enough to push the inode batches out of CPU cache. So
> > that makes sense...
> 
> Yup, sustained bulk throughput is where cache residency really
> matters. And for unlink, sustained unlink workloads are quite
> common; they often are something people wait for on the command line
> or make up a performance critical component of a highly concurrent
> workload so it's pretty important to get this part right.
> 
> > > Darrick made the original assumption that we could delay
> > > inactivation indefinitely and so he allowed really deep queues of up
> > > to 64k deferred inactivations. But with queues this deep, we could
> > > never get that background inactivation code to perform anywhere near
> > > the original synchronous background inactivation code. e.g. I
> > > measured 60-70% performance degradataions on my scalability tests,
> > > and nothing stood out in the profiles until I started looking at
> > > CPU data cache misses.
> > > 
> > 
> > ... but could you elaborate on the scalability tests involved here so I
> > can get a better sense of it in practice and perhaps observe the impact
> > of changes in this path?
> 
> The same conconrrent fsmark create/traverse/unlink workloads I've
> been running for the past decade+ demonstrates it pretty simply. I
> also saw regressions with dbench (both op latency and throughput) as
> the clinet count (concurrency) increased, and with compilebench.  I
> didn't look much further because all the common benchmarks I ran
> showed perf degradations with arbitrary delays that went away with
> the current code we have.  ISTR that parts of aim7/reaim scalability
> workloads that the intel zero-day infrastructure runs are quite
> sensitive to background inactivation delays as well because that's a
> CPU bound workload and hence any reduction in cache residency
> results in a reduction of the number of concurrent jobs that can be
> run.
> 

Ok, so if I (single threaded) create (via fs_mark), sync and remove 5m
empty files, the remove takes about a minute. If I just bump out the
current queue and block thresholds by 10x and repeat, that time
increases to about ~1m24s. If I hack up a kernel to disable queueing
entirely (i.e. fully synchronous inactivation), then I'm back to about a
minute again. So I'm not producing any performance benefit with
queueing/batching in this single threaded scenario, but I suspect the
10x threshold delta is at least measuring the negative effect of poor
caching..? (Any decent way to confirm that..?).

And of course if I take the baseline kernel and stick a
cond_synchronize_rcu() in xfs_inactive_ifree() it brings the batch test
numbers right back but slows the removal test way down. What I find
interesting however is that if I hack up something more mild like invoke
cond_synchronize_rcu() on the oldest inode in the current inactivation
batch, bump out the blocking threshold as above (but leave the queueing
threshold at 32), and leave the iget side cond_sync_rcu() to catch
whatever falls through, my 5m file remove test now completes ~5-10s
faster than baseline and I see the following results from the batched
alloc/free test:

batch:  1       files:  731923
batch:  2       files:  693020
batch:  4       files:  750948
batch:  8       files:  743296
batch:  16      files:  738720
batch:  32      files:  746240
batch:  64      files:  598464
batch:  128     files:  672896
batch:  256     files:  633856
batch:  512     files:  605184
batch:  1024    files:  569344
batch:  2048    files:  555008
batch:  4096    files:  524288

Hm?

Brian

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 

