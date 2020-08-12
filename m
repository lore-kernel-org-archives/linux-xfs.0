Return-Path: <SRS0=vsMz=BW=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17841C433DF
	for <linux-xfs@archiver.kernel.org>; Wed, 12 Aug 2020 15:24:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D8414207F7
	for <linux-xfs@archiver.kernel.org>; Wed, 12 Aug 2020 15:24:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PPNyaH+l"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726477AbgHLPYS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 12 Aug 2020 11:24:18 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:21634 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726226AbgHLPYP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 12 Aug 2020 11:24:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597245852;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=7qxoaFZi7LOtc05kjRfqfAqAvTG1AzpTDVdRlH1Navs=;
        b=PPNyaH+lRjCcPWs7TAu7QOzMvydcCcdr82qu4tica+RzlhsMoVYluyv1xhuvpMTB8FmIzx
        OWn058nMIFejsd4jsv+vtkgWmbToZRjVz2JFTwilRlrO0NSfyCWyjAGm8n8Qc54YU3Sfbz
        XFg6rLzq3uJYHfAHWf5j/515HXoDriM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-311-lU9_jMx7NWC1KjbVeF5RvA-1; Wed, 12 Aug 2020 11:24:10 -0400
X-MC-Unique: lU9_jMx7NWC1KjbVeF5RvA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5CF83802816;
        Wed, 12 Aug 2020 15:24:09 +0000 (UTC)
Received: from segfault.boston.devel.redhat.com (segfault.boston.devel.redhat.com [10.19.60.26])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id F10C25DA69;
        Wed, 12 Aug 2020 15:24:08 +0000 (UTC)
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
        <x49zh70zyt6.fsf@segfault.boston.devel.redhat.com>
        <20200811220929.GQ2114@dread.disaster.area>
        <a36fb6bd-ed0b-6eda-83be-83c0e7b377ce@kernel.dk>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
Date:   Wed, 12 Aug 2020 11:24:07 -0400
In-Reply-To: <a36fb6bd-ed0b-6eda-83be-83c0e7b377ce@kernel.dk> (Jens Axboe's
        message of "Wed, 12 Aug 2020 09:13:58 -0600")
Message-ID: <x49v9hnzy3s.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Jens Axboe <axboe@kernel.dk> writes:

> Yes, it would ideally wait, or at least trigger on the last one. I'll
> see if I can improve that. For any of my testing, the amount of
> triggered short reads is minimal. For the verify case that we just ran,
> we're talking 8-12 ios out of 820 thousand, or 0.001% of them. So
> nothing that makes a performance difference in practical terms, though
> it would be nice to not hand back short reads if we can avoid it. Not
> for performance reasons, but for usage reasons.

I think you could make the case that handing back a short read is a
bug (unless RWF_NOWAIT was specified, of course).  At the very least, it
violates the principle of least surprise, and the fact that it happens
infrequently actually makes it a worse problem when it comes to
debugging.

-Jeff

