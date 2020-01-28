Return-Path: <SRS0=UJS8=3R=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC778C2D0DB
	for <linux-xfs@archiver.kernel.org>; Tue, 28 Jan 2020 16:15:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7E6B724681
	for <linux-xfs@archiver.kernel.org>; Tue, 28 Jan 2020 16:15:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="eRh+qVuU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726240AbgA1QPE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 28 Jan 2020 11:15:04 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:43986 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725959AbgA1QPD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 28 Jan 2020 11:15:03 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00SGDldu001917;
        Tue, 28 Jan 2020 16:14:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=MzMuO8N+HuMVxP+onA0x06glm9Oq2ScwoAqnN6XYA4A=;
 b=eRh+qVuUoGSudzJ2qTPGd2uO5zNDmthPkFjSGL7WNLrjcyDoPBnfcpvFJIZxwtfA+jHQ
 HvDsxsZgU4gyaNoYxWgWA3Ev9b/VlGXL8QjgjxFv6HirkN+neMNoiuRMWye3keavwnhJ
 M2oYJbQSFLTWocu9WvAcWUzSfAGIAPvp6GbFG3JIxXh4Fx0nbB0dBW6b21VAjNHp5UqJ
 aOMKtjMcQ5BllJ6+eXd5YGDOF4SQqgFuw2ZlhSmp4wUbe1OdCQc7+9zo+raVnI84aqTi
 fj1mm1/PWcNeGi7QTNM26JrE8bsvjY/2zcWkzxYyETnx9TBoKi1MDQs98C0wg4rVzAWE SA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2xrdmqfcw6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 28 Jan 2020 16:14:51 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00SGEOVo124663;
        Tue, 28 Jan 2020 16:14:51 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 2xtg7v6rfq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 28 Jan 2020 16:14:47 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 00SGEOH3019633;
        Tue, 28 Jan 2020 16:14:24 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 28 Jan 2020 08:14:24 -0800
Date:   Tue, 28 Jan 2020 08:14:23 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Jeff Moyer <jmoyer@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfsprogs: mkfs: don't default to the physical sector
 size if it's bigger than XFS_MAX_SECTORSIZE
Message-ID: <20200128161423.GO3447196@magnolia>
References: <x49h80ftviy.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <x49h80ftviy.fsf@segfault.boston.devel.redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9514 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001280126
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9514 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001280126
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jan 28, 2020 at 11:07:01AM -0500, Jeff Moyer wrote:
> Hi,
> 
> In testing on ppc64, I ran into the following error when making a file
> system:
> 
> # ./mkfs.xfs -b size=65536 -f /dev/ram0
> illegal sector size 65536
> 
> Which is odd, because I didn't specify a sector size!  The problem is
> that validate_sectorsize defaults to the physical sector size, but in
> this case, the physical sector size is bigger than XFS_MAX_SECTORSIZE.
> 
> # cat /sys/block/ram0/queue/physical_block_size 
> 65536
> 
> Fall back to the default (logical sector size) if the physical sector
> size is greater than XFS_MAX_SECTORSIZE.

Do we need to check that ft->lsectorsize <= XFS_MAX_SECTORSIZE too?

(Not that I really expect disks with 64k LBA units...)

--D

> Signed-off-by: Jeff Moyer <jmoyer@redhat.com>
> 
> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index 606f79da..dc9858af 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -1803,8 +1803,13 @@ validate_sectorsize(
>  		if (!ft->lsectorsize)
>  			ft->lsectorsize = XFS_MIN_SECTORSIZE;
>  
> -		/* Older kernels may not have physical/logical distinction */
> -		if (!ft->psectorsize)
> +		/*
> +		 * Older kernels may not have physical/logical distinction.
> +		 * Some architectures have a page size > XFS_MAX_SECTORSIZE.
> +		 * In that case, a ramdisk or persistent memory device may
> +		 * advertise a physical sector size that is too big to use.
> +		 */
> +		if (!ft->psectorsize || ft->psectorsize > XFS_MAX_SECTORSIZE)
>  			ft->psectorsize = ft->lsectorsize;
>  
>  		cfg->sectorsize = ft->psectorsize;
> 
