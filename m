Return-Path: <SRS0=BjFQ=46=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF24BC10DCE
	for <linux-xfs@archiver.kernel.org>; Fri, 13 Mar 2020 06:54:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B4EC92072C
	for <linux-xfs@archiver.kernel.org>; Fri, 13 Mar 2020 06:54:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="V6K5QKrD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726236AbgCMGyh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 13 Mar 2020 02:54:37 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:57630 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726001AbgCMGyh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 13 Mar 2020 02:54:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Transfer-Encoding
        :Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
        Sender:Reply-To:Content-ID:Content-Description;
        bh=D/WRUBEy9og0iQFNiOIwpk+8MHdY18d9fTEkAneuK1U=; b=V6K5QKrDtzMGXqYPMFBWy0Cp3P
        paAg8qDUNzMNnzYLs3jdC0zy8vAqhIpzwz7J9VZ5yOmWqMuq8MYOqLlTa0JiEzM8q0eE8U1WmudM7
        eVbMD/b+424Z0x05/nKCORFybWtPFLy5UGbo3ZeBH/AV72fN6xl27/26sq/2A6/2G2XJ/TbJyY5Jr
        iY6iqfc6brmaiuPyX0kvLIy3+NQ9FwJi/teJ1qMEMHGjlY4R0zBz/BnfKhyONj8Wy68i7xdjtpCMh
        1Mqcpwyzus4yYWdj2jm++ZvsINKfLUKlGOUB4jOHeXZscgHTBnZkPt7UgYQpuCr516Hi+EkIXuTkD
        ejpShLZw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jCeDM-0003Ao-Qc; Fri, 13 Mar 2020 06:54:36 +0000
Date:   Thu, 12 Mar 2020 23:54:36 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Eric Sandeen <sandeen@redhat.com>
Cc:     Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org
Subject: Re: xfsprogs process question
Message-ID: <20200313065436.GB5198@infradead.org>
References: <20200312141351.GA30388@infradead.org>
 <244a8391-77c4-94a1-3bd4-b78c7a1f39ad@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <244a8391-77c4-94a1-3bd4-b78c7a1f39ad@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Mar 12, 2020 at 10:46:47AM -0500, Eric Sandeen wrote:
> Would it help to open a libxfs-sync-$VERSION branch as soon as the kernel
> starts on a new version?

Yes.  I'd just call it for-next, but the name is the least of our
problems :)

> I've never quite understood what the common expectation for a "for-next"
> branch behavior is, though I recognize that my use of it right now is a bit
> unconventional.

Іt really is just a kernel convention due to linux-next.  And I'd just
name the xfsprogs branch to match.  But as said above, the name isn't
really what matters.
