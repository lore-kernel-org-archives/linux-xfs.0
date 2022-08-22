Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1B5AC28D13
	for <linux-xfs@archiver.kernel.org>; Mon, 22 Aug 2022 09:36:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230467AbiHVJg6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 22 Aug 2022 05:36:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230370AbiHVJg4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 22 Aug 2022 05:36:56 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A9E631212
        for <linux-xfs@vger.kernel.org>; Mon, 22 Aug 2022 02:36:55 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id F3FAD1FB5C;
        Mon, 22 Aug 2022 09:36:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1661161014;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=h+BxhhYnsr6hoefbZrh0xKNdC0aNnv2SordBDWoyEew=;
        b=D1n9Lrq7prTdH8PSJWpd8oEdbICwcabU31lNKRgcwkZeK8L4jSG4KNGDRlB53Vc1S2oH8G
        hEYAritDsadkUHYfFVW42AqwEHYDrGWGAAN3N7YZU8au35WnGVXJ8JkgPhQZ2QFWBnaBfJ
        MGlPkq6dqmJ5ErRn7CeF3Ht2eCWKEcI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1661161014;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=h+BxhhYnsr6hoefbZrh0xKNdC0aNnv2SordBDWoyEew=;
        b=p1cLOCKxL6w3CtilKfWbq3NJDgjhpXFYw84uWQ+qRvz+2JNXTQy+jujzkY/wA8rdRep4W9
        d8U1kEMH9GZuFlAw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 629EA13523;
        Mon, 22 Aug 2022 09:36:53 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id sBrtFTVOA2NBdgAAMHmgww
        (envelope-from <pvorel@suse.cz>); Mon, 22 Aug 2022 09:36:53 +0000
Date:   Mon, 22 Aug 2022 11:36:51 +0200
From:   Petr Vorel <pvorel@suse.cz>
To:     Li Wang <liwang@redhat.com>
Cc:     Geert Uytterhoeven <geert@linux-m68k.org>,
        Cyril Hrubis <chrubis@suse.cz>, LTP List <ltp@lists.linux.it>,
        Martin Doucha <mdoucha@suse.cz>,
        automated-testing@yoctoproject.org,
        "Darrick J . Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
        automated-testing@lists.yoctoproject.org
Subject: Re: [Automated-testing] [RFC PATCH 1/1] API: Allow to use xfs
 filesystems < 300 MB
Message-ID: <YwNOMy9m72J/uH+Q@pevik>
Reply-To: Petr Vorel <pvorel@suse.cz>
References: <20220817204015.31420-1-pvorel@suse.cz>
 <Yv4MBF79PnJKJbwm@yuki>
 <Yv4eiT5L+M7dMkQ5@pevik>
 <Yv4i0gWiHTkfWB5m@yuki>
 <CAMuHMdUMBjCTwPu7wxrnagXnbyVxxmXN+vHmML0Lr=SyrTw0nQ@mail.gmail.com>
 <Yv/kVXSK0xJGb3RO@pevik>
 <CAEemH2ehh1+WPtwjzere-JEHeBUpg27w4nZs6_QG71ZTAkUzpA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEemH2ehh1+WPtwjzere-JEHeBUpg27w4nZs6_QG71ZTAkUzpA@mail.gmail.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Li, all,

> Hi Petr, All,

> On Sat, Aug 20, 2022 at 3:28 AM Petr Vorel <pvorel@suse.cz> wrote:

> > Hi all,

> > > Hi Cyril,

> > > On Thu, Aug 18, 2022 at 1:28 PM Cyril Hrubis <chrubis@suse.cz> wrote:
> > > > > > I'm starting to wonder if we should start tracking minimal FS size
> > per
> > > > > > filesystem since btrfs and xfs will likely to continue to grow and
> > with
> > > > > > that we will end up disabling the whole fs related testing on
> > embedded
> > > > > > boards with a little disk space. If we tracked that per filesystem
> > we
> > > > > > would be able to skip a subset of filesystems when there is not
> > enough
> > > > > > space. The downside is obviously that we would have to add a bit
> > more
> > > > > > complexity to the test library.

> > > > > Maybe I could for start rewrite v2 (I've sent it without Cc kernel
> > devs now it's
> > > > > mainly LTP internal thing) as it just to have 300 MB for XFS and 256
> > MB for the
> > > > > rest. That would require to specify filesystem when acquiring device
> > (NULL would
> > > > > be for the default filesystem), that's would be worth if embedded
> > folks counter
> > > > > each MB. It'd be nice to hear from them.

> > > > The 256MB limit was set previously due to btrfs, I bet that we can
> > > > create smaller images for ext filesytems for example.

> > Thanks for input, Geert!

> > > Yeah, we used to have ext2 root file systems that fit on 1440 KiB
> > floppies.
> > These nice times when everything simple hadn't been solved yet ... :).
> > > IIRC, ext3 does have a minimum size of 32 MiB or so.
> > Interesting, I was able to create smaller.

> > I did some testing minimal size (verified on chdir01 test):
> > XFS: 300 MB, btrfs: 109 MB, ntfs: 2 MB, ext3: 2 MB, ext[24]: 1 MB, vfat: 1
> > MB, exfat: 1 MB.

> > I guess using XFS: 300 MB, btrfs: 109 MB and 16 MB for the rest could be
> > enough.


> I think so, tracking minimal FS size per FS is a practical idea.
> But one thing we have to be aware of is that there may be different
> minimal sizes for each FS version.
> (so we'd better choose the maximum of minimal sizes).

> 16MB for general FS should be fine, I will help to test that if someone
> works out the patch.

So should we combine both: minimal FS size and those XFS variables which would
allow to use lower size for XFS? I wonder which which size would be relevant,
it might be safer to use 64 MB:

https://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git/tree/mkfs/xfs_mkfs.c
/*
 * Realistically, the log should never be smaller than 64MB.  Studies by the
 * kernel maintainer in early 2022 have shown a dramatic reduction in long tail
 * latency of the xlog grant head waitqueue when running a heavy metadata
 * update workload when the log size is at least 64MB.
 */

Because there is really not a big difference between 256MB and 300MB.

Kind regards,
Petr

> > But that would require to run all tests to see how many tests actually use
> > bigger data.


> Absolutely YES!
