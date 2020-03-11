Return-Path: <SRS0=qEB5=44=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7FDA9C10F25
	for <linux-xfs@archiver.kernel.org>; Wed, 11 Mar 2020 06:40:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4508021D56
	for <linux-xfs@archiver.kernel.org>; Wed, 11 Mar 2020 06:40:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="cDkMdcza"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728245AbgCKGkL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 11 Mar 2020 02:40:11 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:52218 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725976AbgCKGkL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 11 Mar 2020 02:40:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=Hx1+Z8RmHtdgBqO32XyCYEzcLzkhsqEAWdypOLZsJcE=; b=cDkMdczaJf3NS3OuMD0j/C8L7k
        94S+S59aQmZ4bdF31LBy8GE85YwEJnIwU2ksA6znZ/7vnTvKZj8BujyxZJ9I6RdLBxGgO9lvm+jdb
        Zmd0AgHoXalQ9XxH/UdFuz4SOtxv7EQHqCLZWItsZ0ivu38XdWa0j5E0UPhSamuEceMAgNfLOh6Um
        ySrVfHajAieYTpzMkOhceyJKnn5EpfIGt4eLo9vTJb91l0S9cjCDBizrYyI7wqOW25G5RzZsr7SIJ
        owwcs01Sw5jzwLjbvuy6U3uM72o8dI09OExSPwgfeiW3XIeDNJ3LXdY1z80SQYeLzpAPeZnWdXX2T
        TPX+QfBg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jBv2J-0007xh-HX; Wed, 11 Mar 2020 06:40:11 +0000
Date:   Tue, 10 Mar 2020 23:40:11 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs: fix xfs_rmap_has_other_keys usage of ECANCELED
Message-ID: <20200311064011.GA25435@infradead.org>
References: <158388761806.939081.5340701470247161779.stgit@magnolia>
 <158388763048.939081.7269460615856522299.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158388763048.939081.7269460615856522299.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Mar 10, 2020 at 05:47:10PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> In e7ee96dfb8c26, we converted all ITER_ABORT users to use ECANCELED
> instead, but we forgot to teach xfs_rmap_has_other_keys not to return
> that magic value to callers.  Fix it now.

This doesn't document the remap of the has_rmap flag.  As far as I can
tell that isn't needed now the caller checks for ECANCELED, but it
takes a while to figure that out.  It'll need to be documented properly
in the commit log.
