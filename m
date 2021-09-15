Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F9A4C433FE
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Sep 2021 17:02:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 54FC061242
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Sep 2021 17:02:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230240AbhIOREL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 15 Sep 2021 13:04:11 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:57617 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S230038AbhIOREK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 15 Sep 2021 13:04:10 -0400
Received: from cwcc.thunk.org (pool-72-74-133-215.bstnma.fios.verizon.net [72.74.133.215])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 18FH2TuF020081
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 15 Sep 2021 13:02:29 -0400
Received: by cwcc.thunk.org (Postfix, from userid 15806)
        id 3862A15C3424; Wed, 15 Sep 2021 13:02:29 -0400 (EDT)
Date:   Wed, 15 Sep 2021 13:02:29 -0400
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     NeilBrown <neilb@suse.de>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Matthew Wilcox <willy@infradead.org>,
        Mel Gorman <mgorman@suse.com>, linux-xfs@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-nfs@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/6] EXT4: Remove ENOMEM/congestion_wait() loops.
Message-ID: <YUInJQ0wJ4Cd07dT@mit.edu>
References: <163157808321.13293.486682642188075090.stgit@noble.brown>
 <163157838437.13293.14244628630141187199.stgit@noble.brown>
 <YUE+L19JyjqWh+Md@mit.edu>
 <163168354018.3992.580533638417199797@noble.neil.brown.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <163168354018.3992.580533638417199797@noble.neil.brown.name>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Sep 15, 2021 at 03:25:40PM +1000, NeilBrown wrote:
> Adding gfp_mask to __ext4_journal_start_sb() make perfect sense.
> There doesn't seem much point adding one to __ext4_journal_start(),
> we can have ext4_journal_start_with_revoke() call
> __ext4_journal_start_sb() directly.
> But I cannot see what it doesn't already do that.
> i.e. why have the inline __ext4_journal_start() at all?
> Is it OK if I don't use that for ext4_journal_start_with_revoke()?

Sure.  I think the only reason why we have __ext4_journal_start() as
an inline function at all was for historical reasons.  That is, we
modified __ext4_journal_start() so that it took a struct super, and
instead of changing all of the macros which called
__ext4_journal_start(), we named it to be __ext4_journal_start_sb()
and added the inline definition of __ext4_journal_start() to avoid
changing all of the existing users of __ext4_journal_start().

So sure, it's fine not to use that for
ext4_journal_start_with_revoke(), and we probably should clean up the
use of __ext4_journal_start() at some point.  That's unrelated to your
work, though.

Cheers,

					- Ted
