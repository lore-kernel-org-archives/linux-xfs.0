Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:50478 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751681AbdIUPer (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 21 Sep 2017 11:34:47 -0400
Date: Thu, 21 Sep 2017 08:34:17 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 16/19] xfs: pass a struct xfs_bmbt_irec to
 xfs_bmbt_lookup_eq
Message-ID: <20170921153417.GE7112@magnolia>
References: <20170918152422.24345-1-hch@lst.de>
 <20170918152422.24345-17-hch@lst.de>
 <20170920222700.GX7112@magnolia>
 <20170921132315.GA20148@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170921132315.GA20148@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org

On Thu, Sep 21, 2017 at 06:23:15AM -0700, Christoph Hellwig wrote:
> On Wed, Sep 20, 2017 at 03:27:00PM -0700, Darrick J. Wong wrote:
> > Hope all the structure copies throughout this series don't get us into
> > trouble on sparc (I think they're fine), but otherwise...
> 
> I didn't know sparc had any problems with struct copies.  But I haven't
> had a sparc machine since 2002, so..

It only has trouble when either of the structs doesn't satisfy the
memory alignment requirements.  I /think/ this is mostly an issue
dealing with packed on-disk metadata arrays (like btree blocks).  Every
now and then I get bug reports from the sparc people about kernel oopses
that happen on sparc and not x64, and they usually turn out to be memory
access problems.

(AFAICT it's not a problem copying from one stack struct to another as
you do in these patches, but something I have to keep an eye on...)

--D

> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
