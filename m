Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8F2AC6FD18
	for <linux-xfs@archiver.kernel.org>; Wed, 19 Apr 2023 16:03:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231496AbjDSQDz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 Apr 2023 12:03:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231779AbjDSQDy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Apr 2023 12:03:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31BFA11A
        for <linux-xfs@vger.kernel.org>; Wed, 19 Apr 2023 09:03:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B3B676214C
        for <linux-xfs@vger.kernel.org>; Wed, 19 Apr 2023 16:03:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19ABBC433D2;
        Wed, 19 Apr 2023 16:03:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681920229;
        bh=pKUjB0+NUZKQEt+144stfGaX0c4mWvNi3af0yRRckJY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=lc1reMZHcYwUMIs09RICN3X3ImMdZUjXIv4iEiz1zRSRkjKw/9a+xo8JMPYisedaV
         Dcp1l9mfdHeJOLctBhjJoBenT5QrVxCyfSjHIEb6+FnTypB+M70As5uF6AjL+UJMwN
         uhJkLnEYakiycfzwu3Mg1VAdDtlinw5kOYz4u+zxyBYbwya9QQvgH//DllP6JFmNnB
         dIfSb5sQnZMhbDCVgXhrh+KLVl/X5mBMpxs1gpyuiUXRx9Uq+DpON4XY37doYcGfBa
         OZ2IB/k9f7tpq6f60Turj7BZPlSO17g/vnT5DCWjf2J3K1DtEvT4MH8AIEOgXViTpA
         yu1pqnwPABH3w==
Date:   Wed, 19 Apr 2023 09:03:48 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Paul Khuong <pvk@pvk.ca>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: Re: Abusing XFS_IOC_SWAPEXT until FIEXCHANGE_RANGE is merged
Message-ID: <20230419160348.GN360895@frogsfrogsfrogs>
References: <CAKiQGhnizx7P6ggAfDJ=mF=DajnWQA4uVqzHH0t2LYuyGwGHOQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKiQGhnizx7P6ggAfDJ=mF=DajnWQA4uVqzHH0t2LYuyGwGHOQ@mail.gmail.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

[cc linux-xfs]

On Wed, Apr 19, 2023 at 08:57:30AM -0400, Paul Khuong wrote:
> Hi Darrick,
> 
> I think FIEXCHANGE_RANGE will be a perfect fit for a lot of my needs.
> In the meantime, would it be (crash-)safe to use XFS_IOC_SWAPEXT as a
> less flexible replacement?

TLDR: SWAPEXT might work for atomic file content swaps, but I haven't
done the work to ensure that it always does, and I don't think anyone
else has.  FIEXCHANGE (without NONATOMIC) will; that's where all my QA
effort has been focused.

SWAPEXT doesn't guarantee atomicity of the extents swapped.  It might
survive an unexpected crash if you have do not have reverse mapping
enabled on the filesystem /and/ mount with -o wsync.

But keep in mind that all the SWAPEXT fstests (until recently) only
checked that fsr works ok, and fsr calls the kernel with two files that
have identical contents.  Also, as you note below, SWAPEXT refuses to
run if the fdtmp has more extents than fdtarget, which makes it doubly
unsuitable for atomic file commits since ... reversing the order of the
fds and retrying is kinda gross.

FIEXCHANGE adds the necessary logging support and removes all those
restrictions so that it /can/ be used for atomic file data commits, in
more or less the sequence you lay out below.  I'll evaluate your steps
as if you were asking about FIEXCHANGE. ;)

> I tested the following sequence in XFS
> (https://gist.github.com/pkhuong/d41f42b1536592cb0dace837c17cb402),
> and, while the happy path seems to work, I'm not fully convinced it
> won't corrupt my data on system crash.
> 
> 0. Assume mutual exclusion is handled somewhere else, so we don't have
> to worry about concurrent writes/swaps

Yes, the kernel locks and flushes both files once you issue the
FIEXCHANGE call.

> 1. open data file
> 2. open O_TMPFILE (* should I instead use a named temporary file?)

Either's fine, FIEXCHANGE operate on file descriptors, not paths.

> 3. FICLONE data file in tmpfile
> 4. overwrite some bytes in tmpfile, without changing its size
> 5. fsync the tmpfile

FIEXCHANGE flushes both files for you after taking the kernel locks.

> 6. SWAPEXT data file "into" tmpfile
> 7. If that failed, try to SWAPEXT the tmpfile into the data file

No need for #7, FIEXCHANGE isn't like FIDEDUPERANGE where there's an
implied direction.

> The last two steps are already strange, because they clearly diverge
> from what xfs_fsr does. AFAICT, there's a kernel-side check that
> "fdtmp" isn't more fragmented than "fdtarget", so I usually have to
> try to set my tmpfile as "fdtarget" and the actual data file as
> "fdtmp." The behaviour when nothing crashes is still correct: a swap
> is commutative.
> 
> I'm worried about seeing a mix of the initial data file and the
> tmpfile's contents after a system crash. In other words, does
> XFS_IOC_SWAPEXT currently implement something like
> FILE_XCHG_RANGE_NONATOMIC (and if so, would XFS be willing to pin down
> and document the order in which extents are swapped? ;), or is the
> swap actually crash-atomic?

It's not guaranteed to be crash atomic at all, and I don't want to
expand the support scope of an ioctl that will soon be part of the
legacy API.

Everyone else please focus on getting FIEXCHANGE reviewed so we can
merge that to upstream.

--D

> TIA,
> 
> Paul Khuong
