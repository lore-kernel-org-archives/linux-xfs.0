Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16574C00A8F
	for <linux-xfs@archiver.kernel.org>; Mon, 23 Oct 2023 15:40:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229570AbjJWPkN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 23 Oct 2023 11:40:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbjJWPkM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 23 Oct 2023 11:40:12 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7369BC
        for <linux-xfs@vger.kernel.org>; Mon, 23 Oct 2023 08:40:10 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56A2AC433C8;
        Mon, 23 Oct 2023 15:40:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1698075610;
        bh=u7Irvec8kCFhdxHMo9fnHcNTLk3hG5exxyGRNHfTayU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=phkSECBo36dkG96AQJkuSNPIPgxLAxDzqtUCb91EmbisFRoVQsguNvPsL6GbtTYLh
         OvQJ4+9l9cwt7WBr0+XWsh/4RSdq2L2nJk2CNQFfaEdK6RFx9e4vmrerV/EJ7+gYM3
         gZFeUi2kXRASd0yk2SYxAyHp/1OHTCu0Q12Mbxu6r3uD5pIq4Hy1OtfnRhukSOLRCs
         zHxZRGgoCINxkIihgRZnxkrrlA8tJy2QLVWjneO+nbEOr9BkFZNvtO95jJfnv9CREM
         5oD/zQQqo61ju4mWWVX9ajqeejvmCZuapuBGg+E2O8P4+XLPWm1Jix56yPiwwyMwA2
         IBB9Aa8kmyv7Q==
Date:   Mon, 23 Oct 2023 08:40:09 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Christoph Hellwig <hch@infradead.org>,
        Catherine Hoang <catherine.hoang@oracle.com>,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH v4] xfs: allow read IO and FICLONE to run concurrently
Message-ID: <20231023154009.GU3195650@frogsfrogsfrogs>
References: <20231017201208.18127-1-catherine.hoang@oracle.com>
 <ZS92TizgnKHdBtDb@infradead.org>
 <20231019200411.GN3195650@frogsfrogsfrogs>
 <ZTIY8jE9vK6A0FE3@infradead.org>
 <20231020153448.GR3195650@frogsfrogsfrogs>
 <ZTWlc3R95DPLOjw3@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZTWlc3R95DPLOjw3@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Oct 23, 2023 at 09:42:59AM +1100, Dave Chinner wrote:
> On Fri, Oct 20, 2023 at 08:34:48AM -0700, Darrick J. Wong wrote:
> > On Thu, Oct 19, 2023 at 11:06:42PM -0700, Christoph Hellwig wrote:
> > > On Thu, Oct 19, 2023 at 01:04:11PM -0700, Darrick J. Wong wrote:
> > > > Well... the stupid answer is that I augmented generic/176 to try to race
> > > > buffered and direct reads with cloning a million extents and print out
> > > > when the racing reads completed.  On an unpatched kernel, the reads
> > > > don't complete until the reflink does:
> > > 
> > > > So as you can see, reads from the reflink source file no longer
> > > > experience a giant latency spike.  I also wrote an fstest to check this
> > > > behavior; I'll attach it as a separate reply.
> > > 
> > > Nice.  I guess write latency doesn't really matter for this use
> > > case?
> > 
> > Nope -- they've gotten libvirt to tell qemu to redirect vm disk writes
> > to a new sidecar file.  Then they reflink the original source file to
> > the backup file, but they want qemu to be able to service reads from
> > that original source file while the reflink is ongoing.  When the backup
> > is done, they commit the sidecar contents back into the original image.
> > 
> > It would be kinda neat if we had file range locks.  Regular progress
> > could shorten the range as it makes progress.  If the thread doing the
> > reflink could find out that another thread has blocked on part of the
> > file range, it could even hurry up and clone that part so that neither
> > reads nor writes would see enormous latency spikes.
> > 
> > Even better, we could actually support concurrent reads and writes to
> > the page cache as long as the ranges don't overlap.  But that's all
> > speculative until Dave dumps his old ranged lock patchset on the list.
> 
> The unfortunate reality is that range locks as I was trying to
> implement them didn't scale - it was a failed experiment.
> 
> The issue is the internal tracking structure of a range lock. It has
> to be concurrency safe itself, and even with lockless tree
> structures using per-node seqlocks for internal sequencing, they
> still rely on atomic ops for safe concurrent access and updates.
> 
> Hence the best I could get out of an uncontended range lock (i.e.
> locking different exclusive ranges concurrently) was about 400,000
> lock/unlock operations per second before the internal tracking
> structure broke down under concurrent modification pressure.  That
> was a whole lot better than previous attempts that topped out at
> ~150,000 lock/unlock ops/s, but it's still far short of the ~3
> million concurrent shared lock/unlock ops/s than a rwsem could do on
> that same machine.
> 
> Worse for range locks was that once passed peak performance,
> internal contention within the range lock caused performance to fall
> off a cliff and ends up being much worse than just using pure
> exclusive locking with a mutex.
> 
> Hence without some novel new internal lockless and memory allocation
> free tracking structure and algorithm, range locks will suck for the
> one thing we want them for: high performance, highly concurrent
> access to discrete ranges of a single file.

Ah.  Thanks for the reminder about that.

--D

> -Dave.
> 
> -- 
> Dave Chinner
> david@fromorbit.com
