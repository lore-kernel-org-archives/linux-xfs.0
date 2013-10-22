Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 13E917F4E
	for <xfs@oss.sgi.com>; Tue, 22 Oct 2013 13:29:45 -0500 (CDT)
Date: Tue, 22 Oct 2013 13:29:32 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 09/19] xfs: decouple inode and bmap btree header files
Message-ID: <20131022182932.GP1935@sgi.com>
References: <1381789085-21923-1-git-send-email-david@fromorbit.com>
	<1381789085-21923-10-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1381789085-21923-10-git-send-email-david@fromorbit.com>
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

On Tue, Oct 15, 2013 at 09:17:55AM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Currently the xfs_inode.h header has a dependency on the definition
> of the BMAP btree records as the inode fork includes an array of
> xfs_bmbt_rec_host_t objects in it's definition.
> 
> Move all the btree format definitions from xfs_btree.h,
> xfs_bmap_btree.h, xfs_alloc_btree.h and xfs_ialloc_btree.h to
> xfs_format.h to continue the process of centralising the on-disk
> format definitions. With this done, the xfs inode definitions are no
> longer dependent on btree header files.
> 
> The enables a massive culling of unnecessary includes, with close to
> 200 #include directives removed from the XFS kernel code base.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Reviewed-by: Ben Myers <bpm@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
