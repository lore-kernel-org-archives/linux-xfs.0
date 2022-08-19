Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3891DC32793
	for <linux-xfs@archiver.kernel.org>; Fri, 19 Aug 2022 16:18:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351834AbiHSQSV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 19 Aug 2022 12:18:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352515AbiHSQQ5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 19 Aug 2022 12:16:57 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2EBC116ECE;
        Fri, 19 Aug 2022 09:00:13 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id C2B1B2051C;
        Fri, 19 Aug 2022 16:00:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1660924811;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=1EOPRaUipOJxcZOITEcfDSR5J7gAs1mJruhQw7ACMlA=;
        b=smCeWKPTuJhSif5sFZ4Prn5bYmJO+mDoSbkTHJKVWW66GzH7wQ1uw+ea0D8K4+7AMWBBgo
        wW+6I3DO+SzqwAeMD/eDwunsv/a7agp+jDAeaTLLarSgX7QyCgGNfltvmBrwcpws/rDp6+
        JqogaYLIKSyExQcgEHCa/cXb1pIBaKE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1660924811;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=1EOPRaUipOJxcZOITEcfDSR5J7gAs1mJruhQw7ACMlA=;
        b=tnazJTR5H/s2WuWaiLEGCBInYSOSLgfJUdRxxUgjgF4Q3+o6xzmZ4mPS8hojQkdeo9XlZ+
        eeayDImQEn+oIzDQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 35C5D13AC1;
        Fri, 19 Aug 2022 16:00:11 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id iOwRCouz/2JbGwAAMHmgww
        (envelope-from <pvorel@suse.cz>); Fri, 19 Aug 2022 16:00:11 +0000
Date:   Fri, 19 Aug 2022 18:00:09 +0200
From:   Petr Vorel <pvorel@suse.cz>
To:     Eric Sandeen <sandeen@redhat.com>
Cc:     "Darrick J. Wong" <djwong@kernel.org>,
        Eric Sandeen <sandeen@sandeen.net>,
        Dave Chinner <david@fromorbit.com>,
        linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Jan Kara <jack@suse.cz>, Hannes Reinecke <hare@suse.de>,
        linux-xfs@vger.kernel.org, ltp@lists.linux.it
Subject: Re: LTP test df01.sh detected different size of loop device in v5.19
Message-ID: <Yv+ziab2IiVIsqN6@pevik>
Reply-To: Petr Vorel <pvorel@suse.cz>
References: <YvZUfq+3HYwXEncw@pevik>
 <YvZTpQFinpkB06p9@pevik>
 <20220814224440.GR3600936@dread.disaster.area>
 <YvoSeTmLoQVxq7p9@pevik>
 <8d33a7a0-7a7c-47a1-ed84-83fd25089897@sandeen.net>
 <Yv5Z7eu5RGnutMly@pevik>
 <f03c6929-9a14-dd58-3726-dd2c231d0981@sandeen.net>
 <Yv5oaxsX6z2qxxF3@magnolia>
 <Yv5wUcLpIR0hwbmI@pevik>
 <974cc110-d47e-5fae-af5f-e2e610720e2d@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <974cc110-d47e-5fae-af5f-e2e610720e2d@redhat.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

> On 8/18/22 12:01 PM, Petr Vorel wrote:
> >> On Thu, Aug 18, 2022 at 11:05:33AM -0500, Eric Sandeen wrote:
> >>> On 8/18/22 10:25 AM, Petr Vorel wrote:
> >>>> Hi Eric, all,


> >>> ...


> >>>>> IOWS, I think the test expects that free space is reflected in statfs numbers
> >>>>> immediately after a file is removed, and that's no longer the case here. They
> >>>>> change in between the df check and the statfs check.

> >>>>> (The test isn't just checking that the values are correct, it is checking that
> >>>>> the values are /immediately/ correct.)

> >>>>> Putting a "sleep 1" after the "rm -f" in the test seems to fix it; IIRC
> >>>>> the max time to wait for inodegc is 1s. This does slow the test down a bit.

> >>>> Sure, it looks like we can sleep just 50ms on my hw (although better might be to
> >>>> poll for the result [1]), I just wanted to make sure there is no bug/regression
> >>>> before hiding it with sleep.

> >>>> Thanks for your input!

> >>>> Kind regards,
> >>>> Petr

> >>>> [1] https://people.kernel.org/metan/why-sleep-is-almost-never-acceptable-in-tests

> >>>>> -Eric

> >>>> +++ testcases/commands/df/df01.sh
> >>>> @@ -63,6 +63,10 @@ df_test()
> >>>>  		tst_res TFAIL "'$cmd' failed."
> >>>>  	fi

> >>>> +	if [ "$DF_FS_TYPE" = xfs ]; then
> >>>> +		tst_sleep 50ms
> >>>> +	fi
> >>>> +

> >>> Probably worth at least a comment as to why ...

> > Sure, that was just to document possible fix. BTW even 200ms was not reliable in
> > the long run => not a good solution.

> >>> Dave / Darrick / Brian - I'm not sure how long it might take to finish inodegc?
> >>> A too-short sleep will let the flakiness remain ...

> >> A fsfreeze -f / fsfreeze -u cycle will force all the background garbage
> >> collection to run to completion when precise free space accounting is
> >> being tested.
> > Thanks for a hint, do you mean to put it into df_test after creating file with
> > dd to wrap second df_verify (calls df) and df_check (runs stat and compare values)?
> > Because that does not help - it fails when running in the loop (managed to break after 5th run).

> I think it would go after you remove the file, to ensure that no space usage
> changes are pending when you check.

> <tests>

> This seems to work fine (pseudopatch):

>         ROD_SILENT rm -rf mntpoint/testimg

> +       # Ensure free space change can be seen by statfs
> +       fsfreeze -f $TST_MNTPOINT
> +       fsfreeze -u $TST_MNTPOINT
It looks like it works. We might add small binary which just calls these 2
ioctl (FIFREEZE and FITHAW), just to be friendly to people on embedded
environment with minimal dependencies (yes, some people might not install
util-linux).

>         # flush file system buffers, then we can get the actual sizes.
>         sync


> (although: what's the difference between $TST_MNTPOINT and mountpoint/ ?)
Thanks for a report, fixed in 96ae882d3 ("df01.sh: Use $TST_MNTPOINT")

> You just don't want to accidentally freeze the root filesystem ;)
Sure :)

Kind regards,
Petr

> -Eric


