Return-Path: <SRS0=Q7ae=6N=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F808C83003
	for <linux-xfs@archiver.kernel.org>; Wed, 29 Apr 2020 07:09:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1955F2073E
	for <linux-xfs@archiver.kernel.org>; Wed, 29 Apr 2020 07:09:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="JQ6IGx3h"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726477AbgD2HJV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 29 Apr 2020 03:09:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726401AbgD2HJV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 29 Apr 2020 03:09:21 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EF1BC03C1AD
        for <linux-xfs@vger.kernel.org>; Wed, 29 Apr 2020 00:09:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=Tl5VP8JCRdkG4+8Fg0Esram+FsquAPu+xJwoHF8lKaY=; b=JQ6IGx3hOYqJx53nVb9VgbhnaA
        LYxUkT0LzExykYW42TvGTBBL7xQm/L9y8i3RbVDMmliG/GT1SSlUfHHyStBVKUiujVF+nxbnMdMMM
        is8cWbPfzaW8WvY+Z3WbMUolDWwgA0W0KN2yFk3sE3QYDjMqKSTWX3phRZtWADelIUcns74Xa1uJH
        03EmjBn7Pj/hrxBUry2hi/k3CHOYeceqsFwdyOopNb1fFV1sG3cFyF81+8keB/Wm4tL2DfCw4EbCs
        e80BdRBT9wneAzmbPsb6W9+XPr2RhJmyvK1q6/VrkJ4QhD5wzb4czns1fj1UiluvicI6HVxtcdsHx
        OxYvuccg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jTgqK-00047s-Oy; Wed, 29 Apr 2020 07:09:16 +0000
Date:   Wed, 29 Apr 2020 00:09:16 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 11/19] xfs: refactor EFI log item recovery dispatch
Message-ID: <20200429070916.GA2625@infradead.org>
References: <158752116283.2140829.12265815455525398097.stgit@magnolia>
 <158752123303.2140829.7801078756588477964.stgit@magnolia>
 <20200425182801.GE16698@infradead.org>
 <20200428224132.GP6742@magnolia>
 <20200428234557.GR6742@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200428234557.GR6742@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Apr 28, 2020 at 04:45:57PM -0700, Darrick J. Wong wrote:
> On Tue, Apr 28, 2020 at 03:41:32PM -0700, Darrick J. Wong wrote:
> > On Sat, Apr 25, 2020 at 11:28:01AM -0700, Christoph Hellwig wrote:
> > > On Tue, Apr 21, 2020 at 07:07:13PM -0700, Darrick J. Wong wrote:
> > > > From: Darrick J. Wong <darrick.wong@oracle.com>
> > > > 
> > > > Move the extent free intent and intent-done log recovery code into the
> > > > per-item source code files and use dispatch functions to call them.  We
> > > > do these one at a time because there's a lot of code to move.  No
> > > > functional changes.
> > > 
> > > What is the reason for splitting xlog_recover_item_type vs
> > > xlog_recover_intent_type?  To me it would seem more logical to have
> > > one operation vector, with some ops only set for intents.
> > 
> > Partly because I started by refactoring only the intent items, and then
> > decided to prepend a series to do everything; and partly to be stingy
> > with bytes. :P
> > 
> > That said, I like your suggestion of every XFS_LI_* code gets its own
> > xlog_recover_item_type so I'll go do that.
> 
> Aha, now I remember why those two are separate types -- the
> process_intent and cancel_intent functions operate on the xfs_log_item
> that gets created from the xlog_recover_item that we pulled out of the
> log, whereas the other functions are called directly on the
> xlog_recovery_item.  There's no direct link between the log item and the
> recovery log item, nor is there a good way to link through their
> dispatch functions.

Maybe those should move to xfs_item_ops as they operate on a "live"
xfs_log_item? (they'd need to grow names clearly related to recovery
of course).  In fact except for slightly different calling convention
->cancel_intent already seems to be identical to ->abort_intent in
xfs_item_ops, so that would be one off the list.

Btw, it seems like we should drop the ail_lock before calling
->process_intent as all instances do that anyway, and it would keep
the locking a little more centralized, and it will allow killing
one pointless wrapper in each instance.  Maybe we can also move
the recovered flag to the generic log item flags?
