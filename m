Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84CBFC433F5
	for <linux-xfs@archiver.kernel.org>; Sat, 22 Jan 2022 16:56:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234557AbiAVQ4C (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 22 Jan 2022 11:56:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230136AbiAVQ4B (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 22 Jan 2022 11:56:01 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02524C06173B;
        Sat, 22 Jan 2022 08:56:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BD627B80917;
        Sat, 22 Jan 2022 16:55:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C1A1C004E1;
        Sat, 22 Jan 2022 16:55:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642870558;
        bh=etDQxPI3s/HzeW+iAu/0gOZXdv9GZeRBZzPSolI+6LU=;
        h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
        b=UM6GVdJtcHEoAdda150uWQgUf4lKL82phaC0OO+rCmfQMBTYAN+swJH+h7VxQHMUi
         3MkNm+5xAFhycIe2BuTtVgZd5L0fGBzaSNM3zBI6jaq1OrF9Zel13rrrBgeKwVQ2UO
         DIWmBjQnTRIIMQ2CZ9eChsQxC/qHwpTMUbZenWHBS+PLO05MMVAw3IhbNBi865iaiA
         ir7ql+eLPszi5gM1EsVYm0Nb0lItfLci7qNvV9s5CggCCn1APotSrUmN51BAFJ57an
         /pLv3bvdvxkKWbkHL63OI1IKqX6t/oWeP/pwSq1ljcfsErFf9hagbcAVh4BMHONLsY
         jKdJa6c8Dky9g==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
        id 154A25C0F71; Sat, 22 Jan 2022 08:55:58 -0800 (PST)
Date:   Sat, 22 Jan 2022 08:55:58 -0800
From:   "Paul E. McKenney" <paulmck@kernel.org>
To:     Brian Foster <bfoster@redhat.com>
Cc:     "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
        Dave Chinner <david@fromorbit.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Ian Kent <raven@themaw.net>,
        rcu@vger.kernel.org
Subject: Re: [PATCH] xfs: require an rcu grace period before inode recycle
Message-ID: <20220122165558.GA827430@paulmck-ThinkPad-P17-Gen-1>
Reply-To: paulmck@kernel.org
References: <20220121142454.1994916-1-bfoster@redhat.com>
 <20220121172603.GR13540@magnolia>
 <Yer8iqBIcwfLwh5s@bfoster>
 <20220122053019.GE947480@paulmck-ThinkPad-P17-Gen-1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220122053019.GE947480@paulmck-ThinkPad-P17-Gen-1>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jan 21, 2022 at 09:30:19PM -0800, Paul E. McKenney wrote:
> On Fri, Jan 21, 2022 at 01:33:46PM -0500, Brian Foster wrote:

[ . . . ]

> > My previous experiments on a teardown grace period had me thinking
> > batching would occur, but I don't recall which RCU call I was using at
> > the time so I'd probably have to throw a tracepoint in there to dump
> > some of the grace period values and double check to be sure. (If this is
> > not the case, that might be a good reason to tweak things as discussed
> > above).
> 
> An RCU grace period typically takes some milliseconds to complete, so a
> great many inodes would end up being tagged for the same grace period.
> For example, if "rm -rf" could delete one file per microsecond, the
> first few thousand files would be tagged with one grace period,
> the next few thousand with the next grace period, and so on.
> 
> In the unlikely event that RCU was totally idle when the "rm -rf"
> started, the very first file might get its own grace period, but
> they would batch in the thousands thereafter.
> 
> On start_poll_synchronize_rcu() vs. get_state_synchronize_rcu(), if
> there is always other RCU update activity, get_state_synchronize_rcu()
> is just fine.  So if XFS does a call_rcu() or synchronize_rcu() every
> so often, all you need here is get_state_synchronize_rcu()().
> 
> Another approach is to do a start_poll_synchronize_rcu() every 1,000
> events, and use get_state_synchronize_rcu() otherwise.  And there are
> a lot of possible variations on that theme.
> 
> But why not just try always doing start_poll_synchronize_rcu() and
> only bother with get_state_synchronize_rcu() if that turns out to
> be too slow?

Plus there are a few optimizations I could apply that would speed up
get_state_synchronize_rcu(), for example, reducing lock contention.
But I would of course have to see a need before increasing complexity.

							Thanx, Paul
