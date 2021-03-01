Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 542A8C433E0
	for <linux-xfs@archiver.kernel.org>; Mon,  1 Mar 2021 20:39:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 199C6600CD
	for <linux-xfs@archiver.kernel.org>; Mon,  1 Mar 2021 20:39:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239583AbhCAUhV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 1 Mar 2021 15:37:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:51356 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243145AbhCAUfN (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 1 Mar 2021 15:35:13 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3B519601FF;
        Mon,  1 Mar 2021 19:18:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614626285;
        bh=Hukifh4hnUCmfpynvVbMNFVrBbahH+s0NQ5ov4AJMjo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MJV0t+RONsyLbelIcL31hnn1OK+WGUxeAZdQXkOMTym6DjODPVBAQXAklDrO6uJol
         0mCzWEZoLcUy5suF3NZXmvNc8br9t7rJQkb5+UbVFnWYnrWczj5bkS0OlrS5+7LdJl
         g0xC0yVVJqSiqbmj5nA4OSzn9xryApNaJB1u7w1saGUTVzAKSfnZ42cuW52p29ZNvd
         PpDZghOA6MjgaoPtfKRMDghNw469q9Kgyoz/UrYshwse3aIj1XdfnfuX1GrAKDmv1f
         gKcip3p8CndphyH3VgfqdLHRB0VXB3vJabHb5q/iywhXz1BndHyZzIkLlLiCqhKZnj
         /pnYqlQFmbtBA==
Date:   Mon, 1 Mar 2021 11:18:03 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Geert Hendrickx <geert@hendrickx.be>
Cc:     Eric Sandeen <sandeen@sandeen.net>, xfs <linux-xfs@vger.kernel.org>
Subject: Re: xfs_admin -O feature upgrade feedback
Message-ID: <20210301191803.GE7269@magnolia>
References: <YDy+OmsVCkTfiMPp@vera.ghen.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YDy+OmsVCkTfiMPp@vera.ghen.be>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

[adding linux-xfs to cc]

On Mon, Mar 01, 2021 at 11:13:14AM +0100, Geert Hendrickx wrote:
> Gentlemen
> 
> 
> I've been testing xfsprogs 5.11.0-rc1 for XFS feature upgrades (inobtcount
> and bigtime), and have a couple of small nits with it - besides the actual
> functionality working as expected:
> 
> 1/ xfs_admin responds to every xfs_repair failure with the very generic
> "Conversion failed, is the filesystem unmounted?"  This isn't very helpful
> (and left me scratching my head in a number of scenarios), whereas calling
> xfs_repair directly shows a relevant error message in all cases.  This
> output should somehow be relayed through xfs_admin - without just dumping
> the whole xfs_repair output which I know you wanted to avoid.  Maybe by
> distinguishing more carefully between stderr and stdout?  (Currently, it
> seems xfs_repair sends its errors to stdout and "normal output" to stderr,
> and xfs_admin discards xfs_repair's stderr.)

That's a difficult project -- some of the things repair will complain
about are a result of whatever the upgrade is (e.g. complaining about
incorrect inode btree counters when you're in the process of enabling
the counters) but then there are other things that it probably should
not be dropping on the floor.

> 2/ minor, but xfs_admin(8) manpage documents `xfs_admin -O feature=status`,
> however xfs_admin itself appends another `=1`, resulting in `xfs_repair -c
> feature=1=1`.  This works, but looks ugly, and is not consistent with the
> option to enable multiple features at once.  I think either the xfs_admin
> script or its manpage should be adjusted to be consistent?

Yeah, xfs_admin should not add '=1'. Thanks for pointing that out.

> Apart from this, the actual upgrade functionality is working as expected,
> great job!

Thx :)

> Btw, do you have an idea from which release onwards mkfs.xfs will enable
> the new features by default?  Are there fixed rules for this (like feature
> must be X releases old, or supported by the latest LTS kernel), or is this
> judged on a case-by-case basis?

~6mo after we hear that people are using the feature /and/ we haven't
heard of any serious complaints.

Or some distro makes a business case and enables it by default. <cough>

--D

> 
> Thanks!
> 
> 
> 	Geert
> 
> 
