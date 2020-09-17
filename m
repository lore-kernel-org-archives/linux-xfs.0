Return-Path: <SRS0=EbdE=C2=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9AD85C433E2
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Sep 2020 10:58:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4A19421655
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Sep 2020 10:58:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="T1Sz4kTt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726285AbgIQK6L (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 17 Sep 2020 06:58:11 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:48455 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726185AbgIQK6J (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 Sep 2020 06:58:09 -0400
X-Greylist: delayed 546 seconds by postgrey-1.27 at vger.kernel.org; Thu, 17 Sep 2020 06:58:08 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600340287;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=1AILeBfCeAXslU5j6k+yENWo8hu+Ro9QzlEjIRtqFLo=;
        b=T1Sz4kTtgRZZVxLh57JTs3o/Fh/T84s6ZywDEaxTZjkhdjME6Nv2exwQ1pX2H72LqVNy2E
        KLNQ/E1FbiWykAi44MhyThVyYIZCjxayQz03PZYVwL6QMGN28RpamQCNZo+uuosjCGeMaa
        ZPkhWpsC1x7wgpRa2hf9/v6QO/KJ8TE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-366-m_IOLND_OrKpG5ScXjMk3w-1; Thu, 17 Sep 2020 06:42:24 -0400
X-MC-Unique: m_IOLND_OrKpG5ScXjMk3w-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5A9BD1007472;
        Thu, 17 Sep 2020 10:42:22 +0000 (UTC)
Received: from bfoster (ovpn-113-130.rdu2.redhat.com [10.10.113.130])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 24BC619646;
        Thu, 17 Sep 2020 10:42:21 +0000 (UTC)
Date:   Thu, 17 Sep 2020 06:42:19 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        Dave Chinner <david@fromorbit.com>,
        Ritesh Harjani <riteshh@linux.ibm.com>,
        Anju T Sudhakar <anju@linux.vnet.ibm.com>,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, willy@infradead.org,
        minlei@redhat.com
Subject: Re: [PATCH] iomap: Fix the write_count in iomap_add_to_ioend().
Message-ID: <20200917104219.GA1811187@bfoster>
References: <20200822131312.GA17997@infradead.org>
 <20200824142823.GA295033@bfoster>
 <20200824150417.GA12258@infradead.org>
 <20200824154841.GB295033@bfoster>
 <20200825004203.GJ12131@dread.disaster.area>
 <20200825144917.GA321765@bfoster>
 <20200916001242.GE7955@magnolia>
 <20200916084510.GA30815@infradead.org>
 <20200916130714.GA1681377@bfoster>
 <20200917080455.GY26262@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200917080455.GY26262@infradead.org>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Sep 17, 2020 at 09:04:55AM +0100, Christoph Hellwig wrote:
> On Wed, Sep 16, 2020 at 09:07:14AM -0400, Brian Foster wrote:
> > Dave described the main purpose earlier in this thread [1]. The initial
> > motivation is that we've had downstream reports of soft lockup problems
> > in writeback bio completion down in the bio -> bvec loop of
> > iomap_finish_ioend() that has to finish writeback on each individual
> > page of insanely large bios and/or chains. We've also had an upstream
> > reports of a similar problem on linux-xfs [2].
> > 
> > The magic number itself was just pulled out of a hat. I picked it
> > because it seemed conservative enough to still allow large contiguous
> > bios (1GB w/ 4k pages) while hopefully preventing I/O completion
> > problems, but was hoping for some feedback on that bit if the general
> > approach was acceptable. I was also waiting for some feedback on either
> > of the two users who reported the problem but I don't think I've heard
> > back on that yet...
> 
> I think the saner answer is to always run large completions in the
> workqueue, and add a bunch of cond_resched() calls, rather than
> arbitrarily breaking up the I/O size.
> 

That wouldn't address the latency concern Dave brought up. That said, I
have no issue with this as a targeted solution for the softlockup issue.
iomap_finish_ioend[s]() is common code for both the workqueue and
->bi_end_io() contexts so that would require either some kind of context
detection (and my understanding is in_atomic() is unreliable/frowned
upon) or a new "atomic" parameter through iomap_finish_ioend[s]() to
indicate whether it's safe to reschedule. Preference?

Brian

