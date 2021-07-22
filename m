Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E680C63797
	for <linux-xfs@archiver.kernel.org>; Thu, 22 Jul 2021 06:38:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0766461285
	for <linux-xfs@archiver.kernel.org>; Thu, 22 Jul 2021 06:38:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230117AbhGVF51 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 22 Jul 2021 01:57:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229931AbhGVF50 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 22 Jul 2021 01:57:26 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61D52C061575;
        Wed, 21 Jul 2021 23:38:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=MpRz/6xHo9kpoJ3ZdkiqXY0AEI35K2RkRiZjlnCevxs=; b=F52cUQTa81mip4pzDe0B3FnPgB
        sHglVmJv1clVJHvqrs3306SW6J5Bliaf6LgDrVRhquDI6EgVnUNFAj+G/kN/6he+p6LTTV/ZMjBNn
        R7btuCtpv/LxigMg2tY2rphvuS5LaGBLoAC8gkD85snl9ndDT2Esp55CkgTd+GDrGDNwtKmesa6oF
        jwOquJzP/XzFcn+PVj0UiFY4+gu69bUf6mm35l6KSjEKHHj5wA2offb3+li3w74PlNgBGsI69126/
        TlZ3IJWmAnlzngMEij2zP/FMrbXqL2ZxvN+7EwCNQxyucBBit/Fkxu8klDEUnjaZBNBzYPPGtbFWJ
        /YVMKkTA==;
Received: from hch by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1m6SKe-009xhz-PP; Thu, 22 Jul 2021 06:37:33 +0000
Date:   Thu, 22 Jul 2021 07:37:20 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     guaneryu@gmail.com,
        Allison Henderson <allison.henderson@oracle.com>,
        linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Subject: Re: [PATCH 1/1] generic/561: hide assertions when duperemove is
 killed
Message-ID: <YPkSICt0pnAPIV42@infradead.org>
References: <162674330387.2650745.4586773764795034384.stgit@magnolia>
 <162674330933.2650745.11380233368495712613.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <162674330933.2650745.11380233368495712613.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jul 19, 2021 at 06:08:29PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Use some bash redirection trickery to capture in $seqres.full all of
> bash's warnings about duperemove being killed due to assertions
> triggering.

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
