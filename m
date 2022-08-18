Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01CF4C00140
	for <linux-xfs@archiver.kernel.org>; Thu, 18 Aug 2022 09:45:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242831AbiHRJpr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 18 Aug 2022 05:45:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243526AbiHRJpq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 18 Aug 2022 05:45:46 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87C0AB08AB
        for <linux-xfs@vger.kernel.org>; Thu, 18 Aug 2022 02:45:44 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 39C952108B;
        Thu, 18 Aug 2022 09:45:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1660815943;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=4+LcSyNkb5WBqX0USANKXsWGWq/H06zcrui9isF0wQ4=;
        b=O5HdzCF70xwlA79tuUnywkLHk3CbFNT74gGHzEC0WKXCDB/rzR+YJP52m0dwWppJDA+DGF
        I+J5c2jXIKblkuAePtoQsVAMRXZz6HEC2gwX+m5G5o3pdU2qDa3uLyVzvWHinqbmUIf7J8
        OoBkqXpQBhH1JiNflADI5qL4wG0xFHo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1660815943;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=4+LcSyNkb5WBqX0USANKXsWGWq/H06zcrui9isF0wQ4=;
        b=qmGKR4nO6KJU20bcliyTqShVBaONPAr8KsFgQFFNcCyKnbHvWBS9BmLnwputOa8mvsDulh
        2t1WBsEgrx5DLqBA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id D5DE1139B7;
        Thu, 18 Aug 2022 09:45:42 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id tYC5MkYK/mJsAwAAMHmgww
        (envelope-from <pvorel@suse.cz>); Thu, 18 Aug 2022 09:45:42 +0000
Date:   Thu, 18 Aug 2022 11:45:41 +0200
From:   Petr Vorel <pvorel@suse.cz>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     "Darrick J. Wong" <djwong@kernel.org>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        automated-testing@yoctoproject.org, LTP List <ltp@lists.linux.it>,
        automated-testing@lists.yoctoproject.org,
        Richard Palethorpe <rpalethorpe@suse.com>,
        Joerg Vehlow <joerg.vehlow@aox-tech.de>,
        Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [LTP] [RFC PATCH 1/1] API: Allow to use xfs filesystems < 300 MB
Message-ID: <Yv4KRRNM2Dq+B+2x@pevik>
Reply-To: Petr Vorel <pvorel@suse.cz>
References: <20220817204015.31420-1-pvorel@suse.cz>
 <Yv2A9Ggkv/NBrTd4@magnolia>
 <CAOQ4uxjMEHYQwO25dhs5WtzbOkJcee0HofQDTT3cD-qXJn7xQw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxjMEHYQwO25dhs5WtzbOkJcee0HofQDTT3cD-qXJn7xQw@mail.gmail.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

> On Thu, Aug 18, 2022 at 2:59 AM Darrick J. Wong <djwong@kernel.org> wrote:

> > On Wed, Aug 17, 2022 at 10:40:15PM +0200, Petr Vorel wrote:
> > > mkfs.xfs since v5.19.0-rc1 [1] refuses to create filesystems < 300 MB.
> > > Reuse workaround intended for fstests: set 3 environment variables:
> > > export TEST_DIR=1 TEST_DEV=1 QA_CHECK_FS=1

> > > Workaround added to both C API (for .needs_device) and shell API (for
> > > TST_NEEDS_DEVICE=1).

> > > Fix includes any use of filesystem (C API: .all_filesystems,
> > > .format_device, shell API: TST_MOUNT_DEVICE=1, TST_FORMAT_DEVICE=1).

> > > Fixes various C and shell API failures, e.g.:

> > > ./mkfs01.sh -f xfs
> > > mkfs01 1 TINFO: timeout per run is 0h 5m 0s
> > > tst_device.c:89: TINFO: Found free device 0 '/dev/loop0'
> > > mkfs01 1 TFAIL: 'mkfs -t xfs  -f /dev/loop0 ' failed.
> > > Filesystem must be larger than 300MB.

> > > ./creat09
> > > ...
> > > tst_test.c:1599: TINFO: Testing on xfs
> > > tst_test.c:1064: TINFO: Formatting /dev/loop0 with xfs opts='' extra opts=''
> > > Filesystem must be larger than 300MB.

> > > Link: https://lore.kernel.org/all/164738662491.3191861.15611882856331908607.stgit@magnolia/

> > > Reported-by: Martin Doucha <mdoucha@suse.cz>
> > > Signed-off-by: Petr Vorel <pvorel@suse.cz>
> > > ---
> > > Dave, please next time remember there are other testsuites testing XFS,

> > Dave?? <cough>


> TBH, it is not about remembering, it is about running integration tests
> that catch these test bugs.
You're right, that's the only reliable thing.

> Obviously, xfsprogs maintainer (Eric) is running fstests before an
> xfsprogs release, but I cannot blame Eric for not running the entire
> LTS test suite for xfsprogs release...
Not expecting that.

> I suppose that the bots running LTP on rc kernels might want
> to consider also running LTP with rc xfsprogs/e2fsprogs/...
That would be great, but don't expect it'd happen.

> otherwise, those bugs would be caught when *progs hits a distro
> that is used to run LTP.
That's what happen on openSUSE.

> > > not just fstests :). How long do you plan to keep this workaround?

> > Forever.  In the ideal world we'll some day get around to restructuring
> > all the xfstests that do tricky things with sub-500M filesystems, but
> > that's the unfortunate part of removing support for small disks.


> If it's forever, then it should probably have been a command line option.
> IIUC, the motivation was to discourage users from formatting too small
> filesystems, but if users have a way to do it, they will find it anyway.
+1

> Petr,

> Notice that the fstests hack was needed for fstests that require MAX fs size,
> while the existing LTP lib and tests only have MIN dev size requirement.

> > Most of the fstests don't care about the fs size and so they'll run with
> > the configured storage (some tens or millions of gigabytes) so we're
> > mostly using the same fs sizes that users are expected to have.

> > > LTP community: do we want to depend on this behavior or we just increase from 256MB to 301 MB
> > > (either for XFS or for all). It might not be a good idea to test size users are required
> > > to use.


> For most LTS tests, all you need to do is increase the default (DEV_MIN_SIZE)
> from 300MB to 301MB so that's not worth doing any workarounds.
FYI DEV_MIN_SIZE is used just for tests which test LTP API itself. For real
tests is DEV_SIZE_MB (lib/tst_device.c). And actually 300 MB is enough,
therefore the only change for the default values is: DEV_SIZE_MB from 256 to 300
(should be enough for all LTP tests: C and shell API, also these tests of LTP
API itself).  I also think 46MB is not worth of hacks.

BTW for some reason DEV_MIN_SIZE was higher than the default (probably to test
library with non-default value, but now is the same, we might want to increase
it (or remove it).

> For the 3 memcontrol tests that require dev_min_size = 256 and run on
> all_filesystems, it does not look like changing min size is needed at all.
Indeed, this value can stay. This check is here because although LTP uses loop
device by default, any device can be used via LTP_DEV env variable.

> For squashfs01 the xfs limitation is irrelevant, but generally,
> If the test min requirement (1MB) is smaller than the lib default,
> DEV_MIN_SIZE still meets the test requirement, so why bother
> going below the lib default DEV_MIN_SIZE?
For use with LTP_DEV.

Anyway, Darrick, Amir, thank you both for your input.

Kind regards,
Petr

> Thanks,
> Amir.
