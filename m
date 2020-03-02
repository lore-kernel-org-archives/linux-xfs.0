Return-Path: <SRS0=0zz6=4T=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F05D1C3F2D1
	for <linux-xfs@archiver.kernel.org>; Mon,  2 Mar 2020 17:45:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C7964214DB
	for <linux-xfs@archiver.kernel.org>; Mon,  2 Mar 2020 17:45:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="m2TMRvWQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727250AbgCBRpp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 2 Mar 2020 12:45:45 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:58516 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727255AbgCBRpp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 2 Mar 2020 12:45:45 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 022HheVv146820
        for <linux-xfs@vger.kernel.org>; Mon, 2 Mar 2020 17:45:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=lQhJ4TecyD30XScEYF4ecCRsXAfvEGDHPCm9tu2xeRk=;
 b=m2TMRvWQA2lwAsoz70nkCRlTk+MwIIzfYU0DcRqEy0mj6ZWmOS0aTd5mFrHF49hjQEg+
 vE6D0m2q2vpAm5bKsEO3UIv1U7d5Hfw1VOtlultkqp5raOtjY9nAgV5AHxUOtvyOduEu
 ZZ+2gnYmKOsdmlYzPqq8ptbEPqA5gAOdDVAiYPsJB2N/ECPUdk4y18mF7vkMZGrVdCrh
 wAdq8ztTf6XOlMIdSsTNGhpFE9rSqGNXw0cxmq5a7HHNRZltECnKVBgHKdy67OWddSfK
 lUmYxP+NToMSecxI8AoueE2C9db0yKtEy4YPaWoWFswISmxA7RkXBD95FPBTwDydT0H0 Qw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2yffcu9byw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 02 Mar 2020 17:45:43 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 022HgW84142817
        for <linux-xfs@vger.kernel.org>; Mon, 2 Mar 2020 17:43:43 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 2yg1ehh4m2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 02 Mar 2020 17:43:43 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 022HhgGs018917
        for <linux-xfs@vger.kernel.org>; Mon, 2 Mar 2020 17:43:42 GMT
Received: from [192.168.1.223] (/67.1.3.112)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 02 Mar 2020 09:43:42 -0800
Subject: Re: [PATCH 1/3] xfs: mark dir corrupt when lookup-by-hash fails
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
References: <158294094367.1730101.10848559171120744339.stgit@magnolia>
 <158294094977.1730101.1658645036964056566.stgit@magnolia>
From:   Allison Collins <allison.henderson@oracle.com>
Message-ID: <7504a6ee-94d5-734c-9298-a35c6da138a3@oracle.com>
Date:   Mon, 2 Mar 2020 10:43:41 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <158294094977.1730101.1658645036964056566.stgit@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9547 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0 spamscore=0
 mlxlogscore=999 malwarescore=0 bulkscore=0 mlxscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2003020117
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9547 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 bulkscore=0
 adultscore=0 suspectscore=0 spamscore=0 malwarescore=0 impostorscore=0
 priorityscore=1501 mlxlogscore=999 lowpriorityscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2003020117
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 2/28/20 6:49 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> In xchk_dir_actor, we attempt to validate the directory hash structures
> by performing a directory entry lookup by (hashed) name.  If the lookup
> returns ENOENT, that means that the hash information is corrupt.  The
> _process_error functions don't catch this, so we have to add that
> explicitly.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Ok, looks ok to me
Reviewed-by: Allison Collins <allison.henderson@oracle.com>

> ---
>   fs/xfs/scrub/dir.c |    5 +++++
>   1 file changed, 5 insertions(+)
> 
> 
> diff --git a/fs/xfs/scrub/dir.c b/fs/xfs/scrub/dir.c
> index 266da4e4bde6..54afa75c95d1 100644
> --- a/fs/xfs/scrub/dir.c
> +++ b/fs/xfs/scrub/dir.c
> @@ -155,6 +155,11 @@ xchk_dir_actor(
>   	xname.type = XFS_DIR3_FT_UNKNOWN;
>   
>   	error = xfs_dir_lookup(sdc->sc->tp, ip, &xname, &lookup_ino, NULL);
> +	if (error == -ENOENT) {
> +		/* ENOENT means the hash lookup failed and the dir is corrupt */
> +		xchk_fblock_set_corrupt(sdc->sc, XFS_DATA_FORK, offset);
> +		return -EFSCORRUPTED;
> +	}
>   	if (!xchk_fblock_process_error(sdc->sc, XFS_DATA_FORK, offset,
>   			&error))
>   		goto out;
> 
