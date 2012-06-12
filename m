Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q5CENuKp250129 for <xfs@oss.sgi.com>; Tue, 12 Jun 2012 09:23:57 -0500
Date: Tue, 12 Jun 2012 10:23:47 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 18/27] xfs: Convert to new freezing code
Message-ID: <20120612142346.GA25132@infradead.org>
References: <1339510848-16992-1-git-send-email-jack@suse.cz>
	<1339510848-16992-19-git-send-email-jack@suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1339510848-16992-19-git-send-email-jack@suse.cz>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Jan Kara <jack@suse.cz>
Cc: Alex Elder <elder@kernel.org>, linux-fsdevel@suse.cz, LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com, Ben Myers <bpm@sgi.com>, Al Viro <viro@ZenIV.linux.org.uk>

> +	 * We will pass freeze protection with a transaction.  So tell lockdep
> +	 * we released it.
> +	 */
> +	rwsem_release(&ioend->io_inode->i_sb->s_writers.lock_map[SB_FREEZE_FS-1],
> +		      1, _THIS_IP_);

I'll need some time to get through the whole series, but repeated use
of constructs like this really screams for a helper abstracting it out
and documenting it.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
