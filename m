Return-Path: <SRS0=ttQi=5Y=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8FC74C2BA1B
	for <linux-xfs@archiver.kernel.org>; Wed,  8 Apr 2020 15:47:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4F85620820
	for <linux-xfs@archiver.kernel.org>; Wed,  8 Apr 2020 15:47:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="AndkqnyF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729511AbgDHPrc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 8 Apr 2020 11:47:32 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:43410 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729867AbgDHPrV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 8 Apr 2020 11:47:21 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 038FdRob068902;
        Wed, 8 Apr 2020 15:47:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=D9PAT1LArQzvlD8ohn2RdC2Eoh+5ARAqYjSFBZRLN0A=;
 b=AndkqnyFLyLly1KzmpKerLCa62IzcQhb5wCNOanGNNHe9OFu4F2sI45/XqT7IV7kHdP5
 2f7RYJ3KkqDwwekdfUKHFwAejvkBPI6aOzlMdpQbYlwXlGDnFJ0YQV31MjUob4p1/mL6
 Q3DprTRVLqzJxxqyB+/JWLtVG6ukcs9XXdjOjmX8m+W+tUQfh96Lu068CHjbF8lLdgNp
 /Oz9IQkM6AKb5ehs9BayiXXBQ5A18UdyMJveuiakLLixIDXd7+gpFNwPU+i/rlGsJFjL
 Qq7xgWsAlLMmhAVVEjPsAAVh2obrOb16JgINfEJ0ZPOhKRFYLGibpI5vo6J4ZsxQzw1E 4g== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 309gw48919-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 08 Apr 2020 15:47:15 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 038FceCH067193;
        Wed, 8 Apr 2020 15:45:15 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 309gd8x1vb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 08 Apr 2020 15:45:15 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 038FjDuh014687;
        Wed, 8 Apr 2020 15:45:13 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 08 Apr 2020 08:45:13 -0700
Date:   Wed, 8 Apr 2020 08:45:12 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Chandan Rajendra <chandanrlinux@gmail.com>,
        linux-xfs@vger.kernel.org, chandan@linux.ibm.com,
        bfoster@redhat.com
Subject: Re: [PATCH 2/2] xfs: Extend xattr extent counter to 32-bits
Message-ID: <20200408154512.GA6741@magnolia>
References: <20200404085203.1908-1-chandanrlinux@gmail.com>
 <20200404085203.1908-3-chandanrlinux@gmail.com>
 <20200406170603.GD6742@magnolia>
 <20200406233002.GD21885@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200406233002.GD21885@dread.disaster.area>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9584 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 adultscore=0 mlxscore=0 spamscore=0 bulkscore=0 phishscore=0
 suspectscore=2 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004080124
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9584 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 bulkscore=0
 phishscore=0 lowpriorityscore=0 impostorscore=0 clxscore=1015
 suspectscore=2 malwarescore=0 spamscore=0 mlxlogscore=999 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004080124
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Apr 07, 2020 at 09:30:02AM +1000, Dave Chinner wrote:
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
> parent pointers hit.

Oh, I didn't realize that analysis work has already been done.

Chandan, could you please mention that somewhere in the cover letter?
It does mention that you tried creating 1M xattrs, but I guess it needed
to be more explicit about not uncovering any gigantic performance holes.

> Long story short - there's no degradation in
> performance in the dabtree out to tens of millions of records with
> different fixed size or random sized attributes, nor does various
> combinations of insert/lookup/remove/replace operations seem to
> impact the tree performance at scale. IOWs, we hit the 16 bit extent
> limits of the attribute trees without finding any degradation in
> performance.

Ok.  I'll take "attr v3 upgrade" off my list of things to look out for.

> Hence we concluded that the dabtree structure does not require
> significant modification or optimisation to work well with typical
> parent pointer attribute demands...
> 
> As for free space indexes....
> 
> The issue with the directory structure that requires external free
> space is that the directory data is not part of the dabtree itself.
> The attribute fork stores all the attributes at the leaves of the
> dabtree, while the directory structure stores the directory data in
> external blocks and the dabtree only contains the name hash index
> that points to the external data.
> 
> i.e. When we add an attribute to the dabtree, we split/merge leaves
> of the tree based on where the name hash index tells us it needs to
> be inserted/removed from. i.e. we make space available or collapse
> sparse leaves of the dabtree as a side effect of inserting or
> removing objects.
> 
> The directory structure is very different. The dirents cannot change
> location as their logical offset into the dir data segment is used
> as the readdir/seekdir/telldir cookie. Therefore that location is
> not allowed to change for the life of the dirent and so we can't
> store them in the leaves of a dabtree indexed in hash order because
> the offset into the tree would change as other entries are inserted
> and removed.  Hence when we remove dirents, we must leave holes in
> the data segment so the rest of the dirent data does not change
> logical offset.
> 
> The directory name hash index - the dabtree bit - is in a separate
> segment (the 2nd one). Because it only stores pointers to dirents in
> the data segment, it doesn't need to leave holes - the dabtree just
> merge/splits as required as pointers to the dir data segment are
> added/removed - and has no free space tracking.
> 
> Hence when we go to add a dirent, we need to find the best free
> space in the dir data segment to add that dirent. This requires a
> dir data segment free space index, and that is held in the 3rd dir
> segment.  Once we've found the best free space via lookup in the
> free space index, we go modify the dir data block it points to, then
> update the dabtree to point the name hash at that new dirent.
> 
> IOWs, the requirement for a free space map in the directory
> structure results from storing the dirent data externally to the
> dabtree. Attributes are stored directly in the leaves of the
> dabtree - except for remote attributes which can be anywhere in the
> BMBT address space - and hence do no need external free space
> tracking to determine where to best insert them...

<nod> Got it.  I've suspected this property about the xattr structures
for a long time, so I'm glad to hear someone else echo that. :)

Dave: May I try to rework the above into something suitable for the
ondisk format documentation?

--D

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
