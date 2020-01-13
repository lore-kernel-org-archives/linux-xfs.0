Return-Path: <SRS0=9ni0=3C=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 259C1C33CA9
	for <linux-xfs@archiver.kernel.org>; Mon, 13 Jan 2020 19:17:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E997F21556
	for <linux-xfs@archiver.kernel.org>; Mon, 13 Jan 2020 19:17:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="CS1+6M+H"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728516AbgAMTRU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 13 Jan 2020 14:17:20 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:39844 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726878AbgAMTRU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 13 Jan 2020 14:17:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=pnrnJUL3meO7e1NBiM9HlyO1v6zxCbpBycwSdqVWSGE=; b=CS1+6M+HVo6LgPrWOqRrh6w2m
        HmNe2tACzwRn5Ds0L5Xkp1X4TUFFBRGwG+cYC0L+3wb4vPxVrsumKae8SObfGz9+z0Dh7aJHQjL4R
        WtPxY/O0DRuHPTeFydLaanrTPhvpFgLkO/T0qtLZNP52+82DJeQxw2P57RXM3HCCenioThAxFqMtu
        Wdp+Kol2qyI1YGxKG6+rmP5Elvj302MqxXyXBJ2vG3L2WPxm2VxmXZAT6zEf1wnXXZLnMLKgXqBaD
        ISO5hIHnbY4y9619unkDbnW4fWFUXGsklbUHzrxIZLImf2Les/HmOtc+tEAbCQuT+CdLk3KcLuzg8
        HPXv0n3bw==;
Received: from willy by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1ir5DD-0000bp-Tu; Mon, 13 Jan 2020 19:17:19 +0000
Date:   Mon, 13 Jan 2020 11:17:19 -0800
From:   Matthew Wilcox <willy@infradead.org>
To:     Daniel Wagner <dwagner@suse.de>
Cc:     linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, jlayton@kernel.org, hch@infradead.org
Subject: Re: [PATCH 4/8] mm/fs: Add a_ops->readahead
Message-ID: <20200113191719.GD332@bombadil.infradead.org>
References: <20200113153746.26654-1-willy@infradead.org>
 <20200113153746.26654-5-willy@infradead.org>
 <20200113182242.byzbv5frzyymbddi@beryllium.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200113182242.byzbv5frzyymbddi@beryllium.lan>
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jan 13, 2020 at 07:22:42PM +0100, Daniel Wagner wrote:
> > +	int (*readahead)(struct file *, struct address_space *,
> > +			struct pagevec *, pgoff_t index);
> 
> Shouldn't this be no return type? Just trying to map your commit
> message to the code.

Yes, I'll fix it.  I'm not really impressed with the filesystem
documentation at this point; I feel like more could be automated and
there's too much duplication.

> Maybe I just miss the point, in the case, sorry for the noise.

Well, mostly I'm looking for architectural and design feedback.  I have
compiled this code, but not run it.
