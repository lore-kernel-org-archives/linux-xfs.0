Return-Path: <SRS0=QxtL=3Z=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5CC26C35254
	for <linux-xfs@archiver.kernel.org>; Wed,  5 Feb 2020 13:44:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3A2CF20702
	for <linux-xfs@archiver.kernel.org>; Wed,  5 Feb 2020 13:44:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726575AbgBENoA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 5 Feb 2020 08:44:00 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:1856 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726308AbgBENoA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 5 Feb 2020 08:44:00 -0500
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 015DbZej063756
        for <linux-xfs@vger.kernel.org>; Wed, 5 Feb 2020 08:43:59 -0500
Received: from e06smtp05.uk.ibm.com (e06smtp05.uk.ibm.com [195.75.94.101])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2xyhmb94xg-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-xfs@vger.kernel.org>; Wed, 05 Feb 2020 08:43:59 -0500
Received: from localhost
        by e06smtp05.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-xfs@vger.kernel.org> from <chandan@linux.ibm.com>;
        Wed, 5 Feb 2020 13:43:57 -0000
Received: from b06cxnps4076.portsmouth.uk.ibm.com (9.149.109.198)
        by e06smtp05.uk.ibm.com (192.168.101.135) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 5 Feb 2020 13:43:55 -0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 015Dhs3d44892308
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 5 Feb 2020 13:43:54 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 094FE5204E;
        Wed,  5 Feb 2020 13:43:54 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.199.63.110])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 2B7F852050;
        Wed,  5 Feb 2020 13:43:52 +0000 (GMT)
From:   Chandan Rajendra <chandan@linux.ibm.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org,
        Allison Collins <allison.henderson@oracle.com>
Subject: Re: [PATCH 01/30] xfs: reject invalid flags combinations in XFS_IOC_ATTRLIST_BY_HANDLE
Date:   Wed, 05 Feb 2020 19:16:38 +0530
Organization: IBM
In-Reply-To: <20200129170310.51370-2-hch@lst.de>
References: <20200129170310.51370-1-hch@lst.de> <20200129170310.51370-2-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-TM-AS-GCONF: 00
x-cbid: 20020513-0020-0000-0000-000003A73945
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20020513-0021-0000-0000-000021FF03FD
Message-Id: <4885448.553QpmS9R8@localhost.localdomain>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-05_04:2020-02-04,2020-02-05 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=797 mlxscore=0
 impostorscore=0 bulkscore=0 phishscore=0 priorityscore=1501 suspectscore=1
 lowpriorityscore=0 malwarescore=0 spamscore=0 adultscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002050109
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wednesday, January 29, 2020 10:32 PM Christoph Hellwig wrote: 

> While the flags field in the ABI and the on-disk format allows for
> multiple namespace flags, that is a logically invalid combination and
> listing multiple namespace flags will return no results as no attr
> can have both set.  Reject this case early with -EINVAL.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_ioctl.c   | 2 ++
>  fs/xfs/xfs_ioctl32.c | 2 ++
>  2 files changed, 4 insertions(+)
> 
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index d42de92cb283..d974bf099d45 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -317,6 +317,8 @@ xfs_attrlist_by_handle(
>  	 */
>  	if (al_hreq.flags & ~(ATTR_ROOT | ATTR_SECURE))
>  		return -EINVAL;

The above statement makes sure that al_hreq.flags has only ATTR_ROOT
and/or ATTR_SECURE flags set ...

> +	if (al_hreq.flags == (ATTR_ROOT | ATTR_SECURE))
> +		return -EINVAL;
>
... Hence if the execution control arrives here, we can be sure that the
presence of no other bits need to be checked.

Therefore the code is logically correct.

Reviewed-by: Chandan Rajendra <chandanrlinux@gmail.com>

>  	dentry = xfs_handlereq_to_dentry(parfilp, &al_hreq.hreq);
>  	if (IS_ERR(dentry))
> diff --git a/fs/xfs/xfs_ioctl32.c b/fs/xfs/xfs_ioctl32.c
> index 769581a79c58..9705172e5410 100644
> --- a/fs/xfs/xfs_ioctl32.c
> +++ b/fs/xfs/xfs_ioctl32.c
> @@ -375,6 +375,8 @@ xfs_compat_attrlist_by_handle(
>  	 */
>  	if (al_hreq.flags & ~(ATTR_ROOT | ATTR_SECURE))
>  		return -EINVAL;
> +	if (al_hreq.flags == (ATTR_ROOT | ATTR_SECURE))
> +		return -EINVAL;
> 
>  	dentry = xfs_compat_handlereq_to_dentry(parfilp, &al_hreq.hreq);
>  	if (IS_ERR(dentry))
> 

-- 
chandan



