Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qALF2Jdn060057 for <xfs@oss.sgi.com>; Wed, 21 Nov 2012 09:02:19 -0600
From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH 3/9] xfs: factor out everything but the
	filemap_write_and_wait from xfs_file_fsync
References: <20121120074116.24645.36369.stgit@blackbox.djwong.org>
	<20121120074138.24645.36708.stgit@blackbox.djwong.org>
	<20121121100913.GF23339@infradead.org>
Date: Wed, 21 Nov 2012 09:10:35 -0500
In-Reply-To: <20121121100913.GF23339@infradead.org> (Christoph Hellwig's
	message of "Wed, 21 Nov 2012 05:09:13 -0500")
Message-ID: <x49mwybujvo.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
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
To: Christoph Hellwig <hch@infradead.org>
Cc: axboe@kernel.dk, tytso@mit.edu, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, bpm@sgi.com, viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org, jack@suse.cz, linux-ext4@vger.kernel.org

Christoph Hellwig <hch@infradead.org> writes:

> On Mon, Nov 19, 2012 at 11:41:38PM -0800, Darrick J. Wong wrote:
>> Hi,
>> 
>> Fsyncing is tricky business, so factor out the bits of the xfs_file_fsync
>> function that can be used from the I/O post-processing path.
>
> Why would we need to skip the filemap_write_and_wait_range call here?
> If we're doing direct I/O we should not have any pages in this regions
> anyway.  You're also not skipping it in the generic implementation as
> far as I can see, so I see no point in doing it just in XFS.

OK, I'll fix that.

Thanks!
Jeff

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
