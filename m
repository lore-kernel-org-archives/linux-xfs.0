Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD573C48BDF
	for <linux-xfs@archiver.kernel.org>; Fri, 18 Jun 2021 13:55:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AB6866117A
	for <linux-xfs@archiver.kernel.org>; Fri, 18 Jun 2021 13:55:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233840AbhFRN5n (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 18 Jun 2021 09:57:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233754AbhFRN5m (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 18 Jun 2021 09:57:42 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E8DCC061574
        for <linux-xfs@vger.kernel.org>; Fri, 18 Jun 2021 06:55:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=dmv1F/m7Qj83vKNaWphW2tqT3R0krWjYiXLxb/EDDOQ=; b=PPuoltX7Y84KsM7vNe0j4XqvuQ
        /O2wZvWjS0xEWODsJchmHy6F3jVI/gVbakjerT8Mqhmc2a5ujyVs5dLyicb6xX9VlL4dct8ZA65pV
        fBlBwiJ49omp33KOf4reQIyf8dmyg3nznjm2ZE0gpuc9uNnziqh+iIc8HHptbV8gz0iZyDlxOkkE7
        ehcW8RpfkBggbYbr+A9Sm8OUyO0Si6i57eew63So7opyh6osJWTmUn7fDVcLRwmMwjKC6PhcVmM6H
        qXoB10o/A8MY/sdABLIkqNIx88DAZCbQmMGeEdUkEdoMjGdIejkdmQT6cv3R1oMUVE4YNQj99U+x1
        B2rAbNJw==;
Received: from hch by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1luExb-00AKQo-Fk; Fri, 18 Jun 2021 13:55:11 +0000
Date:   Fri, 18 Jun 2021 14:55:03 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Brian Foster <bfoster@redhat.com>
Cc:     Dave Chinner <david@fromorbit.com>,
        "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 0/8 V2] xfs: log fixes for for-next
Message-ID: <YMyltwuBKbfnIUvw@infradead.org>
References: <20210617082617.971602-1-david@fromorbit.com>
 <YMuVPgmEjwaGTaFA@bfoster>
 <20210617190519.GV158209@locust>
 <20210617234308.GH664593@dread.disaster.area>
 <YMyav1+JiSlQbDFH@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YMyav1+JiSlQbDFH@bfoster>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jun 18, 2021 at 09:08:15AM -0400, Brian Foster wrote:
> Also FYI, earlier iterations of generic/475 triggered a couple instances
> of the following assert failure before things broke down more severely:
> 
>  XFS: Assertion failed: *log_offset + *len <= iclog->ic_size || iclog->ic_state == XLOG_STATE_WANT_SYNC, file: fs/xfs/xfs_log.c, line: 2115

As you mentioned the placement of this exact assert in my cleanups
series:  after looking at a right place to move it, I'm really not sure
this assert makes much sense in this form.

xlog_write_single is always entered first by xlog_write, so we also
get here for something that later gets handled by xlog_write_partial.
Which means it could be way bigger than the current iclog, and I see no
reason why that iclog would have to be XLOG_STATE_WANT_SYNC.
