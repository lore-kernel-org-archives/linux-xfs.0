Return-Path: <SRS0=Pn/S=YS=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B28ACA9EA0
	for <linux-xfs@archiver.kernel.org>; Fri, 25 Oct 2019 14:40:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 636A92053B
	for <linux-xfs@archiver.kernel.org>; Fri, 25 Oct 2019 14:40:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="fz43wb2O"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439966AbfJYOkK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 25 Oct 2019 10:40:10 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:35064 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2436853AbfJYOkJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 25 Oct 2019 10:40:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=6N1M2bzoB1GH1oeWQqEubGPCJUbDRLPYVIQFUL4ZRNE=; b=fz43wb2OV441XxKxGmF7T5Dii
        PBNU1u5KQ6L7BHNfL6vY29I1Hb3CgZciwVpG3FtxHAJIetdcDA2JCUNsAnujBaZ/343ZNwzSyHDw0
        t7ySPGEYr08LtaYK6qlhvo3X1zyc1xMpby6M7jL6bRd2XcmCOfldvnYXfpbEG8kg3tpSQ4crLAdOX
        yciAP1UZuVtvzMbxIPM/ofePernffFIIN5+Jh6he8oV9Gjo42bIOLfzxfyl/mg9L6ssMXrjyVnYv5
        C3DoEU5O7MB2KJLAIiHUQEHf3tzcpQ/eLF1bFoaznch79ZaSIQnwFhG8AQ9L2/XaIbQwGkZACBwjm
        4PnF9L1qw==;
Received: from [46.189.28.128] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iO0l5-0004T4-LQ; Fri, 25 Oct 2019 14:40:09 +0000
Date:   Fri, 25 Oct 2019 16:39:58 +0200
From:   Christoph Hellwig <hch@infradead.org>
To:     Ian Kent <raven@themaw.net>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Brian Foster <bfoster@redhat.com>,
        Eric Sandeen <sandeen@sandeen.net>,
        David Howells <dhowells@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH v7 11/17] xfs: refactor suffix_kstrtoint()
Message-ID: <20191025143958.GE22076@infradead.org>
References: <157190333868.27074.13987695222060552856.stgit@fedora-28>
 <157190349282.27074.327122390885823342.stgit@fedora-28>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <157190349282.27074.327122390885823342.stgit@fedora-28>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Oct 24, 2019 at 03:51:32PM +0800, Ian Kent wrote:
> The mount-api doesn't have a "human unit" parse type yet so the options
> that have values like "10k" etc. still need to be converted by the fs.
> 
> But the value comes to the fs as a string (not a substring_t type) so
> there's a need to change the conversion function to take a character
> string instead.
> 
> When xfs is switched to use the new mount-api match_kstrtoint() will no
> longer be used and will be removed.
> 
> Signed-off-by: Ian Kent <raven@themaw.net>
> Reviewed-by: Brian Foster <bfoster@redhat.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
