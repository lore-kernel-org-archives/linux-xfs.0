Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E3C3C433E0
	for <linux-xfs@archiver.kernel.org>; Wed, 17 Mar 2021 15:49:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2082364F21
	for <linux-xfs@archiver.kernel.org>; Wed, 17 Mar 2021 15:49:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232502AbhCQPtW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 17 Mar 2021 11:49:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:58508 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232474AbhCQPtH (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 17 Mar 2021 11:49:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A900564F21;
        Wed, 17 Mar 2021 15:49:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615996145;
        bh=MnmIwZjj7gJnF36Ycw5pPCNEfhh5DQPmEA2kv/YWSMU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Ylfo5yUUtYoPbOyWuhU3ET0FrfvocJCpur16IEayUBXzxILL32FPiSIH7Xj+hYkeF
         5pG2y2PlXYLfhnJuCo1nHc70dQh4W6n6VDS3ps7xLJhzp0c16OFh78EalP9X4tfOhA
         zB3/nGUWw3JdCLMy70qfhzsh998QtngW4m3HEU/2HF50Q5WqGlXfP5gA1GePOK4qvK
         bN+uHQv2/L+0VtuiYeQ0VWISG1dkUc+PbwwmaOmNeXJT/esz7/MNJYdQTeP20UX0Mi
         M1C08aYkyq1uM0hu5J+C3xt82h0Y6eJ5N3ACUGiaWypovgBOzIMCta2AZAST0hG6YW
         gmIN74F56sLhA==
Date:   Wed, 17 Mar 2021 08:49:04 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 06/11] xfs: deferred inode inactivation
Message-ID: <20210317154904.GE22097@magnolia>
References: <161543194009.1947934.9910987247994410125.stgit@magnolia>
 <161543197372.1947934.1230576164438094965.stgit@magnolia>
 <20210316072710.GA375263@infradead.org>
 <20210316154729.GI22100@magnolia>
 <20210317152125.GA384335@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210317152125.GA384335@infradead.org>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Mar 17, 2021 at 03:21:25PM +0000, Christoph Hellwig wrote:
> On Tue, Mar 16, 2021 at 08:47:29AM -0700, Darrick J. Wong wrote:
> > On Tue, Mar 16, 2021 at 07:27:10AM +0000, Christoph Hellwig wrote:
> > > Still digesting this.  What trips me off a bit is the huge amount of
> > > duplication vs the inode reclaim mechanism.  Did you look into sharing
> > > more code there and if yes what speaks against that?
> > 
> > TBH I didn't look /too/ hard because once upon a time[1] Dave was aiming
> > to replace the inode reclaim tagging and iteration with an lru list walk
> > so I decided not to entangle the two.
> > 
> > [1] https://lore.kernel.org/linux-xfs/20191009032124.10541-23-david@fromorbit.com/
> 
> Well, it isn't just the radix tree tagging, but mostly the
> infrastructure in iget that seems duplicates a lot of very delicate
> code.
> 
> For the actual inactivation run:  why don't we queue up the inodes
> for deactivation directly that, that use the work_struct in the
> inode to directly queue up the inode to the workqueue and let the
> workqueue manage the details?  That also means we can piggy back on
> flush_work and flush_workqueue to force one or more entries out.
> 
> Again I'm not saying I know this is better, but this is something that
> comes to my mind when reading the code.

Hmm.  You mean reuse i_ioend_work (which maybe we should just rename to
i_work) and queueing the inodes directly into the workqueue?  I suppose
that would mean we don't even need the radix tree tag + inode walk...

I hadn't thought about reusing i_ioend_work, since this patchset
predates the writeback ioend chaining.  The biggest downside that I can
think of doing it that way is that right after a rm -rf, the unbound gc
workqueue will start hundreds of kworkers to deal with the sudden burst
of queued work, but all those workers will end up fighting each other
for (a) log grant space, and after that (b) the AGI buffer locks, and
meanwhile everything else on the frontend stalls on the log.

The other side benefit I can think of w.r.t. keeping the inactivation
work as a per-AG item is that (at least among AGs) we can walk the
inodes in disk order, which probably results in less seeking (note: I
haven't studied this) and might allow us to free inode cluster buffers
sooner in the rm -rf case.

<shrug> Thoughts?

--D
