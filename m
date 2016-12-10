Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:48928 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751246AbcLJQXZ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 10 Dec 2016 11:23:25 -0500
Date: Sat, 10 Dec 2016 17:23:24 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH, RFC] xfs: take indirect blocks into accounting when
        selecting an AG
Message-ID: <20161210162324.GB3204@lst.de>
References: <1481303709-12632-1-git-send-email-hch@lst.de> <20161210061641.GQ29149@eguan.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161210061641.GQ29149@eguan.usersys.redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eryu Guan <eguan@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, darrick.wong@oracle.com

On Sat, Dec 10, 2016 at 02:16:41PM +0800, Eryu Guan wrote:
> I hit "Internal error xfs_trans_cancel" and force shutdown while running
> xfs/109 in a loop with xfs_2k_reflink test config, first hit at 62nd
> iteration then hit at 32nd iteration. Detailed log appended at the end.

That's the bmap btree insert, so we're still having a problem figuring
out the right indlen somehow.
