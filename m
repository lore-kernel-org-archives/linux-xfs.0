Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77FF6C00528
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Jul 2023 01:36:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229552AbjG0Bgi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 26 Jul 2023 21:36:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230405AbjG0Bgh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 Jul 2023 21:36:37 -0400
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55C2D1985
        for <linux-xfs@vger.kernel.org>; Wed, 26 Jul 2023 18:36:36 -0700 (PDT)
Received: from cwcc.thunk.org (pool-173-48-115-64.bstnma.fios.verizon.net [173.48.115.64])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 36R1aRNw008596
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 26 Jul 2023 21:36:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
        t=1690421789; bh=iTEWQUGieEs+LNXYVRdxSu8zpe9pdoHjwLq/GuVDLR4=;
        h=Date:From:Subject:Message-ID:MIME-Version:Content-Type;
        b=fW8hwkNNMLQz8CXvNjgvq7gM8e1Og2ZE/+AuDxqI5Y+1OgThsK16P5TvW4h+MmDGz
         aNsj3BAd0s2awLPT+s0LR5XKGjqoTK6dbW8R12K4EJRrO5qzXfDpOrbiwsJIZq0KsZ
         GqOa62gXa/T5r+ZYBMdJQMzshviwK+JnIfNFrxVZmIs4wOU02SKolcBFNIRW92edJq
         I+rneAZhDBc9tVBUV7b5wKwACzhTSzB52JYXNlYgeammuZK87tz1eHxHZOQwdKEYjH
         K8R45uBW5AM0tzxet9NlnxiRs1ndGveXmebEDpQyhAxGgXko6J1fqIkDe9DijIdu9E
         WSIW3xEV5t/1Q==
Received: by cwcc.thunk.org (Postfix, from userid 15806)
        id 58D4E15C04DF; Wed, 26 Jul 2023 21:36:27 -0400 (EDT)
Date:   Wed, 26 Jul 2023 21:36:27 -0400
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     Zorro Lang <zlang@redhat.com>
Cc:     "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org
Subject: Re: [PATCH 1/2] check: add a -smoketest option
Message-ID: <20230727013627.GF30264@mit.edu>
References: <168972905626.1698606.12419796694170752316.stgit@frogsfrogsfrogs>
 <20230719151024.ef7vgjmtoxwxkmjm@zlang-mailbox>
 <20230719152907.GA11377@frogsfrogsfrogs>
 <20230719161115.byva7tvwoafkesga@zlang-mailbox>
 <20230720022756.GH11352@frogsfrogsfrogs>
 <20230720143433.n5gkhukdkz7s5ab7@zlang-mailbox>
 <20230726000524.GG11340@frogsfrogsfrogs>
 <20230726060102.GB30264@mit.edu>
 <20230726145441.lbzzokwigrztimyq@zlang-mailbox>
 <20230726205930.GC30264@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230726205930.GC30264@mit.edu>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

As an aside, while I was testing my updates to the kvm-quickstart[1]
documentation, I timed how long it takes to run "-g quick" for a basic
ext4 file system config with 4k blocks using a desktop NVMe SSD for
the test and scratch devices.

[1] https://github.com/tytso/xfstests-bld/blob/test/Documentation/kvm-quickstart.md

It took 62 minutes, or a little over an hour.  Yowza!  I hadn't
realized that "kvm-xfstests smoke" was now taking that long.  It used
to be that using a slower SSD (an Intel SATA-attached SSD dating from
2008) I could run "-g quick" in 15 minutes.  Clearly, things were a
lot simpler back then.  :-)

Anyway, I definitely need to replace what "kvm-xfstests smoke" does
with something else much more abbrevuated before I start requesting
drive-by patch submitters to run an fstests "smoke test".  Because an
hour isn't it.  Ideally, I'd like to keep it under 10 minutes if at
all possible, but we still want the testing to be likely to detect
most of the sort of simple problems that a drive-by patch submitter
might be likely find....

The fundamental question is how to do get the maximal amount of value
given a limited test budget.

					- Ted
