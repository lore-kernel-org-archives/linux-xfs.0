Return-Path: <SRS0=ttQi=5Y=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92113C2BA1A
	for <linux-xfs@archiver.kernel.org>; Wed,  8 Apr 2020 12:42:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5EB1B2074F
	for <linux-xfs@archiver.kernel.org>; Wed,  8 Apr 2020 12:42:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726977AbgDHMm0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 8 Apr 2020 08:42:26 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:16642 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727915AbgDHMm0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 8 Apr 2020 08:42:26 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 038CXwq3135966
        for <linux-xfs@vger.kernel.org>; Wed, 8 Apr 2020 08:42:25 -0400
Received: from e06smtp02.uk.ibm.com (e06smtp02.uk.ibm.com [195.75.94.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 30920rk6bw-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-xfs@vger.kernel.org>; Wed, 08 Apr 2020 08:42:25 -0400
Received: from localhost
        by e06smtp02.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-xfs@vger.kernel.org> from <chandan@linux.ibm.com>;
        Wed, 8 Apr 2020 13:42:04 +0100
Received: from b06cxnps4075.portsmouth.uk.ibm.com (9.149.109.197)
        by e06smtp02.uk.ibm.com (192.168.101.132) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 8 Apr 2020 13:42:01 +0100
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 038CgJwe57344108
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 8 Apr 2020 12:42:19 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CAD2452050;
        Wed,  8 Apr 2020 12:42:19 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.85.71.18])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 8028952051;
        Wed,  8 Apr 2020 12:42:18 +0000 (GMT)
From:   Chandan Rajendra <chandan@linux.ibm.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        Chandan Rajendra <chandanrlinux@gmail.com>,
        linux-xfs@vger.kernel.org, bfoster@redhat.com
Subject: Re: [PATCH 2/2] xfs: Extend xattr extent counter to 32-bits
Date:   Wed, 08 Apr 2020 18:13:45 +0530
Organization: IBM
In-Reply-To: <20200406233002.GD21885@dread.disaster.area>
References: <20200404085203.1908-1-chandanrlinux@gmail.com> <20200406170603.GD6742@magnolia> <20200406233002.GD21885@dread.disaster.area>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-TM-AS-GCONF: 00
x-cbid: 20040812-0008-0000-0000-0000036CD9A1
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20040812-0009-0000-0000-00004A8E76F5
Message-Id: <2451772.FeN4kIriKq@localhost.localdomain>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-07_10:2020-04-07,2020-04-07 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 phishscore=0
 priorityscore=1501 impostorscore=0 adultscore=0 mlxscore=0 spamscore=0
 suspectscore=5 mlxlogscore=999 lowpriorityscore=0 bulkscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004080102
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tuesday, April 7, 2020 5:00 AM Dave Chinner wrote: 
> On Mon, Apr 06, 2020 at 10:06:03AM -0700, Darrick J. Wong wrote:
> > On Sat, Apr 04, 2020 at 02:22:03PM +0530, Chandan Rajendra wrote:
> > > XFS has a per-inode xattr extent counter which is 16 bits wide. A workload
> > > which
> > > 1. Creates 1,000,000 255-byte sized xattrs,
> > > 2. Deletes 50% of these xattrs in an alternating manner,
> > > 3. Tries to create 400,000 new 255-byte sized xattrs
> > > causes the following message to be printed on the console,
> > > 
> > > XFS (loop0): xfs_iflush_int: detected corrupt incore inode 131, total extents = -19916, nblocks = 102937, ptr ffff9ce33b098c00
> > > XFS (loop0): xfs_do_force_shutdown(0x8) called from line 3739 of file fs/xfs/xfs_inode.c. Return address = ffffffffa4a94173
> > > 
> > > This indicates that we overflowed the 16-bits wide xattr extent counter.
> > > 
> > > I have been informed that there are instances where a single file has
> > >  > 100 million hardlinks. With parent pointers being stored in xattr,
> > > we will overflow the 16-bits wide xattr extent counter when large
> > > number of hardlinks are created.
> > > 
> > > Hence this commit extends xattr extent counter to 32-bits. It also introduces
> > > an incompat flag to prevent older kernels from mounting newer filesystems with
> > > 32-bit wide xattr extent counter.
> > > 
> > > Signed-off-by: Chandan Rajendra <chandanrlinux@gmail.com>
> > > ---
> > >  fs/xfs/libxfs/xfs_format.h     | 28 +++++++++++++++++++++-------
> > >  fs/xfs/libxfs/xfs_inode_buf.c  | 27 +++++++++++++++++++--------
> > >  fs/xfs/libxfs/xfs_inode_fork.c |  3 ++-
> > >  fs/xfs/libxfs/xfs_log_format.h |  5 +++--
> > >  fs/xfs/libxfs/xfs_types.h      |  4 ++--
> > >  fs/xfs/scrub/inode.c           |  7 ++++---
> > >  fs/xfs/xfs_inode_item.c        |  3 ++-
> > >  fs/xfs/xfs_log_recover.c       | 13 ++++++++++---
> > >  8 files changed, 63 insertions(+), 27 deletions(-)
> > > 
> > > diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
> > > index 045556e78ee2c..0a4266b0d46e1 100644
> > > --- a/fs/xfs/libxfs/xfs_format.h
> > > +++ b/fs/xfs/libxfs/xfs_format.h
> > > @@ -465,10 +465,12 @@ xfs_sb_has_ro_compat_feature(
> > >  #define XFS_SB_FEAT_INCOMPAT_FTYPE	(1 << 0)	/* filetype in dirent */
> > >  #define XFS_SB_FEAT_INCOMPAT_SPINODES	(1 << 1)	/* sparse inode chunks */
> > >  #define XFS_SB_FEAT_INCOMPAT_META_UUID	(1 << 2)	/* metadata UUID */
> > > +#define XFS_SB_FEAT_INCOMPAT_32BIT_AEXT_CNTR (1 << 3)
> > 
> > If you're going to introduce an INCOMPAT feature, please also use the
> > opportunity to convert xattrs to something resembling the dir v3 format,
> > where we index free space within each block so that we can speed up attr
> > setting with 100 million attrs.
> 
> Not necessary. Chandan has already spent a lot of time investigating
> that - I suggested doing the investigation probably a year ago when
> he was looking for stuff to do knowing that this could be a problem
> parent pointers hit. Long story short - there's no degradation in
> performance in the dabtree out to tens of millions of records with
> different fixed size or random sized attributes, nor does various
> combinations of insert/lookup/remove/replace operations seem to
> impact the tree performance at scale. IOWs, we hit the 16 bit extent
> limits of the attribute trees without finding any degradation in
> performance.

My benchmarking was limited to working with a maximum of 1,000,000 xattrs. I
will address the review comments provided on this patchset and then run the
benchmarks once again ... but this time I will increase the upper limit to 100
million xattrs (since we will have a 32-bit extent counter). I will post the
results of the benchmarking (along with the benchmarking programs/scripts) to
the mailing list before I post the patchset itself.

-- 
chandan



