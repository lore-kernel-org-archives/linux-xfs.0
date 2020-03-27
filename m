Return-Path: <SRS0=eBbo=5M=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B29DC43331
	for <linux-xfs@archiver.kernel.org>; Fri, 27 Mar 2020 12:59:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F132E2082D
	for <linux-xfs@archiver.kernel.org>; Fri, 27 Mar 2020 12:59:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="RpHs2d81"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727336AbgC0M7x (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 27 Mar 2020 08:59:53 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:44750 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726742AbgC0M7x (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 27 Mar 2020 08:59:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=Aee7hvwktIHriEt5BjH9V4/wOYIADHhGe/p3kn49Kb0=; b=RpHs2d81ErNAk+JvsfiFFC/UcQ
        iMiD+P5NblsTBpgPoShjCveRrrj4g072zeDygdBJFRE9GeX1MzWy+YKw6jNDruVPBQ4pmSYVQL0BO
        zy0yyTfK0nS4vRZNm9vCmP/XluGMxNGLQbbG7EBm2C2vjbg9WEbuwdcqXgainLpB+Vob6inwcrucd
        Memz2jElL0Zx9THZQBT6KzVhdDu0693U0NLroKUSbCjW1KfNPNp8UaiIW/pq795p/TK78+PBUtb1g
        sq60KspFWrz+mM4cRXZr9Z6qlRIEqImZqJN5hwwSz+NEr+ahoCdA+ZZm5KD5V/TDAoZEibDHqLOrL
        xKJl/LgQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jHoaX-0005eL-Ad; Fri, 27 Mar 2020 12:59:53 +0000
Date:   Fri, 27 Mar 2020 05:59:53 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs: trylock underlying buffer on dquot flush
Message-ID: <20200327125953.GA20273@infradead.org>
References: <20200326131703.23246-1-bfoster@redhat.com>
 <20200326131703.23246-2-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200326131703.23246-2-bfoster@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Mar 26, 2020 at 09:17:02AM -0400, Brian Foster wrote:
> A dquot flush currently blocks on the buffer lock for the underlying
> dquot buffer. In turn, this causes xfsaild to block rather than
> continue processing other items in the meantime. Update
> xfs_qm_dqflush() to trylock the buffer, similar to how inode buffers
> are handled, and return -EAGAIN if the lock fails. Fix up any
> callers that don't currently handle the error properly.

Looks good, seems like the two remaining xfs_qm_dqflush have
sensible -EAGAIN handling.

Reviewed-by: Christoph Hellwig <hch@lst.de>

