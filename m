Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 5E1C07FA2
	for <xfs@oss.sgi.com>; Wed, 22 Jan 2014 17:16:25 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 47081304051
	for <xfs@oss.sgi.com>; Wed, 22 Jan 2014 15:16:22 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	atWbHXyzQZJ75k4Z for <xfs@oss.sgi.com>;
	Wed, 22 Jan 2014 15:16:20 -0800 (PST)
Date: Thu, 23 Jan 2014 10:14:39 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 3/3 V3] xfs: allow logical-sector sized O_DIRECT
Message-ID: <20140122231439.GH27606@dastard>
References: <52DEF81D.4090100@redhat.com>
 <52DEF8BF.5070106@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <52DEF8BF.5070106@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Eric Sandeen <sandeen@redhat.com>, xfs-oss <xfs@oss.sgi.com>

On Tue, Jan 21, 2014 at 04:46:23PM -0600, Eric Sandeen wrote:
> Some time ago, mkfs.xfs started picking the storage physical
> sector size as the default filesystem "sector size" in order
> to avoid RMW costs incurred by doing IOs at logical sector
> size alignments.
> 
> However, this means that for a filesystem made with i.e.
> a 4k sector size on an "advanced format" 4k/512 disk,
> 512-byte direct IOs are no longer allowed.  This means
> that XFS has essentially turned this AF drive into a hard
> 4K device, from the filesystem on up.
> 
> XFS's mkfs-specified "sector size" is really just controlling
> the minimum size & alignment of filesystem metadata.
> 
> There is no real need to tightly couple XFS's minimal
> metadata size to the minimum allowed direct IO size;
> XFS can continue doing metadata in optimal sizes, but
> still allow smaller DIOs for apps which issue them,
> for whatever reason.
> 
> This patch adds a new field to the xfs_buftarg, so that
> we now track 2 sizes:
> 
>  1) The metadata sector size, which is the minimum unit and
>     alignment of IO which will be performed by metadata operations.
>  2) The device logical sector size
> 
> The first is used internally by the file system for metadata
> alignment and IOs.
> The second is used for the minimum allowed direct IO alignment.
> 
> This has passed xfstests on filesystems made with 4k sectors,
> including when run under the patch I sent to ignore
> XFS_IOC_DIOINFO, and issue 512 DIOs anyway.  I also directly
> tested end of block behavior on preallocated, sparse, and
> existing files when we do a 512 IO into a 4k file on a 
> 4k-sector filesystem, to be sure there were no unexpected
> behaviors.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Looks good. Nice work with the comments.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
