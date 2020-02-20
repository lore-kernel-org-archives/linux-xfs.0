Return-Path: <SRS0=u4TP=4I=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F4C0C11D05
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Feb 2020 16:03:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7560320658
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Feb 2020 16:03:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GKiY1M58"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728686AbgBTQDA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 20 Feb 2020 11:03:00 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:59821 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728620AbgBTQC7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 20 Feb 2020 11:02:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582214578;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=3g8Z9IdhxZEUthDjiL2/cSDiIPZivLy1UjwDofPgr1g=;
        b=GKiY1M58QkmtLpi9iZj53sLQSj9rnCDjMucVvfuY43NxTGbp8EfawjF6KGbSm/LqtGvn97
        RXx7QC/lCcG9IIj4jwiXupJvPD8oUFEjaVj+3eN+joN2J5I/qVxHyPMryRXiBE8AHpdAja
        gwo3rG6xQD877SitXMvAnE0+HRGoe+0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-395-VFsjUTWKNY6MIbBF9c6BGw-1; Thu, 20 Feb 2020 11:02:54 -0500
X-MC-Unique: VFsjUTWKNY6MIbBF9c6BGw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2D87E18A6EC9;
        Thu, 20 Feb 2020 16:02:53 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 960EF89F08;
        Thu, 20 Feb 2020 16:02:52 +0000 (UTC)
Date:   Thu, 20 Feb 2020 11:02:50 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2] xfs: fix iclog release error check race with shutdown
Message-ID: <20200220160250.GG48977@bfoster>
References: <20200218175425.20598-1-bfoster@redhat.com>
 <20200218215243.GS10776@dread.disaster.area>
 <20200219131232.GA24157@bfoster>
 <20200219215141.GP9506@magnolia>
 <20200220124144.GA48977@bfoster>
 <20200220154317.GB6870@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200220154317.GB6870@infradead.org>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Feb 20, 2020 at 07:43:17AM -0800, Christoph Hellwig wrote:
> On Thu, Feb 20, 2020 at 07:41:44AM -0500, Brian Foster wrote:
> > I wasn't planning on a v3. The discussion to this point has been
> > centered around the xfs_force_shutdown() call in the associated function
> > (which is orthogonal to the bug). v1 is technically correct, but
> > Christoph suggested to restore historical behavior wrt to the shutdown
> > call. v2 does that, but is a bit superfluous in that the iclog error
> > state with the lock held implies shutdown has already occurred. This is
> > harmless (unless we're worried about shutdown performance or
> > something..), but I think Dave indicated he preferred v1 based on that
> > reasoning.
> > 
> > Functionally I don't think it matters either way and at this point I
> > have no preference between v1 or v2. They fix the same problem. Do note
> > that v2 does have the Fixed: tag I missed with v1 (as well as a R-b)...
> 
> I'm fine with v1 after all this discussion, and volunteer to clean up
> all the ioerr handling for the log code after this fix goes in.
> 

Ok.

> That being said as noted in one of my replies I think we also need to
> add the same check in the other caller of __xlog_state_release_iclog.
> 

That seems reasonable as a cleanup, but I'm not sure how critical it is
otherwise. We've already handled the iclog at that point, so we're
basically just changing the function to return an error code regardless
of the fact that we ran xlog_sync() (which doesn't care about iclog
state until we attempt to write, where it checks state again before bio
submission) and that most callers have their own IOERROR state checks up
the chain anyways because there is no other indication of I/O submission
failure..

Brian

