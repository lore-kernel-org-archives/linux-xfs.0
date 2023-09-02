Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 567F4CA0FFD
	for <linux-xfs@archiver.kernel.org>; Sat,  2 Sep 2023 04:56:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351514AbjIBE4e (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 2 Sep 2023 00:56:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240011AbjIBE4e (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 2 Sep 2023 00:56:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A767410F9;
        Fri,  1 Sep 2023 21:56:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 45FE8615C6;
        Sat,  2 Sep 2023 04:56:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EAC1C433C8;
        Sat,  2 Sep 2023 04:56:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1693630590;
        bh=6Vved2q/8X6dRDE9rlmeVjA/E1S0Ji8343lRxOEcTRc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=lmDM/HJS5+E3kPAzGOJBihgs0U8QHsq8ZPtlqZmfdbRmjbY5a+uxwvOtyEJZe3Lcn
         IzoKdRuf0cVcwPj//ed1JG+DNDlRJ+qH5IR9CIJEfMd9hryEiEWFKv6+ACe6vH20e2
         GGSFkVzDFQDePKbveQGEVn+dIX2c0fpxo2LToLl83ucL90Xc2OC0DtX/1vrxGt4XDX
         BCfjArcxQJPeOTyuw4DKQsK0BV6f/GdOA1IvPtGH+gnh3ATYzQmZp87TzVbWgChriw
         AyoYL7wMwLSjaaEjbC43pe/lrCTbTLKpN9eXRNIWDsMZkHuPgVhOoN4nAoGevaOsdS
         ltb0I+XaKdtsw==
Date:   Fri, 1 Sep 2023 21:56:29 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Zorro Lang <zlang@redhat.com>
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 3/3] xfs/559: adapt to kernels that use large folios for
 writes
Message-ID: <20230902045629.GA28170@frogsfrogsfrogs>
References: <169335021210.3517899.17576674846994173943.stgit@frogsfrogsfrogs>
 <169335022920.3517899.399149462227894457.stgit@frogsfrogsfrogs>
 <20230901190802.zrttyndmri3rgekm@zlang-mailbox>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230901190802.zrttyndmri3rgekm@zlang-mailbox>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Sep 02, 2023 at 03:08:02AM +0800, Zorro Lang wrote:
> On Tue, Aug 29, 2023 at 04:03:49PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > The write invalidation code in iomap can only be triggered for writes
> > that span multiple folios.  If the kernel reports a huge page size,
> > scale up the write size.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> >  tests/xfs/559 |   29 ++++++++++++++++++++++++++++-
> >  1 file changed, 28 insertions(+), 1 deletion(-)
> > 
> > 
> > diff --git a/tests/xfs/559 b/tests/xfs/559
> > index cffe5045a5..64fc16ebfd 100755
> > --- a/tests/xfs/559
> > +++ b/tests/xfs/559
> > @@ -42,11 +42,38 @@ $XFS_IO_PROG -c 'chattr -x' $SCRATCH_MNT &> $seqres.full
> >  _require_pagecache_access $SCRATCH_MNT
> >  
> >  blocks=10
> > -blksz=$(_get_page_size)
> > +
> > +# If this kernel advertises huge page support, it's possible that it could be
> > +# using large folios for the page cache writes.  It is necessary to write
> > +# multiple folios (large or regular) to triggering the write invalidation,
> > +# so we'll scale the test write size accordingly.
> > +blksz=$(_get_hugepagesize)
> 
> Isn't _require_hugepages needed if _get_hugepagesize is used?

Nope -- if the kernel doesn't support hugepages, then _get_hugepagesize
returns the empty string...

> Thanks,
> Zorro
> 
> > +base_pagesize=$(_get_page_size)
> > +test -z "$blksz" && blksz=${base_pagesize}

...and this line will substitute in the base page size as the block size.

--D

> >  filesz=$((blocks * blksz))
> >  dirty_offset=$(( filesz - 1 ))
> >  write_len=$(( ( (blocks - 1) * blksz) + 1 ))
> >  
> > +# The write invalidation that we're testing below can only occur as part of
> > +# a single large write.  The kernel limits writes to one base page less than
> > +# 2GiB to prevent lengthy IOs and integer overflows.  If the block size is so
> > +# huge (e.g. 512M huge pages on arm64) that we'd exceed that, reduce the number
> > +# of blocks to get us under the limit.
> > +max_writesize=$((2147483647 - base_pagesize))
> > +if ((write_len > max_writesize)); then
> > +	blocks=$(( ( (max_writesize - 1) / blksz) + 1))
> > +	# We need at least three blocks in the file to test invalidation
> > +	# between writes to multiple folios.  If we drop below that,
> > +	# reconfigure ourselves with base pages and hope for the best.
> > +	if ((blocks < 3)); then
> > +		blksz=$base_pagesize
> > +		blocks=10
> > +	fi
> > +	filesz=$((blocks * blksz))
> > +	dirty_offset=$(( filesz - 1 ))
> > +	write_len=$(( ( (blocks - 1) * blksz) + 1 ))
> > +fi
> > +
> >  # Create a large file with a large unwritten range.
> >  $XFS_IO_PROG -f -c "falloc 0 $filesz" $SCRATCH_MNT/file >> $seqres.full
> >  
> > 
> 
