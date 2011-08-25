Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p7P51Kr5161940 for <xfs@oss.sgi.com>; Thu, 25 Aug 2011 00:01:20 -0500
Date: Thu, 25 Aug 2011 01:01:18 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/3] xfsprogs: xfs_quota: don't double project block counts
Message-ID: <20110825050118.GC23901@infradead.org>
References: <adcfe5e08d1c060ea95a8aa43e1abade24957dd0.1314222483.git.aelder@sgi.com>
	<e874ff01906d10e2ff4812b6badcc246f6a43af4.1314222483.git.aelder@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <e874ff01906d10e2ff4812b6badcc246f6a43af4.1314222483.git.aelder@sgi.com>
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
To: Alex Elder <aelder@sgi.com>
Cc: xfs@oss.sgi.com

On Wed, Aug 24, 2011 at 04:53:42PM -0500, Alex Elder wrote:
> In projects_free_space_data() all of the block counts returned are
> doubled.  This was probably a mistaken attempt to convert to or from
> 512-byte basic block units.  The caller expects the value returned
> to be in 512-byte units, which is exactly what the fs_disk_quota
> structure holds, so there should be no doubling.
> 
> The effect of this bug is that the disk space used by the "df"
> xfs_quota command shows block counts twice what they should be.
> 
> SGI PV 1015651
> 
> Signed-off-by: Alex Elder <aelder@sgi.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
