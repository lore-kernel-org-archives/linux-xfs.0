Return-Path: <SRS0=jPpR=BA=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06D14C433E1
	for <linux-xfs@archiver.kernel.org>; Tue, 21 Jul 2020 00:59:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DABE92080D
	for <linux-xfs@archiver.kernel.org>; Tue, 21 Jul 2020 00:59:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="gAWLVibC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728127AbgGUA7F (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 20 Jul 2020 20:59:05 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:60920 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728074AbgGUA7F (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 20 Jul 2020 20:59:05 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06L0uPBN176080;
        Tue, 21 Jul 2020 00:59:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=t8OLm9w0bj9duVnrLoX45A5lO4xJODbUk42u6cCvUaw=;
 b=gAWLVibCpa9pdINna5ZclJ42Cropaly2xs6XoyhZ1+BZa7CGaZHvxMEU6mF6XxfyPgSs
 fL8iMEwPvLmvixtftlFw5ypZWYiAB2A/Qo0m3cQfzA2k8Baig9s2scPYMRyGR6KV0W7B
 T/FrWftW/RXDm9tcOSuHFtDwyumiJgZz7rjkPv+ilrfxD+eNcVCVX+VOa7tZpMHtDeo2
 wmb/61skfoZMPcon7JDlMWJJWq1K88jdl8sqa8DT/+Te0LirpC3GdYKL6UEpm3YXxOut
 argm/Ziw94ISgc+3Q5uFIqOfCJZxXglYNCBu/kVcfcaCwnHZpfsyrinjyUko3D9inan+ MQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 32brgra2kd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 21 Jul 2020 00:59:02 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06L0s9kh039973;
        Tue, 21 Jul 2020 00:57:02 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 32dnfnh6p0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 Jul 2020 00:57:02 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 06L0v1cq011514;
        Tue, 21 Jul 2020 00:57:01 GMT
Received: from localhost (/10.159.141.124)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 20 Jul 2020 17:57:01 -0700
Date:   Mon, 20 Jul 2020 17:57:00 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/4] repair: set the in-core inode parent in phase 3
Message-ID: <20200721005700.GY3151642@magnolia>
References: <20200715140836.10197-1-bfoster@redhat.com>
 <20200715140836.10197-2-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200715140836.10197-2-bfoster@redhat.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9688 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=1
 malwarescore=0 mlxscore=0 adultscore=0 spamscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007210002
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9688 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0 spamscore=0
 impostorscore=0 suspectscore=1 adultscore=0 clxscore=1015 mlxlogscore=999
 priorityscore=1501 phishscore=0 lowpriorityscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007210003
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jul 15, 2020 at 10:08:33AM -0400, Brian Foster wrote:
> The inode processing code checks and resets invalid parent values on
> physical inodes in phase 3 but waits to update the parent value in
> the in-core tracking until phase 4. There doesn't appear to be any
> specific reason for the latter beyond caution. In reality, the only
> reason this doesn't cause problems is that phase 3 replaces an
> invalid on-disk parent with another invalid value, so the in-core
> parent returned by phase 4 translates to NULLFSINO.
> 
> This is subtle and fragile. To eliminate this duplicate processing
> behavior and break the subtle dependency of requiring an invalid
> dummy value in physical directory inodes, update the in-core parent
> tracking structure at the same point in phase 3 that physical inodes
> are updated. Invalid on-disk parent values will still translate to
> NULLFSINO for the in-core tracking to be identified by later phases.
> This ensures that if a valid dummy value is placed in a physical
> inode (such as rootino) with an invalid parent in phase 3, phase 4
> won't mistakenly return the valid dummy value to be incorrectly set
> in the in-core tracking over the NULLFSINO value that represents the
> broken on-disk state.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>

Looks fine to me,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  repair/dino_chunks.c | 9 +--------
>  1 file changed, 1 insertion(+), 8 deletions(-)
> 
> diff --git a/repair/dino_chunks.c b/repair/dino_chunks.c
> index 6685a4d2..96ed6a5b 100644
> --- a/repair/dino_chunks.c
> +++ b/repair/dino_chunks.c
> @@ -859,14 +859,7 @@ next_readbuf:
>  		 */
>  		if (isa_dir)  {
>  			set_inode_isadir(ino_rec, irec_offset);
> -			/*
> -			 * we always set the parent but
> -			 * we may as well wait until
> -			 * phase 4 (no inode discovery)
> -			 * because the parent info will
> -			 * be solid then.
> -			 */
> -			if (!ino_discovery)  {
> +			if (ino_discovery)  {
>  				ASSERT(parent != 0);
>  				set_inode_parent(ino_rec, irec_offset, parent);
>  				ASSERT(parent ==
> -- 
> 2.21.3
> 
