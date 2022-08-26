Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BC63ECAAD8
	for <linux-xfs@archiver.kernel.org>; Fri, 26 Aug 2022 21:39:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231652AbiHZVj6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 26 Aug 2022 17:39:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229704AbiHZVj4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 26 Aug 2022 17:39:56 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB97913E33
        for <linux-xfs@vger.kernel.org>; Fri, 26 Aug 2022 14:39:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9933BB80B94
        for <linux-xfs@vger.kernel.org>; Fri, 26 Aug 2022 21:39:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47036C433C1;
        Fri, 26 Aug 2022 21:39:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661549991;
        bh=QaL3flOPB8rUZlqWRfv4s+i01/KJxpnRovKl+35i/lk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=h/mwAg/GCjp7qSHOa3yPYmMlUfO0QacoXS9fpvip/LiWNgy0mJ4LUWPvo9v00/rex
         6kGMdYDstoQlHnmfw520MJNMrPJmJ945TJ9HnQfZ9J5hF+YmgBJI1xk5PtywCG/JNq
         afXWs1kCzDekLVuhVhbDoJmNK4IBHhocHyvMrO3S/Lz5KsrX2O+PFBIE1ApjLen+FK
         rOfsy1ZxC8utcBmJylQxXTUyVdhCX90J/zHKskUOOsDO/d/RgWuS8/rBvw98HkMmCS
         MiTuRqIh79pbgZrFUKFMRQ3UdNtZ4SRL2UFlnn/j1Y7ofcX98LEd3fRirKWYsqHdr+
         4P3xEWd3H2SCA==
Date:   Fri, 26 Aug 2022 14:39:50 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/9] xfs: ensure log tail is always up to date
Message-ID: <Ywk9pqHtrVji6mg7@magnolia>
References: <20220809230353.3353059-1-david@fromorbit.com>
 <20220809230353.3353059-5-david@fromorbit.com>
 <YwQgT1i0x2i+wGF8@magnolia>
 <20220823021847.GO3600936@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220823021847.GO3600936@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Aug 23, 2022 at 12:18:47PM +1000, Dave Chinner wrote:
> On Mon, Aug 22, 2022 at 05:33:19PM -0700, Darrick J. Wong wrote:
> > On Wed, Aug 10, 2022 at 09:03:48AM +1000, Dave Chinner wrote:
> > > From: Dave Chinner <dchinner@redhat.com>
> > > 
> > > Whenever we write an iclog, we call xlog_assign_tail_lsn() to update
> > > the current tail before we write it into the iclog header. This
> > > means we have to take the AIL lock on every iclog write just to
> > > check if the tail of the log has moved.
> > > 
> > > This doesn't avoid races with log tail updates - the log tail could
> > > move immediately after we assign the tail to the iclog header and
> > > hence by the time the iclog reaches stable storage the tail LSN has
> > > moved forward in memory. Hence the log tail LSN in the iclog header
> > > is really just a point in time snapshot of the current state of the
> > > AIL.
> > > 
> > > With this in mind, if we simply update the in memory log->l_tail_lsn
> > > every time it changes in the AIL, there is no need to update the in
> > > memory value when we are writing it into an iclog - it will already
> > > be up-to-date in memory and checking the AIL again will not change
> > > this.
> > 
> > This is too subtle for me to understand -- does the codebase
> > already update l_tail_lsn?  Does this patch make it do that?
> 
> tl;dr: if the AIL is empty, log->l_tail_lsn is not updated on the
> first insert of a new item into the AILi and hence is stale.
> xlog_state_release_iclog() currently works around that by calling
> xlog_assign_tail_lsn() to get the tail lsn from the AIL. This change
> makes sure log->l_tail_lsn is always up to date.
> 
> In more detail:
> 
> The tail update occurs in xfs_ail_update_finish(), but only if we
> pass in a non-zero tail_lsn. xfs_trans_ail_update_bulk() will only
> set a non-zero tail_lsn if it moves the log item at the tail of the
> log (i.e. we relog the tail item and move it forwards in the AIL).
> 
> Hence if we pass a non-zero tail_lsn to xfs_ail_update_finish(), it
> indicates it needs to check it against the LSN of the item currently
> at the tail of the AIL. If the tail LSN has not changed, we do
> nothing, if it has changed, then we call
> xlog_assign_tail_lsn_locked() to update the log tail.
> 
> The problem with the current code is that if the AIL is empty when
> we insert the first item, we've actually moved the log tail but we
> do not update the log tail (i.e. tail_lsn is zero in this case). If
> we then release an iclog for writing at this point in time, the tail
> lsn it writes into the iclog header would be wrong - it does not
> reflect the log tail as defined by the AIL and the checkpoint that
> has just been committed.
> 
> Hence xlog_state_release_iclog() called xlog_assign_tail_lsn() to
> ensure that it checked that the tail LSN it applies to the iclog
> reflects the current state of the AIL. i.e. it checks if there is an
> item in the AIL, and if so, grabs the tail_lsn from the AIL. This
> works around the fact the AIL doesn't update the log tail on the
> first insert.
> 
> Hence what this patch does is have xfs_trans_ail_update_bulk set
> the tail_lsn passed to xfs_ail_update_finish() to NULLCOMMITLSN when
> it does the first insert into the AIL. NULLCOMMITLSN is a
> non-zero value that won't match with the LSN of items we just
> inserted into the AIL, and hence xfs_ail_update_finish() will go an
> update the log tail in this case.
> 
> Hence we close the hole when the log->l_tail_lsn is incorrect after
> the first insert into the AIL, and hence we no longer need to update
> the log->l_tail_lsn when reading it into the iclog header -
> log->l_tail_lsn is always up to date, and so we can now just read it
> in xlog_state_release_iclog() rather than having to grab the AIL
> lock and checking the AIL to update log->l_tail_lsn with the correct
> tail value from iclog IO submission....

Ahhh, ok, I get it now.  Thanks for the explanation.

--D

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
