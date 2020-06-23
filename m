Return-Path: <SRS0=nlsN=AE=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24334C433DF
	for <linux-xfs@archiver.kernel.org>; Tue, 23 Jun 2020 09:40:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F338D206C3
	for <linux-xfs@archiver.kernel.org>; Tue, 23 Jun 2020 09:40:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731921AbgFWJk5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 23 Jun 2020 05:40:57 -0400
Received: from mail110.syd.optusnet.com.au ([211.29.132.97]:37869 "EHLO
        mail110.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731786AbgFWJk5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 23 Jun 2020 05:40:57 -0400
Received: from dread.disaster.area (pa49-180-124-177.pa.nsw.optusnet.com.au [49.180.124.177])
        by mail110.syd.optusnet.com.au (Postfix) with ESMTPS id E21AD105F7D;
        Tue, 23 Jun 2020 19:40:54 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jnfQA-0004fb-Hx; Tue, 23 Jun 2020 19:40:50 +1000
Date:   Tue, 23 Jun 2020 19:40:50 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>, Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] xfs: use MMAPLOCK around filemap_map_pages()
Message-ID: <20200623094050.GA2005@dread.disaster.area>
References: <20200623052059.1893966-1-david@fromorbit.com>
 <CAOQ4uxgbdgqsomb=2c7HFwV7=GD_K6mRHw9GqHLTzBKW1iNa-Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxgbdgqsomb=2c7HFwV7=GD_K6mRHw9GqHLTzBKW1iNa-Q@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=QIgWuTDL c=1 sm=1 tr=0
        a=k3aV/LVJup6ZGWgigO6cSA==:117 a=k3aV/LVJup6ZGWgigO6cSA==:17
        a=kj9zAlcOel0A:10 a=nTHF0DUjJn0A:10 a=7-415B0cAAAA:8 a=20KFwNOVAAAA:8
        a=pGLkceISAAAA:8 a=d0sbk3IE3p_2yvamyWoA:9 a=CjuIK1q_8ugA:10
        a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jun 23, 2020 at 11:54:39AM +0300, Amir Goldstein wrote:
> On Tue, Jun 23, 2020 at 8:21 AM Dave Chinner <david@fromorbit.com> wrote:
> >
> > From: Dave Chinner <dchinner@redhat.com>
> >
> > The page faultround path ->map_pages is implemented in XFS via
> > filemap_map_pages(). This function checks that pages found in page
> > cache lookups have not raced with truncate based invalidation by
> > checking page->mapping is correct and page->index is within EOF.
> >
> > However, we've known for a long time that this is not sufficient to
> > protect against races with invalidations done by operations that do
> > not change EOF. e.g. hole punching and other fallocate() based
> > direct extent manipulations. The way we protect against these
> > races is we wrap the page fault operations in a XFS_MMAPLOCK_SHARED
> > lock so they serialise against fallocate and truncate before calling
> > into the filemap function that processes the fault.
> >
> > Do the same for XFS's ->map_pages implementation to close this
> > potential data corruption issue.
> >
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> 
> Reviewed-by: Amir Goldstein <amir73il@gmail.com>
> 
> I wonder... should xfs_file_fadvise(POSIX_FADV_WILLNEED) also be taking
> XFS_MMAPLOCK_SHARED instead of XFS_IOLOCK_SHARED?

No.

The MMAPLOCK is only to be used in the page fault path because
we can't use the IOLOCK in that path or we will deadlock. i.e.
MMAPLOCK is exclusively for IO path locking in page fault contexts,
IOLOCK is exclusively for IO path locking in syscall and kernel task
contexts.

> Not that it matters that much?

Using the right lock for the IO context actually matters a lot :)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
