Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07AD1C433FE
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Dec 2020 14:18:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CDA1E235F8
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Dec 2020 14:18:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727143AbgLGOSE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 7 Dec 2020 09:18:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726218AbgLGOSE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 7 Dec 2020 09:18:04 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 040DBC0613D1
        for <linux-xfs@vger.kernel.org>; Mon,  7 Dec 2020 06:17:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=+obZpNg4EZeyH4tPLOLTJFjZdcJH0Z0atX+Y0yOshQ0=; b=WO8RCYb5cyl0Px3miBGI2dGCx4
        5+/CUZZ499i/jj2bUdrEe97uwNgc/vhkm7E5Rd2kOIlwODc63RU5L4yfkFhbC8ffpxq/4k1hANo6f
        +fnPGSyYXnC8HZ14gUXmyGbJuoIcmFNLA49VA9kf/sXeDzZE/AP1NaynWTHw9LHkSSd42B1pgj1S5
        2cbcpQ85WIuyJT2zLhD4jlxk7K1Swh4hnmLvSGmbIF4sOWYkrc+LkwgF5a5wQOBfrx52ip4tL9bfo
        HSCo/04S5GerZJaVauwR1mTO2WKE2oxwK3yEdR8vEOSc6JGN4If96BlXSeBgPArcpMRUzl+4wMLvy
        8EJcrIFw==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kmHKM-0002WG-L1; Mon, 07 Dec 2020 14:17:22 +0000
Date:   Mon, 7 Dec 2020 14:17:22 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/4] xfs: refactor file range validation
Message-ID: <20201207141722.GC8637@infradead.org>
References: <160729625074.1608297.13414859761208067117.stgit@magnolia>
 <160729626928.1608297.12355625902682243490.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <160729626928.1608297.12355625902682243490.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

> +/* Check that a file block offset does not exceed the maximum. */
> +bool
> +xfs_verify_fileoff(
> +	struct xfs_mount	*mp,
> +	xfs_fileoff_t		off)
> +{
> +	return off <= XFS_MAX_FILEOFF;
> +}

I think an inline function would make sense here..

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
