Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E4B4C433E6
	for <linux-xfs@archiver.kernel.org>; Wed, 20 Jan 2021 20:16:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 70173235DD
	for <linux-xfs@archiver.kernel.org>; Wed, 20 Jan 2021 20:16:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391813AbhATUQO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 20 Jan 2021 15:16:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:40178 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387621AbhATUPi (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 20 Jan 2021 15:15:38 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C8A3E233FC;
        Wed, 20 Jan 2021 20:14:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611173697;
        bh=EhaEG5wCecB0SLkhEcmsEoS/zqbQ6eHluqPm8OJwQ0k=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=PP+AU1FaBlyI9SiVQ3sbAsL3r/21UZ8tonNfNYJ1iKOcSxWQPf+2SrGRmdwzxQntU
         KQ+kHF0wgzIGOPzsf4Ou7eyM2HqJ3n2pvMlXP8oEs+VNDp/5FXLfzpvO8Q360dH7oE
         gJx/E6cub0lLagmGZUiuCrN6evAtsbweJuuuiJgU9MgT5jSwoO4SxTSFKYuM2SCrkv
         nryNE4jWFLwO0DgVaj1kgz9N4dedpxu+i92D3bynmOXLYpYc/+69ugzpP/BBLrA8Cs
         wlJJRqqXRLqmCoJrhF5S/97N1EP2gX2iKDpsarMYxUtjNRIOn/TjcYr8wFefWaIPD4
         VDwjzXC6Q6x8Q==
Date:   Wed, 20 Jan 2021 12:14:57 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Nikolay Borisov <nborisov@suse.com>
Cc:     Christoph Hellwig <hch@infradead.org>,
        Pavel Reichl <preichl@redhat.com>, linux-xfs@vger.kernel.org,
        david@fromorbit.com
Subject: Re: [RFC PATCH 0/3] Remove mrlock
Message-ID: <20210120201457.GS3134581@magnolia>
References: <20210113111707.756662-1-nborisov@suse.com>
 <20210113112744.GA1474691@infradead.org>
 <3b68fb68-f11f-1c50-a350-28159c003afe@suse.com>
 <20210113120914.GA1482951@infradead.org>
 <bc16a831-8d5d-c2e7-6065-3cbb7a1f92e5@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <bc16a831-8d5d-c2e7-6065-3cbb7a1f92e5@suse.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jan 13, 2021 at 02:17:29PM +0200, Nikolay Borisov wrote:
> 
> 
> On 13.01.21 г. 14:09 ч., Christoph Hellwig wrote:
> > On Wed, Jan 13, 2021 at 01:41:09PM +0200, Nikolay Borisov wrote:
> >>
> >>
> >> On 13.01.21 ??. 13:27 ??., Christoph Hellwig wrote:
> >>> Pavel has looked into this before and got stuck on the allocator
> >>> workqueue offloads:
> >>>
> >>> [PATCH v13 0/4] xfs: Remove wrappers for some semaphores
> >>
> >> I haven't looked into his series but I fail to see how lifting
> >> rwsemaphore out of the nested structure can change the behavior ? It
> >> just removes a level of indirection. My patches are semantically
> >> identical to the original code.
> > 
> > mrlocks have the mr_writer field that annotate that the is a writer
> > locking the lock.  The XFS asserts use it to assert that the lock that
> > the current thread holds it for exclusive protection, which isn't
> > actually what the field says, and this breaks when XFS uses synchronous
> > execution of work_struct as basically an extension of the kernel stack.
> 
> I'm still failing to see what's the problem of checking the last bit of
> the rwsem ->count field. It is set when the sem is held for writing
> (identical to what mr_write does). As I mention in the cover letter this
> might be considered a bit hacky because it exposes an internal detail of
> the rwsem i.e that the bit of interest is bit 0.

I don't want to tear into the implementation details of rwsems if I can
avoid it.  Just because we all have one big happy address space doesn't
mean shortcuts won't hose everyone.

> But I believe the same
> can be achieved using lockdep_is_held_type(xx, 0/1) and making XFS's
> debug routines depend on lockdep being on.

Pavel Reichl tried that two months ago in:
https://lore.kernel.org/linux-xfs/20201102194135.174806-2-preichl@redhat.com/

which resulted in fstests regressions:
https://lore.kernel.org/linux-xfs/20201104005345.GC7115@magnolia/

TLDR: the ILOCK semaphore is data-centric, but lockdep's debugging
chains are task-centric, which causes incorrect lock validation reports.

The solutions as I see them are: (a) figure out if we really still need
to defer bmbt splits to workers to avoid overflowing the kernel stack;
or (b) making it possible to transfer rwsem ownership to shut up
lockdep; or (c) fix the is_held predicate to ignore ownership.

--D

> 
> > 
