Return-Path: <SRS0=5kOL=YZ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8F83CA9ECF
	for <linux-xfs@archiver.kernel.org>; Fri,  1 Nov 2019 20:17:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6AB362086D
	for <linux-xfs@archiver.kernel.org>; Fri,  1 Nov 2019 20:17:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Xk8AI7t2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726477AbfKAURr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 1 Nov 2019 16:17:47 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:51832 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726709AbfKAURq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 1 Nov 2019 16:17:46 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA1KDgme039066;
        Fri, 1 Nov 2019 20:17:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=aMFHqWqqYJPtddQ4GZDMGn7TwWW9GAS0VGNXrW8bLc4=;
 b=Xk8AI7t2PNT6l9x0/U6f0Mwb+sLntFPjqbetS32XgbsuW7XhHxYgiIYFKaNHUQTr/ry3
 NfY3Ax3ljOgbUwqmsBVvwT4EUsp0ebylfLs2r099lSSmha4DmERioSWQNzA0F5JDexxj
 lDuv52jcb4BSk7wVZC/jwfAezEG83gZM0cOP/MqnoBLwqbbBcLBpzPcIfsTnpDBbUVF3
 5JXeefsm8xukAV0NwEEbXdVE/kl62XeSMdjfJ8eFRv1v2/qqNT/G3b+M/dLIUfPdNTN0
 ocB/W8sgs7axXMH0d1R8+gNfkEIwyd19BSeQhlBO289ogvV8oKtQUczRjVSAo3k+2N7o ZA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2vxwhfuyxy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 01 Nov 2019 20:17:20 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA1KE8Sk122560;
        Fri, 1 Nov 2019 20:17:19 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 2w0qdwx808-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 01 Nov 2019 20:17:19 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xA1KHHo9028210;
        Fri, 1 Nov 2019 20:17:17 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 01 Nov 2019 13:17:17 -0700
Date:   Fri, 1 Nov 2019 13:17:16 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Ian Kent <raven@themaw.net>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        Brian Foster <bfoster@redhat.com>,
        Eric Sandeen <sandeen@sandeen.net>,
        David Howells <dhowells@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH v8 15/16] xfs: move xfs_fc_get_tree() above
 xfs_fc_reconfigure()
Message-ID: <20191101201716.GI15222@magnolia>
References: <157259452909.28278.1001302742832626046.stgit@fedora-28>
 <157259468201.28278.11198315382109394618.stgit@fedora-28>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <157259468201.28278.11198315382109394618.stgit@fedora-28>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9428 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1911010186
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9428 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1911010186
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Nov 01, 2019 at 03:51:22PM +0800, Ian Kent wrote:
> Grouping the options parsing and mount handling functions above the
> struct fs_context_operations but below the struct super_operations
> should improve (some) the grouping of the super operations while also
> improving the grouping of the options parsing and mount handling code.
> 
> Now move xfs_fc_get_tree() and friends, also take the oppertunity to
> change STATIC to static for the xfs_fs_put_super() function.
> 
> Signed-off-by: Ian Kent <raven@themaw.net>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_super.c |  116 ++++++++++++++++++++++++++--------------------------
>  1 file changed, 58 insertions(+), 58 deletions(-)
> 
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index 9c5ea74dbfd5..7ff35ee0dc8f 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -1291,6 +1291,64 @@ xfs_destroy_percpu_counters(
>  	percpu_counter_destroy(&mp->m_delalloc_blks);
>  }
>  
> +static void
> +xfs_fs_put_super(
> +	struct super_block	*sb)
> +{
> +	struct xfs_mount	*mp = XFS_M(sb);
> +
> +	/* if ->fill_super failed, we have no mount to tear down */
> +	if (!sb->s_fs_info)
> +		return;
> +
> +	xfs_notice(mp, "Unmounting Filesystem");
> +	xfs_filestream_unmount(mp);
> +	xfs_unmountfs(mp);
> +
> +	xfs_freesb(mp);
> +	free_percpu(mp->m_stats.xs_stats);
> +	xfs_destroy_percpu_counters(mp);
> +	xfs_destroy_mount_workqueues(mp);
> +	xfs_close_devices(mp);
> +
> +	sb->s_fs_info = NULL;
> +	xfs_mount_free(mp);
> +}
> +
> +static long
> +xfs_fs_nr_cached_objects(
> +	struct super_block	*sb,
> +	struct shrink_control	*sc)
> +{
> +	/* Paranoia: catch incorrect calls during mount setup or teardown */
> +	if (WARN_ON_ONCE(!sb->s_fs_info))
> +		return 0;
> +	return xfs_reclaim_inodes_count(XFS_M(sb));
> +}
> +
> +static long
> +xfs_fs_free_cached_objects(
> +	struct super_block	*sb,
> +	struct shrink_control	*sc)
> +{
> +	return xfs_reclaim_inodes_nr(XFS_M(sb), sc->nr_to_scan);
> +}
> +
> +static const struct super_operations xfs_super_operations = {
> +	.alloc_inode		= xfs_fs_alloc_inode,
> +	.destroy_inode		= xfs_fs_destroy_inode,
> +	.dirty_inode		= xfs_fs_dirty_inode,
> +	.drop_inode		= xfs_fs_drop_inode,
> +	.put_super		= xfs_fs_put_super,
> +	.sync_fs		= xfs_fs_sync_fs,
> +	.freeze_fs		= xfs_fs_freeze,
> +	.unfreeze_fs		= xfs_fs_unfreeze,
> +	.statfs			= xfs_fs_statfs,
> +	.show_options		= xfs_fs_show_options,
> +	.nr_cached_objects	= xfs_fs_nr_cached_objects,
> +	.free_cached_objects	= xfs_fs_free_cached_objects,
> +};
> +
>  static struct xfs_mount *
>  xfs_mount_alloc(void)
>  {
> @@ -1515,64 +1573,6 @@ xfs_fc_get_tree(
>  	return get_tree_bdev(fc, xfs_fc_fill_super);
>  }
>  
> -STATIC void
> -xfs_fs_put_super(
> -	struct super_block	*sb)
> -{
> -	struct xfs_mount	*mp = XFS_M(sb);
> -
> -	/* if ->fill_super failed, we have no mount to tear down */
> -	if (!sb->s_fs_info)
> -		return;
> -
> -	xfs_notice(mp, "Unmounting Filesystem");
> -	xfs_filestream_unmount(mp);
> -	xfs_unmountfs(mp);
> -
> -	xfs_freesb(mp);
> -	free_percpu(mp->m_stats.xs_stats);
> -	xfs_destroy_percpu_counters(mp);
> -	xfs_destroy_mount_workqueues(mp);
> -	xfs_close_devices(mp);
> -
> -	sb->s_fs_info = NULL;
> -	xfs_mount_free(mp);
> -}
> -
> -static long
> -xfs_fs_nr_cached_objects(
> -	struct super_block	*sb,
> -	struct shrink_control	*sc)
> -{
> -	/* Paranoia: catch incorrect calls during mount setup or teardown */
> -	if (WARN_ON_ONCE(!sb->s_fs_info))
> -		return 0;
> -	return xfs_reclaim_inodes_count(XFS_M(sb));
> -}
> -
> -static long
> -xfs_fs_free_cached_objects(
> -	struct super_block	*sb,
> -	struct shrink_control	*sc)
> -{
> -	return xfs_reclaim_inodes_nr(XFS_M(sb), sc->nr_to_scan);
> -}
> -
> -static const struct super_operations xfs_super_operations = {
> -	.alloc_inode		= xfs_fs_alloc_inode,
> -	.destroy_inode		= xfs_fs_destroy_inode,
> -	.dirty_inode		= xfs_fs_dirty_inode,
> -	.drop_inode		= xfs_fs_drop_inode,
> -	.put_super		= xfs_fs_put_super,
> -	.sync_fs		= xfs_fs_sync_fs,
> -	.freeze_fs		= xfs_fs_freeze,
> -	.unfreeze_fs		= xfs_fs_unfreeze,
> -	.statfs			= xfs_fs_statfs,
> -	.show_options		= xfs_fs_show_options,
> -	.nr_cached_objects	= xfs_fs_nr_cached_objects,
> -	.free_cached_objects	= xfs_fs_free_cached_objects,
> -};
> -
>  static int
>  xfs_remount_rw(
>  	struct xfs_mount	*mp)
> 
