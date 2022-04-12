Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9867DC433EF
	for <linux-xfs@archiver.kernel.org>; Tue, 12 Apr 2022 17:12:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357986AbiDLROR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 12 Apr 2022 13:14:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344490AbiDLROQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 12 Apr 2022 13:14:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87FDB45054;
        Tue, 12 Apr 2022 10:11:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2AEA8618CF;
        Tue, 12 Apr 2022 17:11:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C6F6C385A5;
        Tue, 12 Apr 2022 17:11:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649783517;
        bh=vPfdaBfBiUoCQQn2gMKycjum+vdTjnK5WAeTnGxN1JI=;
        h=Date:From:To:Subject:References:In-Reply-To:From;
        b=LVS/NRnuAkQhwNudfSggrkA1dc8yIY3i0zsAEnLEKt27d0638EBeMY2M4PtAjAz5c
         9VesFWz8CkMWgEl4+xzg2tEUO1z5xdBnni99JqDaxy1Sxru0e626+Eyr2bR3V+sFWg
         /alDRaR7sZVj+kofvqFrC2rcg298E0Nr7ZyALGXHbWI7115KvnytQ0Xe4zd5ye6Thq
         bpxQ0/qev0MNoEmT8c+BP19YPqEd5kfbNuN55ZLJwQMJ1WxHh7HKcXa6S0VBD0+Bk2
         t4E0A5kEh1HMh4SyNS9xYdsh+d8nUuYgK9MpM2N/5MQDpdjbBiEtNU6trqYCIEIQVG
         zJchWsIiESWHQ==
Date:   Tue, 12 Apr 2022 10:11:56 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs/187: don't rely on FSCOUNTS for free space data
Message-ID: <20220412171156.GF16799@magnolia>
References: <164971765670.169895.10730350919455923432.stgit@magnolia>
 <164971766238.169895.2389864738831855587.stgit@magnolia>
 <20220412084716.vwljkrc7bpnzl75z@zlang-mailbox>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220412084716.vwljkrc7bpnzl75z@zlang-mailbox>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Apr 12, 2022 at 04:47:16PM +0800, Zorro Lang wrote:
> On Mon, Apr 11, 2022 at 03:54:22PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Currently, this test relies on the XFS_IOC_FSCOUNTS ioctl to return
> > accurate free space information.  It doesn't.  Convert it to use statfs,
> > which uses the accurate versions of the percpu counters.  Obviously,
> > this only becomes a problem when we convert the free rtx count to use
> > (sloppier) percpu counters instead of the (more precise and previously
> > buggy) ondisk superblock counts.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> >  tests/xfs/187 |    2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > 
> > diff --git a/tests/xfs/187 b/tests/xfs/187
> > index 1929e566..a9dfb30a 100755
> > --- a/tests/xfs/187
> > +++ b/tests/xfs/187
> > @@ -135,7 +135,7 @@ punch_off=$((bigfile_sz - frag_sz))
> >  $here/src/punch-alternating $SCRATCH_MNT/bigfile -o $((punch_off / fsbsize)) -i $((rtextsize_blks * 2)) -s $rtextsize_blks
> >  
> >  # Make sure we have some free rtextents.
> > -free_rtx=$($XFS_IO_PROG -c 'statfs' $SCRATCH_MNT | grep counts.freertx | awk '{print $3}')
> > +free_rtx=$($XFS_IO_PROG -c 'statfs' $SCRATCH_MNT | grep statfs.f_bavail | awk '{print $3}')
> 
> Do you mean the "cnt->freertx = mp->m_sb.sb_frextents" in xfs_fs_counts() isn't
> right?

Correct -- prior to the patches introduced here:
https://lore.kernel.org/linux-xfs/164961485474.70555.18228016043917319266.stgit@magnolia/T/#t

The kernel would account actual ondisk rt extent usage *and* in-memory
transaction reservations in mp->m_sb.sb_frextents, which meant that one
thread calling xfs_log_sb racing with another thread allocating space on
the rt volume would write the wrong sb_frextents value to disk, which
corrupts the superblock counters.

The fix for that is to separate the two uses into separate counters --
now mp->m_sb.sb_frextents tracks the ondisk usage, and mp->m_frextents
also includes tx reservations.  m_frextents is a percpu counter, which
means that we won't be able to rely on it for a precise accounting after
the series is merged.  Hence the switch to statfs, which does use the
slow-but-accurate percpu_counter_sum method.

--D

> Thanks,
> Zorro
> 
> >  if [ $free_rtx -eq 0 ]; then
> >  	echo "Expected fragmented free rt space, found none."
> >  fi
> > 
> 
