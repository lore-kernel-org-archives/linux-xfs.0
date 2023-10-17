Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D5B0CDB474
	for <linux-xfs@archiver.kernel.org>; Tue, 17 Oct 2023 17:49:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232804AbjJQRt7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 17 Oct 2023 13:49:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232025AbjJQRt6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 Oct 2023 13:49:58 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F11590
        for <linux-xfs@vger.kernel.org>; Tue, 17 Oct 2023 10:49:57 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5913C433C8;
        Tue, 17 Oct 2023 17:49:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697564997;
        bh=kXCtwh6RW8+kSOrsL93fnsx+p1LhiEy8OWkG3E0eyCg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=V/idodw8LSTSxNQYP+yTqpVBp1hr5GHJTalFhJ5y/Vw+zziopThSmtvbs0EX2ljg8
         0VHDG0WNxPPV+ATQnSS7jIhpk/39LffOxttPaLXuJdXAFaIbPdHQNU4UtrXK5Yc1eL
         fgbiHNo2Sg99caRTH3eJxSO9tjhHUhOl3ipP98mSdAe0L1lqM6/h1Eh6obNzR+R/aW
         Q4c2DpmAn9I/a+Pm7LuqLfRDH05KP5WBjBv+N8NhiP7Qrm697mfFJtiSG323soS46C
         PB4N39aO4ZlSZ8YrMxxRDhXPRdacinU/eM0uE4E7fH7SrTwYi+P+YFMh4CVKmSaSNX
         RN3677pM62jzg==
Date:   Tue, 17 Oct 2023 10:49:50 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Andrey Albershteyn <aalbersh@redhat.com>,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        fsverity@lists.linux.dev, djwong@kernel.org, david@fromorbit.com,
        dchinner@redhat.com, willy@infradead.org
Subject: Re: [PATCH v3 07/28] fsverity: always use bitmap to track verified
 status
Message-ID: <20231017174950.GA965@sol.localdomain>
References: <20231006184922.252188-1-aalbersh@redhat.com>
 <20231006184922.252188-8-aalbersh@redhat.com>
 <20231011031543.GB1185@sol.localdomain>
 <q75t2etmyq2zjskkquikatp4yg7k2yoyt4oab4grhlg7yu4wyi@6eax4ysvavyk>
 <20231012072746.GA2100@sol.localdomain>
 <ZS4iWdsXQT7CaxS6@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZS4iWdsXQT7CaxS6@infradead.org>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Oct 16, 2023 at 10:57:45PM -0700, Christoph Hellwig wrote:
> On Thu, Oct 12, 2023 at 12:27:46AM -0700, Eric Biggers wrote:
> > Currently there are two options: PG_checked and the separate bitmap.  I'm not
> > yet convinced that removing the support for the PG_checked method is a good
> > change.  PG_checked is a nice solution for the cases where it can be used; it
> > requires no extra memory, no locking, and has no max file size.  Also, this
> > change seems mostly orthogonal to what you're actually trying to accomplish.
> 
> Given that willy has been on a (IMHO reasonable) quest to kill off
> as many as possible page flags I'd really like to seize the opportunity
> and kill PageCheck in fsverity.  How big are the downsides of the bitmap
> vs using the page flags, and do they matter in practice?
> 

Currently PG_checked is used even with the bitmap-based approach, as a way to
ensure that hash pages that get evicted and re-instantiated from the backing
storage are re-verified.  See is_hash_block_verified() in fs/verity/verify.c.
That would need to be replaced with something else.  I'm not sure what else
would work and still be efficient.

No one has actually deployed the bitmap-based approach in production yet; it was
added in v6.3 and is only used for merkle_tree_block_size != PAGE_SIZE.  But,
the performance and memory overhead is probably not significant in practice.
I'm more worried about the file size limit of the bitmap-based approach, which
is currently ~4 TB.  *Probably* no one is using fsverity on files that large,
but introducing a limit for a case that wasn't supported before
(merkle_tree_block_size != PAGE_SIZE) isn't as bad as retroactively introducing
a limit for existing files that worked before and refusing to open them.  Huge
files would need something other than a simple bitmap, which would add
complexity and overhead.

Note that many filesystems use PG_checked for other purposes such as keeping
track of when directory blocks have been validated.  I'm not sure how feasible
it will be to free up that flag entirely.

- Eric
