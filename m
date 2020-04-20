Return-Path: <SRS0=5D7u=6E=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5EA01C54FCC
	for <linux-xfs@archiver.kernel.org>; Mon, 20 Apr 2020 22:53:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 46D7821D79
	for <linux-xfs@archiver.kernel.org>; Mon, 20 Apr 2020 22:53:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726325AbgDTWxK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 20 Apr 2020 18:53:10 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:58068 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726201AbgDTWxK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 20 Apr 2020 18:53:10 -0400
Received: from dread.disaster.area (pa49-180-0-232.pa.nsw.optusnet.com.au [49.180.0.232])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 6E57F3A3865;
        Tue, 21 Apr 2020 08:53:05 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jQfHj-0006YW-Lu; Tue, 21 Apr 2020 08:53:03 +1000
Date:   Tue, 21 Apr 2020 08:53:03 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 00/12] xfs: flush related error handling cleanups
Message-ID: <20200420225303.GR9800@dread.disaster.area>
References: <20200417150859.14734-1-bfoster@redhat.com>
 <20200419225306.GA9800@dread.disaster.area>
 <20200420140604.GJ27516@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200420140604.GJ27516@bfoster>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=QIgWuTDL c=1 sm=1 tr=0
        a=XYjVcjsg+1UI/cdbgX7I7g==:117 a=XYjVcjsg+1UI/cdbgX7I7g==:17
        a=kj9zAlcOel0A:10 a=cl8xLZFz6L8A:10 a=VwQbUJbxAAAA:8 a=7-415B0cAAAA:8
        a=xQ0dY92RgrjSArvii8sA:9 a=CjuIK1q_8ugA:10 a=AjGcO6oz07-iQ99wixmX:22
        a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Apr 20, 2020 at 10:06:04AM -0400, Brian Foster wrote:
> On Mon, Apr 20, 2020 at 08:53:06AM +1000, Dave Chinner wrote:
> > On Fri, Apr 17, 2020 at 11:08:47AM -0400, Brian Foster wrote:
> > > Hi all,
> > > 
> > > This actually started as what I intended to be a cleanup of xfsaild
> > > error handling and the fact that unexpected errors are kind of lost in
> > > the ->iop_push() handlers of flushable log items. Some discussion with
> > > Dave on that is available here[1]. I was thinking of genericizing the
> > > behavior, but I'm not so sure that is possible now given the error
> > > handling requirements of the associated items.
> > > 
> > > While thinking through that, I ended up incorporating various cleanups
> > > in the somewhat confusing and erratic error handling on the periphery of
> > > xfsaild, such as the flush handlers. Most of these are straightforward
> > > cleanups except for patch 9, which I think requires careful review and
> > > is of debatable value. I have used patch 12 to run an hour or so of
> > > highly concurrent fsstress load against it and will execute a longer run
> > > over the weekend now that fstests has completed.
> > > 
> > > Thoughts, reviews, flames appreciated.
> > 
> > I'll need to do something thinking on this patchset - I have a
> > patchset that touches a lot of the same code I'm working on right
> > now to pin inode cluster buffers in memory when the inode is dirtied
> > so we don't get RMW cycles in AIL flushing.
> > 
> > That code gets rid of xfs_iflush() completely, removes dirty inodes
> > from the AIL and tracks only ordered cluster buffers in the AIL for
> > inode writeback (i.e. reduces AIL tracked log items by up to 30x).
> > It also only does inode writeback from the ordered cluster buffers.
> > 
> 
> Ok. I could see that being reason enough to drop the iflush iodone
> patch, given that it depends on a bit of a rework/hack. A cleaner
> solution requires more thought and it might not be worth the time if the
> code is going away. Most of the rest are straightforward cleanups though
> so I wouldn't expect complex conflict resolution. It's hard to say
> for sure without seeing the code, of course..

Yeah, now I've been though most of it there isn't a huge impact on
my patchset. Mainly just the conflicts in the mods to xfs_iflush and
friends.

> > The idea behind this is to make inode flushing completely
> > non-blocking, and to simply inode cluster flushing to simply iterate
> > all the dirty inodes attached to the buffer. This gets rid of radix
> > tree lookups and races with reclaim, and gets rid of having to
> > special case a locked inode in the cluster iteration code.
> > 
> 
> Sounds interesting, but it's not really clear to me what the general
> flushing dynamic looks like in this model. I.e., you mention
> xfs_iflush() goes away, but cluster flushing still exists in some form,
> so I can't really tell if xfs_iflush() going away is tied to a
> functional change or primarily a refactoring/cleanup. Anyways, no need
> to go into the weeds if the code will eventually clarify..

It's primarily a clean-up to try to reduce AIL pushing overhead as
I'm regularly seeing the xfsaild CPU bound trying to push inodes
that are already on their way to disk. So I'm trying to reduce
cluster flushing to be driven by a buffer item push rather than by
pushing repeatedly on every inode item that is attached to the
buffer. 

> > Do you have a git tree I could pull this from to see how bad the
> > conflicts are?
> > 
> 
> I don't have a public tree. I suppose I could look into getting
> kernel.org access if somebody could point me in the right
> direction for that. :) In the meantime I could make a private tree
> accessible to you directly if that's helpful..

Send a request for an account and git tree to helpdesk@kernel.org
and cc Darrick, Eric and myself so we can ACK the request.

Details here:

https://korg.wiki.kernel.org/userdoc/accounts

and all the userdoc is here:

https://korg.wiki.kernel.org/start

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
