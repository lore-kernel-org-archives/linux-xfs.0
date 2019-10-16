Return-Path: <SRS0=pjFm=YJ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA4E3FA372B
	for <linux-xfs@archiver.kernel.org>; Wed, 16 Oct 2019 18:28:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 87163218DE
	for <linux-xfs@archiver.kernel.org>; Wed, 16 Oct 2019 18:28:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="OxRfUpts"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727374AbfJPS22 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 16 Oct 2019 14:28:28 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:34494 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390895AbfJPS21 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 16 Oct 2019 14:28:27 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9GIImrl132986;
        Wed, 16 Oct 2019 18:28:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=VX1OMuxmuulTTMzTGdQgoZNuBC6FWp+Vsk6ZFreyxwg=;
 b=OxRfUpts+YZct6K9tpHvRCeF1UWwvVPRp+vfz2Imd4YSxj3UbW821cNnZoMuxyAEFqDM
 abDXHPxAO3Mg4AIOFzigw4/OEZq5PbH5DgTr2jRws0NxF7j4HFo0s8AOV52spid4mfcY
 IkoVJYGeR5btDbMXPumsQGt1UOjGDbk0JKpUR2/APtWug/essqeGmidZ3ZT6FZa1ohYK
 tk0cIzh5A7MhCnfVfzf3MEtDDaHFzlpVc6HZI685+eLIP0yMnl7T5/6HqNEepnsLC/N8
 DXZ3Yh/YF8g2OKKcjliE+Pm2HUyTWZC8OmbJBDHHkhwPUc4dNekzV7P8yqXnz67YTDLK /A== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2vk7frgs7w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 16 Oct 2019 18:28:11 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9GIJ7KL057198;
        Wed, 16 Oct 2019 18:26:11 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 2vp3bhqd2g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 16 Oct 2019 18:26:11 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x9GIQ94q030785;
        Wed, 16 Oct 2019 18:26:09 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 16 Oct 2019 11:26:09 -0700
Date:   Wed, 16 Oct 2019 11:26:07 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Ian Kent <raven@themaw.net>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>,
        Brian Foster <bfoster@redhat.com>,
        Eric Sandeen <sandeen@sandeen.net>,
        David Howells <dhowells@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH v6 03/12] xfs: remove unused mount info field m_fsname_len
Message-ID: <20191016182607.GC13108@magnolia>
References: <157118625324.9678.16275725173770634823.stgit@fedora-28>
 <157118645790.9678.2717342742220454176.stgit@fedora-28>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <157118645790.9678.2717342742220454176.stgit@fedora-28>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9412 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910160151
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9412 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910160151
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Oct 16, 2019 at 08:40:58AM +0800, Ian Kent wrote:
> The mount info field m_fsname_len is not used anywhere, remove it.
> 
> Signed-off-by: Ian Kent <raven@themaw.net>

With hch's comments applied,

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_mount.h |    1 -
>  fs/xfs/xfs_super.c |    1 -
>  2 files changed, 2 deletions(-)
> 
> diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
> index fdb60e09a9c5..b3230f7ca2bf 100644
> --- a/fs/xfs/xfs_mount.h
> +++ b/fs/xfs/xfs_mount.h
> @@ -90,7 +90,6 @@ typedef struct xfs_mount {
>  
>  	struct xfs_buf		*m_sb_bp;	/* buffer for superblock */
>  	char			*m_fsname;	/* filesystem name */
> -	int			m_fsname_len;	/* strlen of fs name */
>  	char			*m_rtname;	/* realtime device name */
>  	char			*m_logname;	/* external log device name */
>  	int			m_bsize;	/* fs logical block size */
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index 1bb7ede5d75b..cfa306f62bec 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -172,7 +172,6 @@ xfs_parseargs(
>  	mp->m_fsname = kstrndup(sb->s_id, MAXNAMELEN, GFP_KERNEL);
>  	if (!mp->m_fsname)
>  		return -ENOMEM;
> -	mp->m_fsname_len = strlen(mp->m_fsname) + 1;
>  
>  	/*
>  	 * Copy binary VFS mount flags we are interested in.
> 
