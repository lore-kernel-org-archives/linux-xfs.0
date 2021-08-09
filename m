Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E211C4338F
	for <linux-xfs@archiver.kernel.org>; Mon,  9 Aug 2021 14:52:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5F0A760C41
	for <linux-xfs@archiver.kernel.org>; Mon,  9 Aug 2021 14:52:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233327AbhHIOwZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 9 Aug 2021 10:52:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229474AbhHIOwY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 9 Aug 2021 10:52:24 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F823C0613D3
        for <linux-xfs@vger.kernel.org>; Mon,  9 Aug 2021 07:52:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=l2WBiCb5duYJRA9nKpihqrJOH1Qjg6utSrFiu8qAdtc=; b=uwjb8lmHZIrQDEf5fha9DpDLVs
        n0g3hKmR9zZV5YIKJMjDeIRV+Vjy58fHn0IEfTc5j3BlXpgD5fWWhU/LfWU+TkT3V4s7ZAVGFgIa2
        D2NhayUx/aD3+caKlSPkE/SuayUVrXTJDZMzcsZgQhkoq3NqE47s64hP+UuQVta2w81IFbR7i6rui
        y6skpJrLtjTZRGq9SAD5r3e2sq2EYIIqPcCP4FANvXgEQV/FP4Mhem27xboVWXkyCHoC6yGHXf/yx
        ryb+77W3Omrn3MAaRS+jQ8WJTfPNVurP/turowNAgmROwUB/sqXsQHYohDNLSRHMFOL5Jm1jqNMgf
        05yYs82A==;
Received: from hch by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mD6cP-00B5iN-SD; Mon, 09 Aug 2021 14:51:25 +0000
Date:   Mon, 9 Aug 2021 15:51:09 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/5] xfs: fix silly whitespace problems with kernel libxfs
Message-ID: <YRFA3SJk5MdLnAzo@infradead.org>
References: <162814684332.2777088.14593133806068529811.stgit@magnolia>
 <162814684894.2777088.8991564362005574305.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <162814684894.2777088.8991564362005574305.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
