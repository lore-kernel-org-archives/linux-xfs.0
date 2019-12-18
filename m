Return-Path: <SRS0=QbY/=2I=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CD35C43603
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Dec 2019 23:10:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D08782176D
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Dec 2019 23:10:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="TgL/yNJJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726561AbfLRXKM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 18 Dec 2019 18:10:12 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:51526 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726546AbfLRXKM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 Dec 2019 18:10:12 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBIN9qG7113296;
        Wed, 18 Dec 2019 23:10:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=kaiAXZQXIvCmXKk97InGGu0dRv6UYeSWuF4Vbv01CgY=;
 b=TgL/yNJJoiSXQ5Z/g4HA/ozQzsn3dtwUq9StwKyfeo4yEKUqs9TByq6w9XRkd0Vhn4R4
 EcaFhU3MbkKJoSz6WnE+AQjfuIiErYAF/8XB4/CWqnwWoGLcFh6e7CUb9NfCK2DOQPv9
 K4tIR6+loC05MDkbd71pXHcaX7PfkXvfyNzNP1TexG2eI55bh1R+ORRJGn/dMezykGWR
 N6Bo6o3zu8arLbMUDeQqpSRPjhBw7uKSWUaiZBQNaD/8pEE5KuskPiriQJ0DPs9nNRWK
 gijGhT8/m3WShCq8ODSEGbjymzyW9rBQKNJaAUsxMJ/eMX1HVYByDLKq6N9gDcREVkJu xA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2wvq5urr1h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Dec 2019 23:10:09 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBIN9t1t048980;
        Wed, 18 Dec 2019 23:10:08 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 2wyut4c2fg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Dec 2019 23:10:02 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xBIN8nrP006220;
        Wed, 18 Dec 2019 23:08:49 GMT
Received: from localhost (/10.145.179.16)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 18 Dec 2019 15:08:49 -0800
Date:   Wed, 18 Dec 2019 15:08:48 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 3/3] fsr: remove shadow variable in fsr_setup_attr_fork
Message-ID: <20191218230848.GI7489@magnolia>
References: <291387f3-1517-14c0-f64a-a98164131f89@sandeen.net>
 <fd893f4d-f436-b568-8dbf-5522c291952a@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fd893f4d-f436-b568-8dbf-5522c291952a@sandeen.net>
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

On Wed, Dec 18, 2019 at 04:56:20PM -0600, Eric Sandeen wrote:
> From: Eric Sandeen <sandeen@redhat.com>
> 
> There's no need for the extra inner-scope ret variable in this
> function, so remove it.  The shadow was harmless though.
> 
> Fixes: f31b5e12 ("libfrog: refactor open-coded bulkstat calls")
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
> 
> diff --git a/fsr/xfs_fsr.c b/fsr/xfs_fsr.c
> index 77a10a1d..32282126 100644
> --- a/fsr/xfs_fsr.c
> +++ b/fsr/xfs_fsr.c
> @@ -988,7 +988,6 @@ fsr_setup_attr_fork(
>  	do {
>  		struct xfs_bulkstat	tbstat;
>  		char		name[64];
> -		int		ret;
>  
>  		/*
>  		 * bulkstat the temp inode to see what the forkoff is.  Use
> 
