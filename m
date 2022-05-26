Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E023C433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 26 May 2022 01:35:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232904AbiEZBf0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 25 May 2022 21:35:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229458AbiEZBfZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 25 May 2022 21:35:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 054DEDE93;
        Wed, 25 May 2022 18:35:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9D2D8617C2;
        Thu, 26 May 2022 01:35:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01839C34113;
        Thu, 26 May 2022 01:35:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653528921;
        bh=Ww7ObAXnJpfEuyfB7Be3bLStCrrBnElkWJH1L9aKZQQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=PuV3xQ/3GiO/7AvjrjeP/5gSfyH1raeiOgSKzvGG+MwulxMzwi/H3GV70Ycb14t20
         c2SmctrjGc70WY8fH01aQOtATtSscYsHvjcp3i7YDqKqANFj4kjHVG0rZqAljgWUx1
         3wkMttwgLvZ63Rcb0fsHmTjafRGo+4EIgTTsXWd2+KEdCao9XSyqEG8pZThci5FO0b
         IrDO8c+gtKvsvc4Ak//Ud0jb0Q3y/0t2KuHZNgUwxSUjRVKSLaa7YI9hsJmiSFhqiV
         aV8EnvikV8dsOaYnigvkzs0x1Gwt2qWffIwXy6GjOEdPDNboDtWqSWIhWeRwwDXUKu
         9xurMehJ2sf4g==
Date:   Wed, 25 May 2022 18:35:20 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Zorro Lang <zlang@redhat.com>, Eryu Guan <guaneryu@gmail.com>,
        fstests <fstests@vger.kernel.org>,
        xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: test mkfs.xfs sizing of internal logs that
Message-ID: <Yo7ZWKYseetNITrj@magnolia>
References: <Yo03mZ12X1nLGihK@magnolia>
 <20220524234426.GQ2306852@dread.disaster.area>
 <Yo1vCizXEK7+AkZi@magnolia>
 <20220525002413.GT2306852@dread.disaster.area>
 <Yo66ACF65ao6Akis@magnolia>
 <20220526001149.GW2306852@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220526001149.GW2306852@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, May 26, 2022 at 10:11:49AM +1000, Dave Chinner wrote:
> On Wed, May 25, 2022 at 04:21:36PM -0700, Darrick J. Wong wrote:
> > On Wed, May 25, 2022 at 10:24:13AM +1000, Dave Chinner wrote:
> > > On Tue, May 24, 2022 at 04:49:30PM -0700, Darrick J. Wong wrote:
> > > > On Wed, May 25, 2022 at 09:44:26AM +1000, Dave Chinner wrote:
> > > > > On Tue, May 24, 2022 at 12:52:57PM -0700, Darrick J. Wong wrote:
> > > > > > +# First we try various small filesystems and stripe sizes.
> > > > > > +for M in `seq 298 302` `seq 490 520`; do
> > > > > > +	for S in `seq 32 4 64`; do
> > > > > > +		test_format "M=$M S=$S" -dsu=${S}k,sw=1,size=${M}m
> > > > > > +	done
> > > > > > +done
> > > > > > +
> > > > > > +# log so large it pushes the root dir into AG 1
> > > > > > +test_format "log pushes rootdir into AG 1" -d agcount=3200,size=6366g -lagnum=0
> > > > 
> > > > ...this particular check in mkfs only happens after we allocate the root
> > > > directory, which an -N invocation doesn't do.
> > > 
> > > Ok, so for this test can we drop the -N? We don't need to do 30 IOs
> > > and write 64MB logs for every config we test - I think there's ~35 *
> > > 8 invocations of test_format in the loop above before we get here...
> > > 
> > > Also, why do we need a 6.3TB filesystem with 2.1GB AGs and a 2GB log
> > > to trigger this? That means we have to write 2GB to disk, plus
> > > ~20,000 write IOs for the AG headers and btree root blocks before we
> > > get to the failure case, yes?
> > > 
> > > Why not just exercise the failure case with something like this:
> > > 
> > > # mkfs.xfs -d agcount=2,size=64M -l size=8180b,agnum=0 -d file,name=test.img
> > > meta-data=test.img               isize=512    agcount=2, agsize=8192 blks
> > >          =                       sectsz=512   attr=2, projid32bit=1
> > >          =                       crc=1        finobt=1, sparse=1, rmapbt=0
> > >          =                       reflink=1    bigtime=0 inobtcount=0
> > > data     =                       bsize=4096   blocks=16384, imaxpct=25
> > >          =                       sunit=0      swidth=0 blks
> > > naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
> > > log      =internal log           bsize=4096   blocks=8180, version=2
> > >          =                       sectsz=512   sunit=0 blks, lazy-count=1
> > > realtime =none                   extsz=4096   blocks=0, rtextents=0
> > > mkfs.xfs: root inode created in AG 1, not AG 0
> > 
> > Welll... a better reason for why this test can't do that -- one of my
> > fixes also made mkfs reject -l size=XXX when XXX is not possible.
> 
> So you make other changes to mkfs that aren't yet upstream that
> check whether the log causes the root inode to change position?

It's in for-next, is that not good enough?

> I mean, '-l size=8180b' results in a log that fits perfectly fine in
> an empty AG, and so you must have added more checks to detect this
> moves the root inode somehow?
> 
> > That said... -d agcount=3200,size=6366g -lagnum=0 -N seems to work?
> 
> On a new mkfs binary with those checks that you mention above?  If
> so, it seems to me that those new checks trigger for this case, too,
> before we write anything?
>
> IOWs, this won't fail on older mkfs.xfs binaries that don't have
> these new log size checks because we never get around to allocating
> the root inode and checking it's location, right?  Yet what we
> really want here is for it to fail on an old mkfs binary?

Yeah, something like that.  It's been so long since Eric and I were
actively poking on this that I don't remember so well anymore.

--D

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
