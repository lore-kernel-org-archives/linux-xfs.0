Return-Path: <SRS0=QbY/=2I=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD454C2D0CD
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Dec 2019 23:10:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7E808227BF
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Dec 2019 23:10:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="dciglZt8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726546AbfLRXKN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 18 Dec 2019 18:10:13 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:51528 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726559AbfLRXKM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 Dec 2019 18:10:12 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBIN9tnS113323;
        Wed, 18 Dec 2019 23:10:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=+tDUtIGd+CZmRNNIaS7GP/hM8dwz1JTOx6y/bt3ey3s=;
 b=dciglZt8FQweSEoyF5rB80d6hrX3YmvtsA6lp9q35S4CL0Ax7uViCWwpqj6OyKHPsMb5
 upDOQ/lujqj2Q0+9MuTXoq9x023CzzV3dJLIbQHjEvnV+Da0p1vWwLbQNlaXI5FsrqHY
 ra5VT7mOv9VB5oiGb8odYJhRq96ZhVoSn6GGSSNRppH2XqeGgYAhwxT3vK+PID5S5chW
 GYsejVplrM/ccZR7IbdlEKjSpROEAhPG6d7VzJNbiavOo459POwuMtMpcO41jHk/VUsm
 JeMTzB7l2rGJvIxLxjcM1LDiz+gzA9U5/Bwl5y5pZdWkTPpRRU3JTTtXj1juwsV+tsI2 Xw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2wvq5urr1p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Dec 2019 23:10:10 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBIN9sm0048954;
        Wed, 18 Dec 2019 23:10:09 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 2wyut4c32f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Dec 2019 23:10:08 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xBIN9art006649;
        Wed, 18 Dec 2019 23:09:36 GMT
Received: from localhost (/10.145.179.16)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 18 Dec 2019 15:09:36 -0800
Date:   Wed, 18 Dec 2019 15:09:35 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 2/3] xfsprogs: make a couple of structures static
Message-ID: <20191218230935.GJ7489@magnolia>
References: <291387f3-1517-14c0-f64a-a98164131f89@sandeen.net>
 <ea404006-44aa-ac0a-6bea-b23fb748e71d@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ea404006-44aa-ac0a-6bea-b23fb748e71d@sandeen.net>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9475 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1912180173
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9475 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1912180173
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Dec 18, 2019 at 04:55:38PM -0600, Eric Sandeen wrote:
> From: Eric Sandeen <sandeen@redhat.com>
> 
> Eliminates 2 sparse warnings.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> diff --git a/db/btheight.c b/db/btheight.c
> index 8aa17c89..fdb19a6d 100644
> --- a/db/btheight.c
> +++ b/db/btheight.c
> @@ -22,7 +22,7 @@ static int rmap_maxrecs(struct xfs_mount *mp, int blocklen, int leaf)
>  	return libxfs_rmapbt_maxrecs(blocklen, leaf);
>  }
>  
> -struct btmap {
> +static struct btmap {

Maybe these both should be static const?

--D

>  	const char	*tag;
>  	int		(*maxrecs)(struct xfs_mount *mp, int blocklen,
>  				   int leaf);
> diff --git a/io/bulkstat.c b/io/bulkstat.c
> index 201470b2..05a3d6d6 100644
> --- a/io/bulkstat.c
> +++ b/io/bulkstat.c
> @@ -230,7 +230,7 @@ struct single_map {
>  	uint64_t		code;
>  };
>  
> -struct single_map tags[] = {
> +static struct single_map tags[] = {
>  	{"root", XFS_BULK_IREQ_SPECIAL_ROOT},
>  	{NULL, 0},
>  };
> 
