Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DCA12C433F5
	for <linux-xfs@archiver.kernel.org>; Wed, 22 Sep 2021 03:02:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B7F016058D
	for <linux-xfs@archiver.kernel.org>; Wed, 22 Sep 2021 03:02:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229972AbhIVDE2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 21 Sep 2021 23:04:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:32790 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230138AbhIVDE1 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 21 Sep 2021 23:04:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E45566058D;
        Wed, 22 Sep 2021 03:02:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632279773;
        bh=4p3J9z+TrjSmsy4ixw3b37VCh3tnpdyJEHeqK/7KKHk=;
        h=Date:From:To:Cc:Subject:From;
        b=b+HgXBFmE9Lz6z4bqzuDvFMHUOpkwPBR9VuRTsl9QqxPS1oTme57TPLdRQPOZQg7a
         s5xz8XpmNcwA+bUJiNLWLKrld/Fjc8Kk1zwk8k+qQ8RBsRie0wkQ1Tz0sofysE2JyC
         ASqAbTNZ8Vev4wlwvqoEmN9fD8You0lvAzI8ABNS5Yux6nAESvV19E+rC7bnTAUioa
         5OgrvBSH04OFx5p0uOvshxYgsOCIdpGtF8tghD+RiudDi1ZxLCuNHWWlxMNZNvF54N
         +OsdKWkYsd5WsUcDKG423Jdv9R3XDoyHg8ltNr0STvmaLWsJJsI8HP9y/bWW4Tyltl
         9Vqx0/BcPoRYA==
Date:   Tue, 21 Sep 2021 20:02:52 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     xfs <linux-xfs@vger.kernel.org>
Cc:     Chandan Babu R <chandanrlinux@gmail.com>,
        Allison Henderson <allison.henderson@oracle.com>,
        Dave Chinner <david@fromorbit.com>,
        Eric Sandeen <sandeen@redhat.com>,
        Carlos Maiolino <cmaiolino@redhat.com>
Subject: kernel 5.16 sprint planning
Message-ID: <20210922030252.GE570642@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi everyone,

Now that the LPC fs track is over, I would like to take nominations for
which patchsets do people think they'd like to submit for 5.16, as well
as volunteers to review those submissions.

I can think of a few things that /could/ be close to ready:

 - Allison's logged xattrs (submitted for review during 5.15 and Dave
   started playing around with it)

 - Dave's logging parallelization patches (submitted during 5.14 but
   pulled back at the last minute because of unrelated log recovery
   issues uncovered)

 - Chandan's large extent counter series, which requires the btree
   cursor reworking that I sent last week

 - A patchset from me to reduce sharply the size of transaction
   reservations when rmap and reflink are enabled.

Would anyone like to add items to this list, or remove items?

For each of the items /not/ authored by me, I ask the collaborators on
each: Do you intend to submit this for consideration for 5.16?  And do
you have any reviewers in mind?

For everyone else: Do you see something you'd like to see land in 5.16?
Would you be willing to pair off with the author(s) to conduct a review?

-------

Carlos asked after the FS track today about what kinds of things need
working on.  I can think of two things needing attention in xfsprogs:

 - Helping Eric deal with the xfs_perag changes that require mockups.
   (I might just revisit this, since I already threw a ton of patches at
   the list.)

 - Protofiles: I occasionally get pings both internally and via PM from
   people wanting to create smallest-possible prepopulated XFS images
   from a directory tree.  Exploding minimum-sized images aren't a great
   idea because the log and AGs will be very small, but:

   Given that we have a bitrotting tool (xfs_estimate) to guesstimate
   the size of the image, mkfs support for ye olde 4th Ed. Unix
   protofiles, and I have a script to generate protofiles, should
   someone clean all that up into a single tool that converts a
   directory tree into an image?  Preferably one with as large an AG+log
   as possible?

   Or should we choose to withdraw all that functionality?

   I have a slight greybeard preference for keeping protofiles on the
   grounds that protofiles have been supported on various Unix mkfs for
   almost 50 years, and they're actually compatible with the JFS tools
   and <cough> other things like AIX and HPUX.  But the rest of you can
   overrule me... ;)

Does anyone have any suggestions beyond that?

--Darrick
