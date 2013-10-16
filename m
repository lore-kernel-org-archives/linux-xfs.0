Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id C60A67F4E
	for <xfs@oss.sgi.com>; Wed, 16 Oct 2013 18:54:31 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 6A984AC001
	for <xfs@oss.sgi.com>; Wed, 16 Oct 2013 16:54:31 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	V5rKza7UEKXi2gfD for <xfs@oss.sgi.com>;
	Wed, 16 Oct 2013 16:54:30 -0700 (PDT)
Date: Thu, 17 Oct 2013 10:54:27 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 0/3] xfsprogs: v4 inode type in directory
Message-ID: <20131016235427.GO4446@dastard>
References: <20131016223654.505433792@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131016223654.505433792@sgi.com>
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
To: Mark Tinguely <tinguely@sgi.com>
Cc: xfs@oss.sgi.com

On Wed, Oct 16, 2013 at 05:36:54PM -0500, Mark Tinguely wrote:
> Here are the patches that enable the inode in the directory
> feature in v4 superblocks.
> 
>  patch 1: add the entries to xfs_sb.h (sync with kernel)
>  patch 2: add the XFS_FSOP_GEOM_FLAGS_FTYPE to xfs_fs.h (sync with kernel)
> 	  add the entry to repair so that xfs_info reports the feature
>  patch 3: add the feature to mkfs.xfs and manual page.
>           note: this new feature is ignored for superblock v5
> 		automatically turns on this feature.

xfs_db needs to have the version string output updated, it also
needs support for dirent dtype dumping for block, leaf and node form
directories.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
