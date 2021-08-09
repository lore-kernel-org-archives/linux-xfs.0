Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E285AC4338F
	for <linux-xfs@archiver.kernel.org>; Mon,  9 Aug 2021 18:39:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C410760EE7
	for <linux-xfs@archiver.kernel.org>; Mon,  9 Aug 2021 18:39:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232130AbhHISjg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 9 Aug 2021 14:39:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:60644 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233822AbhHISjg (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 9 Aug 2021 14:39:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 80E2C60EE7;
        Mon,  9 Aug 2021 18:39:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628534355;
        bh=DzCMD//MOZakp+XgmrXevcSdlX1kyQ1UhwUfa1iQL4w=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qnwa/6GJO7gqc3aTDqrPrHgaqhN/KJY3z5lk0vxQDDYLyDM7yHIsOtMOmYEbWuYmX
         xJaNq9F9ZRPHKDB+FqWTi24FlTQ4qDypS1tHrkVgyf0k9Yd3J6vbUOwgYFSfr5vPDD
         rzg/AFeuz5ocpkTA4FmBnrrPX/qTTNkvH7O/CI+q1HCxSjr1xJxf6HBMvrYqLt4jOO
         UQNUvczMa+MZPQkhO6cUCkP97DKJJUt05jq7E/4e4lzjQ0+bGSnYXJ4qDFVLIaT3bE
         lxBJ3QL+bm/Vw3dhT57cuFfCidiKTSJveczYW7G/4X7pmoiGGHHkHEMVObyyd5ru5d
         2K7092k4dGI8A==
Date:   Mon, 9 Aug 2021 11:39:15 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 0/5 v2] xfs: strictly order log start records
Message-ID: <20210809183915.GP3601466@magnolia>
References: <20210714033656.2621741-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210714033656.2621741-1-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jul 14, 2021 at 01:36:51PM +1000, Dave Chinner wrote:
> 
> We recently found a zero-day log recovery issue where overlapping
> log transactions used the wrong LSN for recovery operations despite
> being replayed in the correct commit record order. The issue is that

This series doesn't apply to 5.14-rc4, probably because of the changes
we made in "xfs: fix log cache flush regressions and bugs".  I'd ask if
you could rebase this (and the "make CIL pipelining work" series)
against for-next, except that found regressions with one of Allison's
patches, so I had to kick that one out and restart all the QA stuff.

Between that and fixing all the annoying indentation and whitespace
problems, the 5.15 merge branch isn't going to be ready for for-next
until Wednesday's tree build... and that's why there's still no for-next
in my tree.

--D

> the log recovery code uses the LSN of the start record of the log
> transaction for ordering and metadata stamping, while the actual
> order of transaction replay is determined by the commit record.
> Hence if we pipeline CIL commits we can end up with overlapping
> transactions in the log like:
> 
> Start A .. Start C .. Start B .... Commit A .. Commit B .. Commit C
> 
> The issue is that the "start B" lsn is later than the "start C" lsn.
> When the same metadata block is modified in both transaction B and
> C, writeback from "commit B" will correctly stamp "start B" into the
> metadata.
> 
> However, when "commit C" runs, it will see the LSN in that metadata
> block is "start B", which is *more recent than "Start C" and so
> will, incorrectly, fail to recover that change into the metadata
> block. This results in silent metadata corruption, which can then be
> exposed by future recovery operations failing, runtime
> inconsistencies causing shutdowns and/or xfs_scrub/xfs_repair check
> failures.
> 
> We could fix log recovery to avoid this problem, but there's a
> runtime problem as well: the AIL is ordered by start record LSN. We
> cannot order the AIL by commit LSN as we cannot allow the tail of
> the log to overwrite -any- of the log transaction until the entire
> transaction has been written. As the lowest LSN of the items in the
> AIL defines the current log tail, the same metadata writeback
> ordering issues apply as with log recovery.
> 
> In this case, we run the callbacks for commit B first, which place
> all the items at the head of the log at "start B". Then we run
> callbacks for "commit C", which then do not insert at the head -
> they get inserted before "start B". If the item was modified in both
> B and C, then it moves *backwards* in the AIL and this screws up all
> manner of things that assume relogging can only move objects
> forwards in the log. One of these things it can screw up is the tail
> lsn of the log. Nothing good comes from this...
> 
> Because we have both runtime and journal-based ordering requirements
> for the start_lsn, we have multiple places where there is an
> implicit assumption that transaction start records are strictly
> ordered. Rather than play whack-a-mole with such assumptions, and to
> avoid the eternal "are you running a fixed kernel" question, it's
> better just to strictly order the start records in the same way we
> strictly order the commit records.
> 
> This patch series takes the mechanisms of the strict commit record
> ordering and utilises them for strict start record ordering. It
> builds upon the shutdown rework patchset to guarantee that the CIL
> context structure will not get freed from under it by a racing
> shutdown, and so moves the LSN recording for ordering up into a
> callback from xlog_write() once we have a guaranteed iclog write
> location. This means we have one mechanism for both start and commit
> record ordering, and they both work in exactly the same way.
> 
> 
> Version 2:
> - rebase on 5.14-rc1 + "xfs: shutdown is a racy mess"
> - fixed typos in commit messages
> 
> Version 1:
> - https://lore.kernel.org/linux-xfs/20210630072108.1752073-1-david@fromorbit.com/
> 
