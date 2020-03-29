Return-Path: <SRS0=WYbU=5O=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6757DC43331
	for <linux-xfs@archiver.kernel.org>; Sun, 29 Mar 2020 19:57:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 32B6D20714
	for <linux-xfs@archiver.kernel.org>; Sun, 29 Mar 2020 19:57:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Dg9flV3Y"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728554AbgC2T5D (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 29 Mar 2020 15:57:03 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:33268 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727101AbgC2T5D (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 29 Mar 2020 15:57:03 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02TJqXRf108714
        for <linux-xfs@vger.kernel.org>; Sun, 29 Mar 2020 19:57:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=YSc4SJUKkUDm+TFaos5BybvYqHlbmOz+cbyLOT/NZfw=;
 b=Dg9flV3Yxfuko1ACDY4mDJaWXen0wYQqdSiSv82Wd38tt5i3lN1Qjt6Rbk/wI9GK2Gv5
 P0umkFJIU9ebVme0rRDqdvV0/2jHlS+k+f7/S0Js/EleSrKzSnmknxekmvzpL0g9zmXq
 OhuumrXbXpMQbsh5Dp/IPr82Jv9VifempzY10xQMkrp+yGq8/Fk8PDlSueOTCm/D/oCL
 DXERA5Cj9eZkxVepCF0TkNXNP4tXEsRL6Rl54QmF7jyWNSf+zFUxDdAIUvDOWUOO4I3A
 Btmi3ck9d69fy8cMJn0dnjXa1j9l/NSgyaDi3wGGwfbBhJmmrEOAfO6EK841qt3yMYvl 3A== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 301y7mkpbb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 29 Mar 2020 19:57:02 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02TJqQb6013143
        for <linux-xfs@vger.kernel.org>; Sun, 29 Mar 2020 19:57:01 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 302g9tqrj3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 29 Mar 2020 19:57:01 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 02TJv1is013910
        for <linux-xfs@vger.kernel.org>; Sun, 29 Mar 2020 19:57:01 GMT
Received: from [192.168.1.223] (/67.1.1.216)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 29 Mar 2020 12:57:00 -0700
Subject: Re: [PATCH] xfs: ratelimit inode flush on buffered write ENOSPC
To:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        xfs <linux-xfs@vger.kernel.org>
References: <20200329172209.GA80283@magnolia>
From:   Allison Collins <allison.henderson@oracle.com>
Message-ID: <f463a618-dd04-e0e1-0bec-51c2f21f02be@oracle.com>
Date:   Sun, 29 Mar 2020 12:57:00 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20200329172209.GA80283@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9575 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 mlxlogscore=999 bulkscore=0 mlxscore=0 spamscore=0 adultscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003290186
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9575 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 spamscore=0 phishscore=0
 malwarescore=0 mlxscore=0 mlxlogscore=999 lowpriorityscore=0 adultscore=0
 priorityscore=1501 bulkscore=0 clxscore=1015 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2003290186
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 3/29/20 10:22 AM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> A customer reported rcu stalls and softlockup warnings on a computer
> with many CPU cores and many many more IO threads trying to write to a
> filesystem that is totally out of space.  Subsequent analysis pointed to
> the many many IO threads calling xfs_flush_inodes -> sync_inodes_sb,
> which causes a lot of wb_writeback_work to be queued.  The writeback
> worker spends so much time trying to wake the many many threads waiting
> for writeback completion that it trips the softlockup detector, and (in
> this case) the system automatically reboots.
> 
> In addition, they complain that the lengthy xfs_flush_inodes scan traps
> all of those threads in uninterruptible sleep, which hampers their
> ability to kill the program or do anything else to escape the situation.
> 
> If there's thousands of threads trying to write to files on a full
> filesystem, each of those threads will start separate copies of the
> inode flush scan.  This is kind of pointless since we only need one
> scan, so rate limit the inode flush.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Ok, makes sense
Reviewed-by: Allison Collins <allison.henderson@oracle.com>

> ---
>   fs/xfs/xfs_mount.h |    1 +
>   fs/xfs/xfs_super.c |   14 ++++++++++++++
>   2 files changed, 15 insertions(+)
> 
> diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
> index 88ab09ed29e7..50c43422fa17 100644
> --- a/fs/xfs/xfs_mount.h
> +++ b/fs/xfs/xfs_mount.h
> @@ -167,6 +167,7 @@ typedef struct xfs_mount {
>   	struct xfs_kobj		m_error_meta_kobj;
>   	struct xfs_error_cfg	m_error_cfg[XFS_ERR_CLASS_MAX][XFS_ERR_ERRNO_MAX];
>   	struct xstats		m_stats;	/* per-fs stats */
> +	struct ratelimit_state	m_flush_inodes_ratelimit;
>   
>   	struct workqueue_struct *m_buf_workqueue;
>   	struct workqueue_struct	*m_unwritten_workqueue;
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index 68fea439d974..abf06bf9c3f3 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -528,6 +528,9 @@ xfs_flush_inodes(
>   {
>   	struct super_block	*sb = mp->m_super;
>   
> +	if (!__ratelimit(&mp->m_flush_inodes_ratelimit))
> +		return;
> +
>   	if (down_read_trylock(&sb->s_umount)) {
>   		sync_inodes_sb(sb);
>   		up_read(&sb->s_umount);
> @@ -1366,6 +1369,17 @@ xfs_fc_fill_super(
>   	if (error)
>   		goto out_free_names;
>   
> +	/*
> +	 * Cap the number of invocations of xfs_flush_inodes to 16 for every
> +	 * quarter of a second.  The magic numbers here were determined by
> +	 * observation neither to cause stalls in writeback when there are a
> +	 * lot of IO threads and the fs is near ENOSPC, nor cause any fstest
> +	 * regressions.  YMMV.
> +	 */
> +	ratelimit_state_init(&mp->m_flush_inodes_ratelimit, HZ / 4, 16);
> +	ratelimit_set_flags(&mp->m_flush_inodes_ratelimit,
> +			RATELIMIT_MSG_ON_RELEASE);
> +
>   	error = xfs_init_mount_workqueues(mp);
>   	if (error)
>   		goto out_close_devices;
> 
