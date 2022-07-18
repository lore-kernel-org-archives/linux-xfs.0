Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B033C43334
	for <linux-xfs@archiver.kernel.org>; Mon, 18 Jul 2022 17:31:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235824AbiGRRbN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 18 Jul 2022 13:31:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231274AbiGRRbM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 18 Jul 2022 13:31:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D56AC2D1E1;
        Mon, 18 Jul 2022 10:31:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6E6CC615A4;
        Mon, 18 Jul 2022 17:31:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABAC6C341CA;
        Mon, 18 Jul 2022 17:31:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658165470;
        bh=pMxF06xJrBLBqg91Z0b4c0q2bzVfWr7RTwF5QaqFjU8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=NOqeiWwL1iQvhN8ow4iVE0tGaAdBYA3eSGbZqdJpIxO+3hDmgEW6AiWICDLK7Uy+E
         5fLdgQ0lU0g33+OvXwczPF8zzfMbH1E7l1qjck+gHLh0tjzFImTuWylOphXjjukrVt
         wMGLzejOor2vGjyEXMVg6+qfDqdyGfgo09F/jWrpxKaQZtN2aoTz7ydAX2Y+s/oEQK
         ScckfJ9rWsI3iIsJOMSohy0beihlBlZoNDQ5xcHIPWGQULnT6joEMqAh0DriTSeHK2
         dktTzERz7/0Pea2CAnNK0dPq584qFzDU7tXGOIiZn6c2aytQxhQY3iu8nf3heogQTI
         fpYtrsD9OSeVQ==
Date:   Mon, 18 Jul 2022 10:31:10 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Zorro Lang <zlang@redhat.com>
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, tytso@mit.edu,
        leah.rumancik@gmail.com
Subject: Re: [PATCH 6/8] punch: skip fpunch tests when op length not
 congruent with file allocation unit
Message-ID: <YtWY3r4WrWw5btdm@magnolia>
References: <165767379401.869123.10167117467658302048.stgit@magnolia>
 <165767382771.869123.12118961152998727124.stgit@magnolia>
 <20220713170426.n5kwuvplsdlabr5l@zlang-mailbox>
 <Ys8B0X7iMetn/0Pf@magnolia>
 <20220713175159.j2xyf5lnxac77jb6@zlang-mailbox>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220713175159.j2xyf5lnxac77jb6@zlang-mailbox>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jul 14, 2022 at 01:51:59AM +0800, Zorro Lang wrote:
> On Wed, Jul 13, 2022 at 10:33:05AM -0700, Darrick J. Wong wrote:
> > On Thu, Jul 14, 2022 at 01:04:26AM +0800, Zorro Lang wrote:
> > > On Tue, Jul 12, 2022 at 05:57:07PM -0700, Darrick J. Wong wrote:
> > > > From: Darrick J. Wong <djwong@kernel.org>
> > > > 
> > > > Skip the generic fpunch tests on a file when the file's allocation unit
> > > > size is not congruent with the proposed testing operations.
> > > > 
> > > > This can be the case when we're testing reflink and fallocate on the XFS
> > > > realtime device.  For those configurations, the file allocation unit is
> > > > a realtime extent, which can be any integer multiple of the block size.
> > > > If the request length isn't an exact multiple of the allocation unit
> > > > size, reflink and fallocate will fail due to alignment issues, so
> > > > there's no point in running these tests.
> > > > 
> > > > Assuming this edgecase configuration of an edgecase feature is
> > > > vanishingly rare, let's just _notrun the tests instead of rewriting a
> > > > ton of tests to do their integrity checking by hand.
> > > > 
> > > > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > > > ---
> > > >  common/punch |    1 +
> > > >  1 file changed, 1 insertion(+)
> > > > 
> > > > 
> > > > diff --git a/common/punch b/common/punch
> > > > index 4d16b898..7560edf8 100644
> > > > --- a/common/punch
> > > > +++ b/common/punch
> > > > @@ -250,6 +250,7 @@ _test_generic_punch()
> > > >  	_8k="$((multiple * 8))k"
> > > >  	_12k="$((multiple * 12))k"
> > > >  	_20k="$((multiple * 20))k"
> > > > +	_require_congruent_file_oplen $TEST_DIR $((multiple * 4096))
> > > 
> > > Should the $TEST_DIR be $testfile, or $(dirname $testfile) ?
> > 
> > Ah, right, that ought to be $(dirname $testfile), thanks for catching
> > that.  I guess I didn't catch that because all the current callers pass
> > in $TEST_DIR/<somefile>, which is functionally the same, but a landmine
> > nonetheless.
> 
> Yeah, I checked all cases which call _test_generic_punch(), they all use
> $TEST_DIR. In this patchset (e.g. patch 2/8) you sometimes use $testdir
> for _require_congruent_file_oplen, sometimes use $TEST_DIR or $SCRATCH_MNT
> directly (even there's $testdir too), although they're not wrong :)

<nod> I'll clean that up for the V2 submission tomorrow.

> This patchset really touch many cases, they looks good mostly, but to avoid
> bringing in regressions, I have to give them more tests before merging. And
> welcome more reviewing from others :)

Agreed.

--D

> Thanks,
> Zorro
> 
> > 
> > --D
> > 
> > > >  
> > > >  	# initial test state must be defined, otherwise the first test can fail
> > > >  	# due ot stale file state left from previous tests.
> > > > 
> > > 
> > 
> 
