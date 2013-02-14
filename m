Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id D0B008084
	for <xfs@oss.sgi.com>; Thu, 14 Feb 2013 17:42:44 -0600 (CST)
Date: Thu, 14 Feb 2013 17:42:44 -0600
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH] xfs: xfs_bmap_add_attrfork_local is too generic
Message-ID: <20130214234244.GM22182@sgi.com>
References: <1360558693-20354-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1360558693-20354-1-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Mon, Feb 11, 2013 at 03:58:13PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> When we are converting local data to an extent format as a result of
> adding an attribute, the type of data contained in the local fork
> determines the behaviour that needs to occur.
> 
> xfs_bmap_add_attrfork_local() already handles the directory data
> case specially by using S_ISDIR() and calling out to
> xfs_dir2_sf_to_block(), but with verifiers we now need to handle
> each different type of metadata specially and different metadata
> formats require different verifiers (and eventually block header
> initialisation).
> 
> There is only a single place that we add and attribute fork to
> the inode, but that is in the attribute code and it knows nothing
> about the specific contents of the data fork. It is only the case of
> local data that is the issue here, so adding code to hadnle this
> case in the attribute specific code is wrong. Hence we are really
> stuck trying to detect the data fork contents in
> xfs_bmap_add_attrfork_local() and performing the correct callout
> there.
> 
> Luckily the current cases can be determined by S_IS* macros, and we
> can push the work off to data specific callouts, but each of those
> callouts does a lot of work in common with
> xfs_bmap_local_to_extents(). The only reason that this fails for
> symlinks right now is is that xfs_bmap_local_to_extents() assumes
> the data fork contains extent data, and so attaches a a bmap extent
> data verifier to the buffer and simply copies the data fork
> information straight into it.
> 
> To fix this, allow us to pass a "formatting" callback into
> xfs_bmap_local_to_extents() which is responsible for setting the
> buffer type, initialising it and copying the data fork contents over
> to the new buffer. This allows callers to specify how they want to
> format the new buffer (which is necessary for the upcoming CRC
> enabled metadata blocks) and hence make xfs_bmap_local_to_extents()
> useful for any type of data fork content.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Applied.  We'd like this one in 3.8, one way or the other.

Regards,
	Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
