Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 536C37F3F
	for <xfs@oss.sgi.com>; Tue, 11 Feb 2014 00:08:11 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 2ECD8304070
	for <xfs@oss.sgi.com>; Mon, 10 Feb 2014 22:08:07 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	ii4VFVVvBsTuGGSU for <xfs@oss.sgi.com>;
	Mon, 10 Feb 2014 22:08:06 -0800 (PST)
Date: Tue, 11 Feb 2014 17:07:37 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v3 02/11] xfs: reserve v5 superblock read-only compat.
	feature bit for finobt
Message-ID: <20140211060737.GC13647@dastard>
References: <1391536182-9048-1-git-send-email-bfoster@redhat.com>
	<1391536182-9048-3-git-send-email-bfoster@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1391536182-9048-3-git-send-email-bfoster@redhat.com>
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
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

On Tue, Feb 04, 2014 at 12:49:33PM -0500, Brian Foster wrote:
> Reserve a v5 read-only compatibility feature bit for the finobt and
> create the xfs_sb_version_hasfinobt() helper to determine whether
> an fs has the feature enabled.
> 
> The finobt does not change existing on-disk structures, but must
> remain consistent with the ialloc btree. Modifications from older
> kernels would violate that constrant. Therefore, we restrict older
> kernels to read-only mounts of finobt-enabled filesystems.
> 
> Note that this does not yet enable the ability to rw mount a finobt
> fs (by setting the feature bit in the XFS_SB_FEAT_RO_COMPAT_ALL
> mask).
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>

Looks good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
