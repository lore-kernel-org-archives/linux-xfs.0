Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3520EC43334
	for <linux-xfs@archiver.kernel.org>; Sat, 25 Jun 2022 21:50:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230246AbiFYVuy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 25 Jun 2022 17:50:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230116AbiFYVux (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 25 Jun 2022 17:50:53 -0400
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 269C713E15;
        Sat, 25 Jun 2022 14:50:52 -0700 (PDT)
Received: from letrec.thunk.org (c-24-1-67-28.hsd1.il.comcast.net [24.1.67.28])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 25PLoRcJ023513
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 25 Jun 2022 17:50:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
        t=1656193830; bh=Otfw0i6A+bDyTiPbkZ9vPs4xbMQYL8LtwZ1kUohF33Y=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To;
        b=Lz3Y/yVTX42/+cvT+MFD+cbbkYqDpyzITc5tkb3N4rO8NJ0xAnvS5JzURuz2xGJx/
         dXHB5VAVrJX8QEPT5+KF8ggSZJN5u0vSK5oU8soPhXvICen8v/2tzTd5UaiUrwYNHW
         Gc1alXTL4LyXxZY861hPDNvKVYmY+RaIuVctNBxNy9YzTJW+qZw+hHIJrfhApDA2i4
         b6m+TOSctZVnMkkNNuoyBapmnQvp8nKcS4oxKL9wTIUF+tUaie96ylbjzpl/3UFP1n
         AxNmS/eEWBKflyVjkWAR167WpTrEoqyM5kziD7WogrdRyC17VOYvfJUA7IU0QR/Ak8
         MWcWO0qjCfGCQ==
Received: by letrec.thunk.org (Postfix, from userid 15806)
        id F39CE8C3689; Sat, 25 Jun 2022 17:50:26 -0400 (EDT)
Date:   Sat, 25 Jun 2022 17:50:26 -0400
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     Luis Chamberlain <mcgrof@kernel.org>
Cc:     Amir Goldstein <amir73il@gmail.com>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Leah Rumancik <leah.rumancik@gmail.com>,
        Josef Bacik <josef@toxicpanda.com>,
        Chuck Lever <chuck.lever@oracle.com>, chandanrmail@gmail.com,
        Sweet Tea Dorminy <sweettea-kernel@dorminy.me>,
        Pankaj Raghav <pankydev8@gmail.com>,
        Zorro Lang <zlang@redhat.com>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        fstests <fstests@vger.kernel.org>
Subject: Re: sharing fstests results (Was: [PATCH 5.15 CANDIDATE v2 0/8] xfs
 stable candidate patches for 5.15.y (part 1))
Message-ID: <YreDIk2FMMPQDpLL@mit.edu>
References: <20220616182749.1200971-1-leah.rumancik@gmail.com>
 <YrJdLhHBsolF83Rq@bombadil.infradead.org>
 <YrONPrBgopZQ2EUj@mit.edu>
 <YrTboFa4usTuCqUb@bombadil.infradead.org>
 <YrVMZ7/rJn11HH92@mit.edu>
 <YrZAtOqQERpYbBXg@bombadil.infradead.org>
 <CAOQ4uxi-KVMWb4nvNCriPdjMcZkPut7x6LA6aHJz_hVMeBxvOA@mail.gmail.com>
 <YrdjluHoj9xAz3Op@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YrdjluHoj9xAz3Op@bombadil.infradead.org>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Jun 25, 2022 at 12:35:50PM -0700, Luis Chamberlain wrote:
> 
> The way the expunge list is process could simply be modified in kdevops
> so that non-deterministic tests are not expunged but also not treated as
> fatal at the end. But think about it, the exception is if the non-deterministic
> failure does not lead to a crash, no?

That's what I'm doing today, but once we have a better test analysis
system, what I think the only thing which should be excluded is:

   a)   bugs which cause the kernel to crash
   b)   test bugs
   c)   tests which take ***forever*** for a particular configuration
   	    (and for which  we probably get enough coverage through
	    other configs)

If we have a non-deterministic failure, which is due to a kernel bug,
I don't see any reason why we should skip the test.  We just need to
have a fully-featured enough test results analyzer so that we can
distinguish between known failures, known flaky failures, and new test
regressions.

So for example, the new tests generic/681, generic/682, and
generic/692 are causing determinsitic failures for the ext4/encrypt
config.  Right now, this is being tracked manually in a flat text
file:

generic/68[12]  encrypt   Failure percentage: 100%
    The directory does grow, but blocks aren't charged to either root or
    the non-privileged users' quota.  So this appears to be a real bug.
    Testing shows this goes all the way back to at least 4.14.

It's currently not tagged by kernel version, because I mostly only
care about upstream.  So once it's fixed upstream, I stop caring about
it.  In the ideal world, we'd track the kernel commit which fixed the
test failure, and when the fix propagated to the various stable
kernels, etc.

I've also resisted putting it in an expunge file, since if it did, I
would ignore it forever.  If it stays in my face, I'm more likely to
fix it, even if it's on my personal time.

> Here's the thing though. Not all developers have incentives to share.

Part of this is the amount of *time* that it takes to share this
information.  Right now, a lot of sharing takes place on the weekly
ext4 conference call.  It doesn't take Eric Whitney a lot of time to
mention that he's seeing a particular test failure, and I can quickly
search my test summary Unix mbox file and say, "yep, I've seen this
fail a couple of times before, starting in February 2020 --- but it's
super rare."

And since Darrick attends the weekly ext4 video chats, once or twice
we've asked him about some test failures on some esoteric xfs config,
such as realtime with an external logdev, and he might say, "oh yeah,
that's a known test bug.  pull this branch from my public xfstests
tree, I just haven't had time to push those fixes upstream yet."

(And I don't blame him for that; I just recently pushed some ext4 test
bug fixes, some of which I had initially sent to the list in late
April --- but on code review, changes were requested, and I just
didn't have *time* to clean up fixes in response to the code reviews.
So the fix which was good enough to suppress the failures sat in my
tree, but didn't go upstream since it was deemed not ready for
upstream.  I'm all for decreasing tech debt in xfstests; but do
understand that sometimes this means fixes to known test bugs will
stay in developers' git trees, since we're all overloaded.)

It's a similar problem with test failures.  Simply reporting a test
failure isn't *that* hard.  But the analysis, even if it's something
like:

generic/68[12]  encrypt   Failure percentage: 100%
    The directory does grow, but blocks aren't charged to either root or
    the non-privileged users' quota.....
    
... is the critical bit that people *really* want, and it takes real
developer time to come up with that kind of information.  In the ideal
world, I'd have an army of trained minions to run down this kind of
stuff.  In the real world, sometimes this stuff happens after
midnight, local time, on a Friday night.

(Note that Android and Chrome OS, both of which are big users of
fscrypt, don't use quota.  So If I were to open a bug tracker entry on
it, the bug would get prioritized to P2 or P3, and never be heard from
again, since there's no business reason to prioritize fixing it.
Which is why some of this happens on personal time.)

      	      	    	      	    	       - Ted
