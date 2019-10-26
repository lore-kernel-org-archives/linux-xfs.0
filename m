Return-Path: <SRS0=KB2e=YT=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,URIBL_SBL,URIBL_SBL_A
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8576CA9EB9
	for <linux-xfs@archiver.kernel.org>; Sat, 26 Oct 2019 09:54:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B82A2206DD
	for <linux-xfs@archiver.kernel.org>; Sat, 26 Oct 2019 09:54:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726232AbfJZJyJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 26 Oct 2019 05:54:09 -0400
Received: from mr011msb.fastweb.it ([85.18.95.108]:36806 "EHLO
        mr011msb.fastweb.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726193AbfJZJyI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 26 Oct 2019 05:54:08 -0400
Received-SPF: pass (mr011msb.fastweb.it: domain assyoma.it designates
 93.63.55.57 as permitted sender) identity=mailfrom;
 receiver=mr011msb.fastweb.it; client-ip=93.63.55.57;
 envelope-from=g.danti@assyoma.it; helo=ceres.assyoma.it;
X-RazorGate-Vade: gggruggvucftvghtrhhoucdtuddrgedufedrleehgddvvdcutefuodetggdotefrodftvfcurfhrohhfihhlvgemucfhtefuvfghgfeupdcuqfgfvfenuceurghilhhouhhtmecufedttdenucenucfjughrpefvufggtgfgfffhohgjfhfkgigfsehtjehjtddtredvnecuhfhrohhmpefiihhonhgrthgrnhcuffgrnhhtihcuoehgrdgurghnthhisegrshhshihomhgrrdhitheqnecuffhomhgrihhnpegrshhshihomhgrrdhithenucfkphepleefrdeifedrheehrdehjeenucfrrghrrghmpehhvghloheptggvrhgvshdrrghsshihohhmrgdrihhtpdhinhgvthepleefrdeifedrheehrdehjedpmhgrihhlfhhrohhmpeeoghdruggrnhhtihesrghsshihohhmrgdrihhtqedprhgtphhtthhopeeouggrvhhiugesfhhrohhmohhrsghithdrtghomhequcfqtfevrffvpehrfhgtkedvvdenuggrvhhiugesfhhrohhmohhrsghithdrtghomhdprhgtphhtthhopeeolhhinhhugidqgihfshesvhhgvghrrdhkvghrnhgvlhdrohhrghequcfqtfevrffvpehrfhgtkedvvdenlhhinhhugidqgihfshesvhhgvghrrdhkvghrnhgvlhdrohhrghenucevlhhushhtvghrufhiiigvpedt
X-RazorGate-Vade-Verdict: clean 0
X-RazorGate-Vade-Classification: clean
Received: from ceres.assyoma.it (93.63.55.57) by mr011msb.fastweb.it (5.8.208)
        id 5DA0477F0141949B; Sat, 26 Oct 2019 11:54:03 +0200
Received: by ceres.assyoma.it (Postfix, from userid 48)
        id E80E325C83F; Sat, 26 Oct 2019 11:54:02 +0200 (CEST)
To:     Dave Chinner <david@fromorbit.com>
Subject: Re: Question about logbsize default value
X-PHP-Originating-Script: 0:rcube.php
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Sat, 26 Oct 2019 11:54:02 +0200
From:   Gionatan Danti <g.danti@assyoma.it>
Cc:     linux-xfs@vger.kernel.org, g.danti@assyoma.it
Organization: Assyoma s.r.l.
In-Reply-To: <20191025233934.GI4614@dread.disaster.area>
References: <00242d70-1d8e-231d-7ba0-1594412714ad@assyoma.it>
 <20191024215027.GC4614@dread.disaster.area>
 <eb0ef021-27be-c0bd-5950-103cd8b04594@assyoma.it>
 <20191025233934.GI4614@dread.disaster.area>
Message-ID: <51fef5c8e58db12a72b693680c2feaa5@assyoma.it>
X-Sender: g.danti@assyoma.it
User-Agent: Roundcube Webmail/1.0.12
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Il 26-10-2019 01:39 Dave Chinner ha scritto:
> Again, it's a trade-off.
> 
> 256kB iclogs mean that a crash can leave an unrecoverable 2MB hole
> in the journal, while 32kB iclogs means it's only 256kB.

Sure, but a crash will always cause the loss of unsynced data, 
especially when using deferred logging and/or deferred allocation, 
right?

> 256kB iclogs mean 2MB of memory usage per filesystem, 32kB is only
> 256kB. We have users with hundreds of individual XFS filesystems
> mounted on single machines, and so 256kB iclogs is a lot of wasted
> memory...

Just wondering: 1000 filesystems with 256k logbsize would result in 2 GB 
of memory consumed by journal buffers. Is this considered too much 
memory for a system managing 1000 filesystems? The pagecache write back 
memory consumption on these systems (probably equipped with 10s GB of 
RAM) would dwarfs any journal buffers, no?

> On small logs and filesystems, 256kB iclogs doesn't provide any real
> benefit because throughput is limited by log tail pushing (metadata
> writeback), not async transaction throughput.
> 
> It's not uncommon for modern disks to have best throughput and/or
> lowest latency at IO sizes of 128kB or smaller.
> 
> If you have lots of NVRAM in front of your spinning disks, then log
> IO sizes mostly don't matter - they end up bandwidth limited before
> the iclog size is an issue.

Yes, this matches my observation.

> Testing on a pristine filesystem doesn't show what happens as the
> filesystem ages over years of constant use, and so what provides
> "best performance on empty filesystem" often doesn't provide best
> long term production performance.
> 
> And so on.
> 
> Storage is complex, filesystems are complex, and no one setting is
> right for everyone. The defaults are intended to be "good enough" in
> the majority of typical user configs.

Yep.

> 
> For you're specific storage setup, yes.
> 
>> If you, do you suggest to always set logbsize
>> to the maximum supported value?
> 
> No. I recommend that people use the defaults, and only if there are
> performance issues with their -actual production workload- should
> they consider changing anything.
> 
> Benchmarks rarely match the behaviour of production workloads -
> tuning for benchmarks can actively harm production performance,
> especially over the long term...
> 
> Cheers,
> 
> Dave.

Ok, very clear.
Thank you so much.

-- 
Danti Gionatan
Supporto Tecnico
Assyoma S.r.l. - www.assyoma.it
email: g.danti@assyoma.it - info@assyoma.it
GPG public key ID: FF5F32A8
