Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-qk0-f180.google.com ([209.85.220.180]:45532 "EHLO
        mail-qk0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751980AbdJFVJ7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 6 Oct 2017 17:09:59 -0400
Received: by mail-qk0-f180.google.com with SMTP id f199so5981937qke.2
        for <linux-xfs@vger.kernel.org>; Fri, 06 Oct 2017 14:09:59 -0700 (PDT)
Date: Fri, 6 Oct 2017 17:09:57 -0400
From: Josef Bacik <josef@toxicpanda.com>
Subject: [ANNOUNCE] fsperf: a simple fs/block performance testing framework
Message-ID: <20171006210956.vf326sydjiphsefo@destiny>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-fsdevel@vger.kernel.org, kernel-team@fb.com, linux-btrfs@vger.kernel.org, linux-block@vger.kernel.org, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org

Hello,

One thing that comes up a lot every LSF is the fact that we have no general way
that we do performance testing.  Every fs developer has a set of scripts or
things that they run with varying degrees of consistency, but nothing central
that we all use.  I for one am getting tired of finding regressions when we are
deploying new kernels internally, so I wired this thing up to try and address
this need.

We all hate convoluted setups, the more brain power we have to put in to setting
something up the less likely we are to use it, so I took the xfstests approach
of making it relatively simple to get running and relatively easy to add new
tests.  For right now the only thing this framework does is run fio scripts.  I
chose fio because it already gathers loads of performance data about it's runs.
We have everything we need there, latency, bandwidth, cpu time, and all broken
down by reads, writes, and trims.  I figure most of us are familiar enough with
fio and how it works to make it relatively easy to add new tests to the
framework.

I've posted my code up on github, you can get it here

https://github.com/josefbacik/fsperf

All (well most) of the results from fio are stored in a local sqlite database.
Right now the comparison stuff is very crude, it simply checks against the
previous run and it only checks a few of the keys by default.  You can check
latency if you want, but while writing this stuff up it seemed that latency was
too variable from run to run to be useful in a "did my thing regress or improve"
sort of way.

The configuration is brain dead simple, the README has examples.  All you need
to do is make your local.cfg, run ./setup and then run ./fsperf and you are good
to go.

The plan is to add lots of workloads as we discover regressions and such.  We
don't want anything that takes too long to run otherwise people won't run this,
so the existing tests don't take much longer than a few minutes each.  I will be
adding some more comparison options so you can compare against averages of all
previous runs and such.

Another future goal is to parse the sqlite database and generate graphs of all
runs for the tests so we can visualize changes over time.  This is where the
latency measurements will be more useful so we can spot patterns rather than
worrying about test to test variances.

Please let me know if you have any feedback.  I'll take github pull requests for
people who like that workflow, but email'ed patches work as well.  Thanks,

Josef
