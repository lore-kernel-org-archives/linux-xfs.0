Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2MJxYLD029715 for <xfs@oss.sgi.com>; Thu, 22 Mar 2012 14:59:34 -0500
Date: Thu, 22 Mar 2012 14:59:43 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH] xfs: fix deadlock in xfs_rtfree_extent with kernel v3.x
Message-ID: <20120322195943.GT7762@sgi.com>
References: <kdasu.kdev@gmail.com>
	<1329957699-20769-1-git-send-email-kdasu.kdev@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1329957699-20769-1-git-send-email-kdasu.kdev@gmail.com>
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
To: Kamal Dasu <kdasu.kdev@gmail.com>
Cc: cernekee@gmail.com, xfs@oss.sgi.com

On Wed, Feb 22, 2012 at 07:41:39PM -0500, Kamal Dasu wrote:
> To fix the deadlock caused by recursively calling xfs_rtfree_extent
> 
>  - removed xfs_ilock() and xfs_trans_ijoin() from xfs_rtfree_extent(),
>    instead added asserts that the inode is locked and has an inode_item
>    attached to it.
>  - in xfs_bunmapi() when dealing with an inode with the rt flag
>    call xfs_ilock() and xfs_trans_ijoin() so that the
>    reference count is bumped on the inode and attached it to the
>    transaction before calling into xfs_bmap_del_extent, similar to
>    what we do in xfs_bmap_rtalloc.
> 
> Signed-off-by: Kamal Dasu <kdasu.kdev@gmail.com>

Kamal, this looks good to me.
Reviewed-by: Ben Myers <bpm@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
