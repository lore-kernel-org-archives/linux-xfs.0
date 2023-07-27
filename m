Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2EBC6C04A6A
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Jul 2023 14:33:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233600AbjG0Odq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 27 Jul 2023 10:33:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231774AbjG0Odp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Jul 2023 10:33:45 -0400
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BE3F2D42
        for <linux-xfs@vger.kernel.org>; Thu, 27 Jul 2023 07:33:44 -0700 (PDT)
Received: from cwcc.thunk.org (pool-173-48-115-64.bstnma.fios.verizon.net [173.48.115.64])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 36REXQ2N011799
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 27 Jul 2023 10:33:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
        t=1690468408; bh=tiH0gJjtJAW5yKPdP3EWVd/KsTzn/JB/KqeRfaNhPeQ=;
        h=Date:From:Subject:Message-ID:MIME-Version:Content-Type;
        b=DcB/RZN/jEvO7ETV/e6QLwvY7pWWRUL6ltTTaC0zsbPn1GnoA/IH7xF5OG3atJxAg
         wQJHwGpOnxGaDtYRSwxqDTmHf/y6etIZlxzQ+smuTjHZoDO6isDkgRwb3UPsTptCtS
         VMZVEO6iM74Kx6X7FWMLYuVwKzgAfQDfsIpPsjb3zgO/ZHjAkGQU7ymDH1JNIFj4G7
         GtHvio2m4TNznIId45mKqAjigF24yh/+/kcj3JeHozVHTRh+JivwlMolDaRIMZl1Z5
         GBeaHcK02U2cV9Ym9ck6r1/CNzxp3Ukk4SOkqJlRxb0nmt5GEhJPBqmiwdJoDKHmk0
         KShXgelEC1drA==
Received: by cwcc.thunk.org (Postfix, from userid 15806)
        id CDFCA15C04EF; Thu, 27 Jul 2023 10:33:26 -0400 (EDT)
Date:   Thu, 27 Jul 2023 10:33:26 -0400
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     Zorro Lang <zlang@redhat.com>
Cc:     "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org
Subject: Re: [PATCH 1/2] check: add a -smoketest option
Message-ID: <20230727143326.GG30264@mit.edu>
References: <20230719151024.ef7vgjmtoxwxkmjm@zlang-mailbox>
 <20230719152907.GA11377@frogsfrogsfrogs>
 <20230719161115.byva7tvwoafkesga@zlang-mailbox>
 <20230720022756.GH11352@frogsfrogsfrogs>
 <20230720143433.n5gkhukdkz7s5ab7@zlang-mailbox>
 <20230726000524.GG11340@frogsfrogsfrogs>
 <20230726060102.GB30264@mit.edu>
 <20230726145441.lbzzokwigrztimyq@zlang-mailbox>
 <20230726205930.GC30264@mit.edu>
 <20230727032537.hyqyuvemnwmh25d5@zlang-mailbox>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230727032537.hyqyuvemnwmh25d5@zlang-mailbox>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jul 27, 2023 at 11:25:37AM +0800, Zorro Lang wrote:
> > SOAK_DURATION=4m ./check -g smoketest
> 
> Now we provide two ways to help to customize testing in fstests:
> 
> 1)
> https://lore.kernel.org/fstests/20230727030529.r4ivp6dmtrht5zo2@zlang-mailbox/T/#mc5cdb59344f4cd681515bf0fab501d7f30f1e263
> 
> 2)
> https://lore.kernel.org/fstests/169033660570.3222210.3010411210438664310.stgit@frogsfrogsfrogs/T/#u
> 
> Which one do you like to use? I'd like to hear more review points before I
> choose one to merge.

(1) is the "./check -t smoketest" option, and it provides a more
generic way of adding new templates.  On the positive side it allows
more of this kind of simple "configuration" style options where "-t
smoketest" is essentially syntactic sugar for:

	SOAK_DURATION=${SOAK_DURATION:-4m} ./check -g smoketest"

The potential disadvantage of (1) is that it seems like extra
complexity for what is really simple.


(2) is "./check -smoketest" option.  Its advantage is that it might
easier for a drive-by patcher to type.  The disadvantage is that it's
adding Yet Another Option to the ./check script.

I also will note that we have some "long options" which use a single
hypen (e.g., -overlay and -udiff) but newer "long options" seem to use
the double hypehn approach (e.g., --exact-order and --large-fs).  My
personal preference is for the newer GNU getopt style of using double
hyphens, but the fact that we have both types of long options
is... unfortunate.


I guess I have a slight preference for (1), but I'm really not sure
either is really necessary.  My view is that for a drive-by tester,
trying to set up xfstests is Too Hard.  So the reality is they will be
using some kind of wrapper script --- either one that they've written
for their own, such as what Darrick (and I assume other XFS developers
have their own), or they're using something like kdevops or
kvm-xfstests.

From *my* perspective, I have absolutely *no* problem with having my
wrapper script use:

	SOACK_DURATION=4m ./check -g smoketest

because I only have to do it once, and no end-user is ever going to
see it.  They will just use "kvm-xfstests smoke", and all of the magic
will be hidden from them.

The main advantage of having some kind of "official" top-level way of
specifying the smoke test is that it makes it more likely that
different wrapper scripts will converge on the same kind of smoke
test, and it becomes easier for fstests developers to communicate with
each other because the concept of what a "smoke test" is has been well
defined in the fstests source code.  And for that purpose, I think the
"./check -t smoketest" approach works just fine.

But really, I can live with either.   :-)

Cheers,

						- Ted
