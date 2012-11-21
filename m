Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qALA75su031145 for <xfs@oss.sgi.com>; Wed, 21 Nov 2012 04:07:05 -0600
Date: Wed, 21 Nov 2012 05:09:13 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/9] xfs: factor out everything but the
	filemap_write_and_wait from xfs_file_fsync
Message-ID: <20121121100913.GF23339@infradead.org>
References: <20121120074116.24645.36369.stgit@blackbox.djwong.org>
	<20121120074138.24645.36708.stgit@blackbox.djwong.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20121120074138.24645.36708.stgit@blackbox.djwong.org>
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
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: axboe@kernel.dk, xfs@oss.sgi.com, tytso@mit.edu, bpm@sgi.com, linux-kernel@vger.kernel.org, hch@infradead.org, jmoyer@redhat.com, viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org, jack@suse.cz, linux-ext4@vger.kernel.org

On Mon, Nov 19, 2012 at 11:41:38PM -0800, Darrick J. Wong wrote:
> Hi,
> 
> Fsyncing is tricky business, so factor out the bits of the xfs_file_fsync
> function that can be used from the I/O post-processing path.

Why would we need to skip the filemap_write_and_wait_range call here?
If we're doing direct I/O we should not have any pages in this regions
anyway.  You're also not skipping it in the generic implementation as
far as I can see, so I see no point in doing it just in XFS.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
