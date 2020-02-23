Return-Path: <SRS0=wjSb=4L=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2576C35671
	for <linux-xfs@archiver.kernel.org>; Sun, 23 Feb 2020 07:31:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B79C0206E0
	for <linux-xfs@archiver.kernel.org>; Sun, 23 Feb 2020 07:31:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726208AbgBWHbe (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 23 Feb 2020 02:31:34 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:49764 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725980AbgBWHbe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 23 Feb 2020 02:31:34 -0500
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01N7Ofs2133231
        for <linux-xfs@vger.kernel.org>; Sun, 23 Feb 2020 02:31:33 -0500
Received: from e06smtp03.uk.ibm.com (e06smtp03.uk.ibm.com [195.75.94.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2yax36exsx-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-xfs@vger.kernel.org>; Sun, 23 Feb 2020 02:31:32 -0500
Received: from localhost
        by e06smtp03.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-xfs@vger.kernel.org> from <chandan@linux.ibm.com>;
        Sun, 23 Feb 2020 07:31:30 -0000
Received: from b06cxnps4076.portsmouth.uk.ibm.com (9.149.109.198)
        by e06smtp03.uk.ibm.com (192.168.101.133) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Sun, 23 Feb 2020 07:31:27 -0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 01N7VQe053542974
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 23 Feb 2020 07:31:26 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2DDD8A405B;
        Sun, 23 Feb 2020 07:31:26 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B492EA4054;
        Sun, 23 Feb 2020 07:31:24 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.102.2.13])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Sun, 23 Feb 2020 07:31:24 +0000 (GMT)
From:   Chandan Rajendra <chandan@linux.ibm.com>
To:     Chandan Rajendra <chandanrlinux@gmail.com>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com,
        darrick.wong@oracle.com, bfoster@redhat.com
Subject: Re: [PATCH V4 1/7] xfs: Pass xattr name and value length explicitly to xfs_attr_leaf_newentsize
Date:   Sun, 23 Feb 2020 13:04:15 +0530
Organization: IBM
In-Reply-To: <20200223073120.14324-1-chandanrlinux@gmail.com>
References: <20200223073120.14324-1-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-TM-AS-GCONF: 00
x-cbid: 20022307-0012-0000-0000-000003897116
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20022307-0013-0000-0000-000021C60DA0
Message-Id: <2657151.Z7JirttBKy@localhost.localdomain>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-22_08:2020-02-21,2020-02-22 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 impostorscore=0
 bulkscore=0 spamscore=0 suspectscore=0 mlxlogscore=999 priorityscore=1501
 lowpriorityscore=0 clxscore=1015 phishscore=0 malwarescore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002230063
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sunday, February 23, 2020 1:01 PM Chandan Rajendra wrote: 
> This commit changes xfs_attr_leaf_newentsize() to explicitly accept name and
> value length instead of a pointer to struct xfs_da_args. A future commit will
> need to invoke xfs_attr_leaf_newentsize() from functions that do not have
> a struct xfs_da_args to pass in.
> 
> Signed-off-by: Chandan Rajendra <chandanrlinux@gmail.com>
> ---
> 
> Changelog:
> V1 -> V2:
> 1. Use convenience variables to reduce indentation of code.
> 
> V2 -> V3:
> 1. Introduce 'struct xfs_attr_set_resv' to collect various block size
>    reservations when inserting an xattr.
> 2. Add xfs_calc_attr_res() to calculate the total log reservation to
>    required when inserting an xattr.
> 
> V3 -> V4:
> 1. Rebase the patchset on top of Christoph's "Clean attr interface"
>    patchset. The patchset can be obtained from
>    https://github.com/chandanr/linux/tree/xfs-fix-attr-resv-calc-v4.

Sorry, The above link should have been
https://github.com/chandanr/xfsprogs-dev/tree/xfs-fix-attr-resv-calc-v4.

-- 
chandan



