Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ECB28C433ED
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Apr 2021 19:24:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C01226144E
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Apr 2021 19:24:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229965AbhD2TYq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 29 Apr 2021 15:24:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:33850 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231631AbhD2TUI (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 29 Apr 2021 15:20:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 523A26143A;
        Thu, 29 Apr 2021 19:19:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619723945;
        bh=zaHmnMI1qm7aj0odMUw1v/NysGsQ/7dYEMqbptg8O84=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GdDDOlb+e7KfUYg1DV7rjB5mWL8mlH23+G9PXxSwN7bjqvcCIwEtsBOyYTk+OTCOS
         6Hf3UykjYfoWKnsGTatt2dqLzcecWcnTKVhc0JnV6f9pcLNSHtAzVMkERjecprYZJB
         wMeoGhSg1TSZ/CqxcDSKkp6q/O6XWe8cei/E8dLv0xElpnkiHbjmB8W8QgQEVkzM+d
         q1w6L46o9kgkMdKCJctMdY3hYm3+nMhXWGFLPd7tuSaTXPhr3PpTIEMepQzbxpgg7M
         cd7/QJD6TMIJXvn6whkF3VkWTJ2nfY2x0RsqRl7hkTY5niwJvNnSkRmQSY4j0T+A73
         FgYgRpuQ0Rg2A==
Date:   Thu, 29 Apr 2021 12:19:04 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        Dave Chinner <david@fromorbit.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Eric Sandeen <sandeen@sandeen.net>,
        Christoph Hellwig <hch@lst.de>
Subject: Re: [GIT PULL] xfs: new code for 5.13
Message-ID: <20210429191904.GN3122264@magnolia>
References: <20210429170619.GM3122264@magnolia>
 <CAHk-=wgpn570yfA+EM5yZ0T-m0c5jnLcx3WGSu3xR8E4DGvCFg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wgpn570yfA+EM5yZ0T-m0c5jnLcx3WGSu3xR8E4DGvCFg@mail.gmail.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Apr 29, 2021 at 10:50:51AM -0700, Linus Torvalds wrote:
> On Thu, Apr 29, 2021 at 10:06 AM Darrick J. Wong <djwong@kernel.org> wrote:
> >
> > Unfortunately, some of our refactoring work collided with Miklos'
> > patchset that refactors FS_IOC_[GS]ETFLAGS and FS_IOC_FS[GS]ETXATTR.
> 
> Ok, the resolution looked reasonably straightforward to me, and I
> ended up with what looks like the same end result you did.
> 
> But I only did a visual inspection of our --cc diffs (you seem to use
> --patience, which made my initial diff look different) and obviously
> verified that it all builds cleanly, I didn't do any actual testing.
> 
> So please double-check that everything still looks good,

At a first glance it looks good to me, thanks. :)

(Currently running fstests to double-check...)

--D

> 
>                  Linus
