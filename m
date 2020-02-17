Return-Path: <SRS0=xOwi=4F=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 876E4C34022
	for <linux-xfs@archiver.kernel.org>; Mon, 17 Feb 2020 13:46:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 55D3B2070B
	for <linux-xfs@archiver.kernel.org>; Mon, 17 Feb 2020 13:46:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="fDS/73CC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726823AbgBQNqW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 17 Feb 2020 08:46:22 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:51620 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727208AbgBQNqI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 17 Feb 2020 08:46:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=jg4Wz924X+lnevBlxa31fmhoW8fObZ6vFU/G07zxcZ8=; b=fDS/73CC9AbUN/Ny082+rlqtNI
        T+We7skl3VGsJl3VbMmGscQt13KI2al4rBQzBy42qWtSsZHa0Im4yXd80X8zNWgpGeAQWHxyPsaK8
        /k6Z0aXsfzMfNHRN8Hgo0KNQbaqOuta+4QJNWrA6mzhLOsvDAiCm2IFlzmWH0tlVGvyd6pfkjJxlx
        5QfdadQ+9KSSTJ7Sdu8PvA57c06oTPS+B4Vt4JDHgmtPyZDT5wYjdh++LxSHjlgTZ94+noEoAR5OV
        /dqUpPleu65QH7bMTOsYWfpabCgO7rMJNZAhEisyM3QVXP6U4lAGjWTURGIwdX9X7tZHwznBwApet
        v7ejrldQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1j3gis-0006Uo-Il; Mon, 17 Feb 2020 13:46:06 +0000
Date:   Mon, 17 Feb 2020 05:46:06 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org,
        Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH 2/4] libfrog: remove libxfs.h dependencies in fsgeom.c
 and linux.c
Message-ID: <20200217134606.GB18371@infradead.org>
References: <158086356778.2079557.17601708483399404544.stgit@magnolia>
 <158086358002.2079557.9233731246621270812.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158086358002.2079557.9233731246621270812.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Feb 04, 2020 at 04:46:20PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> libfrog isn't supposed to depend on libxfs, so don't include the header
> file in the libfrog source code.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> Reviewed-by: Eric Sandeen <sandeen@redhat.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
