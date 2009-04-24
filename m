Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n3O4P9jQ057933 for <xfs@oss.sgi.com>; Thu, 23 Apr 2009 23:25:09 -0500
Received: from estes.americas.sgi.com (estes.americas.sgi.com [128.162.236.10])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 3D4DA3040A4
	for <xfs@oss.sgi.com>; Thu, 23 Apr 2009 21:25:04 -0700 (PDT)
Message-Id: <2890C8FC-5620-4F1B-8D25-A6DDC8527F7E@sgi.com>
From: Felix Blyakher <felixb@sgi.com>
In-Reply-To: <1624785772.3251240539480564.JavaMail.root@zmail05.collab.prod.int.phx2.redhat.com>
Mime-Version: 1.0 (Apple Message framework v930.3)
Subject: Re: [PATCH] xfs_file_last_byte() needs to acquire ilock
Date: Thu, 23 Apr 2009 23:25:03 -0500
References: <1624785772.3251240539480564.JavaMail.root@zmail05.collab.prod.int.phx2.redhat.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"; DelSp="yes"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Lachlan McIlroy <lmcilroy@redhat.com>
Cc: xfs@oss.sgi.com


On Apr 23, 2009, at 9:18 PM, Lachlan McIlroy wrote:

> We had some systems crash with this stack:
>
> [<a00000010000cb20>] ia64_leave_kernel+0x0/0x280
> [<a00000021291ca00>] xfs_bmbt_get_startoff+0x0/0x20 [xfs]
> [<a0000002129080b0>] xfs_bmap_last_offset+0x210/0x280 [xfs]
> [<a00000021295b010>] xfs_file_last_byte+0x70/0x1a0 [xfs]
> [<a00000021295b200>] xfs_itruncate_start+0xc0/0x1a0 [xfs]
> [<a0000002129935f0>] xfs_inactive_free_eofblocks+0x290/0x460 [xfs]
> [<a000000212998fb0>] xfs_release+0x1b0/0x240 [xfs]
> [<a0000002129ad930>] xfs_file_release+0x70/0xa0 [xfs]
> [<a000000100162ea0>] __fput+0x1a0/0x420
> [<a000000100163160>] fput+0x40/0x60
>
> The problem here is that xfs_file_last_byte() does not acquire the
> inode lock and can therefore race with another thread that is  
> modifying
> the extext list.  While xfs_bmap_last_offset() is trying to lookup
> what was the last extent some extents were merged and the extent list
> shrunk so the index we lookup is now beyond the end of the extent list
> and potentially in a freed buffer.
>
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index e7ae08d..cf62d9d 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -1258,8 +1258,10 @@ xfs_file_last_byte(
> 	 * necessary.
> 	 */
> 	if (ip->i_df.if_flags & XFS_IFEXTENTS) {
> +		xfs_ilock(ip, XFS_ILOCK_SHARED);
> 		error = xfs_bmap_last_offset(NULL, ip, &last_block,
> 			XFS_DATA_FORK);
> +		xfs_iunlock(ip, XFS_ILOCK_SHARED);
> 		if (error) {
> 			last_block = 0;
> 		}

My understanding from the original patch was that this is one part
of the fix, and the other was the following change:

@@ -3206,6 +3208,8 @@ xfs_bmap_del_extent(
                  */
                 XFS_BMAP_TRACE_DELETE("3", ip, idx, 1, whichfork);
                 xfs_iext_remove(ifp, idx, 1);
+               if (idx >= (ifp->if_bytes /  
(uint)sizeof(xfs_bmbt_rec_t)))
+                       idx--;
                 ifp->if_lastex = idx;
                 if (delay)
                         break;

You don't think it's still needed, do you?

Felix

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
