Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D6BEC48BC2
	for <linux-xfs@archiver.kernel.org>; Mon, 21 Jun 2021 17:12:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6B41C6102A
	for <linux-xfs@archiver.kernel.org>; Mon, 21 Jun 2021 17:12:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230071AbhFUROX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 21 Jun 2021 13:14:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:53558 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230059AbhFUROX (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 21 Jun 2021 13:14:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B64F460FF2;
        Mon, 21 Jun 2021 17:12:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624295528;
        bh=HhfnTsMcscWDmzFalZgDJ1tnP8RQRTozYtuP1ozKBos=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=leM2haVEYCQtbwPeD5uAbf1LOr3HLt6R1y2aCmFRMU7viQjvBZgC/2JVyMMAbFawl
         EA/A5EYhHfQ7vZMFEqbw8GrIm77yteMFGtIe3pvkcO/C5HK2yqE5hlwCqnTVKSru2q
         o62bTC2bgSG9jodArQa67X1cMK+apTwMFzHvs14OrmlbE4V1euPtKzCDXfEhzeHEVk
         qxt+GgxWRKO+CcADZ1rr4t+wG02p3zSwTKxtS3LuwgyDARrbMLNUTduUG5ymCVxDOo
         yMilPA7XRxKIZQ3j37cn8URycUFqhDSRuBwP3hLcdwN2kwmashktTfEd1LLDCysOui
         SV5FJsONnj6Nw==
Date:   Mon, 21 Jun 2021 10:12:08 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Stephen Rothwell <sfr@canb.auug.org.au>
Cc:     David Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org,
        Allison Henderson <allison.henderson@oracle.com>,
        Chandan Babu R <chandanrlinux@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: Re: linux-next: Signed-off-by missing for commits in the xfs tree
Message-ID: <20210621171208.GD3619569@locust>
References: <20210621082656.59cae0d8@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210621082656.59cae0d8@canb.auug.org.au>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jun 21, 2021 at 08:26:56AM +1000, Stephen Rothwell wrote:
> Hi all,
> 
> Commits
> 
>   742140d2a486 ("xfs: xfs_log_force_lsn isn't passed a LSN")
>   e30fbb337045 ("xfs: Fix CIL throttle hang when CIL space used going backwards")
>   feb616896031 ("xfs: journal IO cache flush reductions")
>   6a5c6f5ef0a4 ("xfs: remove need_start_rec parameter from xlog_write()")
>   d7693a7f4ef9 ("xfs: CIL checkpoint flushes caches unconditionally")
>   e45cc747a6fd ("xfs: async blkdev cache flush")
>   9b845604a4d5 ("xfs: remove xfs_blkdev_issue_flush")
>   25f25648e57c ("xfs: separate CIL commit record IO")
>   a6a65fef5ef8 ("xfs: log stripe roundoff is a property of the log")
> 
> are missing a Signed-off-by from their committers.

<sigh> Ok, I'll rebase the branch again to fix the paperwork errors.

For future reference, if I want to continue accepting pull requests from
other XFS developers, what are the applicable standards for adding the
tree maintainer's (aka my) S-o-B tags?  I can't add my own S-o-Bs after
the fact without rewriting the branch history and changing the commit
ids (which would lose the signed tag), so I guess that means the person
sending the pull request has to add my S-o-B for me?  Which also doesn't
make sense?

--D

> -- 
> Cheers,
> Stephen Rothwell


