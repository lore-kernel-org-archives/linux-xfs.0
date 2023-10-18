Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D862CDB482
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Oct 2023 15:52:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232279AbjJRPwa (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 18 Oct 2023 11:52:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231764AbjJRPw3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 Oct 2023 11:52:29 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F39A111;
        Wed, 18 Oct 2023 08:52:25 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 652F067373; Wed, 18 Oct 2023 17:52:20 +0200 (CEST)
Date:   Wed, 18 Oct 2023 17:52:20 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Jan Stancek <jstancek@redhat.com>
Cc:     Christoph Hellwig <hch@lst.de>, djwong@kernel.org,
        willy@infradead.org, linux-xfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        viro@zeniv.linux.org.uk
Subject: Re: [PATCH] iomap: fix short copy in iomap_write_iter()
Message-ID: <20231018155220.GA26845@lst.de>
References: <8762e91a210f4cc5713fce05fe5906c18513bd0a.1697617238.git.jstancek@redhat.com> <20231018122220.GB10751@lst.de> <CAASaF6xHTv6iZd5ttHOJ_M=hpjaGZOnUCGSHkbGy_yLbe2G8nw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAASaF6xHTv6iZd5ttHOJ_M=hpjaGZOnUCGSHkbGy_yLbe2G8nw@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Oct 18, 2023 at 04:32:19PM +0200, Jan Stancek wrote:
> On Wed, Oct 18, 2023 at 2:22 PM Christoph Hellwig <hch@lst.de> wrote:
> >
> > On Wed, Oct 18, 2023 at 10:24:20AM +0200, Jan Stancek wrote:
> > > Make next iteration retry with amount of bytes we managed to copy.
> >
> > The observation and logic fix look good.  But I wonder if simply
> > using a goto instead of the extra variable would be a tad cleaner?
> > Something like this?
> 
> Looks good to me. Would you be OK if I re-posted it as v2 with your
> Signed-off-by added?

Please skip my signoff.  This is really your work and I just a very
cosmetic suggestion.

