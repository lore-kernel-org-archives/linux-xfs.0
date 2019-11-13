Return-Path: <SRS0=J5MO=ZF=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EBF68C43331
	for <linux-xfs@archiver.kernel.org>; Wed, 13 Nov 2019 04:41:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BD4E6222CA
	for <linux-xfs@archiver.kernel.org>; Wed, 13 Nov 2019 04:41:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Eq8TZ1I2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727041AbfKMElm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 12 Nov 2019 23:41:42 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:45278 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727001AbfKMElm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 12 Nov 2019 23:41:42 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAD4dTF0170264;
        Wed, 13 Nov 2019 04:41:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=S++V1UKeA7WJj4ofe8jaL8C/vURdwr6aL1uTi587mxM=;
 b=Eq8TZ1I2a8s9HPd2HkJG2+wum35EBh0euxEVqZOlNE8STfHH39GIbXXjqtfNdNf9z7dW
 lwSpb1f8dnE0j50hE+IJdoRttVv5pjXXZvfsFzZB8NfnkS5OmOMjvYexER+AGpg9wpag
 4Jlvz7XoUUsC7HzcfDzjHcUumhJnFyodx7gwDqJxUAIJhuYrtQof0mbBe6mqWloD5AzN
 osvCfwB7gqS9PAz8ciyIZRPnpV2UnS/vMGZaCIYPJt8hXlMiMwv7malt6Gw2yMSwqpS0
 n/2ChJuUxTrQzTAWC+/F/O94FGULktnxJIAQ+PJwTEir/aQrENqgUGqkeAB8ypQ8CS0e DA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2w5ndq9kbb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Nov 2019 04:41:38 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAD4cdfP164706;
        Wed, 13 Nov 2019 04:41:38 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 2w7vpnk1sw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Nov 2019 04:41:38 +0000
Received: from abhmp0022.oracle.com (abhmp0022.oracle.com [141.146.116.28])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xAD4fbfF009816;
        Wed, 13 Nov 2019 04:41:37 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 12 Nov 2019 20:41:36 -0800
Date:   Tue, 12 Nov 2019 20:41:35 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 2/2] xfs: remove unused structure members & simple
 typedefs
Message-ID: <20191113044135.GJ6219@magnolia>
References: <321019c7-574e-e7e1-0eb6-e60776ad7948@sandeen.net>
 <9b291c94-2961-3c11-22e4-556220758a9c@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9b291c94-2961-3c11-22e4-556220758a9c@sandeen.net>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9439 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1910280000 definitions=main-1911130040
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9439 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1910280000
 definitions=main-1911130040
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Nov 12, 2019 at 05:01:43PM -0600, Eric Sandeen wrote:
> Remove some unused typedef'd simple types, and some unused 
> structure members.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
> 
> diff --git a/fs/xfs/libxfs/xfs_types.h b/fs/xfs/libxfs/xfs_types.h
> index 300b3e91ca3a..397d94775440 100644
> --- a/fs/xfs/libxfs/xfs_types.h
> +++ b/fs/xfs/libxfs/xfs_types.h
> @@ -21,7 +21,6 @@ typedef int32_t		xfs_suminfo_t;	/* type of bitmap summary info */
>  typedef uint32_t	xfs_rtword_t;	/* word type for bitmap manipulations */
>  
>  typedef int64_t		xfs_lsn_t;	/* log sequence number */
> -typedef int32_t		xfs_tid_t;	/* transaction identifier */
>  
>  typedef uint32_t	xfs_dablk_t;	/* dir/attr block number (in file) */
>  typedef uint32_t	xfs_dahash_t;	/* dir/attr hash value */
> @@ -33,7 +32,6 @@ typedef uint64_t	xfs_fileoff_t;	/* block number in a file */
>  typedef uint64_t	xfs_filblks_t;	/* number of blocks in a file */
>  
>  typedef int64_t		xfs_srtblock_t;	/* signed version of xfs_rtblock_t */
> -typedef int64_t		xfs_sfiloff_t;	/* signed block number in a file */
>  
>  /*
>   * New verifiers will return the instruction address of the failing check.
> diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
> index b880c23cb6e4..ca0f0de5feb9 100644
> --- a/fs/xfs/xfs_log_priv.h
> +++ b/fs/xfs/xfs_log_priv.h
> @@ -399,8 +399,6 @@ struct xlog {
>  	/* The following field are used for debugging; need to hold icloglock */
>  #ifdef DEBUG
>  	void			*l_iclog_bak[XLOG_MAX_ICLOGS];
> -	/* log record crc error injection factor */
> -	uint32_t		l_badcrc_factor;
>  #endif
>  	/* log recovery lsn tracking (for buffer submission */
>  	xfs_lsn_t		l_recovery_lsn;
> diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
> index fdb60e09a9c5..ebba9a61f804 100644
> --- a/fs/xfs/xfs_mount.h
> +++ b/fs/xfs/xfs_mount.h
> @@ -59,7 +59,6 @@ struct xfs_error_cfg {
>  
>  typedef struct xfs_mount {
>  	struct super_block	*m_super;
> -	xfs_tid_t		m_tid;		/* next unused tid for fs */
>  
>  	/*
>  	 * Bitsets of per-fs metadata that have been checked and/or are sick.
> 
> 
