Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 211B3C48BDF
	for <linux-xfs@archiver.kernel.org>; Fri, 18 Jun 2021 14:03:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E332F61222
	for <linux-xfs@archiver.kernel.org>; Fri, 18 Jun 2021 14:03:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231680AbhFROFL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 18 Jun 2021 10:05:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230387AbhFROFL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 18 Jun 2021 10:05:11 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16EB1C061574
        for <linux-xfs@vger.kernel.org>; Fri, 18 Jun 2021 07:03:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=Oi7Q+l5XuP7Lu9IEBwTrQA3jLuXfzuenQAxAdpKWUhc=; b=oAkdlpgtTNUsX1fLr301cBtXsS
        ndW9RfOekY0h/ibdB2F3s0dH5o/q8EiU2V/bzd1IX7OFP3s65IWBa5t7flpo5z+FollB3cRygxh9q
        q7lYj9srBXoRSw9/6TkUacePkzGS8JKlZuEuNC4NIWP4/ot6PtBKhYO/at36F/bGN0fTBXiauyH7b
        ut/LUnxStxCnSBNfSTnsKkBmnZBSj+5rJ2iu9mSItI9paBuREaIYrIuL/JXEN2riUTbJy/wAbUjAj
        yvPa+F5IgQQzSY6cPIroWRGhiW7qWgLcOMyrm7hinj+onBqfqOE3BDl8UrITm7ypymygAQtEmecfm
        Q2+ectBw==;
Received: from hch by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1luF4y-00AKrb-BF; Fri, 18 Jun 2021 14:02:45 +0000
Date:   Fri, 18 Jun 2021 15:02:40 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Brian Foster <bfoster@redhat.com>
Cc:     Dave Chinner <david@fromorbit.com>,
        "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 0/8 V2] xfs: log fixes for for-next
Message-ID: <YMyngMnug7NooDR9@infradead.org>
References: <20210617082617.971602-1-david@fromorbit.com>
 <YMuVPgmEjwaGTaFA@bfoster>
 <20210617190519.GV158209@locust>
 <20210617234308.GH664593@dread.disaster.area>
 <YMyav1+JiSlQbDFH@bfoster>
 <YMyltwuBKbfnIUvw@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YMyltwuBKbfnIUvw@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jun 18, 2021 at 02:55:03PM +0100, Christoph Hellwig wrote:
> xlog_write_single is always entered first by xlog_write, so we also
> get here for something that later gets handled by xlog_write_partial.
> Which means it could be way bigger than the current iclog, and I see no
> reason why that iclog would have to be XLOG_STATE_WANT_SYNC.

Actually I'll take that back.  There is a second call to
xlog_state_switch_iclogs which we should hit and thus have moved to
XLOG_STATE_WANT_SYNC.
