Return-Path: <SRS0=K4IM=45=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C312C0044D
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Mar 2020 00:07:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 729F32074D
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Mar 2020 00:07:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731448AbgCLAHV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 11 Mar 2020 20:07:21 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:54606 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726194AbgCLAHV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 11 Mar 2020 20:07:21 -0400
Received: from dread.disaster.area (pa49-195-202-68.pa.nsw.optusnet.com.au [49.195.202.68])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id A23E43A23AD;
        Thu, 12 Mar 2020 11:07:18 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jCBNd-0005Ob-1C; Thu, 12 Mar 2020 11:07:17 +1100
Date:   Thu, 12 Mar 2020 11:07:17 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Theodore Y. Ts'o" <tytso@mit.edu>
Cc:     Eric Biggers <ebiggers@kernel.org>,
        Linux Filesystem Development List 
        <linux-fsdevel@vger.kernel.org>,
        Ext4 Developers List <linux-ext4@vger.kernel.org>,
        linux-f2fs-devel@lists.sourceforge.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] writeback: avoid double-writing the inode on a lazytime
 expiration
Message-ID: <20200312000716.GY10737@dread.disaster.area>
References: <20200306004555.GB225345@gmail.com>
 <20200307020043.60118-1-tytso@mit.edu>
 <20200311032009.GC46757@gmail.com>
 <20200311125749.GA7159@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200311125749.GA7159@mit.edu>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=X6os11be c=1 sm=1 tr=0
        a=mqTaRPt+QsUAtUurwE173Q==:117 a=mqTaRPt+QsUAtUurwE173Q==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=SS2py6AdgQ4A:10
        a=7-415B0cAAAA:8 a=hha5DUukJWGJSOMOPv8A:9 a=CjuIK1q_8ugA:10
        a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Mar 11, 2020 at 08:57:49AM -0400, Theodore Y. Ts'o wrote:
> On Tue, Mar 10, 2020 at 08:20:09PM -0700, Eric Biggers wrote:
> > Thanks Ted!  This fixes the fscrypt test failure.
> > 
> > However, are you sure this works correctly on all filesystems?  I'm not sure
> > about XFS.  XFS only implements ->dirty_inode(), not ->write_inode(), and in its
> > ->dirty_inode() it does:
>   ...
> > 		if (flag != I_DIRTY_SYNC || !(inode->i_state & I_DIRTY_TIME))
> > 			return;
> 
> That's true, but when the timestamps were originally modified,
> dirty_inode() will be called with flag == I_DIRTY_TIME, which will
> *not* be a no-op; which is to say, XFS will force the timestamps to be
> updated on disk when the timestamps are first dirtied, because it
> doesn't support I_DIRTY_TIME.

We log the initial timestamp change, and then ignore timestamp
updates until the dirty time expires and the inode is set
I_DIRTY_SYNC via __mark_inode_dirty_sync(). IOWs, on expiry, we have
time stamps that may be 24 hours out of date in memory, and they
still need to be flushed to the journal.

However, your change does not mark the inode dirtying on expiry
anymore, so...

> So I think we're fine.

... we're not fine. This breaks XFS and any other filesystem that
relies on a I_DIRTY_SYNC notification to handle dirty time expiry
correctly.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
