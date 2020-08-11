Return-Path: <SRS0=LlZ6=BV=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DA89C433E0
	for <linux-xfs@archiver.kernel.org>; Tue, 11 Aug 2020 20:56:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 640AD2076C
	for <linux-xfs@archiver.kernel.org>; Tue, 11 Aug 2020 20:56:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Dkn+1kic"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726485AbgHKU4o (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 11 Aug 2020 16:56:44 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:33760 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726483AbgHKU4n (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 11 Aug 2020 16:56:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597179402;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=nptAvAbieGgAsdVwEL6o5uM4SV8m4ZGCyIjcHhTmuOg=;
        b=Dkn+1kic/28AmL0B2dzyZRciQAXdd1/8lk/jD+tjHmv4mQwFuJOfyzSxlCBUcjNpxkfygV
        N3nBG9qvfrksGBwkp+MHPMHZ0Ok1TXM/pgPzwZ0yc3sAq7H9HOIm3zb4zxrrIxRFyfK6ks
        g71xngoC6ZcswAUlgwyfoMGWwvtx31g=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-326-Xj3AH3BLOp-8AiXzmT6XRw-1; Tue, 11 Aug 2020 16:56:40 -0400
X-MC-Unique: Xj3AH3BLOp-8AiXzmT6XRw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 66FA61093082;
        Tue, 11 Aug 2020 20:56:39 +0000 (UTC)
Received: from segfault.boston.devel.redhat.com (segfault.boston.devel.redhat.com [10.19.60.26])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id BC7971A921;
        Tue, 11 Aug 2020 20:56:38 +0000 (UTC)
From:   Jeff Moyer <jmoyer@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Dave Chinner <david@fromorbit.com>,
        bugzilla-daemon@bugzilla.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [Bug 208827] [fio io_uring] io_uring write data crc32c verify failed
References: <bug-208827-201763@https.bugzilla.kernel.org/>
        <bug-208827-201763-ubSctIQBY4@https.bugzilla.kernel.org/>
        <20200810000932.GH2114@dread.disaster.area>
        <20200810035605.GI2114@dread.disaster.area>
        <20200810070807.GJ2114@dread.disaster.area>
        <20200810090859.GK2114@dread.disaster.area>
        <eeb0524b-3aa7-0f5f-22a6-f7faf2532355@kernel.dk>
        <1e2d99ff-a893-9100-2684-f0f2c2d1b787@kernel.dk>
        <cd94fcfb-6a8f-b0f4-565e-74733d71d7c3@kernel.dk>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
Date:   Tue, 11 Aug 2020 16:56:37 -0400
In-Reply-To: <cd94fcfb-6a8f-b0f4-565e-74733d71d7c3@kernel.dk> (Jens Axboe's
        message of "Mon, 10 Aug 2020 20:01:27 -0600")
Message-ID: <x49zh70zyt6.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Jens Axboe <axboe@kernel.dk> writes:

> So it seems to me like the file state is consistent, at least after the
> run, and that this seems more likely to be a fio issue with short
> read handling.

Any idea why there was a short read, though?

-Jeff

