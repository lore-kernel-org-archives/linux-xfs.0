Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:41786 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1758366AbdAIPwA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 9 Jan 2017 10:52:00 -0500
Date: Mon, 9 Jan 2017 07:51:58 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v6 1/3] xfs: fix the size of xfs_mode_to_ftype table
Message-ID: <20170109155158.GA19396@infradead.org>
References: <1483967189-27313-1-git-send-email-amir73il@gmail.com>
 <1483967189-27313-2-git-send-email-amir73il@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1483967189-27313-2-git-send-email-amir73il@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Amir Goldstein <amir73il@gmail.com>
Cc: "Darrick J . Wong" <darrick.wong@oracle.com>, Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org

On Mon, Jan 09, 2017 at 03:06:27PM +0200, Amir Goldstein wrote:
> Fix the size of the xfs_mode_to_ftype conversion table,
> which was too small to handle an invalid value of mode=S_IFMT.
> 
> Use a convenience macro S_DT(mode) to convert from
> mode to dirent file type and change the name of the table
> to xfs_dtype_to_ftype to correctly describe its index values.

This looks like an awful lot of magic.  Would a switch statement
generate so much worse code?
