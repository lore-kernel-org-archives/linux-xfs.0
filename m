Return-Path: <SRS0=RTOF=DJ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1EEBBC4363D
	for <linux-xfs@archiver.kernel.org>; Fri,  2 Oct 2020 07:15:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C038C206DD
	for <linux-xfs@archiver.kernel.org>; Fri,  2 Oct 2020 07:15:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="GcHwYCl2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725993AbgJBHPH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 2 Oct 2020 03:15:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725948AbgJBHPH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 2 Oct 2020 03:15:07 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D5B5C0613D0
        for <linux-xfs@vger.kernel.org>; Fri,  2 Oct 2020 00:15:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=jo+HMJIpsgab9z2rW9Q5xHwaV31rVYgOV4Xr/+O9Oxo=; b=GcHwYCl2vpla3YPcxnXO0uxKNC
        Y3DfWaAs/iqexFf4ilWStd74QYG9b1OgJWluWlJ0Lz4T0nxQm1D2yzUzRckkU3unkAHCPgmPUW1Qa
        OY4pZ/m4wxgs2SWTwlkabN0cd2WA14PD06x4F7dHat/uh6j6GT8l1Gnu333kQJVUEeac7u4IwVnI0
        /2Mpd03674kZr3OIbopdxR6HZNXWGZpAEMaOw0cgTQM3JP9oybbZ2ZnyYB9Zv3aRxwZdvbVN3vT1W
        WleveWLibKFxzhlQNXe2u42EEb4hd4kQFc0F8RPxRlRVbxRo4MxKf0WxZNm5dA2CJCdB1Yih2rmA5
        Ln/AgkHA==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kOFHV-0000dd-Qs; Fri, 02 Oct 2020 07:15:05 +0000
Date:   Fri, 2 Oct 2020 08:15:05 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs: streamline xfs_getfsmap performance
Message-ID: <20201002071505.GB32516@infradead.org>
References: <160161415855.1967459.13623226657245838117.stgit@magnolia>
 <160161417069.1967459.11222290374186255598.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <160161417069.1967459.11222290374186255598.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Oct 01, 2020 at 09:49:30PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Refactor xfs_getfsmap to improve its performance: instead of indirectly
> calling a function that copies one record to userspace at a time, create
> a shadow buffer in the kernel and copy the whole array once at the end.
> This should speed it up significantly.

So we save an indirect call and uaccess_enable/disable per entry,
but pay for it with the cost of a memory allocation (and actually
using that memory).

Doesn't seem like an obvious win to me, do you have numbers?
