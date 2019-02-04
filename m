Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:57986 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727202AbfBDWXg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 4 Feb 2019 17:23:36 -0500
Date: Mon, 4 Feb 2019 14:23:29 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 07/10] xfs: refactor unlinked list search and mapping to
 a separate function
Message-ID: <20190204222329.GD7991@magnolia>
References: <154930313674.31814.17994684613232167921.stgit@magnolia>
 <154930318626.31814.6656693057965798100.stgit@magnolia>
 <20190204205828.GF30334@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190204205828.GF30334@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org

On Mon, Feb 04, 2019 at 12:58:28PM -0800, Christoph Hellwig wrote:
> > +		next_ino = XFS_AGINO_TO_INO(mp, pag->pag_agno, next_agino);
> > +		error = xfs_iunlink_map_ino(tp, next_ino, imap, &last_dip,
> > +				&last_ibp);
> 
> Last round I suggested pasing the agno/agino to xfs_iunlink_map_ino,
> and good reason for not doing that?

I forgot to do it. :(

Looking through the code, I could also change the _update_dinode
function to take xfs_agino_t instead of xfs_ino_t, though even that is
nearly pointless since we only do it to feed a tracepoint.

Anyway, I'll incorporate that into v3.

--D
