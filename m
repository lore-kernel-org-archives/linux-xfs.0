Return-Path: <SRS0=5xP4=AI=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7443EC433E0
	for <linux-xfs@archiver.kernel.org>; Sat, 27 Jun 2020 13:09:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 47E0121548
	for <linux-xfs@archiver.kernel.org>; Sat, 27 Jun 2020 13:09:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ecaF/nSE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726576AbgF0NJZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 27 Jun 2020 09:09:25 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:26633 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726394AbgF0NJY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 27 Jun 2020 09:09:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593263360;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=gocYarnZ2JlHVc9RG/zHaX044tbXdzru5bTv0I6/CXM=;
        b=ecaF/nSEbz6rGsfqONBqtlz5UGzGHvcB/U/B36awRbWxlwttGBxIKvfFzV+o807ZRf0QIJ
        OW/cd9LMZYw3P6iZxHK55PAYGqHHjT9aEwQNUtPYqIpvCnH8zoNnd/Ue2p6rCJH2rXYZOf
        cxeh6JdjGL/StrprSUXkB7VmIY4nIpw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-263-qk0xhzsyPy-G0Q7G_J2UvQ-1; Sat, 27 Jun 2020 09:09:18 -0400
X-MC-Unique: qk0xhzsyPy-G0Q7G_J2UvQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BDF59804001;
        Sat, 27 Jun 2020 13:09:16 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (file01.intranet.prod.int.rdu2.redhat.com [10.11.5.7])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 3758B2B4AC;
        Sat, 27 Jun 2020 13:09:13 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (localhost [127.0.0.1])
        by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4) with ESMTP id 05RD9CXa015401;
        Sat, 27 Jun 2020 09:09:12 -0400
Received: from localhost (mpatocka@localhost)
        by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4/Submit) with ESMTP id 05RD99e3015395;
        Sat, 27 Jun 2020 09:09:10 -0400
X-Authentication-Warning: file01.intranet.prod.int.rdu2.redhat.com: mpatocka owned process doing -bs
Date:   Sat, 27 Jun 2020 09:09:09 -0400 (EDT)
From:   Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To:     Dave Chinner <david@fromorbit.com>
cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-xfs@vger.kernel.org, dm-devel@redhat.com,
        Jens Axboe <axboe@kernel.dk>, NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 0/6] Overhaul memalloc_no*
In-Reply-To: <20200626230847.GI2005@dread.disaster.area>
Message-ID: <alpine.LRH.2.02.2006270848540.14350@file01.intranet.prod.int.rdu2.redhat.com>
References: <20200625113122.7540-1-willy@infradead.org> <alpine.LRH.2.02.2006261058250.11899@file01.intranet.prod.int.rdu2.redhat.com> <20200626230847.GI2005@dread.disaster.area>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On Sat, 27 Jun 2020, Dave Chinner wrote:

> On Fri, Jun 26, 2020 at 11:02:19AM -0400, Mikulas Patocka wrote:
> > Hi
> > 
> > I suggest to join memalloc_noio and memalloc_nofs into just one flag that 
> > prevents both filesystem recursion and i/o recursion.
> > 
> > Note that any I/O can recurse into a filesystem via the loop device, thus 
> > it doesn't make much sense to have a context where PF_MEMALLOC_NOFS is set 
> > and PF_MEMALLOC_NOIO is not set.
> 
> Correct me if I'm wrong, but I think that will prevent swapping from
> GFP_NOFS memory reclaim contexts.

Yes.

> IOWs, this will substantially
> change the behaviour of the memory reclaim system under sustained
> GFP_NOFS memory pressure. Sustained GFP_NOFS memory pressure is
> quite common, so I really don't think we want to telling memory
> reclaim "you can't do IO at all" when all we are trying to do is
> prevent recursion back into the same filesystem.

So, we can define __GFP_ONLY_SWAP_IO and __GFP_IO.

> Given that the loop device IO path already operates under
> memalloc_noio context, (i.e. the recursion restriction is applied in
> only the context that needs is) I see no reason for making that a
> global reclaim limitation....

I think this is a problem.

Suppose that a filesystem does GFP_NOFS allocation, the allocation 
triggers an IO and waits for it to finish, the loop device driver 
redirects the IO to the same filesystem that did the GFP_NOFS allocation.

I saw this deadlock in the past in the dm-bufio subsystem - see the commit 
9d28eb12447ee08bb5d1e8bb3195cf20e1ecd1c0 that fixed it.

Other subsystems that do IO in GFP_NOFS context may deadlock just like 
bufio.

Mikulas

