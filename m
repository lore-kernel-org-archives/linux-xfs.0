Return-Path: <SRS0=CuST=WZ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 560CEC3A59F
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Aug 2019 11:02:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2027120828
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Aug 2019 11:02:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="IL6cIuhw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727073AbfH2LCA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 29 Aug 2019 07:02:00 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:41330 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726979AbfH2LCA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Aug 2019 07:02:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=oIWQn6hP09YNbOE/DfP9oYO6VgW2UZb9gb5LXZPoCSQ=; b=IL6cIuhwKVgBsXe6ZLNlDFFXw
        LL/dIzHiovDRo8n5HwxzE3cCLd6wj9GAsBHDPJ5N6EN3SQSez+pQj1XvpEkXfQPAQf94kqp8Chgir
        xqMWMehgegCVN2YmNExO5A9yek79BNFmAmWupz9cwwN45hVC5vJ8vMnmEo+kVv/1L7tsuWgiQzl+7
        SXus1HokdDNarHJJvcmHmnHbeERjiaSFoXpJIt4kFfGkGwoex++VgcyIhwbOzcOB5Trx6piK25n1/
        I6+JcEHzXhwIBnANCt/xrk2fH0JYUXTdk7BK/Jps+NMH4ooWuStkM0PKHMZR9oQOiEiRl7s5JPkkh
        OSJuddYOw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92 #3 (Red Hat Linux))
        id 1i3IBk-0004E1-Bb; Thu, 29 Aug 2019 11:02:00 +0000
Date:   Thu, 29 Aug 2019 04:02:00 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/3] xfs: allocate xattr buffer on demand
Message-ID: <20190829110200.GA16151@infradead.org>
References: <20190828042350.6062-1-david@fromorbit.com>
 <20190828042350.6062-4-david@fromorbit.com>
 <20190829075559.GC18966@infradead.org>
 <20190829104516.GU1119@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190829104516.GU1119@dread.disaster.area>
User-Agent: Mutt/1.11.4 (2019-03-13)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Aug 29, 2019 at 08:45:16PM +1000, Dave Chinner wrote:
> > Given that all three callers pass ATTR_ALLOC, do we even need a flag
> 
> Only one caller passes ATTR_ALLOC - the ACL code. The other two
> have their own buffers that are supplied....

Oops, I misread the patch as all three callers changed, but not
actually to pass the flag but just for the different buffer passing.

That being said - xfs_attrmulti_attr_get can trivially use this
scheme.  And for the VFS call it would also make sense, but it
would be a huge change, so maybe some other time.

> Can't overwrite args->valuelen until we've done the ERANGE check.
> Sure, I could put it in a local variable, but that doesn't reduce
> the amount of code, or make it obvious that we intentionally return
> the attribute size when the supplied buffer it too small...

Ok.
