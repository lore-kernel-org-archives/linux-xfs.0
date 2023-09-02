Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5234CCA0FF6
	for <linux-xfs@archiver.kernel.org>; Sat,  2 Sep 2023 05:22:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351535AbjIBFWG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 2 Sep 2023 01:22:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351530AbjIBFWF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 2 Sep 2023 01:22:05 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE55E1703
        for <linux-xfs@vger.kernel.org>; Fri,  1 Sep 2023 22:21:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1693632076;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=kV5gDjjlpNPKkBj+L0PVViuMk2mT0HujpkZRzbHpz9M=;
        b=XSglvpDkaGYpXe+FKiPyhDPhbyhmq+oPsQS+eyXCoFtTtGgLR7D6hMk1v+dTXMUyAPcKu/
        VyCZ9syThCbnNWe/9FbiQMmsyJe03ANuAhWZkexbWWPlP826BB1SyzuExJjyHXHC8+4oXu
        AQNkV9uAu8RXm9TdS+9VGUaZzXgdlzg=
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com
 [209.85.210.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-474-4PPHn9YjN0WpU0SVXUou3A-1; Sat, 02 Sep 2023 01:21:14 -0400
X-MC-Unique: 4PPHn9YjN0WpU0SVXUou3A-1
Received: by mail-pf1-f197.google.com with SMTP id d2e1a72fcca58-68a3d6ce18cso713213b3a.0
        for <linux-xfs@vger.kernel.org>; Fri, 01 Sep 2023 22:21:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693632073; x=1694236873;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kV5gDjjlpNPKkBj+L0PVViuMk2mT0HujpkZRzbHpz9M=;
        b=CyaPgVPdoEC4Iel/GKJgZ/slj0yTOChj61TspqyyYWMO/Er9adOecplMGl6QiIQcp6
         ngl2Fw7pyqUEnMg1FxW9zW5a8jClvqLPfEjWh625i+BdnUZgGlSwM/Ti6FZlbvBzkQLo
         j5KQZWv1pZDZ9WotYtfG+Jl8/49BjyGhi1aH33Ij4G+U/dvpnScYpzu8nBF76nOHnpDE
         y8tvHr23YvSp/MsZKTUSp2e0BC9+QF/JLuSsJhGOpQi1yCo+nc0bl+zM0AoJp+CUpA/E
         qm8u78uERkneEa3TRXKqZ/ACWKK0bPCJNXg+SqAInTZl0fWshoR2YEv08laNnMpiKUY4
         WV1Q==
X-Gm-Message-State: AOJu0YwxfwUqtqB2S4ro3RNsIhn6483JqAfkIP045WAOTaaKbKN5h9vm
        POGqFnY176yxvuiTYSidmkT4vgE4U//svcnDGS6MIEcEMqCt45pROR6FuaMGH2N5PndO8/1caKI
        vlRyiiwnVYbcOgAKLpgK1
X-Received: by 2002:a05:6a00:1502:b0:666:eaaf:a2af with SMTP id q2-20020a056a00150200b00666eaafa2afmr5985268pfu.14.1693632073180;
        Fri, 01 Sep 2023 22:21:13 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHzp5TpqczJqBI1Tu8ZUWoWOnMmAo8Mh6cdwqdTahTEqepd7CcPlYE10kVoUBHuEZN8DEYB2g==
X-Received: by 2002:a05:6a00:1502:b0:666:eaaf:a2af with SMTP id q2-20020a056a00150200b00666eaafa2afmr5985252pfu.14.1693632072788;
        Fri, 01 Sep 2023 22:21:12 -0700 (PDT)
Received: from zlang-mailbox ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id x6-20020aa793a6000000b0068844ee18dfsm3740446pff.83.2023.09.01.22.21.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Sep 2023 22:21:12 -0700 (PDT)
Date:   Sat, 2 Sep 2023 13:21:09 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 3/3] xfs/559: adapt to kernels that use large folios for
 writes
Message-ID: <20230902052109.we2u2i2k6lwu4t6b@zlang-mailbox>
References: <169335021210.3517899.17576674846994173943.stgit@frogsfrogsfrogs>
 <169335022920.3517899.399149462227894457.stgit@frogsfrogsfrogs>
 <20230901190802.zrttyndmri3rgekm@zlang-mailbox>
 <20230902045629.GA28170@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230902045629.GA28170@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Sep 01, 2023 at 09:56:29PM -0700, Darrick J. Wong wrote:
> On Sat, Sep 02, 2023 at 03:08:02AM +0800, Zorro Lang wrote:
> > On Tue, Aug 29, 2023 at 04:03:49PM -0700, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <djwong@kernel.org>
> > > 
> > > The write invalidation code in iomap can only be triggered for writes
> > > that span multiple folios.  If the kernel reports a huge page size,
> > > scale up the write size.
> > > 
> > > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > > ---
> > >  tests/xfs/559 |   29 ++++++++++++++++++++++++++++-
> > >  1 file changed, 28 insertions(+), 1 deletion(-)
> > > 
> > > 
> > > diff --git a/tests/xfs/559 b/tests/xfs/559
> > > index cffe5045a5..64fc16ebfd 100755
> > > --- a/tests/xfs/559
> > > +++ b/tests/xfs/559
> > > @@ -42,11 +42,38 @@ $XFS_IO_PROG -c 'chattr -x' $SCRATCH_MNT &> $seqres.full
> > >  _require_pagecache_access $SCRATCH_MNT
> > >  
> > >  blocks=10
> > > -blksz=$(_get_page_size)
> > > +
> > > +# If this kernel advertises huge page support, it's possible that it could be
> > > +# using large folios for the page cache writes.  It is necessary to write
> > > +# multiple folios (large or regular) to triggering the write invalidation,
> > > +# so we'll scale the test write size accordingly.
> > > +blksz=$(_get_hugepagesize)
> > 
> > Isn't _require_hugepages needed if _get_hugepagesize is used?
> 
> Nope -- if the kernel doesn't support hugepages, then _get_hugepagesize
> returns the empty string...
> 
> > Thanks,
> > Zorro
> > 
> > > +base_pagesize=$(_get_page_size)
> > > +test -z "$blksz" && blksz=${base_pagesize}
> 
> ...and this line will substitute in the base page size as the block size.

Oh yes, you catch it at here :) OK, so the whole patchset is good to me,

Reviewed-by: Zorro Lang <zlang@redhat.com>

> 
> --D
> 
> > >  filesz=$((blocks * blksz))
> > >  dirty_offset=$(( filesz - 1 ))
> > >  write_len=$(( ( (blocks - 1) * blksz) + 1 ))
> > >  
> > > +# The write invalidation that we're testing below can only occur as part of
> > > +# a single large write.  The kernel limits writes to one base page less than
> > > +# 2GiB to prevent lengthy IOs and integer overflows.  If the block size is so
> > > +# huge (e.g. 512M huge pages on arm64) that we'd exceed that, reduce the number
> > > +# of blocks to get us under the limit.
> > > +max_writesize=$((2147483647 - base_pagesize))
> > > +if ((write_len > max_writesize)); then
> > > +	blocks=$(( ( (max_writesize - 1) / blksz) + 1))
> > > +	# We need at least three blocks in the file to test invalidation
> > > +	# between writes to multiple folios.  If we drop below that,
> > > +	# reconfigure ourselves with base pages and hope for the best.
> > > +	if ((blocks < 3)); then
> > > +		blksz=$base_pagesize
> > > +		blocks=10
> > > +	fi
> > > +	filesz=$((blocks * blksz))
> > > +	dirty_offset=$(( filesz - 1 ))
> > > +	write_len=$(( ( (blocks - 1) * blksz) + 1 ))
> > > +fi
> > > +
> > >  # Create a large file with a large unwritten range.
> > >  $XFS_IO_PROG -f -c "falloc 0 $filesz" $SCRATCH_MNT/file >> $seqres.full
> > >  
> > > 
> > 
> 

