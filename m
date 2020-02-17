Return-Path: <SRS0=xOwi=4F=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE0A3C34022
	for <linux-xfs@archiver.kernel.org>; Mon, 17 Feb 2020 13:48:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 956DE2070B
	for <linux-xfs@archiver.kernel.org>; Mon, 17 Feb 2020 13:48:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="agEjOsI1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726977AbgBQNsK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 17 Feb 2020 08:48:10 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:57294 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726707AbgBQNsK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 17 Feb 2020 08:48:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=GRNVWcGYzoA7ZhSwFkfbiKlqVLgnT7kUQ366AdLm/3c=; b=agEjOsI1RZhKPqaKeick2/5ZmW
        YsNGjVC7vAPO+OjLlqRW56nXjRXST99x18hPV8U4KUp/UuuHrqyQvJpR8Hftcb+KKbMcfg9fADHcH
        2zWYV/fPK8iS4XmQEKZeCq4NDLTTEjH8Yin1buGnH50v149DbrUY5nc4YkwsFo0N8ed8rgoe0u0Sn
        X2SIwoRbvjmwI8NKNWjO7bY4e9T9DSdphIx0meRm4eT9WAygsFpOzzNj8ebBaC6vaJxsjGAoBL/q0
        LtekBHcu4KF9wXR+QuPgAQj9M3/qQyMWKhVPLdUkJz/rQslEjHPObsxojE9J8XAkOHsabIbSpCtoj
        PAnGyr+Q==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1j3gkr-000824-7u; Mon, 17 Feb 2020 13:48:09 +0000
Date:   Mon, 17 Feb 2020 05:48:09 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/4] xfs_repair: don't corrupt a attr fork da3 node when
 clearing forw/back
Message-ID: <20200217134809.GD18371@infradead.org>
References: <158086356778.2079557.17601708483399404544.stgit@magnolia>
 <158086359417.2079557.4428155306169446299.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158086359417.2079557.4428155306169446299.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Feb 04, 2020 at 04:46:34PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> In process_longform_attr, we enforce that the root block of the
> attribute index must have both forw or back pointers set to zero.
> Unfortunately, the code that nulls out the pointers is not aware that
> the root block could be in da3 node format.
> 
> This leads to corruption of da3 root node blocks because the functions
> that convert attr3 leaf headers to and from the ondisk structures
> perform some interpretation of firstused on what they think is an attr1
> leaf block.
> 
> Found by using xfs/402 to fuzz hdr.info.hdr.forw.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
