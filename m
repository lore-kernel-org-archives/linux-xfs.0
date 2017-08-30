Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:38246 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751333AbdH3Q4i (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 30 Aug 2017 12:56:38 -0400
Date: Wed, 30 Aug 2017 09:56:32 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs: disable per-inode DAX flag
Message-ID: <20170830165632.GR4757@magnolia>
References: <20170830145119.3013-1-hch@lst.de>
 <20170830161701.GM4757@magnolia>
 <20170830161756.GA3040@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170830161756.GA3040@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Wed, Aug 30, 2017 at 06:17:56PM +0200, Christoph Hellwig wrote:
> On Wed, Aug 30, 2017 at 09:17:01AM -0700, Darrick J. Wong wrote:
> > #ifdef DEBUG ?
> > 
> > So that we developers can play with DAX without having to patch this out?
> > 
> > If that's fine with you I'll just change it on the way in.
> 
> You can always mount with -o dax and get DAX support.  That's how
> ext2/ext4 also work..

Ok, fair enough.

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
