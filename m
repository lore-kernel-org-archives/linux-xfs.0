Return-Path: <SRS0=ByWF=4N=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4265CC35E04
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Feb 2020 17:50:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1A36720CC7
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Feb 2020 17:50:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="fle0MaCQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731110AbgBYRuE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 25 Feb 2020 12:50:04 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:58896 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731017AbgBYRuE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Feb 2020 12:50:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=7Glc5tCzAaI8imgnUyy7IXGM6L6pCc/y76ggMcuiS/g=; b=fle0MaCQOt1aNAOWmj1D9An2jl
        Oj2fb3PnSqDq27Dy2iX2jGizuhHzi5pS1jVLwhVJJnULZVWdr5fkoyVXdhCFMbk4vAAsFd3HCg3LD
        uQup5KbDvYKFqmqKOvPtheiiyf1A+46+zL71VBg3Tu5YjVfLJ4j33GlpT0XkZFWRI/jjAqY3wWzCX
        vAOfMeevlV8hKno7QbTn/nbDxvcTRuGAHl0KNL4T/aDO5fI0stu45MPqPTvewlgicTqpwAvVEqobt
        dIk+yVigalyQ4tLOCUDTE99JZ3EsJsFingQw87la+C+4O5Tb5hxHKOZxq0mSsvHRBTBnK2KKxuyae
        sdLZYL7g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1j6eLL-0008Lj-Rd; Tue, 25 Feb 2020 17:50:03 +0000
Date:   Tue, 25 Feb 2020 09:50:03 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 15/25] libxlog: use uncached buffers instead of
 open-coding them
Message-ID: <20200225175003.GP20570@infradead.org>
References: <158258948821.451378.9298492251721116455.stgit@magnolia>
 <158258958455.451378.14588576332644099597.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158258958455.451378.14588576332644099597.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Feb 24, 2020 at 04:13:04PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Use the new uncached buffer functions to manage buffers instead of
> open-coding the logic.

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
