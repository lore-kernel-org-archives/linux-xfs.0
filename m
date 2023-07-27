Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CCFD5C001DC
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Jul 2023 19:04:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229873AbjG0TEe (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 27 Jul 2023 15:04:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231898AbjG0TEd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Jul 2023 15:04:33 -0400
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78FB32113
        for <linux-xfs@vger.kernel.org>; Thu, 27 Jul 2023 12:04:30 -0700 (PDT)
Received: from cwcc.thunk.org (pool-173-48-115-64.bstnma.fios.verizon.net [173.48.115.64])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 36RJ4AXr025022
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 27 Jul 2023 15:04:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
        t=1690484652; bh=Tci4gZnTc+NqvOWjbW0+IR9pwCRzvvZRz9t38Ngz+wY=;
        h=Date:From:Subject:Message-ID:MIME-Version:Content-Type;
        b=GMJFAJRuWx1oOuo+YNL+3wxla+5T+qle0q8vH1ExajDCXyNkCA2WZbQB7TFDx0D5g
         k7EU56VHrnCNWWRec3ZcG4CMjs2lQrcT15r9cXbjaPUxh32wHK92VGWmAl9DNuGjZv
         k1sx1JkWVLTRNjtYf5EAXeIgzBINClYVYZMTSsxXp57J/zBkuqNfaDyS9UsFGyoJRu
         QBbItmzFukN7foJOyDimOgE9Nmh9lnn3ecToDdSaeurAjcSTRUzup8OENxlW5eFHc2
         OeLIFD9awL2AyUBDFcYvj9daWh/y/P53puL49Xf6gZF9dLgOwH5x1eJI8NPLLlBiLv
         15LFf0bvPln2A==
Received: by cwcc.thunk.org (Postfix, from userid 15806)
        id 8FB4315C04EF; Thu, 27 Jul 2023 15:04:10 -0400 (EDT)
Date:   Thu, 27 Jul 2023 15:04:10 -0400
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     zlang@redhat.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, guan@eryu.me
Subject: Re: [PATCH 1/2] check: add a -smoketest option
Message-ID: <20230727190410.GI30264@mit.edu>
References: <169033659987.3222210.11071346898413396128.stgit@frogsfrogsfrogs>
 <169033660570.3222210.3010411210438664310.stgit@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <169033660570.3222210.3010411210438664310.stgit@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jul 25, 2023 at 06:56:45PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Create a "-smoketest" parameter to check that will run generic
> filesystem smoke testing for five minutes apiece.  Since there are only
> five smoke tests, this is effectively a 16min super-quick test.

The code is setting SOAK_DURATION to 4 minutes, not 5 minutes.
However, when I ran the moral equivalent:

    kvm-xfstests --soak-duration 4m --fail-loop-count 0 -c ext4/4k \
        generic/475 generic/476 generic/521 generic/522 generic/642

It overall took 17 minutes to run, with just under a minute of test
infrastructure overhead (in the check script and my wrapper scripts),
with the actual test time as follows:

ext4/4k: 5 tests, 975 seconds
  generic/475  Pass     242s
  generic/476  Pass     244s
  generic/521  Pass     241s
  generic/522  Pass     241s
  generic/642  Pass     7s
Totals: 5 tests, 0 skipped, 0 failures, 0 errors, 975s

The time which generic/642 ran was surprising so I took a closer look.
It does claim to be in group "soak", and it even tries to canonicalize
SOAK_DURATION (I'm not sure why, since the check script does this
already).  But generic/642 doesn't seem to use SOAK_DURATION.  It does
caculate a DURATION value, but it doesn't actually use SOAK_DURATION.

So that sounds like a bug in the generic/642 test?

There was also a bug xfstests's "make install" in that it doesn't
actually install src/soak_duration.awk, but I'll send that a patch
fixing that under separate cover.

Darrick -- suppose changed the SOAK_DURATION down to 2 minutes?  How
much do you think that would materially affect the code coverage
metrics, and the overall effectiveness of the smoke test?  If we get
generci/642 to honor SOAK_DURATION, using an overall 2 minute soak for
each test would translate to the smoke test taking about 13 minutes,
which would be great from a drive-by patch submitter perspective.

      	       	     	    	     	   - Ted

> With gcov enabled, running these tests yields about ~75% coverage for
> iomap and ~60% for xfs; or ~50% for ext4 and ~75% for ext4; and ~45% for
> btrfs.  Coverage was about ~65% for the pagecache.
