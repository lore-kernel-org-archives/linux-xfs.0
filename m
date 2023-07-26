Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96AB5C001B0
	for <linux-xfs@archiver.kernel.org>; Wed, 26 Jul 2023 14:55:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233621AbjGZOzf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 26 Jul 2023 10:55:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234120AbjGZOze (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 Jul 2023 10:55:34 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DEC12685
        for <linux-xfs@vger.kernel.org>; Wed, 26 Jul 2023 07:54:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1690383289;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=GInM7LYBvIjPovjW2qhN9wZ9AsgqFw8qJN5/ZwzfhKI=;
        b=JI4lBV14htOS2Mck6REV5zKShhygPf7baO11NncvKUrAnnUcDr/4iXONuA62mtC7waTtr2
        FEbcna/VhoR+qTzOtDOv6Y37+yJ3bTuiQ3haEmoax451QLcdpntFKG7R/fCsUxuR9puKgg
        yoYIxfJa/4t49q/5diyYzY5RWKYE1DA=
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com
 [209.85.214.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-642-K3p0xBcvOwSg42lxoxZjCQ-1; Wed, 26 Jul 2023 10:54:48 -0400
X-MC-Unique: K3p0xBcvOwSg42lxoxZjCQ-1
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-1bb9e556af0so18559765ad.0
        for <linux-xfs@vger.kernel.org>; Wed, 26 Jul 2023 07:54:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690383287; x=1690988087;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GInM7LYBvIjPovjW2qhN9wZ9AsgqFw8qJN5/ZwzfhKI=;
        b=B4Qktgt/9lTDXKvf8x0P8hwfV8oxAp+KSSnW0Z3VpOJgpXQiC0HTpjo8N61ymodF5d
         tayudfy0VG1URxEOKK59b/IrnLgd4mPcJCQO+Rwryl6WGfI3jihmpL9PAnLqbragsoZt
         f9kchTS6UVCzdBtcEuTPlIqdUv1wxmx/3WHwv/9/0jD/4jN7cQIagIYSAmm5ywRpOmkf
         28kb8gNBR33QtUTJntpKqj7jGBoKQPk8R0d31+vxiKAEYlQn1XA2MzPeFC8nUOPB3zuI
         h+enjHTJgcTxZB5n6NWICElQSagEEqglSdW1Q4Us+yPPgunMGB8U2TeRchGS/Ok4Krob
         hN3A==
X-Gm-Message-State: ABy/qLZnH7XdX/DHqyISvXQUEr5nr47/iFdMdS0ka3kXyC54XJrA0qtH
        kjytEh1tudsDIhNYVgROBjmGsvE/QiP5wVwRtWMjJawj1x8jEAIS08JfozTmIli0PukBtKzYgRx
        U3NHn6RRuCHKbQTvYt7nOLVXn0MwCaDrPGg==
X-Received: by 2002:a17:902:e742:b0:1bb:a922:4a1a with SMTP id p2-20020a170902e74200b001bba9224a1amr2265400plf.6.1690383286902;
        Wed, 26 Jul 2023 07:54:46 -0700 (PDT)
X-Google-Smtp-Source: APBJJlE1rDoCtwsVjgxw9H4T4mr3lGe+HQhHV98EaNwkWimPShRCGOv+HZVRmLwAXBWneHChuFjabA==
X-Received: by 2002:a17:902:e742:b0:1bb:a922:4a1a with SMTP id p2-20020a170902e74200b001bba9224a1amr2265379plf.6.1690383286521;
        Wed, 26 Jul 2023 07:54:46 -0700 (PDT)
Received: from zlang-mailbox ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id 20-20020a170902e9d400b001bba27d1b65sm6755032plk.85.2023.07.26.07.54.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Jul 2023 07:54:46 -0700 (PDT)
Date:   Wed, 26 Jul 2023 22:54:41 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     Theodore Ts'o <tytso@mit.edu>
Cc:     "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org
Subject: Re: [PATCH 1/2] check: add a -smoketest option
Message-ID: <20230726145441.lbzzokwigrztimyq@zlang-mailbox>
References: <168972905065.1698606.6829635791058054610.stgit@frogsfrogsfrogs>
 <168972905626.1698606.12419796694170752316.stgit@frogsfrogsfrogs>
 <20230719151024.ef7vgjmtoxwxkmjm@zlang-mailbox>
 <20230719152907.GA11377@frogsfrogsfrogs>
 <20230719161115.byva7tvwoafkesga@zlang-mailbox>
 <20230720022756.GH11352@frogsfrogsfrogs>
 <20230720143433.n5gkhukdkz7s5ab7@zlang-mailbox>
 <20230726000524.GG11340@frogsfrogsfrogs>
 <20230726060102.GB30264@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230726060102.GB30264@mit.edu>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jul 26, 2023 at 02:01:02AM -0400, Theodore Ts'o wrote:
> On Tue, Jul 25, 2023 at 05:05:24PM -0700, Darrick J. Wong wrote:
> > 
> > If someone wants that, then ok.  The taret audience for this are the
> > drive-by filesystem patch authors.  IOWs, people who have some small bug
> > they want to try to fix and want to run a quick test to see if their
> > change works.
> 
> Zorro,
> 
> FYI, the context behind this was a comment I had made to Darrick that
> the time necessary to run "-g quick" had been getting longer and
> longer, and it might be nice to create a manually curated "-g smoke"
> that was good enough for drive-by patch authors.  I was originally
> thinking about a cut-down set of tests by selecting a subset of "-g
> quick", but Darrick suggested that instead, we just run a very small
> set of tests (mostly based on fsstress / fsx) and just run them in a
> loop for 4 minutes or so.
> 
> We also talked about having a time budget (say, 15 minutes) and then
> just dividing 15 time by the number of tests, and just run them in for
> a specified soak time, so that the total time is known ahead of time.
> 
> To be honest, I was a bit dubious it could be that simple, but that's
> where using kcov to show that you get a pretty good code coverage
> using something that simple comes from.
> 
> > I don't think it's reasonable to expect drive-by'ers to know all that
> > much about the fstests groups or spend the hours it takes to run -g all.
> > As a maintainer, I prefer that these folks have done at least a small
> > taste of QA before they start talking to the lists.
> 
> A big problem for the drive-by'ers is that that the top-level xfstests
> README file is just plain scary, and has far too many steps for a
> drive-by patch author to follow.
> 
> What I plan to add to a maintainer-entry-file.rst file for ext4 in the
> kernel docs is to tell that drive-by posters that should run
> "kvm-xfstests smoke" before submitting a patch, and setting up
> kvm-xfstess is dead simple easy:
> 
> 
> 1)  Install kvm-xfstests --- you only have to run this once
> 
> % git clone https://github.com/tytso/xfstests-bld fstests
> % cd fstests
> % make ; make install
> 
> # Optional, if your file system you are developing isn't ext4;
> # change f2fs to the file system of your choice
> % echo PRIMARY_FSTYPE=f2fs >> ~/.config/kvm-xfstests
> 
> 
> 2) Build the kernel suitable for use with kvm-xfstests
> 
> % cd /path/to/your/kernel
> % install-kconfig
> % kbuild
> 
> 3) Run the smoke test --- assuming the cwd is /path/to/your/kernel
> 
> (Note: today this runs -g quick, but it would be good if this could be
> faster)
> 
> % kvm-xfstests smoke 
> 
> 
> It's simple, and since the kvm-xfstests script will download a
> pre-compiled test appliance image automatically, there's no need to
> require the drive-by tester to figure out how compile xfstests with
> any of its prerequisites.
> 
> And once things are set up, then it's just a matter of running
> "kbuild" to build your kernel after you make changes, and running
> "kvm-xfstests smoke" to do a quick smoke testing run.
> 
> No muss, no fuss, no dirty dishes...   :-)

Hi Ted,

Thanks for this detailed explanation!

Ahaha, I'm just waiting for Darrick wake up, then ask him is there any
requirement/context about this patch. Due to he (looks like) a bit
hurry to push this patch :)

If most of you prefer this way (an ./check option, not a separated wrapper
script), I'm OK with that.

Just recently I'm a bit worry about the ./check code, it's becoming more
and more complex. I hope to separate something from it, but many things
entwined, and growing. Anyway that's another story, I'll look into this
patchset and review it soon.

Thanks,
Zorro

> 
> Cheers,
> 
> 					- Ted
> 

