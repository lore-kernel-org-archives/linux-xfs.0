Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CEC68C48BE5
	for <linux-xfs@archiver.kernel.org>; Fri, 11 Jun 2021 23:51:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A6AD5613CA
	for <linux-xfs@archiver.kernel.org>; Fri, 11 Jun 2021 23:51:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230197AbhFKXxW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 11 Jun 2021 19:53:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:59622 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229633AbhFKXxW (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 11 Jun 2021 19:53:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7805D6136D;
        Fri, 11 Jun 2021 23:51:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623455483;
        bh=yxHGRl5ytF16J7U/P68fA/KzGM/1q35NRMgbMfgb+SY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=n7YpvmisIeCrG4+1WBcMs07ap5qoVR7tv4TtD5rxFZHse81pDOh2EhbN0vMeaiAPJ
         Hwmql3MCdjwFaqtZch8zidxKMpHtTM1SQLFDVVzYmvyNHvmrQKW/2yDellP/xKkAaw
         Yfjpz4BpebQM+e0KjsSIZpFJErskqMjWuM8x27XUDgrQ26+aL3kE9ptwZg+4NiHLp9
         jgtcxFtJMS+nq4ZhhfjHyQuXo7tFOzR1iANleWG5GhZURiDGmBVEM2fd+aUtVVE1eJ
         6pVT96E/lcDoH+e3Wjxglx8TLqOdfIvjZ4TOasR2OnbjREPaFR1Po4CgMGwjvB1FHx
         fngyXqIHP5HLw==
Date:   Fri, 11 Jun 2021 16:51:22 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, guan@eryu.me, amir73il@gmail.com
Subject: Re: [PATCH 11/13] fstests: remove group files
Message-ID: <YMP2+rMWJGlpkTTp@gmail.com>
References: <162317276202.653489.13006238543620278716.stgit@locust>
 <162317282225.653489.1537192803992898300.stgit@locust>
 <YMPwyeb8wgqzEbeH@gmail.com>
 <20210611232945.GE2945738@locust>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210611232945.GE2945738@locust>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jun 11, 2021 at 04:29:45PM -0700, Darrick J. Wong wrote:
> On Fri, Jun 11, 2021 at 04:24:57PM -0700, Eric Biggers wrote:
> > On Tue, Jun 08, 2021 at 10:20:22AM -0700, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <djwong@kernel.org>
> > > 
> > > Now that we autogenerate group files, get rid of them in the source
> > > tree.
> > > 
> > 
> > This breaks 'make install', since tests/*/Makefile still try to install "group"
> > instead of "group.list".  Changing them to use "group.list" instead fixed it.
> 
> Are you sending a patch, or are you making me fix it?
> 

The v1.1 patch you sent looks good, thanks!

- Eric
