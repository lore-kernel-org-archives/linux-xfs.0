Return-Path: <SRS0=zOU/=7G=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA30EC433E0
	for <linux-xfs@archiver.kernel.org>; Sun, 24 May 2020 05:31:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ADC03207C3
	for <linux-xfs@archiver.kernel.org>; Sun, 24 May 2020 05:31:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Pq88/dKK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726129AbgEXFba (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 24 May 2020 01:31:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725856AbgEXFb3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 24 May 2020 01:31:29 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2BC8C061A0E
        for <linux-xfs@vger.kernel.org>; Sat, 23 May 2020 22:31:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=9cSDTU1m9ALWKC0/PnnqGqPGXeL41BJvcJvFsZrq9iA=; b=Pq88/dKKUlg1p1zJR39IU1HeoC
        aLNEMJHzqPncON9DRhDuwtWW0iekK+mlFSuUJOAGgwDNsFRWQSSjQiGQzLmUwolQuisU+kcwmdqEf
        N102nALQT0cwnLqzAeAQ4ZoKQx2M90hmFQvdMn6jfsfa/6Lia/8OUB6dLF+/mgrPeiyNwD76gqrKP
        ++nmczCSMmjjQyje4aLvTJ4wFfEUQRIhV2ntXQ3ashwBFuN5JVpmcSbOGtOQeHCPsNym9XfgtqQaJ
        3lNgOxINZ6mcL8RMUyyMlb2gQjrdUKuP4XUrJAlK9yY3vmd2E9S3P6nPSmjq6MPu1CAzhEb0hoaPK
        b7OV4Rtw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jcjEK-0004FW-QT; Sun, 24 May 2020 05:31:24 +0000
Date:   Sat, 23 May 2020 22:31:24 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 12/24] xfs: pin inode backing buffer to the inode log item
Message-ID: <20200524053124.GA5468@infradead.org>
References: <20200522035029.3022405-1-david@fromorbit.com>
 <20200522035029.3022405-13-david@fromorbit.com>
 <20200523093451.GA7083@infradead.org>
 <20200523214334.GG2040@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200523214334.GG2040@dread.disaster.area>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, May 24, 2020 at 07:43:34AM +1000, Dave Chinner wrote:
> I've got to rework the error handling code anyway, so I might end up
> getting rid of ->li_error and hard coding these like I've done the
> iodone functions. That way the different objects can use different
> failure mechanisms until the dquot code is converted to the same
> "hold at dirty time" flushing mechanism...

FYI, while reviewing your series I looked at that area a bit, and
found the (pre-existing) code structure a little weird:

 - xfs_buf_iodone_callback_errorl  deals with the buffer itself and
   thus should sit in xfs_buf.c, not xfs_buf_item.c
 - xfs_buf_do_callbacks_fail really nees to be a buffer level
   methods instead of polig into b_li_list, which nothing else in
   "common" code does.  My though was to either add another method
   or overload the b_write_done method to pass the error back to
   the buffer owner and let the owner deal with the list iteration
   an exact error handling method.
