Return-Path: <SRS0=9CIi=XZ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73AA5C32792
	for <linux-xfs@archiver.kernel.org>; Mon, 30 Sep 2019 12:17:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4ABD82054F
	for <linux-xfs@archiver.kernel.org>; Mon, 30 Sep 2019 12:17:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728214AbfI3MRD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 30 Sep 2019 08:17:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49210 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726314AbfI3MRD (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 30 Sep 2019 08:17:03 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 58D6D4E908;
        Mon, 30 Sep 2019 12:17:03 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 00F205D6D0;
        Mon, 30 Sep 2019 12:17:02 +0000 (UTC)
Date:   Mon, 30 Sep 2019 08:17:01 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v5 01/11] xfs: track active state of allocation btree
 cursors
Message-ID: <20190930121701.GA57295@bfoster>
References: <20190927171802.45582-1-bfoster@redhat.com>
 <20190927171802.45582-2-bfoster@redhat.com>
 <20190930081138.GA2999@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190930081138.GA2999@infradead.org>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.38]); Mon, 30 Sep 2019 12:17:03 +0000 (UTC)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Sep 30, 2019 at 01:11:38AM -0700, Christoph Hellwig wrote:
> On Fri, Sep 27, 2019 at 01:17:52PM -0400, Brian Foster wrote:
> > The upcoming allocation algorithm update searches multiple
> > allocation btree cursors concurrently. As such, it requires an
> > active state to track when a particular cursor should continue
> > searching. While active state will be modified based on higher level
> > logic, we can define base functionality based on the result of
> > allocation btree lookups.
> > 
> > Define an active flag in the private area of the btree cursor.
> > Update it based on the result of lookups in the existing allocation
> > btree helpers. Finally, provide a new helper to query the current
> > state.
> 
> I vaguely remember having the discussion before, but why isn't the
> active flag in the generic part of xfs_btree_cur and just tracked
> for all types?  That would seem bother simpler and more useful in
> the long run.

The active flag was in the allocation cursor originally and was moved to
the private portion of the btree cursor simply because IIRC that's where
you suggested to put it. FWIW, that seems like the appropriate place to
me because 1.) as of right now I don't have any other use case in mind
outside of allocbt cursors 2.) flag state is similarly managed in the
allocation btree helpers and 3.) the flag is not necessarily used as a
generic btree cursor state (it is more accurately a superset of the
generic btree state where the allocation algorithm can also make higher
level changes). The latter bit is why it was originally put in the
allocation tracking structure, FWIW.

I've no fundamental objection to moving some or all of this to more
generic code down the road, but I'd prefer not to do that until there's
another user so the above can be rectified against an actual use case.
I can include the reasoning for the current placement in the commit log
description if that is useful.

Brian
