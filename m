Return-Path: <SRS0=wjSb=4L=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DDFCC35671
	for <linux-xfs@archiver.kernel.org>; Sun, 23 Feb 2020 17:12:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 73E18206ED
	for <linux-xfs@archiver.kernel.org>; Sun, 23 Feb 2020 17:12:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726583AbgBWRMe (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 23 Feb 2020 12:12:34 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:48244 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726208AbgBWRMe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 23 Feb 2020 12:12:34 -0500
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01NGsidc007850
        for <linux-xfs@vger.kernel.org>; Sun, 23 Feb 2020 12:12:34 -0500
Received: from e06smtp03.uk.ibm.com (e06smtp03.uk.ibm.com [195.75.94.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2yaygmy5uq-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-xfs@vger.kernel.org>; Sun, 23 Feb 2020 12:12:33 -0500
Received: from localhost
        by e06smtp03.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-xfs@vger.kernel.org> from <chandan@linux.ibm.com>;
        Sun, 23 Feb 2020 17:12:31 -0000
Received: from b06cxnps4075.portsmouth.uk.ibm.com (9.149.109.197)
        by e06smtp03.uk.ibm.com (192.168.101.133) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Sun, 23 Feb 2020 17:12:28 -0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 01NHCRIw29360350
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 23 Feb 2020 17:12:27 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 149DE4C050;
        Sun, 23 Feb 2020 17:12:27 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4B44D4C046;
        Sun, 23 Feb 2020 17:12:25 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.199.32.48])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Sun, 23 Feb 2020 17:12:25 +0000 (GMT)
From:   Chandan Rajendra <chandan@linux.ibm.com>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Chandan Rajendra <chandanrlinux@gmail.com>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        Dave Chinner <david@fromorbit.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Brian Foster <bfoster@redhat.com>,
        Allison Henderson <allison.henderson@oracle.com>
Subject: Re: [PATCH V4 7/7] xfs: Fix log reservation calculation for xattr insert operation
Date:   Sun, 23 Feb 2020 22:45:17 +0530
Organization: IBM
In-Reply-To: <CAOQ4uxhgXpDgpjBA+T0h4dwWEcPN7reFx4ywmMOK7=bJXpZQTQ@mail.gmail.com>
References: <20200223073044.14215-1-chandanrlinux@gmail.com> <20200223073044.14215-7-chandanrlinux@gmail.com> <CAOQ4uxhgXpDgpjBA+T0h4dwWEcPN7reFx4ywmMOK7=bJXpZQTQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-TM-AS-GCONF: 00
x-cbid: 20022317-0012-0000-0000-000003898A86
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20022317-0013-0000-0000-000021C627A6
Message-Id: <1908380.8Et6zkQLvG@localhost.localdomain>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-23_03:2020-02-21,2020-02-23 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 suspectscore=0
 bulkscore=0 malwarescore=0 adultscore=0 priorityscore=1501 spamscore=0
 phishscore=0 clxscore=1015 impostorscore=0 mlxlogscore=999
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002230141
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sunday, February 23, 2020 3:21 PM Amir Goldstein wrote: 
> On Sun, Feb 23, 2020 at 9:28 AM Chandan Rajendra
> <chandanrlinux@gmail.com> wrote:
> >
> > Log space reservation for xattr insert operation can be divided into two
> > parts,
> > 1. Mount time
> >    - Inode
> >    - Superblock for accounting space allocations
> >    - AGF for accounting space used by count, block number, rmap and refcnt
> >      btrees.
> >
> > 2. The remaining log space can only be calculated at run time because,
> >    - A local xattr can be large enough to cause a double split of the dabtree.
> >    - The value of the xattr can be large enough to be stored in remote
> >      blocks. The contents of the remote blocks are not logged.
> >
> >    The log space reservation could be,
> >    - 2 * XFS_DA_NODE_MAXDEPTH number of blocks. Additional XFS_DA_NODE_MAXDEPTH
> >      number of blocks are required if xattr is large enough to cause another
> >      split of the dabtree path from root to leaf block.
> >    - BMBT blocks for storing (2 * XFS_DA_NODE_MAXDEPTH) record
> >      entries. Additional XFS_DA_NODE_MAXDEPTH number of blocks are required in
> >      case of a double split of the dabtree path from root to leaf blocks.
> >    - Space for logging blocks of count, block number, rmap and refcnt btrees.
> >
> > Presently, mount time log reservation includes block count required for a
> > single split of the dabtree. The dabtree block count is also taken into
> > account by xfs_attr_calc_size().
> >
> > Also, AGF log space reservation isn't accounted for.
> >
> > Due to the reasons mentioned above, log reservation calculation for xattr
> > insert operation gives an incorrect value.
> >
> > Apart from the above, xfs_log_calc_max_attrsetm_res() passes byte count as
> > an argument to XFS_NEXTENTADD_SPACE_RES() instead of block count.
> >
> > To fix these issues, this commit changes xfs_attr_calc_size() to also
> > calculate the number of dabtree blocks that need to be logged.
> >
> > xfs_attr_set() uses the following values computed by xfs_attr_calc_size()
> > 1. The number of dabtree blocks that need to be logged.
> > 2. The number of remote blocks that need to be allocated.
> > 3. The number of dabtree blocks that need to be allocated.
> > 4. The number of bmbt blocks that need to be allocated.
> > 5. The total number of blocks that need to be allocated.
> >
> > ... to compute number of bytes that need to be reserved in the log.
> >
> > This commit also modifies xfs_log_calc_max_attrsetm_res() to invoke
> > xfs_attr_calc_size() to obtain the number of blocks to be logged which it uses
> > to figure out the total number of bytes to be logged.
> >
> > Signed-off-by: Chandan Rajendra <chandanrlinux@gmail.com>
> 
> Hi Chandan,
>
Hi Amir,

> It would have been useful to get this sort of overview in a cover
> letter instead of
> having to find it in the last patch.
>
Sure, I will re-send the patchset with a cover letter.

> I suppose it is a coincident that this work ended up in our mailboxes together
> with Allison's delayed attr work, but it is interesting to know if the two works
> affect each other in any way.

My patchset fixes bugs in the calculation of log space reservation for "xattr
set" operation. I read the code at
"https://github.com/allisonhenderson/xfs_work.git delay_ready_attrs_v7" and
found that the bugs still exist in that code as well. So IMHO, the two
patchsets do not mutually exclude each other.

-- 
chandan



