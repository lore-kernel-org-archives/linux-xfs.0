Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2AEF9C433F5
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Mar 2022 17:43:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231239AbiCGRoR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 7 Mar 2022 12:44:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239106AbiCGRoQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 7 Mar 2022 12:44:16 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4B306F48C
        for <linux-xfs@vger.kernel.org>; Mon,  7 Mar 2022 09:43:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=OsVaBalcYV9laGRjFkzGaO2YKLmfHC4MFIIc5PV+stA=; b=JB3v1flqUDsS/LYBK5Aso7SuPw
        BzmPOgIVreHRFDrfZ6xCwJDXOcXoPEhHl4U0ISFj3sydRyzIH4MAAzG2pX5Lc4422k0tO+Fp8HIP5
        FGKC6NL05gAmSM9YT6KnvNUwTrZWCNRObHGzQBc5pl3pvciV3hTNVEQh3le07N+kRV3AR+eWWByCk
        G3XrlZ7TRF+VITQAseCE3G3sB3y4Ve9fZwGl2XXgUuTPH6nCAeHPTmLfMRb+Kn5Isv5dvyD/tRvVl
        6NYUags9Y6c0KskyEKPm3/vaP0aqziaRu7o1z2pv1y2ZdRxWRqlkcI9AISyTsQ1nBPatUWqKbnxG6
        lizSJRvQ==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nRHOA-00FQMp-Fz; Mon, 07 Mar 2022 17:43:18 +0000
Date:   Mon, 7 Mar 2022 17:43:18 +0000
From:   Matthew Wilcox <willy@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: xfs: log recovery hang fixes
Message-ID: <YiZENvZ1CncSyoYX@casper.infradead.org>
References: <20220307053252.2534616-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220307053252.2534616-1-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Mar 07, 2022 at 04:32:49PM +1100, Dave Chinner wrote:
> Willy reported generic/530 had started hanging on his test machines
> and I've tried to reproduce the problem he reported. While I haven't
> reproduced the exact hang he's been having, I've found a couple of
> others while running g/530 in a tight loop on a couple of test
> machines.
[...]
> 
> Willy, can you see if these patches fix the problem you are seeing?
> If not, I still think they stand alone as necessary fixes, but I'll
> have to keep digging to find out why you are seeing hangs in g/530.

I no longer see hangs, but I do see an interesting pattern in runtime
of g/530.  I was seeing hangs after only a few minutes of running g/530,
and I was using 15 minutes of success to say "git bisect good".  Now at 45
minutes of runtime with no hangs.  Specifically, I'm testing 0020a190cf3e
("xfs: AIL needs asynchronous CIL forcing"), plus these three patches.
If you're interested, I can see which of these three patches actually
fixes my hang.  I should also test these three patches on top of current
5.17-rc, but I wanted to check they were backportable to current stable
first.

Of the 120 times g/530 has run, I see 30 occurrences of the test taking
32-35 seconds.  I see one occurrence of the test taking 63 seconds.
Usually it takes 2-3s.  This smacks to me of a 30s timeout expiring.
Let me know if you want me to try to track down which one it is.
