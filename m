Return-Path: <SRS0=EbdE=C2=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC2BCC433E2
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Sep 2020 07:59:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 56E49221F1
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Sep 2020 07:59:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="G4Zgq9bK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726201AbgIQH7B (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 17 Sep 2020 03:59:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726191AbgIQH7A (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 Sep 2020 03:59:00 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26664C06174A;
        Thu, 17 Sep 2020 00:58:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=XTQMom0LmC2jYtZbFlEeb69BLX7wbkEbM4xpa2yvb/U=; b=G4Zgq9bK5FW0pL2huvsJN5Y8i/
        y6NK6A8bhS7aIDWKz3f6tEzr55zAjfIkzpdLcajBWVEPEyfyAEPaEnojdmGASIeLcfIL92agfg6Y0
        lArN+M+w0I1H6Mwsg1NJThfiPhat+OLFl1uiUjW8r7bROcgG9qRr71NOUCae7EHfrJRi/rJYYCI/0
        YHFd0/Avy5X/YIHtdoFI8VmzLpsNb+4WaZo8ykya+P6cJ85gZzDE2zgPk8oONrhWENEZW8vAs9Cdh
        v5wP/Bey5BqYX+ogajO6/7vDcltM+EMtC8Osvswx+QE85fWOML4IhqVjh7+p668cyWkdMXXgdytYC
        P8ThWqlA==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kIooi-0007Wx-AC; Thu, 17 Sep 2020 07:58:56 +0000
Date:   Thu, 17 Sep 2020 08:58:56 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org
Subject: Re: [PATCH 17/24] xfs: refactor _xfs_check calls to the scratch
 device
Message-ID: <20200917075856.GN26262@infradead.org>
References: <160013417420.2923511.6825722200699287884.stgit@magnolia>
 <160013428386.2923511.798805055641192515.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <160013428386.2923511.798805055641192515.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Sep 14, 2020 at 06:44:43PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Use _scratch_xfs_check, not _xfs_check $SCRATCH_DEV.

This looks ok:

Reviewed-by: Christoph Hellwig <hch@lst.de>

But shouldn't we finally kill off all xfs_check alls instead? :)
