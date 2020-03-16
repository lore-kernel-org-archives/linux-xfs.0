Return-Path: <SRS0=1m5L=5B=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04E35C0044D
	for <linux-xfs@archiver.kernel.org>; Mon, 16 Mar 2020 14:45:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D82B320719
	for <linux-xfs@archiver.kernel.org>; Mon, 16 Mar 2020 14:45:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731611AbgCPOpx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 16 Mar 2020 10:45:53 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:28078 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731589AbgCPOpx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 16 Mar 2020 10:45:53 -0400
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02GEaBTZ183249
        for <linux-xfs@vger.kernel.org>; Mon, 16 Mar 2020 10:45:51 -0400
Received: from e06smtp01.uk.ibm.com (e06smtp01.uk.ibm.com [195.75.94.97])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2yrt340yq6-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-xfs@vger.kernel.org>; Mon, 16 Mar 2020 10:45:51 -0400
Received: from localhost
        by e06smtp01.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-xfs@vger.kernel.org> from <chandan@linux.ibm.com>;
        Mon, 16 Mar 2020 14:45:49 -0000
Received: from b06cxnps3075.portsmouth.uk.ibm.com (9.149.109.195)
        by e06smtp01.uk.ibm.com (192.168.101.131) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Mon, 16 Mar 2020 14:45:47 -0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 02GEjknf50987088
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 16 Mar 2020 14:45:46 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4C0D6A4060;
        Mon, 16 Mar 2020 14:45:46 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 921E7A405F;
        Mon, 16 Mar 2020 14:45:45 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.85.73.127])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 16 Mar 2020 14:45:45 +0000 (GMT)
From:   Chandan Rajendra <chandan@linux.ibm.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/5] xfs: simplify di_flags2 inheritance in xfs_ialloc
Date:   Mon, 16 Mar 2020 20:18:46 +0530
Organization: IBM
In-Reply-To: <20200312142235.550766-5-hch@lst.de>
References: <20200312142235.550766-1-hch@lst.de> <20200312142235.550766-5-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-TM-AS-GCONF: 00
x-cbid: 20031614-4275-0000-0000-000003AD4270
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20031614-4276-0000-0000-000038C2689E
Message-Id: <18642692.yUzKcrDMN6@localhost.localdomain>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-03-16_03:2020-03-12,2020-03-16 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 mlxlogscore=482 mlxscore=0 spamscore=0 bulkscore=0 phishscore=0
 lowpriorityscore=0 suspectscore=1 clxscore=1015 impostorscore=0
 malwarescore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2003020000 definitions=main-2003160068
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thursday, March 12, 2020 7:52 PM Christoph Hellwig wrote: 
> di_flags2 is initialized to zero for v4 and earlier file systems.  This
> means di_flags2 can only be non-zero for a v5 file systems, in which
> case both the parent and child inodes can store the filed.  Remove the
> extra di_version check, and also remove the rather pointless local
> di_flags2 variable while at it.
>

I don't see any logical issues.

Reviewed-by: Chandan Rajendra <chandanrlinux@gmail.com>

> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_inode.c | 13 +++----------
>  1 file changed, 3 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index addc3ee0cb73..ebfd8efb0efa 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -907,20 +907,13 @@ xfs_ialloc(
>  
>  			ip->i_d.di_flags |= di_flags;
>  		}
> -		if (pip &&
> -		    (pip->i_d.di_flags2 & XFS_DIFLAG2_ANY) &&
> -		    pip->i_d.di_version == 3 &&
> -		    ip->i_d.di_version == 3) {
> -			uint64_t	di_flags2 = 0;
> -
> +		if (pip && (pip->i_d.di_flags2 & XFS_DIFLAG2_ANY)) {
>  			if (pip->i_d.di_flags2 & XFS_DIFLAG2_COWEXTSIZE) {
> -				di_flags2 |= XFS_DIFLAG2_COWEXTSIZE;
> +				ip->i_d.di_flags2 |= XFS_DIFLAG2_COWEXTSIZE;
>  				ip->i_d.di_cowextsize = pip->i_d.di_cowextsize;
>  			}
>  			if (pip->i_d.di_flags2 & XFS_DIFLAG2_DAX)
> -				di_flags2 |= XFS_DIFLAG2_DAX;
> -
> -			ip->i_d.di_flags2 |= di_flags2;
> +				ip->i_d.di_flags2 |= XFS_DIFLAG2_DAX;
>  		}
>  		/* FALLTHROUGH */
>  	case S_IFLNK:
> 


-- 
chandan



