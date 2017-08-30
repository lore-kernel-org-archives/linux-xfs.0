Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:50558 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751415AbdH3QR5 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 30 Aug 2017 12:17:57 -0400
Date: Wed, 30 Aug 2017 18:17:56 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] xfs: disable per-inode DAX flag
Message-ID: <20170830161756.GA3040@lst.de>
References: <20170830145119.3013-1-hch@lst.de> <20170830161701.GM4757@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170830161701.GM4757@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org

On Wed, Aug 30, 2017 at 09:17:01AM -0700, Darrick J. Wong wrote:
> #ifdef DEBUG ?
> 
> So that we developers can play with DAX without having to patch this out?
> 
> If that's fine with you I'll just change it on the way in.

You can always mount with -o dax and get DAX support.  That's how
ext2/ext4 also work..
