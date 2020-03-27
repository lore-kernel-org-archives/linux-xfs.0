Return-Path: <SRS0=eBbo=5M=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D946FC43331
	for <linux-xfs@archiver.kernel.org>; Fri, 27 Mar 2020 09:06:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AD30220716
	for <linux-xfs@archiver.kernel.org>; Fri, 27 Mar 2020 09:06:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="KjgutwPz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726063AbgC0JGM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 27 Mar 2020 05:06:12 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:42530 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725956AbgC0JGL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 27 Mar 2020 05:06:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=/3OpTZWCW7XGg84hd40RuOWZOGqD7kWCy24z/gV4Q60=; b=KjgutwPzhwVkyC0CaTCJpktTJM
        3BmcYiZbMcZ1VAuYfcA3994uD4qDw8j8mbr4UbNVKRFbewUU+AkcK9hoqmPp6Q2POlUWOIG+74TTM
        5dlPO5jR2Jj5j6R+xLBoVMtp8lSMP5H1hRcOmRALcRq2ARLc74qVzWjO2yyggeJpcYoTi6en4Bpkh
        TUsFvXwBPKwZKDvXHMawyC6cXRJ7jzydkwsG7w1ZiAfyXavZxCmr3nchmcKbLITBTwsFx6M0DhYIP
        klX6/TBRvIMqsZ0xCO2G32N2lJsVZ8PPkf7YvUldeyBLrpLqyrrlK2jnadKH53CFblc7yZ5Op02Mq
        MnPz33nQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jHkwL-0004zQ-Al; Fri, 27 Mar 2020 09:06:09 +0000
Date:   Fri, 27 Mar 2020 02:06:09 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Dave Chinner <david@fromorbit.com>,
        Brian Foster <bfoster@redhat.com>,
        xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: don't write a corrupt unmount record to force
 summary counter recalc
Message-ID: <20200327090609.GB14052@infradead.org>
References: <20200327011417.GF29339@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200327011417.GF29339@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Mar 26, 2020 at 06:14:17PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> In commit f467cad95f5e3, I added the ability to force a recalculation of
> the filesystem summary counters if they seemed incorrect.  This was done
> (not entirely correctly) by tweaking the log code to write an unmount
> record without the UMOUNT_TRANS flag set.  At next mount, the log
> recovery code will fail to find the unmount record and go into recovery,
> which triggers the recalculation.
> 
> What actually gets written to the log is what ought to be an unmount
> record, but without any flags set to indicate what kind of record it
> actually is.  This worked to trigger the recalculation, but we shouldn't
> write bogus log records when we could simply write nothing.
> 
> Fixes: f467cad95f5e3 ("xfs: force summary counter recalc at next mount")
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks good (assuming the "xfs: refactor unmount record writing" is
applied):

Reviewed-by: Christoph Hellwig <hch@lst.de>
