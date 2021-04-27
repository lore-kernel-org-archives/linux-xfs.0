Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96C05C433B4
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Apr 2021 19:57:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 641EE613C8
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Apr 2021 19:57:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235974AbhD0T6O (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 27 Apr 2021 15:58:14 -0400
Received: from verein.lst.de ([213.95.11.211]:46599 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235719AbhD0T6O (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 27 Apr 2021 15:58:14 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id F007B68B05; Tue, 27 Apr 2021 21:57:27 +0200 (CEST)
Date:   Tue, 27 Apr 2021 21:57:27 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     "Darrick J. Wong" <djwong@kernel.org>, Jia He <justin.he@arm.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        Dave Chinner <david@fromorbit.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Eric Sandeen <sandeen@sandeen.net>,
        Christoph Hellwig <hch@lst.de>
Subject: Re: [GIT PULL] iomap: new code for 5.13-rc1
Message-ID: <20210427195727.GA9661@lst.de>
References: <20210427025805.GD3122264@magnolia> <CAHk-=wj6XUGJCgsr+hx3rz=4KvBP-kspn3dqG5v-cKMzzMktUw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wj6XUGJCgsr+hx3rz=4KvBP-kspn3dqG5v-cKMzzMktUw@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Apr 27, 2021 at 12:40:09PM -0700, Linus Torvalds wrote:
> We have '%pD' for printing a filename. It may not be perfect (by
> default it only prints one component, you can do "%pD4" to show up to
> four components), but it should "JustWork(tm)".
> 
> And if it doesn't, we should fix it.
> 
> So instead of having a kmalloc/kfree for the path buffer, I think you
> should have been able to just do
> 
>     pr_err("swapon: file %pD4 %s\n", isi->file, str);
> 
> and be done with it.

I'm aware of %pD, but 4 components here are not enough.  People
need to distinguish between xfstests runs and something real in
the system for these somewhat scary sounding messages.
