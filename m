Return-Path: <SRS0=R4OI=CF=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB54CC433DF
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Aug 2020 08:14:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7BFC62177B
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Aug 2020 08:14:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="qeQdI0+c"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726826AbgH0IOa (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 27 Aug 2020 04:14:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726395AbgH0IO3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Aug 2020 04:14:29 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B52BC061264
        for <linux-xfs@vger.kernel.org>; Thu, 27 Aug 2020 01:14:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=i6G5e8Uz8lVnwnx8ZWr/8TQjTN5K8gFBVIvG6VDmyqM=; b=qeQdI0+cvUv6mATez/+v5lItFn
        F7hGGGeqiHYXeS6WhIZPVDq15VljFTih7bghhVNTqw3Rl1i5gyen9wZzb02Z/OCwfHTc8rBCRcL+P
        wERBJX+yzg3Cjzk0V++y6xyEWiz25y4qg+Zj/Q+5i1VcZK5fT5lcFo/0B20HTyUK/vrqkAzwXAv7X
        QV9u0eu9vZnw3Ae+6nrTlcpSUc0qqResBzABFEgBAFg1DpIwqtUMsLJ7l2cipvzgG+srAMqUz6Onc
        luA9HAZRDY3I24fbRRmEpfvs4ZFALuTzILGdJxr8eZTh1niwlQEqIqyYAtqyUsCmSpogc5b/vAkUD
        f+Fn0JHg==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kBD3C-0002Mu-97; Thu, 27 Aug 2020 08:14:26 +0000
Date:   Thu, 27 Aug 2020 09:14:26 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-xfs@vger.kernel.org, Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] xfs: initialize the shortform attr header padding entry
Message-ID: <20200827081426.GD7605@infradead.org>
References: <20200825202853.GE6096@magnolia>
 <1c61a2a6-42aa-55b9-49e3-57541b7dae80@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1c61a2a6-42aa-55b9-49e3-57541b7dae80@sandeen.net>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Aug 25, 2020 at 03:48:13PM -0500, Eric Sandeen wrote:
> On 8/25/20 3:28 PM, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Don't leak kernel memory contents into the shortform attr fork.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> 
> I noticed this too, thanks.
> 
> thought I wonder if 
> 
> a) others lurk and
> b) if we should just be memsetting if_data to zero to avoid the need
>    to carefully initialize all of everything always?
> 
> Anyway it fixes the problem we noticed so

Yes, I think fully clearing the thing would be better.  We can do
a memset for now, but splitting the non-existent data case out of
xfs_idata_realloc into a new helper that does kzmalloc sounds best
long term.
