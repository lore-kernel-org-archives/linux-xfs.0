Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72277C433FE
	for <linux-xfs@archiver.kernel.org>; Mon, 28 Feb 2022 23:22:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229683AbiB1XWy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 28 Feb 2022 18:22:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229760AbiB1XWy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 28 Feb 2022 18:22:54 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E83EA27A5
        for <linux-xfs@vger.kernel.org>; Mon, 28 Feb 2022 15:22:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D1CC361411
        for <linux-xfs@vger.kernel.org>; Mon, 28 Feb 2022 23:22:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 304B8C340EE;
        Mon, 28 Feb 2022 23:22:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646090532;
        bh=BMlcKeXWkT8Dr3Dc7+u2UMfT0iFwnnOpTgDXBFVaXoE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Jt9rc9LDHcrsntCYRU8eW06XQrgEOwED9q7IgnaCrHS5VYbhUkR5nF4IT5dy/IfDW
         uwZbomuuVMZo8cYObTGm0db2hkuWPNr4rcxXMvlwI7neibl75vt3aisNC0PiK/ednP
         2c5C1Pq41B3/rDcRULXYV/6H3Wq+KxWgifMOTUgzlfoWRcNgkWmBJDGP6VzLZIiGTi
         mePfaFlmH0NwuKMhgywwPA7GsP37QKHaeOhfcBYHGdVZwHyvBDo7K3LwZWfNddWxRz
         HuvD/JKJcorvIIqvQyiwuTbNYe/+mqef5KAhiQPZ2Z4DCWMHBSBNHIcGYpXhI0DZp6
         Xl8bs6XdpK1yA==
Date:   Mon, 28 Feb 2022 15:22:11 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     sandeen@sandeen.net, Christoph Hellwig <hch@lst.de>,
        Dave Chinner <dchinner@redhat.com>,
        Theodore Ts'o <tytso@mit.edu>, linux-xfs@vger.kernel.org,
        allison.henderson@oracle.com
Subject: Re: [PATCH 19/17] mkfs: increase default log size for new (aka
 bigtime) filesystems
Message-ID: <20220228232211.GA117732@magnolia>
References: <20220226213720.GQ59715@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220226213720.GQ59715@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Feb 27, 2022 at 08:37:20AM +1100, Dave Chinner wrote:
> On Fri, Feb 25, 2022 at 06:54:50PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Recently, the upstream kernel maintainer has been taking a lot of heat on
> > account of writer threads encountering high latency when asking for log
> > grant space when the log is small.  The reported use case is a heavily
> > threaded indexing product logging trace information to a filesystem
> > ranging in size between 20 and 250GB.  The meetings that result from the
> > complaints about latency and stall warnings in dmesg both from this use
> > case and also a large well known cloud product are now consuming 25% of
> > the maintainer's weekly time and have been for months.
> 
> Is the transaction reservation space exhaustion caused by, as I
> pointed out in another thread yesterday, the unbound concurrency in
> IO completion?

No.  They're using synchronous directio writes to write trace data in 4k
chunks.  The number of files does not exceed the number of writer
threads, and the number of writer threads can be up to 10*NR_CPUS (~400
on the test system).  If I'm reading the iomap directio code correctly,
the writer threads block and do not issue more IO until the first IO
completes...

> i.e. we have hundreds of active concurrent
> transactions that then block on common objects between them (e.g.
> inode locks) and serialise?

...so yes, there are hundreds of active transactions, but (AFAICT) they
mostly don't share objects, other than the log itself.  Once we made the
log bigger, the hotspot moved to the AGF buffers.  I'm not sure what to
do about /that/, since a 5GB AG is pretty small.  That aside...

> Hence only handful of completions can
> actually run concurrently, depsite every completion holding a full
> reservation of log space to allow them to run concurrently?

...this is still an issue for different scenarios.  I would still be
interested in experimenting with constraining the number of writeback
completion workers that get started, even though that isn't at play
here.

> > For small filesystems, the log is small by default because we have
> > defaulted to a ratio of 1:2048 (or even less).  For grown filesystems,
> > this is even worse, because big filesystems generate big metadata.
> > However, the log size is still insufficient even if it is formatted at
> > the larger size.
> > 
> > Therefore, if we're writing a new filesystem format (aka bigtime), bump
> > the ratio unconditionally from 1:2048 to 1:256.  On a 220GB filesystem,
> > the 99.95% latencies observed with a 200-writer file synchronous append
> > workload running on a 44-AG filesystem (with 44 CPUs) spread across 4
> > hard disks showed:
> > 
> > Log Size (MB)	Latency (ms)	Throughput (MB/s)
> > 10		520		243w
> > 20		220		308
> > 40		140		360
> > 80		92		363
> > 160		86		364
> > 
> > For 4 NVME, the results were:
> > 
> > 10		201		409
> > 20		177		488
> > 40		122		550
> > 80		120		549
> > 160		121		545
> > 
> > Hence we increase the ratio by 16x because there doesn't seem to be much
> > improvement beyond that, and we don't want the log to grow /too/ large.
> 
> 1:2048 -> 1:256 is an 8x bump, yes?  Which means we'll get a 2GB log
> on a 512GB filesystem, and the 220GB log you tested is getting a
> ~1GB log?

Right.

> I also wonder if the right thing to do here is just set a minimum
> log size of 32MB? The worst of the long tail latencies are mitigated
> by this point, and so even small filesystems grown out to 200GB will
> have a log size that results in decent performance for this sort of
> workload.

Are you asking for a second patch where mkfs refuses to format a log
smaller than 32MB (e.g. 8GB with the x86 defaults)?  Or a second patch
that cranks the minimum log size up to 32MB, even if that leads to
absurd results (e.g. 66MB filesystems with 2 AGs and a 32MB log)?

--D

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
