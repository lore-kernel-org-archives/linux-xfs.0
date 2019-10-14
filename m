Return-Path: <SRS0=3dSt=YH=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F612ECE587
	for <linux-xfs@archiver.kernel.org>; Mon, 14 Oct 2019 08:41:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1AC3D20659
	for <linux-xfs@archiver.kernel.org>; Mon, 14 Oct 2019 08:41:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="th9WrI/I"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730495AbfJNIlN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 14 Oct 2019 04:41:13 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:41248 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730441AbfJNIlN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 14 Oct 2019 04:41:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=YWhdhtBrZUMDegyRdBfWME/xoEfq9DJ0UMoY+JsVhWk=; b=th9WrI/Ifrp4mz1W+/xorxRVD
        JbBs6btizZls1LTkMYnVrPztOY/GC9R7ZMZqo2pyNfMUzeebzh8LE+/6W+PV1YkFyGszYM3VxtEtZ
        gXFT8Cwu3Yu9MTqWdZJZHD0f37UChHPe9BOkiwvTbjLyEKII4UrOjTJOvk6z67pk88nLvhCPizyip
        e5qXa+QHe/St1BMhDd4Y0aPzPAb/1z1dltBHGVrUbR3rqdk8LpPjAEZCC1HJuJmQ975F9H9Sf22/N
        SZDQ2IlI8LBnUaN5/Rx8tXHhB14M/BKVraKwC0aB3X9CgtDKeoU2bbSbRus7LMiolpHZJJV77lT3y
        29oE67gxg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iJvuj-0002u4-9U; Mon, 14 Oct 2019 08:41:13 +0000
Date:   Mon, 14 Oct 2019 01:41:13 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Jan Kara <jack@suse.cz>
Cc:     linux-fsdevel@vger.kernel.org,
        Christoph Hellwig <hch@infradead.org>, darrick.wong@oracle.com,
        linux-xfs@vger.kernel.org,
        Matthew Bobrowski <mbobrowski@mbobrowski.org>,
        Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/2] xfs: Use iomap_dio_rw_wait()
Message-ID: <20191014084113.GC3593@infradead.org>
References: <20191014082418.13885-1-jack@suse.cz>
 <20191014082610.6298-2-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191014082610.6298-2-jack@suse.cz>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Oct 14, 2019 at 10:26:03AM +0200, Jan Kara wrote:
> Use iomap_dio_rw() to wait for unaligned direct IO instead of opencoding
> the wait.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
