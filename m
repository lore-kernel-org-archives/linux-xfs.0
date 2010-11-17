Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oAH9WTF4219680 for <xfs@oss.sgi.com>; Wed, 17 Nov 2010 03:32:29 -0600
Date: Wed, 17 Nov 2010 04:34:02 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v3 4/9] xfsrestore: mmap dirent names for faster lookups
Message-ID: <20101117093402.GG17317@infradead.org>
References: <20101116150502.179825893@sgi.com>
	<20101116150704.454578811@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20101116150704.454578811@sgi.com>
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
To: wkendall@sgi.com
Cc: xfs@oss.sgi.com

On Tue, Nov 16, 2010 at 09:05:06AM -0600, wkendall@sgi.com wrote:
> Pathname resolution in xfsrestore is about 4x faster if the file
> containing dirent names ("namreg") is memory mapped.  If xfsrestore is
> unable to map the file (e.g., due to virtual memory constraints)
> fallback to the existing seek-and-read approach.
> 
> The file is mapped after all directory entries have been written to
> the "namreg" file. If the caller tries to add additional entries after
> the file has been mapped, it will be unmapped and restore will resort
> back to seek-and-read lookups.
> 
> Signed-off-by: Bill Kendall <wkendall@sgi.com>
> 
> Reviewed-by: Alex Elder <aelder@sgi.com>

Generally looks good to me, but I really hate how namreg_map/unmap
are hidden under namreg_add/flush.  As a start instead of adding the
done_adding argument we can easily move the explicit map to the one
caller wanting it, similarly namreg_unmap could be moved to namreg_add,
that is manage to mapping/unmapping explicitly.

In fact I'm not sure what the point of the unmap/map cycles is.  At
least in Linux concurrent buffer writes and mmap reads are coherent.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
