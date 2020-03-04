Return-Path: <SRS0=37eZ=4V=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19105C3F2CE
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Mar 2020 15:50:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DCD762166E
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Mar 2020 15:50:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="jeeqbcf8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729766AbgCDPui (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 4 Mar 2020 10:50:38 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:51502 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727084AbgCDPui (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 4 Mar 2020 10:50:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=h1LsmnHFqBmQePHQUkRSCl+bWQ8TelOrCLqZc+wE/hs=; b=jeeqbcf88TZFir+lFHRz+mtaqa
        d+0eDYm6qitdp0fCaWCsDXD4SK78saIlvCH5k+y3ezmKvTlmg+quMZ+EO0+h9bsP+e45RGNRLKQDw
        WEO3LjeM2lsMUk7xZ62tVEuApLPOyq3mHcUtkinqVhejqO7RHpt9hS8pKUxP8N38Z2r1IqZ/i6U3n
        wasPRG2ZD2QDPDS2+Sb76q98T8XP2FspE1pb+Fow90MLWK9Pmx7eEsXbhsOLcUVgR1ENYFoQes/xx
        4kiEki3J7Z7nazCGN0r9HNWNkbIodv4HGYQQRH6CzOPVKhTZrjWM14ipSzSoDOfWDpC0xyQlRBET4
        97DEyjxg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1j9WIA-0001o4-2B; Wed, 04 Mar 2020 15:50:38 +0000
Date:   Wed, 4 Mar 2020 07:50:38 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 04/11] xfs: merge xlog_commit_record with
 xlog_write_done()
Message-ID: <20200304155038.GC17565@infradead.org>
References: <20200304075401.21558-1-david@fromorbit.com>
 <20200304075401.21558-5-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200304075401.21558-5-david@fromorbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Mar 04, 2020 at 06:53:54PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> xlog_write_done() is just a thin wrapper around
> xlog_commit_record(), so they can be merged together easily. Convert
> all the xlog_commit_record() callers to use xlog_write_done() and
> merge the implementations.

Ok, you are doing the merge here.  I think it would be nicer to just
simply do that from the beginning, though.
