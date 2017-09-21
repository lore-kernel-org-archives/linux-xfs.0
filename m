Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:43147 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751779AbdIUNXS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 21 Sep 2017 09:23:18 -0400
Date: Thu, 21 Sep 2017 06:23:15 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 16/19] xfs: pass a struct xfs_bmbt_irec to
 xfs_bmbt_lookup_eq
Message-ID: <20170921132315.GA20148@infradead.org>
References: <20170918152422.24345-1-hch@lst.de>
 <20170918152422.24345-17-hch@lst.de>
 <20170920222700.GX7112@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170920222700.GX7112@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org

On Wed, Sep 20, 2017 at 03:27:00PM -0700, Darrick J. Wong wrote:
> Hope all the structure copies throughout this series don't get us into
> trouble on sparc (I think they're fine), but otherwise...

I didn't know sparc had any problems with struct copies.  But I haven't
had a sparc machine since 2002, so..
