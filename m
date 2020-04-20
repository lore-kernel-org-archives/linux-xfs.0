Return-Path: <SRS0=5D7u=6E=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3EDDC3815B
	for <linux-xfs@archiver.kernel.org>; Mon, 20 Apr 2020 14:06:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9214820722
	for <linux-xfs@archiver.kernel.org>; Mon, 20 Apr 2020 14:06:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dvALpr91"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727820AbgDTOGO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 20 Apr 2020 10:06:14 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:59020 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726871AbgDTOGN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 20 Apr 2020 10:06:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587391572;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=WJ4F5P9qehBRxSk7rTZsMCJwo2XQhglkmf4pQpqsLkg=;
        b=dvALpr91y+VIquw8E3XrQRDVMKzdMCSL072LlD4SAmaM7LH5+/CB751lQQ0pk4p74UHSLB
        7Unw/G6aiycRKhc0qIPh34/lB0rg4p6wd6Y73DiPtG6T1h2KWW+Sb9ZcSt6/1t5vNAm3Yi
        HnzasrMFPLp8T9r+WqhIDKs01zKDvWk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-331-iI3UMjviONCvTsSXaqg5zQ-1; Mon, 20 Apr 2020 10:06:07 -0400
X-MC-Unique: iI3UMjviONCvTsSXaqg5zQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4E4A8801A00;
        Mon, 20 Apr 2020 14:06:06 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 04221277B5;
        Mon, 20 Apr 2020 14:06:05 +0000 (UTC)
Date:   Mon, 20 Apr 2020 10:06:04 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 00/12] xfs: flush related error handling cleanups
Message-ID: <20200420140604.GJ27516@bfoster>
References: <20200417150859.14734-1-bfoster@redhat.com>
 <20200419225306.GA9800@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200419225306.GA9800@dread.disaster.area>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Apr 20, 2020 at 08:53:06AM +1000, Dave Chinner wrote:
> On Fri, Apr 17, 2020 at 11:08:47AM -0400, Brian Foster wrote:
> > Hi all,
> > 
> > This actually started as what I intended to be a cleanup of xfsaild
> > error handling and the fact that unexpected errors are kind of lost in
> > the ->iop_push() handlers of flushable log items. Some discussion with
> > Dave on that is available here[1]. I was thinking of genericizing the
> > behavior, but I'm not so sure that is possible now given the error
> > handling requirements of the associated items.
> > 
> > While thinking through that, I ended up incorporating various cleanups
> > in the somewhat confusing and erratic error handling on the periphery of
> > xfsaild, such as the flush handlers. Most of these are straightforward
> > cleanups except for patch 9, which I think requires careful review and
> > is of debatable value. I have used patch 12 to run an hour or so of
> > highly concurrent fsstress load against it and will execute a longer run
> > over the weekend now that fstests has completed.
> > 
> > Thoughts, reviews, flames appreciated.
> 
> I'll need to do something thinking on this patchset - I have a
> patchset that touches a lot of the same code I'm working on right
> now to pin inode cluster buffers in memory when the inode is dirtied
> so we don't get RMW cycles in AIL flushing.
> 
> That code gets rid of xfs_iflush() completely, removes dirty inodes
> from the AIL and tracks only ordered cluster buffers in the AIL for
> inode writeback (i.e. reduces AIL tracked log items by up to 30x).
> It also only does inode writeback from the ordered cluster buffers.
> 

Ok. I could see that being reason enough to drop the iflush iodone
patch, given that it depends on a bit of a rework/hack. A cleaner
solution requires more thought and it might not be worth the time if the
code is going away. Most of the rest are straightforward cleanups though
so I wouldn't expect complex conflict resolution. It's hard to say
for sure without seeing the code, of course..

> The idea behind this is to make inode flushing completely
> non-blocking, and to simply inode cluster flushing to simply iterate
> all the dirty inodes attached to the buffer. This gets rid of radix
> tree lookups and races with reclaim, and gets rid of having to
> special case a locked inode in the cluster iteration code.
> 

Sounds interesting, but it's not really clear to me what the general
flushing dynamic looks like in this model. I.e., you mention
xfs_iflush() goes away, but cluster flushing still exists in some form,
so I can't really tell if xfs_iflush() going away is tied to a
functional change or primarily a refactoring/cleanup. Anyways, no need
to go into the weeds if the code will eventually clarify..

> I was looking at this as the model to then apply to dquot flushing,
> too, because it currently does not have cluster flushing, and hence
> flushes dquots individually, even though there can be multiple dirty
> dquots per buffer. Some of this patchset moves the dquot flushing a
> bit closer to the inode code, so those parts are going to be useful
> regardless of everything else....
> 

Makes sense.

> Do you have a git tree I could pull this from to see how bad the
> conflicts are?
> 

I don't have a public tree. I suppose I could look into getting
kernel.org access if somebody could point me in the right direction for
that. :) In the meantime I could make a private tree accessible to you
directly if that's helpful..

Brian

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 

