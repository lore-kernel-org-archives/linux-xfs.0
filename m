Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wr0-f196.google.com ([209.85.128.196]:49894 "EHLO
        mail-wr0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751921AbdJXKGS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 24 Oct 2017 06:06:18 -0400
Date: Tue, 24 Oct 2017 12:06:13 +0200
From: Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH v3 2/8] lockdep: Introduce CROSSRELEASE_STACK_TRACE and
 make it not unwind as default
Message-ID: <20171024100613.vqy3l7gfjychauoc@gmail.com>
References: <1508837889-16932-1-git-send-email-byungchul.park@lge.com>
 <1508837889-16932-3-git-send-email-byungchul.park@lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1508837889-16932-3-git-send-email-byungchul.park@lge.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Byungchul Park <byungchul.park@lge.com>
Cc: peterz@infradead.org, axboe@kernel.dk, tglx@linutronix.de, linux-kernel@vger.kernel.org, linux-mm@kvack.org, tj@kernel.org, johannes.berg@intel.com, oleg@redhat.com, amir73il@gmail.com, david@fromorbit.com, darrick.wong@oracle.com, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org, hch@infradead.org, idryomov@gmail.com, kernel-team@lge.com


Cannot pick up this series yet, but I have enhanced the changelog to:

=============>
Subject: locking/lockdep: Introduce CONFIG_CROSSRELEASE_STACK_TRACE and make it not unwind by default
From: Byungchul Park <byungchul.park@lge.com>
Date: Tue, 24 Oct 2017 18:38:03 +0900

Johan Hovold reported a heavy performance regression caused by
lockdep cross-release:

 > Boot time (from "Linux version" to login prompt) had in fact doubled
 > since 4.13 where it took 17 seconds (with my current config) compared to
 > the 35 seconds I now see with 4.14-rc4.
 >
 > I quick bisect pointed to lockdep and specifically the following commit:
 >
 >	28a903f63ec0 ("locking/lockdep: Handle non(or multi)-acquisition
 >	               of a crosslock")
 >
 > which I've verified is the commit which doubled the boot time (compared
 > to 28a903f63ec0^) (added by lockdep crossrelease series [1]).

Currently crossrelease performs unwind on every acquisition, but that is
very expensive.

This patch makes unwind optional and disables it by default and only records
acquire_ip.

Full stack traces are sometimes required for full analysis, in which
case CROSSRELEASE_STACK_TRACE can be enabled.

On my qemu Ubuntu machine (x86_64, 4 cores, 512M), the regression was
fixed. We measure boot times with 'perf stat --null --repeat 10 $QEMU',
where $QEMU launches a kernel with init=/bin/true:

1. No lockdep enabled:

 Performance counter stats for 'qemu_booting_time.sh bzImage' (10 runs):

       2.756558155 seconds time elapsed                    ( +-  0.09% )

2. Lockdep enabled:

 Performance counter stats for 'qemu_booting_time.sh bzImage' (10 runs):

       2.968710420 seconds time elapsed                    ( +-  0.12% )

3. Lockdep enabled + crossrelease enabled:

 Performance counter stats for 'qemu_booting_time.sh bzImage' (10 runs):

       3.153839636 seconds time elapsed                    ( +-  0.31% )

4. Lockdep enabled + crossrelease enabled + this patch applied:

 Performance counter stats for 'qemu_booting_time.sh bzImage' (10 runs):

       2.963669551 seconds time elapsed                    ( +-  0.11% )

I.e. lockdep-crossrelease performance is now indistinguishable
from vanilla lockdep.

