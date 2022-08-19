Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD008C32771
	for <linux-xfs@archiver.kernel.org>; Fri, 19 Aug 2022 19:28:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351024AbiHST2c (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 19 Aug 2022 15:28:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349705AbiHST2b (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 19 Aug 2022 15:28:31 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79B3A28E22
        for <linux-xfs@vger.kernel.org>; Fri, 19 Aug 2022 12:28:26 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id F20931FBA8;
        Fri, 19 Aug 2022 19:28:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1660937305;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=4JhAhYtqVHiLuemLCzuwsU8zpofcCP6KjmPE8fH0dA4=;
        b=HRooOVmGO7M5TK9e+sgNjL76RGeOnZ6wouG74fa1M9mKm2y/Jz/22Ild5W5RetlKuF/3Ih
        FUdCUxgeroNwnaA8kCw+whSuX1576Av24v5ffbk6jpVqmnpg4/TxrbOh5jTAMX+nDixLaW
        BO42affBPaUzUd4LblanbEue+tbN8Fg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1660937305;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=4JhAhYtqVHiLuemLCzuwsU8zpofcCP6KjmPE8fH0dA4=;
        b=jcQl0FqxUBHU3m2t9Ubv+Dc6S72+i6ulFlh7lSvIyCYooh1+UQl5f+LlFNj2ct1hTydHCs
        +xGSlpfIwlJd1dCw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 71AA113AE9;
        Fri, 19 Aug 2022 19:28:24 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id JVIUAVjk/2IlWQAAMHmgww
        (envelope-from <pvorel@suse.cz>); Fri, 19 Aug 2022 19:28:24 +0000
Date:   Fri, 19 Aug 2022 21:28:21 +0200
From:   Petr Vorel <pvorel@suse.cz>
To:     Geert Uytterhoeven <geert@linux-m68k.org>
Cc:     Cyril Hrubis <chrubis@suse.cz>, ltp@lists.linux.it,
        Li Wang <liwang@redhat.com>, Martin Doucha <mdoucha@suse.cz>,
        automated-testing@yoctoproject.org,
        "Darrick J . Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
        automated-testing@lists.yoctoproject.org
Subject: Re: [Automated-testing] [RFC PATCH 1/1] API: Allow to use xfs
 filesystems < 300 MB
Message-ID: <Yv/kVXSK0xJGb3RO@pevik>
Reply-To: Petr Vorel <pvorel@suse.cz>
References: <20220817204015.31420-1-pvorel@suse.cz>
 <Yv4MBF79PnJKJbwm@yuki>
 <Yv4eiT5L+M7dMkQ5@pevik>
 <Yv4i0gWiHTkfWB5m@yuki>
 <CAMuHMdUMBjCTwPu7wxrnagXnbyVxxmXN+vHmML0Lr=SyrTw0nQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMuHMdUMBjCTwPu7wxrnagXnbyVxxmXN+vHmML0Lr=SyrTw0nQ@mail.gmail.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

> Hi Cyril,

> On Thu, Aug 18, 2022 at 1:28 PM Cyril Hrubis <chrubis@suse.cz> wrote:
> > > > I'm starting to wonder if we should start tracking minimal FS size per
> > > > filesystem since btrfs and xfs will likely to continue to grow and with
> > > > that we will end up disabling the whole fs related testing on embedded
> > > > boards with a little disk space. If we tracked that per filesystem we
> > > > would be able to skip a subset of filesystems when there is not enough
> > > > space. The downside is obviously that we would have to add a bit more
> > > > complexity to the test library.

> > > Maybe I could for start rewrite v2 (I've sent it without Cc kernel devs now it's
> > > mainly LTP internal thing) as it just to have 300 MB for XFS and 256 MB for the
> > > rest. That would require to specify filesystem when acquiring device (NULL would
> > > be for the default filesystem), that's would be worth if embedded folks counter
> > > each MB. It'd be nice to hear from them.

> > The 256MB limit was set previously due to btrfs, I bet that we can
> > create smaller images for ext filesytems for example.

Thanks for input, Geert!

> Yeah, we used to have ext2 root file systems that fit on 1440 KiB floppies.
These nice times when everything simple hadn't been solved yet ... :).
> IIRC, ext3 does have a minimum size of 32 MiB or so.
Interesting, I was able to create smaller.

I did some testing minimal size (verified on chdir01 test):
XFS: 300 MB, btrfs: 109 MB, ntfs: 2 MB, ext3: 2 MB, ext[24]: 1 MB, vfat: 1 MB, exfat: 1 MB.

I guess using XFS: 300 MB, btrfs: 109 MB and 16 MB for the rest could be enough.
But that would require to run all tests to see how many tests actually use
bigger data.

Kind regards,
Petr

> Gr{oetje,eeting}s,

>                         Geert
