Return-Path: <SRS0=ByWF=4N=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4F75C35DF5
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Feb 2020 09:52:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9025221927
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Feb 2020 09:52:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729086AbgBYJwS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 25 Feb 2020 04:52:18 -0500
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:41132 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729178AbgBYJwS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Feb 2020 04:52:18 -0500
Received: from dread.disaster.area (pa49-195-202-68.pa.nsw.optusnet.com.au [49.195.202.68])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 9D0903A2A4A;
        Tue, 25 Feb 2020 20:52:13 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1j6Wsv-00086P-0j; Tue, 25 Feb 2020 20:52:13 +1100
Date:   Tue, 25 Feb 2020 20:52:12 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Allison Collins <allison.henderson@oracle.com>,
        linux-xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH v7 00/19] xfs: Delayed Ready Attrs
Message-ID: <20200225095212.GM10776@dread.disaster.area>
References: <20200223020611.1802-1-allison.henderson@oracle.com>
 <CAOQ4uxgvJOF6+jd9BuJfxxGQbiit6J7zVOVnigwLb-RWizRqfg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxgvJOF6+jd9BuJfxxGQbiit6J7zVOVnigwLb-RWizRqfg@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=W5xGqiek c=1 sm=1 tr=0
        a=mqTaRPt+QsUAtUurwE173Q==:117 a=mqTaRPt+QsUAtUurwE173Q==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=l697ptgUJYAA:10
        a=yPCof4ZbAAAA:8 a=nt1UNTH2AAAA:8 a=7-415B0cAAAA:8 a=FH9BZ1WyLk-STIrBqosA:9
        a=wxOv5TZsKvRJQwJq:21 a=6AW3ajc78ZXtvRZF:21 a=CjuIK1q_8ugA:10
        a=1jnEqRSf4vEA:10 a=7AW3Uk2BEroXwU7YnAE8:22 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Feb 23, 2020 at 09:55:48AM +0200, Amir Goldstein wrote:
> On Sun, Feb 23, 2020 at 4:06 AM Allison Collins
> <allison.henderson@oracle.com> wrote:
> >
> > Hi all,
> >
> > This set is a subset of a larger series for delayed attributes. Which is
> > a subset of an even larger series, parent pointers. Delayed attributes
> > allow attribute operations (set and remove) to be logged and committed
> > in the same way that other delayed operations do. This allows more
> > complex operations (like parent pointers) to be broken up into multiple
> > smaller transactions. To do this, the existing attr operations must be
> > modified to operate as either a delayed operation or a inline operation
> > since older filesystems will not be able to use the new log entries.
> 
> High level question, before I dive into the series:
> 
> Which other "delayed operations" already exist?

See Chandan's answer :P

> I think delayed operations were added by Darrick to handle the growth of
> translation size due to reflink. Right? So I assume the existing delayed
> operations deal with block accounting.

No, they are intended to allow atomic, recoverable multi-transaction
operations. They grew out of this:

https://xfs.org/index.php/Improving_Metadata_Performance_By_Reducing_Journal_Overhead#Atomic_Multi-Transaction_Operations

which was essentially an generalisation of the EFI/EFD intent
logging that has existed in XFS for 20 years.

Essentially, it is a mechanism of chaining intent operations to
ensure that recover will restart the operation at the point the
system failed so that once the operation is started (i.e. first
intent is logged to the journal) the entire operation is always
completed regardless of whether the system crashes or not.

> When speaking of parent pointers, without having looked into the details yet,
> it seem the delayed operations we would want to log are operations that deal
> with namespace changes, i.e.: link,unlink,rename.
> The information needed to be logged for these ops is minimal.

Not really. the parent pointers are held in attributes, so parent
pointers are effectively adding an attribute creation to every inode
allocation and an attribute modification to every directory
modification. And, well, when an inode has 100 million hard links,
it's going to have 100 million parent pointer attributes. Modifying
a link is then a major operation, and Chandan has done a great job
in analysing the attr btree to see if there are scalability issues
that will be exposed by this sort of attribute usage....

> Why do we need a general infrastructure for delayed attr operations?

These have to be done atomically with the create/unlink/rename/etc
and to include attribute modification in those transaction
reservations blows the size of them out massively (especially
rename!). By converting these operations to use defered operations
to add the parent pointer to the inode, we no longer need to
increase the log reservation for the operations (because the attr
reservation is usually smaller than the directory reservation), and
it is guaranteed to be atomic with the directory modification. i.e.
parent pointers never get out of sync, even when the system crashes.

Hence having attributes modified as a series of individual
operations chained together into an atomic whole via intents is a
pre-requisite for updating attributes atomically within directory
modification operations.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
