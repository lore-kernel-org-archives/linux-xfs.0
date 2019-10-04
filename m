Return-Path: <SRS0=FqvN=X5=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4194DC4360C
	for <linux-xfs@archiver.kernel.org>; Fri,  4 Oct 2019 12:25:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1F16420867
	for <linux-xfs@archiver.kernel.org>; Fri,  4 Oct 2019 12:25:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730043AbfJDMZG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 4 Oct 2019 08:25:06 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:45024 "EHLO
        ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728219AbfJDMZG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 4 Oct 2019 08:25:06 -0400
Received: from viro by ZenIV.linux.org.uk with local (Exim 4.92.2 #3 (Red Hat Linux))
        id 1iGMdo-0000NH-Gv; Fri, 04 Oct 2019 12:25:00 +0000
Date:   Fri, 4 Oct 2019 13:25:00 +0100
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     Ian Kent <raven@themaw.net>
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        Brian Foster <bfoster@redhat.com>,
        Eric Sandeen <sandeen@sandeen.net>,
        David Howells <dhowells@redhat.com>,
        Dave Chinner <dchinner@redhat.com>
Subject: Re: [PATCH v4 02/17] vfs: add missing blkdev_put() in get_tree_bdev()
Message-ID: <20191004122500.GF26530@ZenIV.linux.org.uk>
References: <157009817203.13858.7783767645177567968.stgit@fedora-28>
 <157009832879.13858.5261547183927327078.stgit@fedora-28>
 <20191003145635.GJ13108@magnolia>
 <19b70f919a15598c0a4f1a61a3845aaeeb445217.camel@themaw.net>
 <56611110f8ffd80c6a706504d389d5d59b88c2fe.camel@themaw.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <56611110f8ffd80c6a706504d389d5d59b88c2fe.camel@themaw.net>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Oct 04, 2019 at 02:59:57PM +0800, Ian Kent wrote:
> On Fri, 2019-10-04 at 14:49 +0800, Ian Kent wrote:
> > On Thu, 2019-10-03 at 07:56 -0700, Darrick J. Wong wrote:
> > > On Thu, Oct 03, 2019 at 06:25:28PM +0800, Ian Kent wrote:
> > > > There appear to be a couple of missing blkdev_put() in
> > > > get_tree_bdev().
> > > 
> > > No SOB, not reviewable......
> > 
> > It's not expected to be but is needed if anyone wants to test
> > the series.
> > 
> > I sent this to Al asking if these are in fact missing.
> > If they are I expect he will push an update to Linus pretty
> > quickly.
> 
> But he hasn't responded so perhaps I should have annotated
> it, just in case ...

Sorry, just getting out of flu ;-/  I'll apply that fix and push out.
