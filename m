Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49C27C001DF
	for <linux-xfs@archiver.kernel.org>; Wed, 26 Jul 2023 20:59:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230224AbjGZU7n (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 26 Jul 2023 16:59:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229721AbjGZU7m (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 Jul 2023 16:59:42 -0400
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9450519B6
        for <linux-xfs@vger.kernel.org>; Wed, 26 Jul 2023 13:59:41 -0700 (PDT)
Received: from cwcc.thunk.org (pool-173-48-115-64.bstnma.fios.verizon.net [173.48.115.64])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 36QKxUeM017140
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 26 Jul 2023 16:59:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
        t=1690405172; bh=fwwcd203P4+rAd7TlalyYy+grQDBBdIhp5JCjNTMb8Q=;
        h=Date:From:Subject:Message-ID:MIME-Version:Content-Type;
        b=O5W8lvE9i18FdE7LjwUqx9hZsLzI3hAT9dsZfOGkYoNvMfFWQuwhVdta9NurPfAb0
         yQ42uRaom776r4xqesvHzTGH+31Ls5SLjIcnKafgYIcg6hXX1ydiwSRxq80VtHtSt3
         X1yXjbaOxrlHN2JrnoOYuTT2I8jLXnS74EhGZ+wJnp+BuNRKsOAqpYSJcD3QMTGViW
         GdgFRDB2R4vXxrovQ7r4cD+L7krwe9RMhQ4V2An62nGGtMTwTT/KiNs1th2hsGVCFX
         iS0V92GwsI5NcBCYnLP8qQ+pzwbpl1Eqwcu4276Cws7KpHfCevUEcKhZ+3HtJCvE7b
         hw/f6KFjAlJ5A==
Received: by cwcc.thunk.org (Postfix, from userid 15806)
        id C5B9115C04DF; Wed, 26 Jul 2023 16:59:30 -0400 (EDT)
Date:   Wed, 26 Jul 2023 16:59:30 -0400
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     Zorro Lang <zlang@redhat.com>
Cc:     "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org
Subject: Re: [PATCH 1/2] check: add a -smoketest option
Message-ID: <20230726205930.GC30264@mit.edu>
References: <168972905065.1698606.6829635791058054610.stgit@frogsfrogsfrogs>
 <168972905626.1698606.12419796694170752316.stgit@frogsfrogsfrogs>
 <20230719151024.ef7vgjmtoxwxkmjm@zlang-mailbox>
 <20230719152907.GA11377@frogsfrogsfrogs>
 <20230719161115.byva7tvwoafkesga@zlang-mailbox>
 <20230720022756.GH11352@frogsfrogsfrogs>
 <20230720143433.n5gkhukdkz7s5ab7@zlang-mailbox>
 <20230726000524.GG11340@frogsfrogsfrogs>
 <20230726060102.GB30264@mit.edu>
 <20230726145441.lbzzokwigrztimyq@zlang-mailbox>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230726145441.lbzzokwigrztimyq@zlang-mailbox>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jul 26, 2023 at 10:54:41PM +0800, Zorro Lang wrote:
> 
> Ahaha, I'm just waiting for Darrick wake up, then ask him is there any
> requirement/context about this patch. Due to he (looks like) a bit
> hurry to push this patch :)
> 
> If most of you prefer this way (an ./check option, not a separated wrapper
> script), I'm OK with that.

I'm agnostic on that front, since I already *have* my own wrapper
script.  So if we need to do it in the wrapper script, I'm certainly
OK with that.  OTOH, if we think it's a feature which is generally
interesting to multiple developers and/or test wrappers, maybe it
makes sense to push things into the ./check sccript.

So I certainly don't have any objections to adding support to my
/root/runtests.sh so that "{gce,kvm,android}-xfstests smoke" gets ends
up running the moral equivalent of:

SOAK_DURATION=4m ./check -g smoketest

... and adding extra special case support in the check script just for
this use case.  I'm doing enough other stuff in runtests.sh[1] that
it's really not a big deal for me.  :-)

[1] https://github.com/tytso/xfstests-bld/blob/master/test-appliance/files/root/runtests.sh


More generally, there are some "intresting" hacks --- for example, I
want to be able to run code in between every single test run, and the
way I do it is a big ugly, but effective.  I basically set

LOGGER_PROG to my own special script, gce-logger[2]

[2] https://github.com/tytso/xfstests-bld/blob/master/test-appliance/files/usr/local/lib/gce-logger

and this allows the user to upload a script which will get run in
between every single individual fstest (e.g., to grab information from
BPF, or grab and reset lockstats, etc.).  This script also updates the
VM metadata so someone can query the VM to find out what test it's
currently running, and the percentage completion for that VM.

I could have asked for extra features in check, but whenever possible
I try to work around it to limit the number of special things just for
my set of wrapper scripts.


> Just recently I'm a bit worry about the ./check code, it's becoming more
> and more complex. I hope to separate something from it, but many things
> entwined, and growing. Anyway that's another story, I'll look into this
> patchset and review it soon.

Well, I don't use the config sections feature at all, because my
wrapper script has a lot more functionality than what you can get with
the config sections, so I just pass in TEST_DEV, SCRATCH_DEV,
MKFS_OPTIONS, etc., via environment variables, and I have my own set
of scripts to set up te test parameters.

So if you were going to simplify things by removing config sections,
*I* wouldn't care.  Enough other people might be using it that
changing the fstests interface for this might raise a lot of
objections from other folks, though.

Cheers,

					- Ted
