Return-Path: <SRS0=BKGZ=5R=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A6B5C43331
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Apr 2020 13:47:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DEC91206F5
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Apr 2020 13:47:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732661AbgDANrB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 1 Apr 2020 09:47:01 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:60807 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732205AbgDANrB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 1 Apr 2020 09:47:01 -0400
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 031DY536196040
        for <linux-xfs@vger.kernel.org>; Wed, 1 Apr 2020 09:47:00 -0400
Received: from e06smtp07.uk.ibm.com (e06smtp07.uk.ibm.com [195.75.94.103])
        by mx0a-001b2d01.pphosted.com with ESMTP id 304mcbdk9n-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-xfs@vger.kernel.org>; Wed, 01 Apr 2020 09:46:58 -0400
Received: from localhost
        by e06smtp07.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-xfs@vger.kernel.org> from <chandan@linux.ibm.com>;
        Wed, 1 Apr 2020 14:46:52 +0100
Received: from b06cxnps4075.portsmouth.uk.ibm.com (9.149.109.197)
        by e06smtp07.uk.ibm.com (192.168.101.137) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 1 Apr 2020 14:46:49 +0100
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 031DknmA52035716
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 1 Apr 2020 13:46:49 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D44924C046;
        Wed,  1 Apr 2020 13:46:49 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 39F184C050;
        Wed,  1 Apr 2020 13:46:49 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.199.52.194])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed,  1 Apr 2020 13:46:48 +0000 (GMT)
From:   Chandan Rajendra <chandan@linux.ibm.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/4] xfs: validate the realtime geometry in xfs_validate_sb_common
Date:   Wed, 01 Apr 2020 19:19:51 +0530
Organization: IBM
In-Reply-To: <158510668306.922633.16796248628127177511.stgit@magnolia>
References: <158510667039.922633.6138311243444001882.stgit@magnolia> <158510668306.922633.16796248628127177511.stgit@magnolia>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-TM-AS-GCONF: 00
x-cbid: 20040113-0028-0000-0000-000003F0106B
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20040113-0029-0000-0000-000024B596B7
Message-Id: <2265826.PVY0go2oF0@localhost.localdomain>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-01_01:2020-03-31,2020-03-31 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 suspectscore=1 bulkscore=0 mlxscore=0 adultscore=0 priorityscore=1501
 clxscore=1015 lowpriorityscore=0 malwarescore=0 phishscore=0
 mlxlogscore=999 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2003020000 definitions=main-2004010118
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wednesday, March 25, 2020 8:54 AM Darrick J. Wong wrote: 
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Validate the geometry of the realtime geometry when we mount the
> filesystem, so that we don't abruptly shut down the filesystem later on.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

The changes look logically correct.

Reviewed-by: Chandan Rajendra <chandanrlinux@gmail.com>

> ---
>  fs/xfs/libxfs/xfs_sb.c |   35 +++++++++++++++++++++++++++++++++++
>  1 file changed, 35 insertions(+)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
> index 2f60fc3c99a0..dee0a1a594dc 100644
> --- a/fs/xfs/libxfs/xfs_sb.c
> +++ b/fs/xfs/libxfs/xfs_sb.c
> @@ -328,6 +328,41 @@ xfs_validate_sb_common(
>  		return -EFSCORRUPTED;
>  	}
>  
> +	/* Validate the realtime geometry; stolen from xfs_repair */
> +	if (unlikely(
> +	    sbp->sb_rextsize * sbp->sb_blocksize > XFS_MAX_RTEXTSIZE	||
> +	    sbp->sb_rextsize * sbp->sb_blocksize < XFS_MIN_RTEXTSIZE)) {
> +		xfs_notice(mp,
> +			"realtime extent sanity check failed");
> +		return -EFSCORRUPTED;
> +	}
> +
> +	if (sbp->sb_rblocks == 0) {
> +		if (unlikely(
> +		    sbp->sb_rextents != 0				||
> +		    sbp->sb_rbmblocks != 0				||
> +		    sbp->sb_rextslog != 0				||
> +		    sbp->sb_frextents != 0)) {
> +			xfs_notice(mp,
> +				"realtime zeroed geometry sanity check failed");
> +			return -EFSCORRUPTED;
> +		}
> +	} else {
> +		xfs_rtblock_t	rexts;
> +		uint32_t	temp;
> +
> +		rexts = div_u64_rem(sbp->sb_rblocks, sbp->sb_rextsize, &temp);
> +		if (unlikely(
> +		    rexts != sbp->sb_rextents				||
> +		    sbp->sb_rextslog != xfs_highbit32(sbp->sb_rextents)	||
> +		    sbp->sb_rbmblocks != howmany(sbp->sb_rextents,
> +						NBBY * sbp->sb_blocksize))) {
> +			xfs_notice(mp,
> +				"realtime geometry sanity check failed");
> +			return -EFSCORRUPTED;
> +		}
> +	}
> +
>  	if (sbp->sb_unit) {
>  		if (!xfs_sb_version_hasdalign(sbp) ||
>  		    sbp->sb_unit > sbp->sb_width ||
> 
> 


-- 
chandan



