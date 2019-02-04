Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:38274 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725855AbfBDU62 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 4 Feb 2019 15:58:28 -0500
Date: Mon, 4 Feb 2019 12:58:28 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 07/10] xfs: refactor unlinked list search and mapping to
 a separate function
Message-ID: <20190204205828.GF30334@infradead.org>
References: <154930313674.31814.17994684613232167921.stgit@magnolia>
 <154930318626.31814.6656693057965798100.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <154930318626.31814.6656693057965798100.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

> +		next_ino = XFS_AGINO_TO_INO(mp, pag->pag_agno, next_agino);
> +		error = xfs_iunlink_map_ino(tp, next_ino, imap, &last_dip,
> +				&last_ibp);

Last round I suggested pasing the agno/agino to xfs_iunlink_map_ino,
and good reason for not doing that?
