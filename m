Return-Path: <SRS0=ldVD=CD=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00C38C433E1
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Aug 2020 05:17:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D2FBA20678
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Aug 2020 05:17:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726149AbgHYFR5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 25 Aug 2020 01:17:57 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:55917 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726095AbgHYFR5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Aug 2020 01:17:57 -0400
Received: from dread.disaster.area (pa49-181-146-199.pa.nsw.optusnet.com.au [49.181.146.199])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 66DBF3A5FD1;
        Tue, 25 Aug 2020 15:17:54 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1kARLF-0006V7-Dq; Tue, 25 Aug 2020 15:17:53 +1000
Date:   Tue, 25 Aug 2020 15:17:53 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 05/13] xfs: add unlink list pointers to xfs_inode
Message-ID: <20200825051753.GM12131@dread.disaster.area>
References: <20200812092556.2567285-1-david@fromorbit.com>
 <20200812092556.2567285-6-david@fromorbit.com>
 <20200822090339.GB25623@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200822090339.GB25623@infradead.org>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=QIgWuTDL c=1 sm=1 tr=0 cx=a_idp_d
        a=GorAHYkI+xOargNMzM6qxQ==:117 a=GorAHYkI+xOargNMzM6qxQ==:17
        a=kj9zAlcOel0A:10 a=y4yBn9ojGxQA:10 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8
        a=ze0E97fQ6B5YVgsr3s0A:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Aug 22, 2020 at 10:03:39AM +0100, Christoph Hellwig wrote:
> On Wed, Aug 12, 2020 at 07:25:48PM +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > To move away from using the on disk inode buffers to track and log
> > unlinked inodes, we need pointers to track them in memory. Because
> > we have arbitrary remove order from the list, it needs to be a
> > double linked list.
> > 
> > We start by noting that inodes are always in memory when they are
> > active on the unlinked list, and hence we can track these inodes
> > without needing to take references to the inodes or store them in
> > the list. We cannot, however, use inode locks to protect the inodes
> > on the list - the list needs an external lock to serialise all
> > inserts and removals. We can use the existing AGI buffer lock for
> > this right now as that already serialises all unlinked list
> > traversals and modifications.
> > 
> > Hence we can convert the in-memory unlinked list to a simple
> > list_head list in the perag. We can use list_empty() to detect an
> > empty unlinked list, likewise we can detect the end of the list when
> > the inode next pointer points back to the perag list_head. This
> > makes insert, remove and traversal.
> > 
> > The only complication here is log recovery of old filesystems that
> > have multiple lists. These always remove from the head of the list,
> > so we can easily construct just enough of the unlinked list for
> > recovery from any list to work correctly.
> 
> I'd much prefer not bloating the inode for the relative rate case of
> inode unlinked while still open.  Can't we just allocate a temporary
> structure with the list_head and inode pointer instead?

That's precisely the complexity this code gets rid of. i.e. the
complex reverse pointer mapping rhashtable that had to be able to
handle rhashtable memory allocation failures and so required
fallbacks to straight buffer based unlink list walking. I much
prefer that we burn a little bit more memory for *much* simpler,
faster and more flexible code....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
