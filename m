Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86583FA3741
	for <linux-xfs@archiver.kernel.org>; Fri, 28 Oct 2022 13:05:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230407AbiJ1NF1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 28 Oct 2022 09:05:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230337AbiJ1NFT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 28 Oct 2022 09:05:19 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AF781CEC09
        for <linux-xfs@vger.kernel.org>; Fri, 28 Oct 2022 06:04:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666962257;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=e1mOFa3eaHGR4MUE9zQEczT0S4cDApwULW1uJ9yrX10=;
        b=J6jzLdLH0XmTnJ964cFm5FJa91/TQyUtDweUyNSqJJzKidZA9QJ8oM+cibERtmIdEAxYW6
        n/Zjd6zVWWOW4E+cfC5IViJpsUqU5YlY3PVgvaLx6g3YmJhXgn8JUzFv1GSWnmsNaR2EFp
        EtNAdwNOlyTBP+ogS9B8CdhxRDSWVqw=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-128-esj_advGMdmCogW0vgrzEg-1; Fri, 28 Oct 2022 09:04:16 -0400
X-MC-Unique: esj_advGMdmCogW0vgrzEg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EFB7F2803081
        for <linux-xfs@vger.kernel.org>; Fri, 28 Oct 2022 13:04:10 +0000 (UTC)
Received: from bfoster.redhat.com (unknown [10.22.16.42])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 29D9C40C9562
        for <linux-xfs@vger.kernel.org>; Fri, 28 Oct 2022 13:04:05 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH RFC 0/2] xfs: optimize truncate cache flushing
Date:   Fri, 28 Oct 2022 09:04:09 -0400
Message-Id: <20221028130411.977076-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

We have a customer that has complained about a significant performance
impact caused by commit 869ae85dae64 ("xfs: flush new eof page on
truncate to avoid post-eof corruption"). The workload is a fairly simple
repetitive, small, fixed-size buffered write followed by a truncate. The
truncate now unconditionally involves multiple flushes where previously,
once the eof block was converted, only one flush was involved.

My first reaction when revisiting the aforementioned commit was the same
as for when that commit was first introduced.. that we really shouldn't
need to flush at all here for zeroing to work correctly. Instead, the
iomap zeroing mechanism should one way or another (either in iomap or
via the fs callbacks) detect scenarios like a dirty page over an
unwritten extent and do the right thing (tm). From there, I tried a few
different experiments to get something working along those lines, but so
far haven't been able to come up with anything that is sufficiently
elegant or otherwise not too ugly or racy.

I still think something along those lines is the proper long term
solution because it addresses other scenarios where zeroing might not
technically do the right thing, but given the significance of the
performance/customer impact and implementation complexity I've fallen
back to something more incremental to try and disconnect user impact
from longer term solutions. With that in mind, the most straightforward
approach to me seemed to be to just check for the cases we explicitly
care about flushing and to skip the flush otherwise. This is
implemented by this RFC and restores original behavior for the simple
overwrite+truncate scenario.

Of course there are various other options to achieve a similar result.
Some examples:

1. Simply skip the xfs_truncate_page() branch in the (newsize ==
oldsize) scenario. This is technically a subtle behavior change in that
something like a post-eof mapped write is no longer zeroed by a
truncate. That might be reasonable as the page should still be partially
zeroed at writeback time, but it may require a bit of an audit to ensure
there are no other problems. I was initially uneasy about this approach
when I first explored it, but IIRC it did survive an fstests run, and
the priority of the regression and hopefully temporary nature has me
considering it as more acceptable.

2. Do something like unconditionally zero the eof page regardless of the
underlying extent state. This has an obvious tradeoff of unconditional
extent conversion if an unwritten block had not previously been written
by the user, but also it's not totally clear to me that such a simple
behavior change will necessarily have a simple implementation.

3. A slightly different variant of option #2 that comes to mind is to
take advantage of the fact that pagecache truncate already does partial
page zeroing (but not dirtying) and manually handle the race that the
flush is trying to prevent. For example, first look up the EOF page and
track whether it 1. exists and 2. is dirty. If so, hold a reference to
the page, call the iomap zeroing bits, call truncate_setsize() (which
falls into pagecache truncation), and then redirty the page if
(did_zeroing == false) and the page was originally dirty before we
started.

IIRC in most cases I think pagecache truncate is really what prevents
observable problems here because it does zero the eof page and for the
case of a dirty page over an unwritten extent, writeback is more likely
to complete before the iomap zeroing or after the pagecache zeroing vs.
within that race window. So the idea here would just be to ensure the
pagecache truncate zeroing makes it to disk if iomap doesn't zero. FWIW,
I hadn't yet experimented with this idea as I wrote this, and even
though it's clearly still a temporary hack, it sounded potentially
simple enough that I put a quick prototype together. I'll post that in
reply to this cover letter.

4. Given that the second filemap_write_and_wait_range() doesn't actually
wait for submitted I/O to complete for this particular workload [1],
consider whether we want to conditionally elide the second flush to
restore historically "single flush" behavior. I've quickly tested this
and it seems to show less consistent of an improvement for whatever
reason, but regardless I suspect this is too devious to consider even as
a temporary fix.

So all in all none of these options are proper long term solutions, but
the long term solutions all seem complex enough to me that I'd prefer to
take the incremental step of a mitigating fix before getting too deep
into the weeds on fixing zeroing properly.

Thoughts, reviews, flames appreciated.

Brian

[1] https://lore.kernel.org/linux-mm/20221028125428.976549-1-bfoster@redhat.com/

Brian Foster (2):
  xfs: lift truncate iomap zeroing into a new helper
  xfs: optimize eof page flush for iomap zeroing on truncate

 fs/xfs/xfs_iops.c | 84 +++++++++++++++++++++++++++++++++++++----------
 1 file changed, 66 insertions(+), 18 deletions(-)

-- 
2.37.3

