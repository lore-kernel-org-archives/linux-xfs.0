Return-Path: <SRS0=ODsa=5J=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F6D4C4332B
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Mar 2020 08:38:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6FD1C20724
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Mar 2020 08:38:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="IFzRIMRL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726231AbgCXIiA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 24 Mar 2020 04:38:00 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:33140 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726129AbgCXIiA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 24 Mar 2020 04:38:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=w0tf+LzLJgcsDnMH9vZGmgZTed6vh6jn/5MMwqLl++w=; b=IFzRIMRL9LS1VQlsAqCfwy+lvc
        a59rPM7MkWSfUYSOy84zBKgv1fR8cWlMLg1qWqcXZPMfObCwn/XHHNDlzD3Yiz2EICORO5Ksw2gzQ
        ER+Q12eJvjfUp/BZsuyRrZW+Y3cJO/m0CzGzidqSucoDuWOOuUrVBGoWR900mfu43SuaFxnV1B5gF
        RRqozVgDapH3/ealfBN7P+DO5Y1VXniV9PPFfXxQ99NjvGuZ7UgZDEc+BocOz+yIFT0e2NfwQtYFV
        R5dX+/pCSuO0lCHde6rD9OUloG7icXWWS8HJ/ytpMJIsU6Xsps1swne+8uunIuqh++NeH16bts4iN
        fnIeJjSg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jGf4R-00029L-74; Tue, 24 Mar 2020 08:37:59 +0000
Date:   Tue, 24 Mar 2020 01:37:59 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Theodore Y. Ts'o" <tytso@mit.edu>
Cc:     Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>,
        Ext4 Developers List <linux-ext4@vger.kernel.org>,
        linux-f2fs-devel@lists.sourceforge.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] writeback, xfs: call dirty_inode() with
 I_DIRTY_TIME_EXPIRED when appropriate
Message-ID: <20200324083759.GA32036@infradead.org>
References: <20200320024639.GH1067245@mit.edu>
 <20200320025255.1705972-1-tytso@mit.edu>
 <20200320025255.1705972-2-tytso@mit.edu>
 <20200323175838.GA7133@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200323175838.GA7133@mit.edu>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Mar 23, 2020 at 01:58:38PM -0400, Theodore Y. Ts'o wrote:
> Christoph, Dave --- does this give you the notification that you were
> looking such that XFS could get the notification desired that it was
> the timestamps need to be written back?

I need to look at it in more detail as it seems convoluted.  Also the
order seems like you regress XFS in patch 1 and then fix it in patch 2?
