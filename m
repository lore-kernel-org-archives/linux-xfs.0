Return-Path: <SRS0=aQ/b=BI=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC507C433EC
	for <linux-xfs@archiver.kernel.org>; Wed, 29 Jul 2020 01:23:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AD0072078E
	for <linux-xfs@archiver.kernel.org>; Wed, 29 Jul 2020 01:23:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Aien3Y4W"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730351AbgG2BXw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 28 Jul 2020 21:23:52 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:35314 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728364AbgG2BXv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 28 Jul 2020 21:23:51 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06T1LdOW090562
        for <linux-xfs@vger.kernel.org>; Wed, 29 Jul 2020 01:23:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=/F1YLFVyROtKJg5k7ML+urFjCsOglW/RpEpje68i8Jk=;
 b=Aien3Y4WGeU5p03HOYK3WRs9JlAw2vdgRHaoTDL2Flvc9+Z9R1JxLSL1Tz4ZRe3jfmC3
 OPbjRKedGv3m/9ERjZw2aeUNWvK6iegvepEfxVjdLx8uSklBFo5fRhQzmay0Jg6BwwM/
 27F9HMhB63k9hJLCTeLnI2Wh7lDpJs2gkiHWcu4nFWSw64TqnUU8tJpNJ8ntUhn+xB2D
 zKpGSlhYwcNS7DAkjX9TbGofSNyWtEmFzMrGWiFOghRmsL/7e191Atdo90mYWTfEEIHO
 Qhy4fnmYJEbw/EVgMew9SSM8Tor/QMHlU03sCOGPYwSh08yN9cFjIqIZsPsnTGFrSozf tA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 32hu1jaqwh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Wed, 29 Jul 2020 01:23:50 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06T1MjFm096130
        for <linux-xfs@vger.kernel.org>; Wed, 29 Jul 2020 01:23:50 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 32hu5v0d4b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 29 Jul 2020 01:23:50 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 06T1NnUR031346
        for <linux-xfs@vger.kernel.org>; Wed, 29 Jul 2020 01:23:49 GMT
Received: from localhost (/10.159.234.45)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 28 Jul 2020 18:23:49 -0700
Date:   Tue, 28 Jul 2020 18:23:48 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Allison Collins <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/1] xfs: Fix Smatch warning in xfs_attr_node_get
Message-ID: <20200729012348.GD3151642@magnolia>
References: <20200729000853.10215-1-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200729000853.10215-1-allison.henderson@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9696 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=7 malwarescore=0
 mlxscore=0 adultscore=0 spamscore=0 phishscore=0 mlxlogscore=999
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007290007
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9696 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 mlxlogscore=999
 lowpriorityscore=0 malwarescore=0 clxscore=1015 mlxscore=0 impostorscore=0
 phishscore=0 adultscore=0 suspectscore=7 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007290007
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jul 28, 2020 at 05:08:53PM -0700, Allison Collins wrote:
> Fix warning: variable dereferenced before check 'state' in
> xfs_attr_node_get.  If xfs_attr_node_hasname fails, it may return a null
> state.  If state is null, do not derefrence it.  Go straight to out.
> 
> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_attr.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index e5ec9ed..90b7b24 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -1409,6 +1409,9 @@ xfs_attr_node_get(
>  	 * Search to see if name exists, and get back a pointer to it.
>  	 */
>  	error = xfs_attr_node_hasname(args, &state);
> +	if (!state)
> +		goto out;
> +
>  	if (error != -EEXIST)
>  		goto out_release;
>  
> @@ -1426,7 +1429,7 @@ xfs_attr_node_get(

I would've just changed the for loop to:

	for (i = 0; state && i < state->path.active; i++) {

Since that way we'd know that the error-out path always does the right
thing wrt any resources that could have been allocated.

--D

>  		xfs_trans_brelse(args->trans, state->path.blk[i].bp);
>  		state->path.blk[i].bp = NULL;
>  	}
> -
> +out:
>  	if (state)
>  		xfs_da_state_free(state);
>  	return error;
> -- 
> 2.7.4
> 
