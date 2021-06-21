Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB8F4C49EA2
	for <linux-xfs@archiver.kernel.org>; Mon, 21 Jun 2021 05:26:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B6B486108E
	for <linux-xfs@archiver.kernel.org>; Mon, 21 Jun 2021 05:26:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229710AbhFUF2W (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 21 Jun 2021 01:28:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229486AbhFUF2V (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 21 Jun 2021 01:28:21 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8662C061574;
        Sun, 20 Jun 2021 22:26:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=6T7KfXP3oFEb52sQgAVbd3KwsqUgUH+8ZFfQLlGrDgA=; b=St3U462J50H6LgdS0slzkgXo2S
        56yO45Wqj/+f86xeKHXx/nb/D9ci4tlMkXEwQpcAE7vHbpQJUZStBpNJqUmYGXbvNhvvagKGDVhbp
        2+xYq/vEzQ0/oXKJ+zCVgGsIVQS23C6Ivjjev4hGFDDQFN1w5yATsBDAVw6R5Iucqx3KBkIPUCOfJ
        dP/FqzVtFL3u4zr3T+ZB55B2Q9955/J/o664tSMUYGUyAmR/nFfWtIQRrBAQnzRaWhvWEvDzDcOpa
        GcxhOF1oIM+MX71g46HC6WUpUqH48wrHFLiIfHwClEgGN/hP0zjbnwKG2idZXtscNGkW9lMZqEC5u
        bPIeBymA==;
Received: from hch by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1lvCQs-00CkYh-OJ; Mon, 21 Jun 2021 05:25:20 +0000
Date:   Mon, 21 Jun 2021 06:25:14 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Amir Goldstein <amir73il@gmail.com>,
        Christoph Hellwig <hch@infradead.org>,
        Eryu Guan <guaneryu@gmail.com>,
        Chandan Babu R <chandanrlinux@gmail.com>,
        Allison Henderson <allison.henderson@oracle.com>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        fstests <fstests@vger.kernel.org>, Eryu Guan <guan@eryu.me>,
        ebiggers@kernel.org
Subject: Re: [PATCH 07/13] fstests: automatically generate group files
Message-ID: <YNAiutsL1f/KoBXM@infradead.org>
References: <162370433910.3800603.9623820748404628250.stgit@locust>
 <162370437774.3800603.15907676407985880109.stgit@locust>
 <YMmpDGT9b4dBdSh2@infradead.org>
 <20210617001320.GK158209@locust>
 <YMsAEQsNhI1Y5JR8@infradead.org>
 <20210617171500.GC158186@locust>
 <YMyjgGEuLLcid9i+@infradead.org>
 <CAOQ4uxjvkJh2XcfDgj7g+JUkFXEc36_6YOKQHJ=pX2hpGfUDhQ@mail.gmail.com>
 <20210618155630.GE158209@locust>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210618155630.GE158209@locust>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jun 18, 2021 at 08:56:30AM -0700, Darrick J. Wong wrote:
> On Fri, Jun 18, 2021 at 06:32:18PM +0300, Amir Goldstein wrote:
> > On Fri, Jun 18, 2021 at 4:47 PM Christoph Hellwig <hch@infradead.org> wrote:
> > >
> > > On Thu, Jun 17, 2021 at 10:15:00AM -0700, Darrick J. Wong wrote:
> > > > I suppose I could make the '-g' switch call 'make group.list', though
> > > > that's just going to increase the amount of noise for anyone like me who
> > > > runs fstests with a mostly readonly rootfs.
> > >
> > > Just stick to the original version and see if anyone screams loud
> > 
> > What is the original version?
> 
> Assuming the developer is smart enough to run 'make all install' before
> running fstests.

So install is also required now?  I have never before installed xfstests
I think.

