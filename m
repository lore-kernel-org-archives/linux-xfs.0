Return-Path: <SRS0=tkkj=YB=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19254C4360C
	for <linux-xfs@archiver.kernel.org>; Tue,  8 Oct 2019 07:00:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D77A120867
	for <linux-xfs@archiver.kernel.org>; Tue,  8 Oct 2019 07:00:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="dG1xC6Id"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730112AbfJHHAF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 8 Oct 2019 03:00:05 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:50142 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730083AbfJHHAF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 8 Oct 2019 03:00:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=bJ9fjyOv/CeGOSfMNazXcUXcfCpU1Ii9J64PhV7wC+k=; b=dG1xC6IdoCdBXyC24n1otQqC9
        AGY/0epjI02nw5UBgn1pYO34Ddy8t0dakn7jvKJM2nYzllrhiqDjrKQlYPdHALj5cG72Y2PpYG8mt
        Y2v9TFHPeuuTmY65pOeqKPBqwW2op+xUdLwnx2nnNgNTjvSwlTvD27vIg5NnmhwYSy5LMUfUExIFO
        xdGQMZDTGr3H35nl4uMJef7d9itxyasoBlzg+sK5LtyOloZTMcl0/CBL+MUqiBmQoZi/PmV4bbypx
        sRGaqOgbhZ6BZYS5KiR5R3ANGfTWKAhIby/4t7l5S1GLP4YuDE+cCWJnsodOHIvK2509dr8imnnHC
        oxrpKB3vw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.2 #3 (Red Hat Linux))
        id 1iHjTZ-0006NE-4Z; Tue, 08 Oct 2019 07:00:05 +0000
Date:   Tue, 8 Oct 2019 00:00:05 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2 2/3] xfs: remove broken error handling on failed attr
 sf to leaf change
Message-ID: <20191008070005.GB21805@infradead.org>
References: <20191007131938.23839-1-bfoster@redhat.com>
 <20191007131938.23839-3-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191007131938.23839-3-bfoster@redhat.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Oct 07, 2019 at 09:19:37AM -0400, Brian Foster wrote:
> xfs_attr_shortform_to_leaf() attempts to put the shortform fork back
> together after a failed attempt to convert from shortform to leaf
> format. While this code reallocates and copies back the shortform
> attr fork data, it never resets the inode format field back to local
> format. Further, now that the inode is properly logged after the
> initial switch from local format, any error that triggers the
> recovery code will eventually abort the transaction and shutdown the
> fs. Therefore, remove the broken and unnecessary error handling
> code.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
