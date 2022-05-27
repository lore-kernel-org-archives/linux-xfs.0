Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D8A4C433EF
	for <linux-xfs@archiver.kernel.org>; Fri, 27 May 2022 15:40:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346319AbiE0PkV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 27 May 2022 11:40:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237983AbiE0PkU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 27 May 2022 11:40:20 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 612CD108A9B;
        Fri, 27 May 2022 08:40:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=1im2zbHEc3hQkZgSdxFkdu60S9CPZEI+N3LtuKc0Sq0=; b=hkhSk2Nn++xzvaOl8s8FlU+05o
        W7XrKZZET/qU5A4DD4TAsVlpiTxuEJjVpnywcqi8r50zywK9QCjd9FUjy+TbXd0YwJqPJGUUJ7rXN
        iB6D3Sutbcx+66qwG88fSCy4uKC4vFXV5Dm6KmYHkuxpp4zvkMT5AWpgTJlMUUQmZCM1IBLf1oTi5
        0A/MxHZzObmjN7IqmdnjrSjIvC+OE+rRcbB3u4tXfSMNHoWS16/ZVSjLj5B0lN7sRJpbFRL07EwpP
        2LAQIMa+A00MdH88iEZW64OI55YMHPqa24M0hPJPkSvQjP29N2AuaqFesHprA9UcFdWweA0BNGQzk
        n/69HxJA==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nuc4U-000RWN-Fj; Fri, 27 May 2022 15:40:14 +0000
Date:   Fri, 27 May 2022 08:40:14 -0700
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        Theodore Ts'o <tytso@mit.edu>,
        Adam Manzanares <a.manzanares@samsung.com>,
        Tyler Hicks <code@tyhicks.com>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        fstests <fstests@vger.kernel.org>
Subject: Re: [PATH 5.10 0/4] xfs stable candidate patches for 5.10.y (part 1)
Message-ID: <YpDw3uVFB7LjPquX@bombadil.infradead.org>
References: <20220525111715.2769700-1-amir73il@gmail.com>
 <YpBqfdmwQ675m72G@infradead.org>
 <CAOQ4uxjek9331geZGVbVT=gqkNTyVA_vjyjuB=2eGZD-ufeqNQ@mail.gmail.com>
 <20220527090838.GD3923443@dread.disaster.area>
 <CAOQ4uxgc9Zu0rvTY3oOqycGG+MoYEL3-+qghm9_qEn67D8OukA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxgc9Zu0rvTY3oOqycGG+MoYEL3-+qghm9_qEn67D8OukA@mail.gmail.com>
Sender: Luis Chamberlain <mcgrof@infradead.org>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, May 27, 2022 at 03:24:02PM +0300, Amir Goldstein wrote:
> On Fri, May 27, 2022 at 12:08 PM Dave Chinner <david@fromorbit.com> wrote:
> > Backport candidate: yes. Severe: absolutely not.
> In the future, if you are writing a cover letter for an improvement
> series or internal pull request and you know there is a backport
> candidate inside, if you happen to remember to mention it, it would
> be of great help to me.

Amir, since you wrote a tool enhancement to scrape for possible
candidates, *if* we defined some sort of meta-data to describe
this sort of stuff on the cover letter:

Backport candidate: yes. Severe: absolutely not

It would be useful when scraping. Therefore, leaving the effort
to try to backport / feasibility to others. This would be different
than a stable Cc tag, as those have a high degree of certainty.

How about something like:

Backport-candidate: yes
Impact: low

  Luis
