Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7CA80C48BE6
	for <linux-xfs@archiver.kernel.org>; Wed, 16 Jun 2021 20:47:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5B9FF613CB
	for <linux-xfs@archiver.kernel.org>; Wed, 16 Jun 2021 20:47:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233672AbhFPUtl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 16 Jun 2021 16:49:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:37160 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233639AbhFPUtk (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 16 Jun 2021 16:49:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2699A6128B;
        Wed, 16 Jun 2021 20:47:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623876454;
        bh=JL8WiOkGUHrrOcBBRZA0hXxel0E2WWgRiX3VBJYbhHg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=eoicM13ySuU5peyJpYwzNjL4DGXx/tCSwxG3o7d9n51tYdUAKea7NTZWiz1sVqrdR
         qgZTJVJhrMudgm92fQYOBA/msxZVmTKJfGp7JDlaeRfGnW/MSjkXwK6hGOw54slrdW
         Jl34xU4YXPwlZmKOEUTbbtrBuWkYZ2SFyZiUIWVuIlENkJugJQxVL/VtdCH46T6U+/
         2tHXcZvNrztxUU7laekfNBO+XEf5RKLhlZXuYc3dBr4+WuWbplKRUlJ387Ga/lqIsL
         D9VnSbfbc6L0pULdpjzFco/dXiC+VrhIbFSMsyzkwLY9edDXtgK+/Ph0d2pqfcIOus
         Q7pVGP4admE4w==
Date:   Wed, 16 Jun 2021 13:47:32 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     guaneryu@gmail.com, Chandan Babu R <chandanrlinux@gmail.com>,
        Allison Henderson <allison.henderson@oracle.com>,
        linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me,
        amir73il@gmail.com
Subject: Re: [PATCH 03/13] fstests: refactor test boilerplate code
Message-ID: <YMpjZGaR9IKfzGax@sol.localdomain>
References: <162370433910.3800603.9623820748404628250.stgit@locust>
 <162370435585.3800603.509157515145342966.stgit@locust>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <162370435585.3800603.509157515145342966.stgit@locust>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jun 14, 2021 at 01:59:15PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Create two new helper functions to deal with boilerplate test code:
> 
> A helper function to set the seq and seqnum variables.  We will expand
> on this in the next patch so that fstests can autogenerate group files
> from now on.
> 
> A helper function to register cleanup code that will run if the test
> exits or trips over a standard range of signals.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
> Reviewed-by: Allison Henderson <allison.henderson@oracle.com>

Looks good:

Reviewed-by: Eric Biggers <ebiggers@google.com>

A couple nits below:

> +# Standard cleanup function.  Individual tests should override this.
> +_cleanup()
> +{
> +	cd /
> +	rm -r -f $tmp.*
> +}

It should say "can override this", not "should override this".

> +# Initialize the global seq, seqres, here, tmp, and status variables to their
> +# defaults.  Group memberships are the only arguments to this helper.
> +_begin_fstest()
> +{

This function does more than what the comment says.  It should say something
more along the lines of "Prepare for executing a fstest by initializing some
global variables, registering a default cleanup function, importing helper
functions, and removing $seqres.full.  This must be passed the list of groups to
which the test belongs."

- Eric
