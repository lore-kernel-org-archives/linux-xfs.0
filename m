Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 14 Jul 2008 07:03:41 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m6EE3Z8s005780
	for <xfs@oss.sgi.com>; Mon, 14 Jul 2008 07:03:37 -0700
Received: from g1t0027.austin.hp.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 645D8E1007D
	for <xfs@oss.sgi.com>; Mon, 14 Jul 2008 07:04:43 -0700 (PDT)
Received: from g1t0027.austin.hp.com (g1t0027.austin.hp.com [15.216.28.34]) by cuda.sgi.com with ESMTP id KVWiI5iaIyQDM548 for <xfs@oss.sgi.com>; Mon, 14 Jul 2008 07:04:43 -0700 (PDT)
Message-ID: <487B5CEE.90404@hp.com>
Date: Mon, 14 Jul 2008 10:04:30 -0400
From: jim owens <jowens@hp.com>
MIME-Version: 1.0
Subject: Re: [PATCH 3/3] Add timeout feature
References: <20080709005254.GQ11558@disturbed> <20080709010922.GE9957@mit.edu> <E1KGSvZ-0006dB-53@pomaz-ex.szeredi.hu> <20080709061621.GA5260@infradead.org> <E1KGT4q-0006fD-Jb@pomaz-ex.szeredi.hu> <20080708234120.5072111f@infradead.org> <E1KGTTm-0006ke-Jh@pomaz-ex.szeredi.hu> <20080708235502.1c52a586@infradead.org> <20080709071346.GS11558@disturbed> <20080709110900.GI9957@mit.edu> <20080709114958.GV11558@disturbed> <4874C3E8.20804@hp.com> <88E7CDF01964465CB9F33DE11298271D@nsl.ad.nec.co.jp>
In-Reply-To: <88E7CDF01964465CB9F33DE11298271D@nsl.ad.nec.co.jp>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Takashi Sato <t-sato@yk.jp.nec.com>
Cc: mtk.manpages@googlemail.com, axboe@kernel.dk, linux-kernel@vger.kernel.org, dm-devel@redhat.com, xfs@oss.sgi.com, linux-ext4@vger.kernel.org, viro@ZenIV.linux.org.uk, akpm@linux-foundation.org, pavel@suse.cz, linux-fsdevel@vger.kernel.org, hch@infradead.org, Miklos Szeredi <miklos@szeredi.hu>, Arjan van de Ven <arjan@infradead.org>, Theodore Tso <tytso@mit.edu>, Dave Chinner <david@fromorbit.com>

Takashi Sato wrote:

> What is the difference between the timeout and AUTO-THAW?
> When the kernel detects a deadlock, does it occur to solve it?

TIMEOUT is a user-specified limit for the freeze.  It is
not a deadlock preventer or deadlock breaker.  The reason
it exists is:

    - middle of the night (low but not zero users)
    - cron triggers freeze and hardware snapshot
    - san is overloaded by tape copy traffic so
      hardware will take 2 hours to ack snapshot done
    - user "company president" tries to create a report
      needed for an AM meeting with bankers
    - with so few users, system will just patiently
      wait for hardware to finish
    - after 10 minutes "company president" pages
      admin, admin's boss, and "IT vice president"
      in a real unhappy mood

AUTO-THAW is simply a name for the effect of all deadlock
preventer and deadlock breaker code that the kernel has
in the freeze implementation paths... if that code would
unfreeze the filesystem.  We also implemented deadlock
preventer code that does not thaw the freeze.

None of the AUTO-THAW code is there to stop a stupid
userspace program caller of freeze.  It handles things
like "a system in our cluster is going down so we
must have this filesystem unfrozen or the whole
cluster will crash".   In places where there could be
a kernel deadlock we made it "lock-only-if-non-blocking"
and if we could not wait to retry later, the failure
to lock would trigger an immediate unfreeze.

Deadlock prevention needs code in critical paths in more
than just filesystems.  Sometimes this is as simple as
an "I can't wait on freeze" flag added to a vm-filesystem
interface.

Timers just don't work for keeping the kernel alive
because they don't trigger on resource exhaustion.

jim
