Return-Path: <SRS0=eBbo=5M=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 177C4C43331
	for <linux-xfs@archiver.kernel.org>; Fri, 27 Mar 2020 16:44:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D9BD520675
	for <linux-xfs@archiver.kernel.org>; Fri, 27 Mar 2020 16:44:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KUxS8Hzw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727770AbgC0QoT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 27 Mar 2020 12:44:19 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:51894 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727769AbgC0QoT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 27 Mar 2020 12:44:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585327457;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=8VplgkIHvoRqKTHOoYINfccKFd69hXV+8dud2H2LdgM=;
        b=KUxS8HzwDGmSOe1/bZA8fpQ2/yRE3GboYVBjp8FwNM+LZLSbZcWwLZwb+OWYRYzCxeFG3I
        O1c0fSfJbGAu71JdfV5W20PHMWX/1tJrlvX84joBZ6DzX/EFrJcCGpeWwOLBhxg1YxNGTw
        zUUbO0rcZEKNdwN8vzlLu6eANHoM3ZU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-239-VUwkZHJpNNC4akkyWbbVkQ-1; Fri, 27 Mar 2020 12:44:16 -0400
X-MC-Unique: VUwkZHJpNNC4akkyWbbVkQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 11864800D4E;
        Fri, 27 Mar 2020 16:44:15 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 946E75C1C3;
        Fri, 27 Mar 2020 16:44:14 +0000 (UTC)
Date:   Fri, 27 Mar 2020 12:44:12 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 0/2] xfs: a couple AIL pushing trylock fixes
Message-ID: <20200327164412.GA29156@bfoster>
References: <20200326131703.23246-1-bfoster@redhat.com>
 <20200327153205.GH29339@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200327153205.GH29339@magnolia>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Mar 27, 2020 at 08:32:05AM -0700, Darrick J. Wong wrote:
> On Thu, Mar 26, 2020 at 09:17:01AM -0400, Brian Foster wrote:
> > Hi all,
> > 
> > Here's a couple more small fixes that fell out of the auto relog work.
> > The dquot issue is actually a deadlock vector if we randomly relog dquot
> > buffers (which is only done for test purposes), but I figure we should
> > handle dquot buffers similar to how inode buffers are handled. Thoughts,
> > reviews, flames appreciated.
> 
> Oops, I missed this one, will review now...
> 
> Do you think there needs to be an explicit testcase for this?  Or are
> the current generic/{388,475} good enough?  I'm pretty sure I've seen
> this exact deadlock on them every now and again, so we're probably
> covered.
> 

I'm actually not aware of a related upstream deadlock. That doesn't mean
there isn't one of course, but the problem I hit was related to the
random buffer relogging stuff in the auto relog series. I split these
out because xfsaild is intended to be mostly async, so they seemed like a
generic fixups..

Brian

> --D
> 
> 
> > Brian
> > 
> > Brian Foster (2):
> >   xfs: trylock underlying buffer on dquot flush
> >   xfs: return locked status of inode buffer on xfsaild push
> > 
> >  fs/xfs/xfs_dquot.c      |  6 +++---
> >  fs/xfs/xfs_dquot_item.c |  3 ++-
> >  fs/xfs/xfs_inode_item.c |  3 ++-
> >  fs/xfs/xfs_qm.c         | 14 +++++++++-----
> >  4 files changed, 16 insertions(+), 10 deletions(-)
> > 
> > -- 
> > 2.21.1
> > 
> 

