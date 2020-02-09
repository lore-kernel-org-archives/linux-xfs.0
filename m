Return-Path: <SRS0=+eDc=35=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D3CDC35250
	for <linux-xfs@archiver.kernel.org>; Sun,  9 Feb 2020 06:55:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6CF97207FF
	for <linux-xfs@archiver.kernel.org>; Sun,  9 Feb 2020 06:55:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725886AbgBIGzT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 9 Feb 2020 01:55:19 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:54918 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725871AbgBIGzT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 9 Feb 2020 01:55:19 -0500
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0196nmP8079120
        for <linux-xfs@vger.kernel.org>; Sun, 9 Feb 2020 01:55:18 -0500
Received: from e06smtp05.uk.ibm.com (e06smtp05.uk.ibm.com [195.75.94.101])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2y1ucgynap-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-xfs@vger.kernel.org>; Sun, 09 Feb 2020 01:55:17 -0500
Received: from localhost
        by e06smtp05.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-xfs@vger.kernel.org> from <chandan@linux.ibm.com>;
        Sun, 9 Feb 2020 06:55:16 -0000
Received: from b06cxnps4075.portsmouth.uk.ibm.com (9.149.109.197)
        by e06smtp05.uk.ibm.com (192.168.101.135) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Sun, 9 Feb 2020 06:55:14 -0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0196tDhG52822044
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 9 Feb 2020 06:55:13 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 82FD4AE045;
        Sun,  9 Feb 2020 06:55:13 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9175CAE04D;
        Sun,  9 Feb 2020 06:55:12 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.199.59.174])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Sun,  9 Feb 2020 06:55:12 +0000 (GMT)
From:   Chandan Rajendra <chandan@linux.ibm.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org,
        Allison Collins <allison.henderson@oracle.com>
Subject: Re: [PATCH 20/30] xfs: open code ATTR_ENTSIZE
Date:   Sun, 09 Feb 2020 12:27:58 +0530
Organization: IBM
In-Reply-To: <20200129170310.51370-21-hch@lst.de>
References: <20200129170310.51370-1-hch@lst.de> <20200129170310.51370-21-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-TM-AS-GCONF: 00
x-cbid: 20020906-0020-0000-0000-000003A8702A
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20020906-0021-0000-0000-000022004732
Message-Id: <5752799.EJxpgnxGVr@localhost.localdomain>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-09_01:2020-02-07,2020-02-09 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 bulkscore=0
 phishscore=0 impostorscore=0 adultscore=0 lowpriorityscore=0 mlxscore=0
 mlxlogscore=999 priorityscore=1501 suspectscore=1 spamscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002090055
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wednesday, January 29, 2020 10:32 PM Christoph Hellwig wrote: 
> Replace an opencoded offsetof and round_up hiden behind to macros
> using the open code variant using the standard helpers.
>

The arithmetic performed in the open coded version is correct.

Reviewed-by: Chandan Rajendra <chandanrlinux@gmail.com>

> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_attr_list.c | 11 ++++-------
>  1 file changed, 4 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/xfs/xfs_attr_list.c b/fs/xfs/xfs_attr_list.c
> index 9c4acb6dc856..f1ca8ef8be22 100644
> --- a/fs/xfs/xfs_attr_list.c
> +++ b/fs/xfs/xfs_attr_list.c
> @@ -545,12 +545,6 @@ xfs_attr_list_int(
>  	return error;
>  }
> 
> -#define	ATTR_ENTBASESIZE		/* minimum bytes used by an attr */ \
> -	(((struct attrlist_ent *) 0)->a_name - (char *) 0)
> -#define	ATTR_ENTSIZE(namelen)		/* actual bytes used by an attr */ \
> -	((ATTR_ENTBASESIZE + (namelen) + 1 + sizeof(uint32_t)-1) \
> -	 & ~(sizeof(uint32_t)-1))
> -
>  /*
>   * Format an attribute and copy it out to the user's buffer.
>   * Take care to check values and protect against them changing later,
> @@ -586,7 +580,10 @@ xfs_attr_put_listent(
> 
>  	arraytop = sizeof(*alist) +
>  			context->count * sizeof(alist->al_offset[0]);
> -	context->firstu -= ATTR_ENTSIZE(namelen);
> +
> +	/* decrement by the actual bytes used by the attr */
> +	context->firstu -= round_up(offsetof(struct attrlist_ent, a_name) +
> +			namelen + 1, sizeof(uint32_t));
>  	if (context->firstu < arraytop) {
>  		trace_xfs_attr_list_full(context);
>  		alist->al_more = 1;
> 


-- 
chandan



