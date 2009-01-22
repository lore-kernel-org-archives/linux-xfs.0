Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n0M6BUZ0050873 for <xfs@oss.sgi.com>; Thu, 22 Jan 2009 00:11:31 -0600
In-Reply-To: <1232578645-20213-1-git-send-email-felixb@sgi.com>
References: <1232578645-20213-1-git-send-email-felixb@sgi.com>
Mime-Version: 1.0 (Apple Message framework v753.1)
Message-Id: <0AC805F5-C30E-4439-A32B-2625D7FBEDFD@sgi.com>
From: Felix Blyakher <felixb@sgi.com>
Subject: Re: [PATCH] [XFS] Warn on transaction in flight on read-only remount
Date: Thu, 22 Jan 2009 00:10:15 -0600
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Felix Blyakher <felixb@sgi.com>
Cc: xfs@oss.sgi.com

[resending after fixing xfs mailing list on oss]

Just wanted to point out to discussion on this topic:

http://oss.sgi.com/archives/xfs/2008-12/msg00019.html

I merely took a suggestion from it, and put it in a patch.

Felix

On Jan 21, 2009, at 4:57 PM, Felix Blyakher wrote:

> Till VFS can correctly support read-only remount without racing,
> use WARN_ON instead of BUG_ON on detecting transaction in flight
> after quiescing filesystem.
>
> Signed-off-by: Felix Blyakher <felixb@sgi.com>
> ---
>  fs/xfs/linux-2.6/xfs_sync.c |    5 ++++-
>  1 files changed, 4 insertions(+), 1 deletions(-)
>
> diff --git a/fs/xfs/linux-2.6/xfs_sync.c b/fs/xfs/linux-2.6/xfs_sync.c
> index 2ed0353..d8373ee 100644
> --- a/fs/xfs/linux-2.6/xfs_sync.c
> +++ b/fs/xfs/linux-2.6/xfs_sync.c
> @@ -371,7 +371,10 @@ xfs_quiesce_attr(
>  	/* flush inodes and push all remaining buffers out to disk */
>  	xfs_quiesce_fs(mp);
>
> -	ASSERT_ALWAYS(atomic_read(&mp->m_active_trans) == 0);
> +	/* Just warn here till VFS can correctly support
> +	 * read-only remount without racing.
> +	 */
> +	WARN_ON(atomic_read(&mp->m_active_trans) == 0);
>
>  	/* Push the superblock and write an unmount record */
>  	error = xfs_log_sbcount(mp, 1);
> -- 
> 1.6.1
>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
