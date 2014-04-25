Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 156057F4E
	for <xfs@oss.sgi.com>; Fri, 25 Apr 2014 14:55:32 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 9158BAC001
	for <xfs@oss.sgi.com>; Fri, 25 Apr 2014 12:55:31 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id wqy2Ebu54PqEeIlL (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 25 Apr 2014 12:55:28 -0700 (PDT)
Date: Fri, 25 Apr 2014 12:55:28 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH, RFC] xfs: add heuristic to flush on rename
Message-ID: <20140425195528.GA16567@infradead.org>
References: <535ABA9D.2060305@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <535ABA9D.2060305@redhat.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@redhat.com>
Cc: xfs-oss <xfs@oss.sgi.com>

> +	/*
> +	 * If we are renaming a just-written file over an existing
> +	 * file, be pedantic and flush it out if it looks like somebody
> +	 * is doing a tmpfile dance, and didn't fsync.  Best effort;
> +	 * ignore errors.
> +	 */
> +	if (new_inode) {
> +		xfs_inode_t *ip = XFS_I(odentry->d_inode);
> +
> +		if (VN_DIRTY(VFS_I(ip)) && ip->i_delayed_blks > 0)
> +			filemap_flush(new_inode->i_mapping);
> +	}

IFF we want a heuristic it should be a proper filemap_write_and_wait.  a
non-blocking start of I/O without waiting for it is snake oil.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
