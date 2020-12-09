Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98E81C4361B
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Dec 2020 19:24:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 38D7C23C41
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Dec 2020 19:24:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730197AbgLITYv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 9 Dec 2020 14:24:51 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:46152 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729345AbgLITYv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 9 Dec 2020 14:24:51 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B9JDLPZ112679;
        Wed, 9 Dec 2020 19:24:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=//NKh4GRdfHBix8BLFRi38vWM0TaIGzMXhQlY4mYrvM=;
 b=nZ1SdXyu9GqJpoRovE2MiRyKMESqIReLT/TaM6Gam5NOlKdhZNfZdjfcqiRoBc2bUh9o
 QHy1hz4BsDUQiFMjA/IN5ldLl2BvoDprY6zyXleTGQODsdp1WrkTXfGp3O2wL9mn6JpE
 7KYto8sOPVLvvJ1mXbsKwTlIWK5dk8blo6ifPRFm1XGZeqaIJ/izP44Qy6YSSeGuvFml
 YBNR7cnCh4DbGmjVOQhFyweLKhmMMjMdGPgGUjbSLLFofYFY9meNrZHMeiwBMPHZBr3Z
 I8Ishg7sJFOCLPTFMSfB2eIpvI+1RQlhuOINzv8D+FiBBuDvnzXgAcu24JIbfQJJIqJ+ cw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 357yqc22q0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 09 Dec 2020 19:24:07 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B9JEpsb075027;
        Wed, 9 Dec 2020 19:24:06 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 358ksqj8um-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Dec 2020 19:24:06 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0B9JO5UJ026756;
        Wed, 9 Dec 2020 19:24:05 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 09 Dec 2020 11:24:05 -0800
Date:   Wed, 9 Dec 2020 11:24:04 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Chandan Babu R <chandanrlinux@gmail.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH V11 05/14] xfs: Check for extent overflow when
 adding/removing dir entries
Message-ID: <20201209192404.GM1943235@magnolia>
References: <20201117134416.207945-1-chandanrlinux@gmail.com>
 <20201203190422.GB106271@magnolia>
 <15021664.sC18oI5324@garuda>
 <3689375.PeLr2PdtSZ@garuda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3689375.PeLr2PdtSZ@garuda>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9830 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=5
 bulkscore=0 malwarescore=0 phishscore=0 mlxscore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012090135
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9830 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=5 mlxlogscore=999
 clxscore=1015 malwarescore=0 bulkscore=0 phishscore=0 adultscore=0
 spamscore=0 priorityscore=1501 mlxscore=0 lowpriorityscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012090135
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Dec 07, 2020 at 01:48:50PM +0530, Chandan Babu R wrote:
> On Fri, 04 Dec 2020 14:34:32 +0530, Chandan Babu R wrote:
> > On Thu, 03 Dec 2020 11:04:22 -0800, Darrick J. Wong wrote:
> > > On Tue, Nov 17, 2020 at 07:14:07PM +0530, Chandan Babu R wrote:
> > > > Directory entry addition/removal can cause the following,
> > > > 1. Data block can be added/removed.
> > > >    A new extent can cause extent count to increase by 1.
> > > > 2. Free disk block can be added/removed.
> > > >    Same behaviour as described above for Data block.
> > > > 3. Dabtree blocks.
> > > >    XFS_DA_NODE_MAXDEPTH blocks can be added. Each of these
> > > >    can be new extents. Hence extent count can increase by
> > > >    XFS_DA_NODE_MAXDEPTH.
> > > > 
> > > > To be able to always remove an existing directory entry, when adding a
> > > > new directory entry we make sure to reserve inode fork extent count
> > > > required for removing a directory entry in addition to that required for
> > > > the directory entry add operation.
> > > > 
> > > > Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
> > > > ---
> > > >  fs/xfs/libxfs/xfs_inode_fork.h | 13 +++++++++++++
> > > >  fs/xfs/xfs_inode.c             | 27 +++++++++++++++++++++++++++
> > > >  fs/xfs/xfs_symlink.c           |  5 +++++
> > > >  3 files changed, 45 insertions(+)
> > > > 
> > > > diff --git a/fs/xfs/libxfs/xfs_inode_fork.h b/fs/xfs/libxfs/xfs_inode_fork.h
> > > > index 5de2f07d0dd5..fd93fdc67ee4 100644
> > > > --- a/fs/xfs/libxfs/xfs_inode_fork.h
> > > > +++ b/fs/xfs/libxfs/xfs_inode_fork.h
> > > > @@ -57,6 +57,19 @@ struct xfs_ifork {
> > > >  #define XFS_IEXT_ATTR_MANIP_CNT(rmt_blks) \
> > > >  	(XFS_DA_NODE_MAXDEPTH + max(1, rmt_blks))
> > > >  
> > > > +/*
> > > > + * Directory entry addition/removal can cause the following,
> > > > + * 1. Data block can be added/removed.
> > > > + *    A new extent can cause extent count to increase by 1.
> > > > + * 2. Free disk block can be added/removed.
> > > > + *    Same behaviour as described above for Data block.
> > > > + * 3. Dabtree blocks.
> > > > + *    XFS_DA_NODE_MAXDEPTH blocks can be added. Each of these can be new
> > > > + *    extents. Hence extent count can increase by XFS_DA_NODE_MAXDEPTH.
> > > > + */
> > > > +#define XFS_IEXT_DIR_MANIP_CNT(mp) \
> > > > +	((XFS_DA_NODE_MAXDEPTH + 1 + 1) * (mp)->m_dir_geo->fsbcount)
> > > > +
> > > >  /*
> > > >   * Fork handling.
> > > >   */
> > > > diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> > > > index 2bfbcf28b1bd..f7b0b7fce940 100644
> > > > --- a/fs/xfs/xfs_inode.c
> > > > +++ b/fs/xfs/xfs_inode.c
> > > > @@ -1177,6 +1177,11 @@ xfs_create(
> > > >  	if (error)
> > > >  		goto out_trans_cancel;
> > > >  
> > > > +	error = xfs_iext_count_may_overflow(dp, XFS_DATA_FORK,
> > > > +			XFS_IEXT_DIR_MANIP_CNT(mp) << 1);
> > > 
> > > Er, why did these double since V10?  We're only adding one entry, right?
> > 
> > To be able to always guarantee the removal of an existing directory entry, we
> > reserve inode fork extent count required for removing a directory entry in
> > addition to that required for the directory entry add operation.
> > 
> > A bug was discovered when executing the following sequence of
> > operations,
> > 1. Keep inserting directory entries until the pseudo max extent count limit is
> >    reached.
> > 2. At this stage, a directory entry remove operation will fail because it
> >    tries to reserve XFS_IEXT_DIR_MANIP_CNT(mp) worth of extent count. This
> >    reservation fails since the extent count would go over the pseudo max
> >    extent count limit as it did in step 1.
> > 
> > We would end up with a directory which can never be deleted.
> 
> I just found that reserving an extra XFS_IEXT_DIR_MANIP_CNT(mp) extent count,
> when performing a directory insert operation, would not prevent us from ending
> up with a directory which can never be deleted.
> 
> Let x be a directory's data fork extent count and lets assume its value to be,
> 
> x = MAX_EXT_COUNT - XFS_IEXT_DIR_MANIP_CNT(mp)
> 
> So in this case we do have sufficient "extent count" to be able to perform a
> directory entry remove operation. But the directory remove operation itself
> can cause extent count to increase by XFS_IEXT_DIR_MANIP_CNT(mp) units in the
> worst case. This happens when freeing 5 dabtree blocks, one data block and one
> free block causes file extents to be split for each of the above mentioned
> blocks.
> 
> If on the other hand, the current value of 'x' were,
> 
> x = MAX_EXT_COUNT - (2 * XFS_IEXT_DIR_MANIP_CNT(mp))
> 
> 'x' can still reach MAX_EXT_COUNT if two consecutive directory remove
> operations can each cause extent count to increase by
> XFS_IEXT_DIR_MANIP_CNT(mp).
> 
> IMHO there is no way to prevent a directory from becoming un-deletable
> once its data fork extent count reaches close to MAX_EXT_COUNT. The other
> choice of not checking for extent overflow would mean silent data
> corruption. Hence maybe the former result is better one to go with.

So in other words you're doubling the amount you pass into the overflow
check so that we can guarantee that a future dirent removal will work.

In other words, the doubling is to preserve future functionality, and is
not required by the create() call itself.  This should be captured in
a comment above the call to xfs_iext_count_may_overflow.

Or I guess you could create an XFS_IEXT_DIRENT_CREATE macro that wraps
all that (along with that comment explaining why).

> W.r.t xattrs, not reserving an extra XFS_IEXT_ATTR_MANIP_CNT(mp) extent count
> units would prevent the user from removing xattrs when the inode's attr fork
> extent count value is close to MAX_EXT_COUNT. However, the file and the
> associated extents will be removed during file deletion operation.

<shrug> I doubt xattr trees often get close to 64k extents, so you might
as well apply the same logic to them.  Better to cut off the user early
than to force them to delete the whole file just to wipe out the xattrs.

> > 
> > Hence V11 doubles the extent count reservation for "directory entry insert"
> > operations. The first XFS_IEXT_DIR_MANIP_CNT(mp) instance is for "insert"
> > operation while the second XFS_IEXT_DIR_MANIP_CNT(mp) instance is for
> > guaranteeing a possible future "remove" operation to succeed.
> > 
> > > 
> > > > +	if (error)
> > > > +		goto out_trans_cancel;
> > > > +
> > > >  	/*
> > > >  	 * A newly created regular or special file just has one directory
> > > >  	 * entry pointing to them, but a directory also the "." entry
> > > > @@ -1393,6 +1398,11 @@ xfs_link(
> > > >  	xfs_trans_ijoin(tp, sip, XFS_ILOCK_EXCL);
> > > >  	xfs_trans_ijoin(tp, tdp, XFS_ILOCK_EXCL);
> > > >  
> > > > +	error = xfs_iext_count_may_overflow(tdp, XFS_DATA_FORK,
> > > > +			XFS_IEXT_DIR_MANIP_CNT(mp) << 1);
> > > 
> > > Same question here.
> > 
> > Creating a new hard link involves adding a new directory entry. Hence apart
> > from reserving extent count for directory entry addition we will have to
> > reserve extent count for a future directory entry removal as well.

In other words, we also want XFS_IEXT_DIRENT_CREATE here?

> > 
> > > 
> > > > +	if (error)
> > > > +		goto error_return;
> > > > +
> > > >  	/*
> > > >  	 * If we are using project inheritance, we only allow hard link
> > > >  	 * creation in our tree when the project IDs are the same; else
> > > > @@ -2861,6 +2871,11 @@ xfs_remove(
> > > >  	xfs_trans_ijoin(tp, dp, XFS_ILOCK_EXCL);
> > > >  	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
> > > >  
> > > > +	error = xfs_iext_count_may_overflow(dp, XFS_DATA_FORK,
> > > > +			XFS_IEXT_DIR_MANIP_CNT(mp));
> > > > +	if (error)
> > > > +		goto out_trans_cancel;
> > > > +
> > > >  	/*
> > > >  	 * If we're removing a directory perform some additional validation.
> > > >  	 */
> > > > @@ -3221,6 +3236,18 @@ xfs_rename(
> > > >  	if (wip)
> > > >  		xfs_trans_ijoin(tp, wip, XFS_ILOCK_EXCL);
> > > >  
> > > > +	error = xfs_iext_count_may_overflow(src_dp, XFS_DATA_FORK,
> > > > +			XFS_IEXT_DIR_MANIP_CNT(mp));
> > > > +	if (error)
> > > > +		goto out_trans_cancel;
> > > > +
> > > > +	if (target_ip == NULL) {
> > > > +		error = xfs_iext_count_may_overflow(target_dp, XFS_DATA_FORK,
> > > > +				XFS_IEXT_DIR_MANIP_CNT(mp) << 1);
> > > 
> > > Why did this change to "<< 1" since V10?
> > 
> > Extent count is doubled since this is essentially a directory insert operation
> > w.r.t target_dp directory. One instance of XFS_IEXT_DIR_MANIP_CNT(mp) is for
> > the directory entry being added to target_dp directory and another instance of
> > XFS_IEXT_DIR_MANIP_CNT(mp) is for guaranteeing a future directory entry
> > removal from target_dp directory to succeed.

...and here too?

> > 
> > > 
> > > I'm sorry, but I've lost my recollection on how the accounting works
> > > here.  This seems (to me anyway ;)) a good candidate for a comment:
> > > 
> > > For a rename between dirs where the target name doesn't exist, we're
> > > removing src_name from src_dp and adding target_name to target_dp.
> > > Therefore we have to check for DIR_MANIP_CNT overflow on each of src_dp
> > > and target_dp, right?
> > 
> > Extent count check is doubled since this is a directory insert operation w.r.t
> > target_dp directory ... One instance of XFS_IEXT_DIR_MANIP_CNT(mp) is for the
> > directory entry being added to target_dp directory and another instance of
> > XFS_IEXT_DIR_MANIP_CNT(mp) is for guaranteeing a future directory entry
> > removal from target_dp directory to succeed.

Or in other words, another place for XFS_IEXT_DIRENT_CREATE...

> > Since a directory entry is being removed from src_dp, reserving only a single
> > instance of XFS_IEXT_DIR_MANIP_CNT(mp) would suffice.

<nod>

> > > 
> > > For a rename within the same dir where target_name doesn't yet exist, we
> > > are removing a name and then adding a name.  We therefore check for iext
> > > overflow with (DIR_MANIP_CNT * 2), right?  And I think that "target name
> > > does not exist" is synonymous with target_ip == NULL?
> > 
> > Here again we have to reserve two instances of XFS_IEXT_DIR_MANIP_CNT(mp) for
> > target_name insertion and one instance of XFS_IEXT_DIR_MANIP_CNT(mp) for
> > src_name removal. This is because insertion and removal of src_name may each
> > end up consuming XFS_IEXT_DIR_MANIP_CNT(mp) extent counts in the worst case. A
> > future directory entry remove operation will require
> > XFS_IEXT_DIR_MANIP_CNT(mp) extent counts to be reserved.

...and another place for DIRENT_CREATE...

> > 
> > Also, You are right about "target name does not exist" being synonymous with
> > target_ip == NULL.
> > 
> > > 
> > > For a rename where target_name /does/ exist, we're only removing the
> > > src_name, so we have to check for DIR_MANIP_CNT on src_dp, right?
> > 
> > Yes, you are right.
> > 
> > > 
> > > For a RENAME_EXCHANGE we're not removing either name, so we don't need
> > > to check for iext overflow of src_dp or target_dp, right?
> > 
> > You are right. Sorry, I missed this. I will move the extent count reservation
> > logic to come after the invocation of xfs_cross_rename().

Ok.

> > I will also add appropriate comments into xfs_rename() describing the
> > scenarios that have been discussed above.

Thanks.

> > PS: I have swapped the order of two comments from your original reply since I
> > think it is easier to explain the scenarios with the order of
> > comments/questions swapped.

Ok.

> > 
> > > 
> > > > +		if (error)
> > > > +			goto out_trans_cancel;
> > > > +	}
> > > > +
> > > >  	/*
> > > >  	 * If we are using project inheritance, we only allow renames
> > > >  	 * into our tree when the project IDs are the same; else the
> > > > diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
> > > > index 8e88a7ca387e..08aa808fe290 100644
> > > > --- a/fs/xfs/xfs_symlink.c
> > > > +++ b/fs/xfs/xfs_symlink.c
> > > > @@ -220,6 +220,11 @@ xfs_symlink(
> > > >  	if (error)
> > > >  		goto out_trans_cancel;
> > > >  
> > > > +	error = xfs_iext_count_may_overflow(dp, XFS_DATA_FORK,
> > > > +			XFS_IEXT_DIR_MANIP_CNT(mp) << 1);
> > > 
> > > Same question as xfs_create.
> > 
> > This is again similar to adding a new directory entry. Hence, apart from
> > reserving extent count for directory entry addition we will have to reserve
> > extent count for a future directory entry removal as well.

...and here yet another place to use XFS_IEXT_DIRENT_CREATE?

--D

> > 
> > > 
> > > --D
> > > 
> > > > +	if (error)
> > > > +		goto out_trans_cancel;
> > > > +
> > > >  	/*
> > > >  	 * Allocate an inode for the symlink.
> > > >  	 */
> > > 
> > 
> > 
> 
> 
> -- 
> chandan
> 
> 
> 
