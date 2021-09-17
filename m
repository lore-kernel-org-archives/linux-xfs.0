Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1E31C433EF
	for <linux-xfs@archiver.kernel.org>; Fri, 17 Sep 2021 11:04:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CB926611CA
	for <linux-xfs@archiver.kernel.org>; Fri, 17 Sep 2021 11:04:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242342AbhIQLGT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 17 Sep 2021 07:06:19 -0400
Received: from verein.lst.de ([213.95.11.211]:44656 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233439AbhIQLGT (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 17 Sep 2021 07:06:19 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 12D3867357; Fri, 17 Sep 2021 13:04:55 +0200 (CEST)
Date:   Fri, 17 Sep 2021 13:04:54 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     David Howells <dhowells@redhat.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-ext4@vger.kernel.org,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: Could we get an IOCB_NO_READ_HOLE?
Message-ID: <20210917110454.GA10535@lst.de>
References: <2315872.1631874463@warthog.procyon.org.uk> <2349284.1631875439@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2349284.1631875439@warthog.procyon.org.uk>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Sep 17, 2021 at 11:43:59AM +0100, David Howells wrote:
> David Howells <dhowells@redhat.com> wrote:
> 
> > Would it be possible to get an IOCB_NO_READ_HOLE flag that causes a read to
> > either fail entirely if there's a hole in the file or to stop at the hole,
> > possibly returning -ENODATA if the hole is at the front of the file?
> > 
> > Looking at iomap_dio_iter(), IOMAP_HOLE should be enabled in
> > iomap_iter::iomap.type for this?  Is it that simple?
> 
> Actually, that's not the right thing.  How about the attached - at least for
> direct I/O?

This looks pretty reasonable.  We'll just need to make sure to reject
the flag for the many file operations instances that do not support it.
