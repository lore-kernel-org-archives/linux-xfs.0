Return-Path: <SRS0=ByWF=4N=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75E67C35E01
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Feb 2020 17:37:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 440142082F
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Feb 2020 17:37:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="TLEd2eG2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729048AbgBYRha (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 25 Feb 2020 12:37:30 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:37664 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728471AbgBYRha (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Feb 2020 12:37:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=j3RFC+QSe+QvyfL/oWqpU/BDGMnCuZFdnucs8U1xJAg=; b=TLEd2eG2t5t64zKWgegz78HSB5
        ko0NOyQZiJKTZAG8Sa3x4bDVbl2C58iyxPM8Pif58iTKeB5RVrw9w9vcuk0NMeGamuGqRjIketKko
        r5u/RSJc8FYFpTertBiDXHU8IbjRO1QnEAb6XYhsgJTIZoN7O8uUh4p+R2o+h6jKrsOkrz5i2PTiR
        UXWAzkj57RWDu+HCiclPRtuqLCTCIS9rhfSHBgNMRxja1hTWSccyv2B/er7q8ePZ36rxNg4kJizJS
        OjUBy0fPm6lSen7Ime9m1Cp+stcHA/z2bvZtRzNEw6zoft/qVKmUYrgU3Ryge0p80LaB0hprC9kEe
        BPQZvtbQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1j6e9B-0000xA-Oj; Tue, 25 Feb 2020 17:37:29 +0000
Date:   Tue, 25 Feb 2020 09:37:29 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/7] libxfs: flush all dirty buffers and report errors
 when unmounting filesystem
Message-ID: <20200225173729.GA20570@infradead.org>
References: <158258942838.451075.5401001111357771398.stgit@magnolia>
 <158258945354.451075.11223931828645692053.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158258945354.451075.11223931828645692053.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Feb 24, 2020 at 04:10:53PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Teach libxfs_umount to flush all dirty buffers when unmounting the
> filesystem, to log write verifier errors and IO errors, and to return an
> error code when things go wrong.  Subsequent patches will teach critical
> utilities to exit with EXIT_FAILURE when this happens.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
