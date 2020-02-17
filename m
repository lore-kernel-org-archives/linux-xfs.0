Return-Path: <SRS0=xOwi=4F=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06B91C35242
	for <linux-xfs@archiver.kernel.org>; Mon, 17 Feb 2020 07:54:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D75242064C
	for <linux-xfs@archiver.kernel.org>; Mon, 17 Feb 2020 07:54:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726612AbgBQHy2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 17 Feb 2020 02:54:28 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:21868 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726267AbgBQHy2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 17 Feb 2020 02:54:28 -0500
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01H7oPNf008768
        for <linux-xfs@vger.kernel.org>; Mon, 17 Feb 2020 02:54:26 -0500
Received: from e06smtp04.uk.ibm.com (e06smtp04.uk.ibm.com [195.75.94.100])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2y6dns9hk5-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-xfs@vger.kernel.org>; Mon, 17 Feb 2020 02:54:26 -0500
Received: from localhost
        by e06smtp04.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-xfs@vger.kernel.org> from <chandan@linux.ibm.com>;
        Mon, 17 Feb 2020 07:54:24 -0000
Received: from b06cxnps4075.portsmouth.uk.ibm.com (9.149.109.197)
        by e06smtp04.uk.ibm.com (192.168.101.134) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Mon, 17 Feb 2020 07:54:23 -0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 01H7sMoD55312402
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 17 Feb 2020 07:54:22 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 97F8511C052;
        Mon, 17 Feb 2020 07:54:22 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 422B811C050;
        Mon, 17 Feb 2020 07:54:21 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.102.3.72])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 17 Feb 2020 07:54:21 +0000 (GMT)
From:   Chandan Rajendra <chandan@linux.ibm.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     Chandan Rajendra <chandanrlinux@gmail.com>,
        linux-xfs@vger.kernel.org, david@fromorbit.com,
        darrick.wong@oracle.com
Subject: Re: [PATCH V3 1/2] xfs: Pass xattr name and value length explicitly to xfs_attr_leaf_newentsize
Date:   Mon, 17 Feb 2020 13:27:10 +0530
Organization: IBM
In-Reply-To: <20200212151115.GA17921@bfoster>
References: <20200129045939.10380-1-chandanrlinux@gmail.com> <20200212151115.GA17921@bfoster>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-TM-AS-GCONF: 00
x-cbid: 20021707-0016-0000-0000-000002E78073
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20021707-0017-0000-0000-0000334A8E6C
Message-Id: <6991250.kRB6YAzXHl@localhost.localdomain>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-17_04:2020-02-14,2020-02-17 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 clxscore=1015
 malwarescore=0 impostorscore=0 lowpriorityscore=0 bulkscore=0 spamscore=0
 adultscore=0 suspectscore=1 mlxscore=0 phishscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002170070
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wednesday, February 12, 2020 8:41 PM Brian Foster wrote: 
> On Wed, Jan 29, 2020 at 10:29:38AM +0530, Chandan Rajendra wrote:
> > This commit changes xfs_attr_leaf_newentsize() to explicitly accept name and
> > value length instead of a pointer to struct xfs_da_args. The next commit will
> > need to invoke xfs_attr_leaf_newentsize() from functions that do not have
> > a struct xfs_da_args to pass in.
> > 
> > Signed-off-by: Chandan Rajendra <chandanrlinux@gmail.com>
> > ---
> >  fs/xfs/libxfs/xfs_attr.c      |  3 ++-
> >  fs/xfs/libxfs/xfs_attr_leaf.c | 41 ++++++++++++++++++++++++-----------
> >  fs/xfs/libxfs/xfs_attr_leaf.h |  3 ++-
> >  3 files changed, 32 insertions(+), 15 deletions(-)
> > 
> ...
> > diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
> > index 08d4b10ae2d53..7cd57e5844d80 100644
> > --- a/fs/xfs/libxfs/xfs_attr_leaf.c
> > +++ b/fs/xfs/libxfs/xfs_attr_leaf.c
> ...
> > @@ -2687,20 +2700,22 @@ xfs_attr_leaf_entsize(xfs_attr_leafblock_t *leaf, int index)
> >   */
> >  int
> >  xfs_attr_leaf_newentsize(
> > -	struct xfs_da_args	*args,
> > +	struct xfs_mount	*mp,
> 
> Any reason not to just pass the geo here rather than the mount?
> Otherwise looks fine to me.

Sorry, I noticed this message now.

You are right. I will change the first argument to be attr geometry pointer.

-- 
chandan



