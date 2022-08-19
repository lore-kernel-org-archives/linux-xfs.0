Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88319C3F6B0
	for <linux-xfs@archiver.kernel.org>; Fri, 19 Aug 2022 19:30:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349727AbiHSTaw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 19 Aug 2022 15:30:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349705AbiHSTav (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 19 Aug 2022 15:30:51 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE3ADB958A;
        Fri, 19 Aug 2022 12:30:49 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 91B871FB18;
        Fri, 19 Aug 2022 19:30:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1660937448;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Pw1NmHI9KzQxdz8dkkDOr++f6TIODk7Z6Hgc2C2acxU=;
        b=MyYG8uqZp040tpE2MMzr5Ho4jKb7zfvN+/ROClufN5R8I/2VG5JhiMd6SyMmETC51TYzCF
        QJpsquR3ejRsdSCgdD4+F4rNIUMBpbP/9TIcfHOymue+Eg0B3XycROGj1o3B9EeXO3p50h
        BvKC0rWypmhJVgTlDM8styypiRy4hFQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1660937448;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Pw1NmHI9KzQxdz8dkkDOr++f6TIODk7Z6Hgc2C2acxU=;
        b=5xlLLG4bjE5ZBzdsjXx1CBk8khPg575IaSkbqPGIUubqKtgq6qlmFlydKTf7fRC+DHH7G4
        /0pLB7xvSwtIBPCA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 12B8513AE9;
        Fri, 19 Aug 2022 19:30:48 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id feo7Aujk/2LLWQAAMHmgww
        (envelope-from <pvorel@suse.cz>); Fri, 19 Aug 2022 19:30:48 +0000
Date:   Fri, 19 Aug 2022 21:30:46 +0200
From:   Petr Vorel <pvorel@suse.cz>
To:     "Bird, Tim" <Tim.Bird@sony.com>
Cc:     Eric Sandeen <sandeen@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
        Eric Sandeen <sandeen@sandeen.net>, Jan Kara <jack@suse.cz>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Dave Chinner <david@fromorbit.com>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        Hannes Reinecke <hare@suse.de>,
        "ltp@lists.linux.it" <ltp@lists.linux.it>
Subject: Re: [LTP] LTP test df01.sh detected different size of loop device in
 v5.19
Message-ID: <Yv/k5tblR0QLQT1q@pevik>
Reply-To: Petr Vorel <pvorel@suse.cz>
References: <20220814224440.GR3600936@dread.disaster.area>
 <YvoSeTmLoQVxq7p9@pevik>
 <8d33a7a0-7a7c-47a1-ed84-83fd25089897@sandeen.net>
 <Yv5Z7eu5RGnutMly@pevik>
 <f03c6929-9a14-dd58-3726-dd2c231d0981@sandeen.net>
 <Yv5oaxsX6z2qxxF3@magnolia>
 <Yv5wUcLpIR0hwbmI@pevik>
 <974cc110-d47e-5fae-af5f-e2e610720e2d@redhat.com>
 <Yv+ziab2IiVIsqN6@pevik>
 <BYAPR13MB25036BC8089554DABE287CC2FD6C9@BYAPR13MB2503.namprd13.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BYAPR13MB25036BC8089554DABE287CC2FD6C9@BYAPR13MB2503.namprd13.prod.outlook.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



> > -----Original Message-----
> > From: ltp <ltp-bounces+tim.bird=sony.com@lists.linux.it> On Behalf Of Petr Vorel

> > > On 8/18/22 12:01 PM, Petr Vorel wrote:
> > > >> On Thu, Aug 18, 2022 at 11:05:33AM -0500, Eric Sandeen wrote:
> > > >>> On 8/18/22 10:25 AM, Petr Vorel wrote:
> > > >>>> Hi Eric, all,


> > > >>> ...


> > > >>>>> IOWS, I think the test expects that free space is reflected in statfs numbers
> > > >>>>> immediately after a file is removed, and that's no longer the case here. They
> > > >>>>> change in between the df check and the statfs check.

> > > >>>>> (The test isn't just checking that the values are correct, it is checking that
> > > >>>>> the values are /immediately/ correct.)

> > > >>>>> Putting a "sleep 1" after the "rm -f" in the test seems to fix it; IIRC
> > > >>>>> the max time to wait for inodegc is 1s. This does slow the test down a bit.

> > > >>>> Sure, it looks like we can sleep just 50ms on my hw (although better might be to
> > > >>>> poll for the result [1]), I just wanted to make sure there is no bug/regression
> > > >>>> before hiding it with sleep.

> > > >>>> Thanks for your input!

> > > >>>> Kind regards,
> > > >>>> Petr

> > > >>>> [1] https://people.kernel.org/metan/why-sleep-is-almost-never-acceptable-in-tests

> > > >>>>> -Eric

> > > >>>> +++ testcases/commands/df/df01.sh
> > > >>>> @@ -63,6 +63,10 @@ df_test()
> > > >>>>  		tst_res TFAIL "'$cmd' failed."
> > > >>>>  	fi

> > > >>>> +	if [ "$DF_FS_TYPE" = xfs ]; then
> > > >>>> +		tst_sleep 50ms
> > > >>>> +	fi
> > > >>>> +

> > > >>> Probably worth at least a comment as to why ...

> > > > Sure, that was just to document possible fix. BTW even 200ms was not reliable in
> > > > the long run => not a good solution.

> > > >>> Dave / Darrick / Brian - I'm not sure how long it might take to finish inodegc?
> > > >>> A too-short sleep will let the flakiness remain ...

> > > >> A fsfreeze -f / fsfreeze -u cycle will force all the background garbage
> > > >> collection to run to completion when precise free space accounting is
> > > >> being tested.
> > > > Thanks for a hint, do you mean to put it into df_test after creating file with
> > > > dd to wrap second df_verify (calls df) and df_check (runs stat and compare values)?
> > > > Because that does not help - it fails when running in the loop (managed to break after 5th run).

> > > I think it would go after you remove the file, to ensure that no space usage
> > > changes are pending when you check.

> > > <tests>

> > > This seems to work fine (pseudopatch):

> > >         ROD_SILENT rm -rf mntpoint/testimg

> > > +       # Ensure free space change can be seen by statfs
> > > +       fsfreeze -f $TST_MNTPOINT
> > > +       fsfreeze -u $TST_MNTPOINT
> > It looks like it works. We might add small binary which just calls these 2
> > ioctl (FIFREEZE and FITHAW), just to be friendly to people on embedded
> > environment with minimal dependencies (yes, some people might not install
> > util-linux).

> Thank you!!  It's good to know that small embedded systems are still
> considered, and the consideration is much appreciated!  :-)

> Let me know if you'd like me to try writing the utility.
Thank you, Tim! I'll Cc you when sending this patch (likely next week).

You might also appreciate our effort to lower down loop device size (used for
all_filesystems): https://lore.kernel.org/ltp/Yv%2FkVXSK0xJGb3RO@pevik/

Kind regards,
Petr

>  -- Tim

