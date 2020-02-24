Return-Path: <SRS0=6RgE=4M=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 343EDC11D27
	for <linux-xfs@archiver.kernel.org>; Mon, 24 Feb 2020 08:28:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0EFBA20714
	for <linux-xfs@archiver.kernel.org>; Mon, 24 Feb 2020 08:28:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726628AbgBXI2x (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 24 Feb 2020 03:28:53 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:36202 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727498AbgBXI2w (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Feb 2020 03:28:52 -0500
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01O8KMbT005409
        for <linux-xfs@vger.kernel.org>; Mon, 24 Feb 2020 03:28:51 -0500
Received: from e06smtp02.uk.ibm.com (e06smtp02.uk.ibm.com [195.75.94.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2yb161f3tg-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-xfs@vger.kernel.org>; Mon, 24 Feb 2020 03:28:50 -0500
Received: from localhost
        by e06smtp02.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-xfs@vger.kernel.org> from <chandan@linux.ibm.com>;
        Mon, 24 Feb 2020 08:28:49 -0000
Received: from b06cxnps4074.portsmouth.uk.ibm.com (9.149.109.196)
        by e06smtp02.uk.ibm.com (192.168.101.132) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Mon, 24 Feb 2020 08:28:46 -0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 01O8Sj2t52232286
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 24 Feb 2020 08:28:45 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3928C4C05C;
        Mon, 24 Feb 2020 08:28:45 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C94174C046;
        Mon, 24 Feb 2020 08:28:43 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.85.91.136])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 24 Feb 2020 08:28:43 +0000 (GMT)
From:   Chandan Rajendra <chandan@linux.ibm.com>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     linux-xfs@vger.kernel.org,
        Allison Collins <allison.henderson@oracle.com>
Subject: Re: [PATCH v7 00/19] xfs: Delayed Ready Attrs
Date:   Mon, 24 Feb 2020 14:01:35 +0530
Organization: IBM
In-Reply-To: <CAOQ4uxgvJOF6+jd9BuJfxxGQbiit6J7zVOVnigwLb-RWizRqfg@mail.gmail.com>
References: <20200223020611.1802-1-allison.henderson@oracle.com> <CAOQ4uxgvJOF6+jd9BuJfxxGQbiit6J7zVOVnigwLb-RWizRqfg@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-TM-AS-GCONF: 00
x-cbid: 20022408-0008-0000-0000-00000355D847
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20022408-0009-0000-0000-00004A76EFDC
Message-Id: <2644091.QCrdQm5Jf7@localhost.localdomain>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-24_02:2020-02-21,2020-02-24 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 clxscore=1015
 bulkscore=0 impostorscore=0 adultscore=0 phishscore=0 malwarescore=0
 mlxscore=0 suspectscore=5 mlxlogscore=999 lowpriorityscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002240073
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sunday, February 23, 2020 1:25 PM Amir Goldstein wrote: 
> On Sun, Feb 23, 2020 at 4:06 AM Allison Collins
> <allison.henderson@oracle.com> wrote:
> >
> > Hi all,
> >
> > This set is a subset of a larger series for delayed attributes. Which is
> > a subset of an even larger series, parent pointers. Delayed attributes
> > allow attribute operations (set and remove) to be logged and committed
> > in the same way that other delayed operations do. This allows more
> > complex operations (like parent pointers) to be broken up into multiple
> > smaller transactions. To do this, the existing attr operations must be
> > modified to operate as either a delayed operation or a inline operation
> > since older filesystems will not be able to use the new log entries.
> 
> High level question, before I dive into the series:
>

Hi Amir,

My 2 cents on this topic (Assuming "delayed operations" refer to "deferred
ops") ... 

> Which other "delayed operations" already exist?

static const struct xfs_defer_op_type *defer_op_types[] = {
        [XFS_DEFER_OPS_TYPE_BMAP]       = &xfs_bmap_update_defer_type,
        [XFS_DEFER_OPS_TYPE_REFCOUNT]   = &xfs_refcount_update_defer_type,
        [XFS_DEFER_OPS_TYPE_RMAP]       = &xfs_rmap_update_defer_type,
        [XFS_DEFER_OPS_TYPE_FREE]       = &xfs_extent_free_defer_type,
        [XFS_DEFER_OPS_TYPE_AGFL_FREE]  = &xfs_agfl_free_defer_type,
};


> I think delayed operations were added by Darrick to handle the growth of
> translation size due to reflink. Right? So I assume the existing delayed
> operations deal with block accounting.

IIRC, Deferred ops are meant to not violate the AG locking order.  If AG 'x'
metadata block[s] is locked then we can only lock metadata blocks of AGs
starting from 'x+1'. Transactions can return -EAGAIN when they detect that
they need to lock metadata blocks belonging to AG 'x-1' or less. In such a
case the transaction will be rolled during which the locks on metadata blocks
are given up.

> When speaking of parent pointers, without having looked into the details yet,
> it seem the delayed operations we would want to log are operations that deal
> with namespace changes, i.e.: link,unlink,rename.
> The information needed to be logged for these ops is minimal.
> Why do we need a general infrastructure for delayed attr operations?
> 
> Thanks,
> Amir.
> 
> 
> 
> 

-- 
chandan



