Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98095CDB47E
	for <linux-xfs@archiver.kernel.org>; Wed, 11 Oct 2023 19:10:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232906AbjJKTK2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 11 Oct 2023 15:10:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232224AbjJKTK1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 11 Oct 2023 15:10:27 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D74BB91;
        Wed, 11 Oct 2023 12:10:26 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59FB0C433C8;
        Wed, 11 Oct 2023 19:10:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697051426;
        bh=HhHPFkq4XUkEVYYA0d+VT2rvcvftna4sTAnQN7nnFJc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=bS3R5tpJCHoxovxT4peBWdUh5wPu/bF0S7e66ISztNH+Hk6JxyQGEIx/9e6/z1DAm
         Fq/b5BRUD5v8nPBJG2lqtQ5mDnJ2V2kznV7xti0GzK6FCBSv4Z278ix1KN9IzJOy3e
         Q+ayV7+fKxyMGgDjxGGgXqGZ9QRZVLyRsBQpW+Dv5Lee/1c/PHA/t3duQZY9DOo70p
         XSVVRLEaYSjWstU8FuNcXzWgb9EGHiHEDnO0TWqXhHX5jE0+E2jszv0Yapiz4iT2cg
         STlSUPW7+MbPgLsgGiwKN0295wTU2EbXlTUEU+RsLinn7/vBb2cTEpn5OSAZvsYiro
         gaHsimEA6Lijw==
Date:   Wed, 11 Oct 2023 12:10:25 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     zlang@redhat.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, guan@eryu.me, linux-block@vger.kernel.org,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH 1/3] xfs/178: don't fail when SCRATCH_DEV contains random
 xfs superblocks
Message-ID: <20231011191025.GX21298@frogsfrogsfrogs>
References: <169687550821.3948976.6892161616008393594.stgit@frogsfrogsfrogs>
 <169687551395.3948976.8425812597156927952.stgit@frogsfrogsfrogs>
 <ZST2zRvtMrU0KlkN@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZST2zRvtMrU0KlkN@infradead.org>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Oct 10, 2023 at 12:01:33AM -0700, Christoph Hellwig wrote:
> On Mon, Oct 09, 2023 at 11:18:33AM -0700, Darrick J. Wong wrote:
> > The storage advertises SCSI UNMAP support, but it is of the variety
> > where the UNMAP command returns immediately but takes its time to unmap
> > in the background.  Subsequent rereads are allowed to return stale
> > contents, per DISCARD semantics.
> > 
> > When the fstests cloud is not busy, the old contents disappear in a few
> > seconds.  However, at peak utilization, there are ~75 VMs running, and
> > the storage backend can take several minutes to commit these background
> > requests.
> 
> Umm, that is not valid behavior fo SCSI UNMAP or any other command
> that Linux discard maps to.  All of them can do one of the two options
> on a per-block basis:
> 
>  - return the unmap pattern (usually but not always 0) for any read
>    following the unmap/trim/discard
>  - always return the previous pattern until it is overwritten or
>    discarded again
> 
> Changing the pattern some time after unmap is a grave bug, and we need
> to blacklist the device.

Ok, I'll go pester them about fixing that, if they haven't already.
Apparently discard support is somewhat new.

I'm pretty sure I've seen some NVME SSDs where you can issue devicewide
DISCARDs and slowly watch the namespace utilization go down over tens of
minutes; and reads will only eventually start returning zeroes.

(Note that *writes* during the slow-discard period are persisted
correctly.)

However, that's orthogonal to this patch -- if the device doesn't
support discard, _scratch_mkfs won't zero the entire disk to remove old
dead superblocks that might have been written by previous tests.  After
we shatter the primary super, the xfs_repair scanning code can still
trip over those old supers and break the golden output.

--D
