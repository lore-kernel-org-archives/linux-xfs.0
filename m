Return-Path: <SRS0=+9Bg=A4=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60776C433DF
	for <linux-xfs@archiver.kernel.org>; Fri, 17 Jul 2020 11:57:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3A05C2065D
	for <linux-xfs@archiver.kernel.org>; Fri, 17 Jul 2020 11:57:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CmaCAyc4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726229AbgGQL5q (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 17 Jul 2020 07:57:46 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:32788 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726040AbgGQL5q (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 17 Jul 2020 07:57:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594987065;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=DjqcAhzUswcIZZ973O88PxfII3MLq2tdBoytg1fxtA8=;
        b=CmaCAyc4OyUZB/fF0AYx5jXin4aA/L3KKV9s7jnLCnEINbRdzXrwSv12p1NHG6k41ieSwD
        23Syf1qnHk/oxQSB3rT2Fiv1Bm/BgQvOs6ZmwSfhzEmZhRf5LXw045IN0e1EuAV+oKAWL5
        R2MiexBlsfosZS+u7oWlXNDU8QBuVFc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-339-P9U7iLwhPfq2a27uaOxLQg-1; Fri, 17 Jul 2020 07:57:43 -0400
X-MC-Unique: P9U7iLwhPfq2a27uaOxLQg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1A91F80183C;
        Fri, 17 Jul 2020 11:57:42 +0000 (UTC)
Received: from bfoster (ovpn-113-214.rdu2.redhat.com [10.10.113.214])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id B61FC8FA22;
        Fri, 17 Jul 2020 11:57:41 +0000 (UTC)
Date:   Fri, 17 Jul 2020 07:57:39 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/4] repair: use fs root ino for dummy parent value
 instead of zero
Message-ID: <20200717115739.GA58041@bfoster>
References: <20200715140836.10197-1-bfoster@redhat.com>
 <20200715140836.10197-4-bfoster@redhat.com>
 <20200715222216.GH2005@dread.disaster.area>
 <20200716104103.GB26218@bfoster>
 <20200716220605.GM2005@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200716220605.GM2005@dread.disaster.area>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jul 17, 2020 at 08:06:05AM +1000, Dave Chinner wrote:
> On Thu, Jul 16, 2020 at 06:41:03AM -0400, Brian Foster wrote:
> > On Thu, Jul 16, 2020 at 08:22:16AM +1000, Dave Chinner wrote:
> > > On Wed, Jul 15, 2020 at 10:08:35AM -0400, Brian Foster wrote:
> > > > If a directory inode has an invalid parent ino on disk, repair
> > > > replaces the invalid value with a dummy value of zero in the buffer
> > > > and NULLFSINO in the in-core parent tracking. The zero value serves
> > > > no functional purpose as it is still an invalid value and the parent
> > > > must be repaired by phase 6 based on the in-core state before the
> > > > buffer can be written out.  Instead, use the root fs inode number as
> > > > a catch all for invalid parent values so phase 6 doesn't have to
> > > > create custom verifier infrastructure just to work around this
> > > > behavior.
> > > > 
> > > > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > > 
> > > Reasonale, but wouldn't it be better to use lost+found as the dummy
> > > parent inode (i.e. the orphanage inode)? Because if the parent can't
> > > be found and the inode reconnected correctly, we're going to put it
> > > in lost+found, anyway?
> > > 
> > 
> > That was my first thought when I originally wrote this, but there's
> > several reasons I didn't end up doing that. The orphanage isn't created
> > until much later in repair and only if we end up with orphaned inodes.
> > We'd have to change that in order to use a dummy parent inode number
> > that corresponds to a valid orphanage, and TBH I'm not even sure if it's
> > always going to be safe to expect an inode allocation to work at this
> > point in repair.
> > 
> > Further, it's still too early to tell whether these directories are
> > orphaned because the directory scan in phase 6 can easily repair
> > missing/broken parent information. The scenarios I used to test this
> > functionality didn't involve the orphanage at all, so now we not only
> > need to change when/how the orphanage is created, but need to free it if
> > it ends up unused before we exit (which could be via any number of
> > do_error() calls before we ever get close to phase 6).
> 
> Fair enough - can you please capture all this in the commit message
> to preserve the explanation of why the root inode was chosen and
> not lost+found?
> 

Sure, v2 incoming...

Brian

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 

