Return-Path: <SRS0=59Ki=B7=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86E81C433DF
	for <linux-xfs@archiver.kernel.org>; Fri, 21 Aug 2020 14:54:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 61D9F2075E
	for <linux-xfs@archiver.kernel.org>; Fri, 21 Aug 2020 14:54:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="jyGV3VON"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727791AbgHUOyR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 21 Aug 2020 10:54:17 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:41926 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727006AbgHUOyR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Aug 2020 10:54:17 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07LEpZFX182017;
        Fri, 21 Aug 2020 14:54:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=V9Btv0VogTqoDNzFZ8Zx+h6wVyzx5eHSXmVE5BslYq4=;
 b=jyGV3VONcxJ1k8zZIA4SYZdAGinHKIpWyowiiQmqyHz/t3HuhIvhZhaRP9jTHdwQ5IRs
 3d9B7nUhjHRilbLrkm//emYrQM+Hb6YDr/eX0v+QSfKnZ8rkfeFlYzJ3hARldZDnOALc
 BsxSIUxht01b5uQtilIKTQDSFCzp3k4GrTgmqQ5WbC1B1+wvAmPPstm+9kLQvjb+tiI2
 ykpWj2CgmEMIF0/SVYykp1j9xs1hHWhfAi2I1kmHDzhiU9SOBGAF7uH59HnpzS7NAq9P
 DU/gYHTcCf+uVg01BDWnS7OCPMS3PT7rr/W26tI4KY4Mw/VlsAcAm5/h1wJ18adU0WWP jg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 3322bjk06r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 21 Aug 2020 14:54:12 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07LEn5ew045959;
        Fri, 21 Aug 2020 14:52:12 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 32xsn2n273-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Aug 2020 14:52:12 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 07LEqBVa015150;
        Fri, 21 Aug 2020 14:52:11 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 21 Aug 2020 14:52:11 +0000
Date:   Fri, 21 Aug 2020 07:52:10 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Eric Sandeen <sandeen@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs_db: consolidate set_iocur_type behavior
Message-ID: <20200821145210.GM6096@magnolia>
References: <8b1ab1c4-64f6-5410-bf40-30776dae4dd5@redhat.com>
 <8062b2d0-3fbb-0240-d5dd-c7bfb452f0b3@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8062b2d0-3fbb-0240-d5dd-c7bfb452f0b3@redhat.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9719 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0 bulkscore=0
 mlxlogscore=999 phishscore=0 mlxscore=0 suspectscore=1 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008210138
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9719 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 adultscore=0 mlxscore=0 mlxlogscore=999 phishscore=0 suspectscore=1
 lowpriorityscore=0 spamscore=0 impostorscore=0 clxscore=1015 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008210138
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Aug 20, 2020 at 07:09:45PM -0500, Eric Sandeen wrote:
> Right now there are 3 cases to type_f: inode type, type with fields,
> and a default.  The first two were added to address issues with handling
> V5 metadata.
> 
> The first two already use some version of set_cur, which handles all
> of the validation etc. There's no reason to leave the open-coded bits
> at the end, just send every non-inode type through set_cur and be done
> with it.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
>  io.c |   28 +++++-----------------------
>  1 file changed, 5 insertions(+), 23 deletions(-)
> 
> diff --git a/db/io.c b/db/io.c
> index 884da599..235191f5 100644
> --- a/db/io.c
> +++ b/db/io.c
> @@ -603,33 +603,15 @@ set_iocur_type(
>  				iocur_top->boff / mp->m_sb.sb_inodesize);
>  		ino = XFS_AGINO_TO_INO(mp, xfs_daddr_to_agno(mp, b), agino);
>  		set_cur_inode(ino);
> -		return;
> -	}
> -
> -	/* adjust buffer size for types with fields & hence fsize() */
> -	if (type->fields) {
> -		int bb_count;	/* type's size in basic blocks */
> +	} else  {

Two spaces    ^^ between the else and the paren.

I also wonder, why not leave the "return;" at the end of the
"if (type->typnm == TYP_INODE)" part and then you can reduce the
indenting level of the rest of the function?

<shrug> maintainer's prerogative on that one though.
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

/me also wonders why dquots don't get the same "save the buffer offset"
treatment as inodes, but that's a separate question. :)

--D

> +		int bb_count = 1;	/* type's size in basic blocks */
>  
> -		bb_count = BTOBB(byteize(fsize(type->fields,
> +		/* adjust buffer size for types with fields & hence fsize() */
> +		if (type->fields)
> +			bb_count = BTOBB(byteize(fsize(type->fields,
>  					       iocur_top->data, 0, 0)));
>  		set_cur(type, iocur_top->bb, bb_count, DB_RING_IGN, NULL);
>  	}
> -	iocur_top->typ = type;
> -
> -	/* verify the buffer if the type has one. */
> -	if (!bp)
> -		return;
> -	if (!type->bops) {
> -		bp->b_ops = NULL;
> -		bp->b_flags |= LIBXFS_B_UNCHECKED;
> -		return;
> -	}
> -	if (!(bp->b_flags & LIBXFS_B_UPTODATE))
> -		return;
> -	bp->b_error = 0;
> -	bp->b_ops = type->bops;
> -	bp->b_ops->verify_read(bp);
> -	bp->b_flags &= ~LIBXFS_B_UNCHECKED;
>  }
>  
>  static void
> 
