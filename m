Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D4AEC4332F
	for <linux-xfs@archiver.kernel.org>; Tue, 18 Oct 2022 08:41:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229941AbiJRIlU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 18 Oct 2022 04:41:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230103AbiJRIlS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 Oct 2022 04:41:18 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1F3C2C118
        for <linux-xfs@vger.kernel.org>; Tue, 18 Oct 2022 01:41:16 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 68D6E33E1B;
        Tue, 18 Oct 2022 08:41:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1666082475;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=c4pgoN7vEpeEera8J2sxjndJsBG4Nw8PIRXEDuqWNQ4=;
        b=Ppp8rjW2/zpXUiYVc9ASz7kGMpnzTRfySJ/fbOCw16J4lMcX/vTxvD+eeiSRctnKjhFDNu
        lT/RititBk26uBEifcPz6grYdSzQvMvlgy6SCUfWt4pL21OI85W2stF2SHuM4poz2S4kbP
        5t7bw6YqWMZVcaQNS3diExIfrGzZ1YY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1666082475;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=c4pgoN7vEpeEera8J2sxjndJsBG4Nw8PIRXEDuqWNQ4=;
        b=rFOWbs3U5XJs+IWrr9vE68Z3YNQxYx0KgKofUufqlhGiu6MLuz5F75SDVNZNQkpTmJXId5
        JWI0aB04h8lJWRDQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 32F1F139D2;
        Tue, 18 Oct 2022 08:41:15 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id HwQrC6tmTmNTbAAAMHmgww
        (envelope-from <pvorel@suse.cz>); Tue, 18 Oct 2022 08:41:15 +0000
Date:   Tue, 18 Oct 2022 10:41:13 +0200
From:   Petr Vorel <pvorel@suse.cz>
To:     Richard Palethorpe <rpalethorpe@suse.de>
Cc:     linux-xfs@vger.kernel.org, Eric Sandeen <sandeen@redhat.com>,
        "Darrick J . Wong" <djwong@kernel.org>, ltp@lists.linux.it,
        Cyril Hrubis <chrubis@suse.cz>
Subject: Re: [LTP] [PATCH 1/1] df01.sh: Use own fsfreeze implementation for
 XFS
Message-ID: <Y05mqQxG5NVukQNP@pevik>
Reply-To: Petr Vorel <pvorel@suse.cz>
References: <20221004090810.9023-1-pvorel@suse.cz>
 <87sfjmmswf.fsf@suse.de>
 <Y01wmJ0ZT+G+N5IE@pevik>
 <87k04xmt4i.fsf@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87k04xmt4i.fsf@suse.de>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

> Hello,

> Petr Vorel <pvorel@suse.cz> writes:

> > Hi Richie,

> >> Hello,

> >> Petr Vorel <pvorel@suse.cz> writes:

> >> > df01.sh started to fail on XFS on certain configuration since mkfs.xfs
> >> > and kernel 5.19. Implement fsfreeze instead of introducing external
> >> > dependency. NOTE: implementation could fail on other filesystems
> >> > (EOPNOTSUPP on exfat, ntfs, vfat).

> >> > Suggested-by: Darrick J. Wong <djwong@kernel.org>
> >> > Suggested-by: Eric Sandeen <sandeen@redhat.com>
> >> > Signed-off-by: Petr Vorel <pvorel@suse.cz>
> >> > ---
> >> > Hi,

> >> > FYI the background of this issue:
> >> > https://lore.kernel.org/ltp/Yv5oaxsX6z2qxxF3@magnolia/
> >> > https://lore.kernel.org/ltp/974cc110-d47e-5fae-af5f-e2e610720e2d@redhat.com/

> >> > @LTP developers: not sure if the consensus is to avoid LTP API
> >> > completely (even use it just with TST_NO_DEFAULT_MAIN), if required I

> >> Why would that be the consensus? :-)

> > $ ls testcases/lib/*.c |wc -l
> > 19

> > $ git grep -l TST_NO_DEFAULT_MAIN testcases/lib/*.c |wc -l
> > 9

> > => 10 tests not use tst_test.h at all.
> > => none is *not* defining TST_NO_DEFAULT_MAIN (not a big surprise),
> > but 2 of them (testcases/lib/tst_device.c, testcases/lib/tst_get_free_pids.c)
> > implement workaround to force messages to be printed from the new library
> > (tst_test.c).

> Possibly the reason for this is that it's not clear whether some core
> library functions will work as expected if we create an executable with
> TST_NO_DEFAULT_MAIN.

> However most stuff works fine.


> > static struct tst_test test = {
> > };
> > tst_test = &test;

> > My opinion also was based on Cyril's comments on nfs05_make_tree.c patch, but he
> > probably meant to just use TST_NO_DEFAULT_MAIN instead of struct tst_test test:
> > https://lore.kernel.org/ltp/YqxFo1iFzHatNRIl@yuki/

> Certainly we shouldn't put a test struct in anything which is not a
> test. Possibly we could create a util struct


> >> > can rewrite to use it just to get SAFE_*() macros (like
> >> > testcases/lib/tst_checkpoint.c) or even with tst_test workarounds
> >> > (testcases/lib/tst_get_free_pids.c).

> >> Yes, it should work fine with TST_NO_DEFAULT_MAIN
> > Both versions IMHO work well, the question what we prefer more.
> > Do you vote for rewriting?

> Yes, avoiding the LTP library caused a number of problems in sparse-ltp
> and the ltx prototype. Then I found linking in the LTP libs with
> TST_NO_DEFAULT_MAIN to ltx and using tst_res(TBROK, ...) etc. worked
> fine.

Well, this simple utility works without LTP library. It's more a matter of
style. OK, I'll send TST_NO_DEFAULT_MAIN version and let the community decide.

Kind regards,
Petr
