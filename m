Return-Path: <SRS0=xOwi=4F=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15D61C34022
	for <linux-xfs@archiver.kernel.org>; Mon, 17 Feb 2020 13:48:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D0DD1206D5
	for <linux-xfs@archiver.kernel.org>; Mon, 17 Feb 2020 13:48:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Qgnpx4To"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728430AbgBQNs0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 17 Feb 2020 08:48:26 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:57338 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728387AbgBQNs0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 17 Feb 2020 08:48:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=KXraFm5/LfEOFm55eWhdjO0tT64ITJnWSjKl+cLM0bo=; b=Qgnpx4Toc/7LQ9gaPjLp9y0GBz
        GLxc21dOnnLYZIr/Fjd2fIhCoDpjXub4aK80HUenej/93SO86cqD3Yx23jcqrMriaow+9e6IyqTyp
        B3jFcNmiH8Y88GkuDDvz/yBQVyIh8UEu4/xeFOQ8MAk0SIrssavyyz1kxc1ecRp/rxgO0LFa8yUyT
        gCWMntUmlznTDwL3uco9np1moWUHFJsXY393a6ACbjfnz2pT7TR4kmEJYUs0egbPaqrRWWN3FfMBz
        Q4jVaWzFjPqK+IIy0Ie8eYlTiNhOjgTfTRU3MXaqY8VFoHkTcX+br2/Z7472pyUEp0sEw6jeJPgq8
        N1Wf7BDA==;
Received: from [88.128.92.35] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1j3gl7-0008D9-6P; Mon, 17 Feb 2020 13:48:25 +0000
Date:   Mon, 17 Feb 2020 14:48:23 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Chandan Rajendra <chandan@linux.ibm.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        Allison Collins <allison.henderson@oracle.com>
Subject: Re: [PATCH 21/30] xfs: move the legacy xfs_attr_list to xfs_ioctl.c
Message-ID: <20200217094631.GA25992@infradead.org>
References: <20200129170310.51370-1-hch@lst.de>
 <20200129170310.51370-22-hch@lst.de>
 <1601688.7pIFPY2mFX@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1601688.7pIFPY2mFX@localhost.localdomain>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Feb 09, 2020 at 01:14:18PM +0530, Chandan Rajendra wrote:
> > +/*
> > + * Define how lists of attribute names are returned to the user from
> > + * the attr_list() call.  A large, 32bit aligned, buffer is passed in
> > + * along with its size.  We put an array of offsets at the top that each
> > + * reference an attrlist_ent_t and pack the attrlist_ent_t's at the bottom.
> 
> In the above comment, 'attrlist_ent_t' should be replaced with 'struct
> xfs_attrlist_ent'.

Fixed, thanks.
