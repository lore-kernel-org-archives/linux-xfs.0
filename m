Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C01BC433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 26 May 2022 15:02:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242608AbiEZPCJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 26 May 2022 11:02:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230463AbiEZPCG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 26 May 2022 11:02:06 -0400
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 756C349FBA
        for <linux-xfs@vger.kernel.org>; Thu, 26 May 2022 08:02:05 -0700 (PDT)
Received: from cwcc.thunk.org (pool-108-7-220-252.bstnma.fios.verizon.net [108.7.220.252])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 24QF1heA007734
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 26 May 2022 11:01:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
        t=1653577305; bh=4H4+txxdXLc96GhmirugZrV6mPRxx6IFUBY0uW5iPGo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To;
        b=kYcqdj+sHPR/RkkT/9QrTXReS4bkC5Nw9L6BDVERFJPAnMFUminAbheHnvSICoxqS
         a1M8/ak3M/ul4Q4xNOGGF22JILq8SV/RJsF+zRW/WPVf8SsaTNJZN2icV9DnlXKjTy
         m2h75DdrmQvlDHPjmoFj8lsyYdeIEpjPc898h5SDvyHuDsn/nHm9bpYL/Ro380APkP
         se9pNMI97AXIMBS79wLGfAjB1RnApxHpi9sP/azyOxNhoJ3MOI+/ultM1nFEft6t1+
         U9gA9ZjolfZdfOzd0bCpvxcaE7yTYsSRvUzFUZTv98Gk9MBFKnJ4tw6XO50RzGXPRC
         M9LS5pugDzu7Q==
Received: by cwcc.thunk.org (Postfix, from userid 15806)
        id 24AA915C3399; Thu, 26 May 2022 11:01:43 -0400 (EDT)
Date:   Thu, 26 May 2022 11:01:43 -0400
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     xfs <linux-xfs@vger.kernel.org>,
        Leah Rumancik <lrumancik@google.com>,
        Shirley Ma <shirley.ma@oracle.com>,
        Amir Goldstein <amir73il@gmail.com>,
        Eric Sandeen <sandeen@redhat.com>,
        Dave Chinner <david@fromorbit.com>,
        Chandan Babu R <chandan.babu@oracle.com>,
        Konrad Wilk <konrad.wilk@oracle.com>
Subject: Re: XFS LTS backport cabal
Message-ID: <Yo+WV/AfFbJ2Cc68@mit.edu>
References: <Yo6ePjvpC7nhgek+@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yo6ePjvpC7nhgek+@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, May 25, 2022 at 02:23:10PM -0700, Darrick J. Wong wrote:
> 
> 2. Some other tag for patches that could be a fix, but need a few months
> to soak.  This is targetted at (b), since I'm terrible at remembering
> that there are patches that are reaching ripeness.

What I'd suggest here is a simple "Stable-Soak: <date>|<release>" tag.
It wouldn't need to be official, and so we don't need to get the
blessing of the Stable Tree maintainers; it would just be something
that would be honored by the "XFS LTS backport cabal".

> a> I've been following the recent fstests threads, and it seems to me
> that there are really two classes of users -- sustaining people who want
> fstests to run reliably so they can tell if their backports have broken
> anything; and developers, who want the randomness to try to poke into
> dusty corners of the filesystem.  Can we make it easier to associate
> random bits of data (reliability rates, etc.) with a given fstests
> configuration?  And create a test group^Wtag for the tests that rely on
> RNGs to shake things up?

In my experience, tests that have flaky results fall into two
categories; ones that are trying to deal traditional fuzzing, and
those that are running stress tests either by themselves, or as
antagonists against some other operation --- e.g., running fstress
while trying to do an online resize, or why trying to shut down the
file system, etc.

Some of these stress tests do use a PRNG, but even if we fixed the
seed to some value (such as 0), many of the test results would stlil
be potentially flaky.  These test results also tend to be very timing
dependant; so these are the tests that whose failure rate varies
depending on whether the test devices are on a loop device, eMMC flash
device, HDD, SSD, or various cloud virtual block devices, such as
AWS's EBS or or GCE's PD devices.

These tests are often very useful, since if we are missing a lock when
accessing some data structure, these tests which use stress test
programs are the most likely way noticing such problems.  So I don't
think we would want to exclude them; and if we're only excluding those
tests which are doing fuzz testing, I'm not sure it's really move the
needle.

> b> Testing relies very heavily on being able to spin up a lot of testing
> resources.  Can/should we make it easier for people with a kernel.org
> account to get free(ish) cloud accounts with the LF members who are also
> cloud vendors?

If anyone wants to use gce-xfstests, I'm happy to work on sponsoring
some GCE credits for that purpose.  One of the nice things about
gce-xfstests is that Test VM's only are left running when actually
running a test.  Once a test is finished, the VM shuts itself down.
And if we want to run a number of file system configs, we can spawn a
dozen VM's, one for each fsconfig, and when they are done, each VM
shuts itself down except for a small test test manager which collates
the results into a single report.  This makes gce-xfstests much more
cost efficient that those schemes which keeps a VM up and running at
all times, whether it is running tests or not.

Cheers,

						- Ted
