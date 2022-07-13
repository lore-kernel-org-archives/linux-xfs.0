Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB574C433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 13 Jul 2022 17:33:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231860AbiGMRdK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 13 Jul 2022 13:33:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231560AbiGMRdK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 13 Jul 2022 13:33:10 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44AFD27175;
        Wed, 13 Jul 2022 10:33:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 520D9CE2319;
        Wed, 13 Jul 2022 17:33:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87682C34114;
        Wed, 13 Jul 2022 17:33:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657733585;
        bh=zxqVTW4mNK1en+QnLqo6l/j2KjAJ/0br+w2PoqP+9I0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=rws5rwA9VHhqmrUCzAUbpnzrEFRmOf/SK1O2JPpRuaxLtpzs2dgDOj6v5YrtAi/27
         KKmnHoOeOlhOw3+3zH+omkzG3SVuRWIxj1nGquAJeC1y4ehige80j/YZBs7nvQWvTV
         hWk6g2isO+GieEq6S7+E8AG1edPhpzSvoQyQSQTD59RSpEEzucYux31LU73i5MhzLf
         NRWDRBxfWCnYjW51R5t7vp6ytVodiaY67rqpv7UpwoPsmAJirWa7yCFc2+Uwt2deCh
         4m3ty+xab368wIf6Upr3q1wAQ70Kmum8FFND1H7sNh+H11U80wPvakfTYDKPtMEY0g
         38GQU2gPEAG2g==
Date:   Wed, 13 Jul 2022 10:33:05 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Zorro Lang <zlang@redhat.com>
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, tytso@mit.edu,
        leah.rumancik@gmail.com
Subject: Re: [PATCH 6/8] punch: skip fpunch tests when op length not
 congruent with file allocation unit
Message-ID: <Ys8B0X7iMetn/0Pf@magnolia>
References: <165767379401.869123.10167117467658302048.stgit@magnolia>
 <165767382771.869123.12118961152998727124.stgit@magnolia>
 <20220713170426.n5kwuvplsdlabr5l@zlang-mailbox>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220713170426.n5kwuvplsdlabr5l@zlang-mailbox>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jul 14, 2022 at 01:04:26AM +0800, Zorro Lang wrote:
> On Tue, Jul 12, 2022 at 05:57:07PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Skip the generic fpunch tests on a file when the file's allocation unit
> > size is not congruent with the proposed testing operations.
> > 
> > This can be the case when we're testing reflink and fallocate on the XFS
> > realtime device.  For those configurations, the file allocation unit is
> > a realtime extent, which can be any integer multiple of the block size.
> > If the request length isn't an exact multiple of the allocation unit
> > size, reflink and fallocate will fail due to alignment issues, so
> > there's no point in running these tests.
> > 
> > Assuming this edgecase configuration of an edgecase feature is
> > vanishingly rare, let's just _notrun the tests instead of rewriting a
> > ton of tests to do their integrity checking by hand.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> >  common/punch |    1 +
> >  1 file changed, 1 insertion(+)
> > 
> > 
> > diff --git a/common/punch b/common/punch
> > index 4d16b898..7560edf8 100644
> > --- a/common/punch
> > +++ b/common/punch
> > @@ -250,6 +250,7 @@ _test_generic_punch()
> >  	_8k="$((multiple * 8))k"
> >  	_12k="$((multiple * 12))k"
> >  	_20k="$((multiple * 20))k"
> > +	_require_congruent_file_oplen $TEST_DIR $((multiple * 4096))
> 
> Should the $TEST_DIR be $testfile, or $(dirname $testfile) ?

Ah, right, that ought to be $(dirname $testfile), thanks for catching
that.  I guess I didn't catch that because all the current callers pass
in $TEST_DIR/<somefile>, which is functionally the same, but a landmine
nonetheless.

--D

> >  
> >  	# initial test state must be defined, otherwise the first test can fail
> >  	# due ot stale file state left from previous tests.
> > 
> 
