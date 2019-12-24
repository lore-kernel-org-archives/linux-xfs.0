Return-Path: <SRS0=yXRu=2O=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B230C2D0CF
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Dec 2019 11:18:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4AAF420409
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Dec 2019 11:18:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="JJ5eMCCJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726104AbfLXLSl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 24 Dec 2019 06:18:41 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:47458 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726091AbfLXLSl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 24 Dec 2019 06:18:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=1gVMLey5yTdzamj9m0K0blHwy7BBN52QFlQ3m03LwRI=; b=JJ5eMCCJUFlOzchyIy+iWaOaS
        JuFt4BTouneSBlpyeVlA0bjBjIkmVzGCJh8PgjbU1yHTW2OTIfnmIJfkDzywuPwNusAgvtWMKz1HD
        ZA/wQfaxeguL0Xo14wCca8aOrrXrdK8WvcGvk2LupXfKDbh7kDua8zTw+2Myc2v2/5Ns7SiH5aQUn
        gc1eW1//GZRYMy2zNDUcnwz3BzfP21rQ/UQSa7FQfUT1grsE65ZXFUOu6C/C2/c3aBzYKMNoY+KU4
        USZ+K30jl36/HRrD/V3GnfN3iBB5iwJKVhw/3QVidFXeuW5IY2VaLWDbuizlX+rC+eTIWDPCtm1xt
        +mFgjSoTA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1ijiD2-0006S8-W4; Tue, 24 Dec 2019 11:18:40 +0000
Date:   Tue, 24 Dec 2019 03:18:40 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/3] xfs: open code insert range extent split helper
Message-ID: <20191224111840.GA24663@infradead.org>
References: <20191213171258.36934-1-bfoster@redhat.com>
 <20191213171258.36934-2-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191213171258.36934-2-bfoster@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Dec 13, 2019 at 12:12:56PM -0500, Brian Foster wrote:
> The insert range operation currently splits the extent at the target
> offset in a separate transaction and lock cycle from the one that
> shifts extents. In preparation for reworking insert range into an
> atomic operation, lift the code into the caller so it can be easily
> condensed to a single rolling transaction and lock cycle and
> eliminate the helper. No functional changes.

The helper already is rather questionable as-is, so even without looking
at the following patches:

Reviewed-by: Christoph Hellwig <hch@lst.de>
