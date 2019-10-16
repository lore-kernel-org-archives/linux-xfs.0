Return-Path: <SRS0=pjFm=YJ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ADC66FA372A
	for <linux-xfs@archiver.kernel.org>; Wed, 16 Oct 2019 18:30:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 86AA221A49
	for <linux-xfs@archiver.kernel.org>; Wed, 16 Oct 2019 18:30:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="KkGfoj65"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436631AbfJPSaX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 16 Oct 2019 14:30:23 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:44220 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2436612AbfJPSaX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 16 Oct 2019 14:30:23 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9GIIm40146233;
        Wed, 16 Oct 2019 18:29:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=qhccaaYj/f+rbFOZ46h3HKzoEokwNhb+oZod3SwbV0c=;
 b=KkGfoj65Gz8eAtORoYCVyr7zuG0xQF4AR/+Apu19obHWFX/uxGqpQsdk3H6AdFXK8WFB
 BdtE/dmSMieXa9cc7Ep0QALoAb1K2coCSXh/vboRzBh23Zlh5VQT24FeBtYzAfkrZRrk
 lwmP3xjgK6hV8SZ7xa+G6ETRJnCO1hd/Q4e14qjMppef5Qh4a/P/bHTTBSEhjStsmoLG
 9cb8fmqHZ6IVztEXG+yxMYNKIVjYcm3FOIRfY8MTaw2bIpY11ASuZW0weRDAzyFKLTIQ
 hJr461dEsDKSw/HhL1ETsXTDWoMF3oNtS1UamiBmADAlvgxtu8C0546+Ae0OkeyjF4YM dQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2vk68urynt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 16 Oct 2019 18:29:54 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9GIJAZN057833;
        Wed, 16 Oct 2019 18:29:53 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 2vp3bhqjkj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 16 Oct 2019 18:29:53 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x9GITqSG000589;
        Wed, 16 Oct 2019 18:29:52 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 16 Oct 2019 11:29:52 -0700
Date:   Wed, 16 Oct 2019 11:29:50 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Ian Kent <raven@themaw.net>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>,
        Brian Foster <bfoster@redhat.com>,
        Eric Sandeen <sandeen@sandeen.net>,
        David Howells <dhowells@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH v6 07/12] xfs: add xfs_remount_ro() helper
Message-ID: <20191016182950.GG13108@magnolia>
References: <157118625324.9678.16275725173770634823.stgit@fedora-28>
 <157118648212.9678.8527671232668102210.stgit@fedora-28>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <157118648212.9678.8527671232668102210.stgit@fedora-28>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9412 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910160151
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9412 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910160151
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Oct 16, 2019 at 08:41:22AM +0800, Ian Kent wrote:
> Factor the remount read only code into a helper to simplify the
> subsequent change from the super block method .remount_fs to the
> mount-api fs_context_operations method .reconfigure.
> 
> Signed-off-by: Ian Kent <raven@themaw.net>
> Reviewed-by: Brian Foster <bfoster@redhat.com>
> ---
>  fs/xfs/xfs_super.c |   73 +++++++++++++++++++++++++++++++---------------------
>  1 file changed, 43 insertions(+), 30 deletions(-)
> 
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index cdc19c2af50f..1f706cbf9624 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -1275,6 +1275,47 @@ xfs_remount_rw(
>  	return 0;
>  }
>  
> +static int
> +xfs_remount_ro(
> +	struct xfs_mount	*mp)
> +{
> +	int error;

Please indent the variable consistently with the parameter list.
Otherwise looks ok.

--D

> +
> +	/*
> +	 * Cancel background eofb scanning so it cannot race with the
> +	 * final log force+buftarg wait and deadlock the remount.
> +	 */
> +	xfs_stop_block_reaping(mp);
> +
> +	/* Get rid of any leftover CoW reservations... */
> +	error = xfs_icache_free_cowblocks(mp, NULL);
> +	if (error) {
> +		xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
> +		return error;
> +	}
> +
> +	/* Free the per-AG metadata reservation pool. */
> +	error = xfs_fs_unreserve_ag_blocks(mp);
> +	if (error) {
> +		xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
> +		return error;
> +	}
> +
> +	/*
> +	 * Before we sync the metadata, we need to free up the reserve
> +	 * block pool so that the used block count in the superblock on
> +	 * disk is correct at the end of the remount. Stash the current
> +	 * reserve pool size so that if we get remounted rw, we can
> +	 * return it to the same size.
> +	 */
> +	xfs_save_resvblks(mp);
> +
> +	xfs_quiesce_attr(mp);
> +	mp->m_flags |= XFS_MOUNT_RDONLY;
> +
> +	return 0;
> +}
> +
>  STATIC int
>  xfs_fs_remount(
>  	struct super_block	*sb,
> @@ -1345,37 +1386,9 @@ xfs_fs_remount(
>  
>  	/* rw -> ro */
>  	if (!(mp->m_flags & XFS_MOUNT_RDONLY) && (*flags & SB_RDONLY)) {
> -		/*
> -		 * Cancel background eofb scanning so it cannot race with the
> -		 * final log force+buftarg wait and deadlock the remount.
> -		 */
> -		xfs_stop_block_reaping(mp);
> -
> -		/* Get rid of any leftover CoW reservations... */
> -		error = xfs_icache_free_cowblocks(mp, NULL);
> -		if (error) {
> -			xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
> -			return error;
> -		}
> -
> -		/* Free the per-AG metadata reservation pool. */
> -		error = xfs_fs_unreserve_ag_blocks(mp);
> -		if (error) {
> -			xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
> +		error = xfs_remount_ro(mp);
> +		if (error)
>  			return error;
> -		}
> -
> -		/*
> -		 * Before we sync the metadata, we need to free up the reserve
> -		 * block pool so that the used block count in the superblock on
> -		 * disk is correct at the end of the remount. Stash the current
> -		 * reserve pool size so that if we get remounted rw, we can
> -		 * return it to the same size.
> -		 */
> -		xfs_save_resvblks(mp);
> -
> -		xfs_quiesce_attr(mp);
> -		mp->m_flags |= XFS_MOUNT_RDONLY;
>  	}
>  
>  	return 0;
> 
