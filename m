Return-Path: <SRS0=xOwi=4F=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DBEF6C34021
	for <linux-xfs@archiver.kernel.org>; Mon, 17 Feb 2020 13:48:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A0946206D5
	for <linux-xfs@archiver.kernel.org>; Mon, 17 Feb 2020 13:48:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="g5DkmlMn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728428AbgBQNsj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 17 Feb 2020 08:48:39 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:57352 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726707AbgBQNsj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 17 Feb 2020 08:48:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=IpzBrVwnEz0lS8Scli3PoVwD+p1SQCMh46/7RGFhz38=; b=g5DkmlMnO2t4PmzGqa3lgk2oY0
        cDPcFhyztNMm/IHPX4S9Iplbkuwra3om4Mfh/C79N0IXjQOckS7E+0UcGXJS7YSBHEwvX0UDLEoT8
        c81YiZSRtspmDJnbohZY27of/w192X4jXBuQG7whXGlpnYu4CrdnjtkcS720tq1xYfBpGBaycyMH5
        nd5SFyHYH8nis/ps9Q8fpdsJ425LNhwbBfiUj+u7aaumAWq4Q/W8UvmN1Bu/D/CAwjM8XOzE0mchO
        2VTPuhexApXTzAhJtGd0+mnbl3X7aowlm64pGul/cpJr2bkIywsQ439pY0jl/mhc9e//StGYCjDxL
        gXAGHU+g==;
Received: from [88.128.92.35] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1j3glE-0008Iq-3G; Mon, 17 Feb 2020 13:48:38 +0000
Date:   Mon, 17 Feb 2020 14:48:29 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Chandan Rajendra <chandan@linux.ibm.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        Allison Collins <allison.henderson@oracle.com>,
        "Darrick J . Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 26/30] xfs: improve xfs_forget_acl
Message-ID: <20200217134829.GB336731@infradead.org>
References: <20200129170310.51370-1-hch@lst.de>
 <20200129170310.51370-27-hch@lst.de>
 <21965604.HEa247YntI@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <21965604.HEa247YntI@localhost.localdomain>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Feb 10, 2020 at 12:15:34PM +0530, Chandan Rajendra wrote:
> >  	error = xfs_attr_set(&args);
> > -	if (!error)
> > -		xfs_forget_acl(inode, name, args.flags);
> > +	if (!error && (flags & ATTR_ROOT))
> 
> ATTR_ROOT should be checked against args.flags.
> 
> 'flags' refers to argument passed to setxattr() syscall i.e. it can have
> XATTR_CREATE or XATTR_REPLACE as its value.

Fixed, thanks.
