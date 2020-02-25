Return-Path: <SRS0=ByWF=4N=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 250F1C35DF5
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Feb 2020 10:12:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EC2AF21556
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Feb 2020 10:12:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729930AbgBYKMi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 25 Feb 2020 05:12:38 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:48935 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729417AbgBYKMi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Feb 2020 05:12:38 -0500
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01PA9OTZ043187
        for <linux-xfs@vger.kernel.org>; Tue, 25 Feb 2020 05:12:37 -0500
Received: from e06smtp04.uk.ibm.com (e06smtp04.uk.ibm.com [195.75.94.100])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2yb12bwbub-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-xfs@vger.kernel.org>; Tue, 25 Feb 2020 05:12:37 -0500
Received: from localhost
        by e06smtp04.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-xfs@vger.kernel.org> from <chandan@linux.ibm.com>;
        Tue, 25 Feb 2020 10:12:35 -0000
Received: from b06avi18626390.portsmouth.uk.ibm.com (9.149.26.192)
        by e06smtp04.uk.ibm.com (192.168.101.134) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Tue, 25 Feb 2020 10:12:32 -0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 01PABYl523593426
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Feb 2020 10:11:34 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 62217A405D;
        Tue, 25 Feb 2020 10:12:31 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D9907A4040;
        Tue, 25 Feb 2020 10:12:29 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.85.72.199])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 25 Feb 2020 10:12:29 +0000 (GMT)
From:   Chandan Rajendra <chandan@linux.ibm.com>
To:     linux-xfs@vger.kernel.org
Cc:     Allison Collins <allison.henderson@oracle.com>
Subject: Re: [PATCH v7 03/19] xfs: Add xfs_has_attr and subroutines
Date:   Tue, 25 Feb 2020 15:45:22 +0530
Organization: IBM
In-Reply-To: <121751246.BNr9PkcSxa@localhost.localdomain>
References: <20200223020611.1802-1-allison.henderson@oracle.com> <20200223020611.1802-4-allison.henderson@oracle.com> <121751246.BNr9PkcSxa@localhost.localdomain>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-TM-AS-GCONF: 00
x-cbid: 20022510-0016-0000-0000-000002EA1051
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20022510-0017-0000-0000-0000334D3B3D
Message-Id: <1661212.smhFePQppX@localhost.localdomain>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-25_02:2020-02-21,2020-02-25 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 bulkscore=0
 clxscore=1015 priorityscore=1501 lowpriorityscore=0 suspectscore=3
 adultscore=0 malwarescore=0 impostorscore=0 phishscore=0 mlxlogscore=999
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002250083
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tuesday, February 25, 2020 3:19 PM Chandan Rajendra wrote: 
> On Sunday, February 23, 2020 7:35 AM Allison Collins wrote: 
> > From: Allison Henderson <allison.henderson@oracle.com>
> > 
> > This patch adds a new functions to check for the existence of an attribute.
> > Subroutines are also added to handle the cases of leaf blocks, nodes or shortform.
> > Common code that appears in existing attr add and remove functions have been
> > factored out to help reduce the appearance of duplicated code.  We will need these
> > routines later for delayed attributes since delayed operations cannot return error
> > codes.
> > 
> > Signed-off-by: Allison Collins <allison.henderson@oracle.com>
> > ---
> >  fs/xfs/libxfs/xfs_attr.c      | 171 ++++++++++++++++++++++++++++--------------
> >  fs/xfs/libxfs/xfs_attr.h      |   1 +
> >  fs/xfs/libxfs/xfs_attr_leaf.c | 111 +++++++++++++++++----------
> >  fs/xfs/libxfs/xfs_attr_leaf.h |   3 +
> >  4 files changed, 188 insertions(+), 98 deletions(-)
> > 
> > diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> > index 9acdb23..2255060 100644
> > --- a/fs/xfs/libxfs/xfs_attr.c
> > +++ b/fs/xfs/libxfs/xfs_attr.c
> > @@ -46,6 +46,7 @@ STATIC int xfs_attr_shortform_addname(xfs_da_args_t *args);
> >  STATIC int xfs_attr_leaf_get(xfs_da_args_t *args);
> >  STATIC int xfs_attr_leaf_addname(xfs_da_args_t *args);
> >  STATIC int xfs_attr_leaf_removename(xfs_da_args_t *args);
> > +STATIC int xfs_attr_leaf_hasname(struct xfs_da_args *args, struct xfs_buf **bp);
> >  
> >  /*
> >   * Internal routines when attribute list is more than one block.
> > @@ -53,6 +54,8 @@ STATIC int xfs_attr_leaf_removename(xfs_da_args_t *args);
> >  STATIC int xfs_attr_node_get(xfs_da_args_t *args);
> >  STATIC int xfs_attr_node_addname(xfs_da_args_t *args);
> >  STATIC int xfs_attr_node_removename(xfs_da_args_t *args);
> > +STATIC int xfs_attr_node_hasname(xfs_da_args_t *args,
> > +				 struct xfs_da_state **state);
> >  STATIC int xfs_attr_fillstate(xfs_da_state_t *state);
> >  STATIC int xfs_attr_refillstate(xfs_da_state_t *state);
> >  
> > @@ -310,6 +313,37 @@ xfs_attr_set_args(
> >  }
> >  
> >  /*
> > + * Return EEXIST if attr is found, or ENOATTR if not
> > + */
> > +int
> > +xfs_has_attr(
> > +	struct xfs_da_args      *args)
> > +{
> > +	struct xfs_inode	*dp = args->dp;
> > +	struct xfs_buf		*bp = NULL;
> > +	int			error;
> > +
> > +	if (!xfs_inode_hasattr(dp))
> > +		return -ENOATTR;
> > +
> > +	if (dp->i_d.di_aformat == XFS_DINODE_FMT_LOCAL) {
> > +		ASSERT(dp->i_afp->if_flags & XFS_IFINLINE);
> > +		return xfs_attr_sf_findname(args, NULL, NULL);
> > +	}
> > +
> > +	if (xfs_bmap_one_block(dp, XFS_ATTR_FORK)) {
> > +		error = xfs_attr_leaf_hasname(args, &bp);
> > +
> > +		if (bp)
> > +			xfs_trans_brelse(args->trans, bp);
> > +
> > +		return error;
> > +	}
> > +
> > +	return xfs_attr_node_hasname(args, NULL);
> > +}
> > +
> > +/*
> >   * Remove the attribute specified in @args.
> >   */
> >  int
> > @@ -583,26 +617,20 @@ STATIC int
> >  xfs_attr_leaf_addname(
> >  	struct xfs_da_args	*args)
> >  {
> > -	struct xfs_inode	*dp;
> >  	struct xfs_buf		*bp;
> >  	int			retval, error, forkoff;
> > +	struct xfs_inode	*dp = args->dp;
> >  
> >  	trace_xfs_attr_leaf_addname(args);
> >  
> >  	/*
> > -	 * Read the (only) block in the attribute list in.
> > -	 */
> > -	dp = args->dp;
> > -	args->blkno = 0;
> > -	error = xfs_attr3_leaf_read(args->trans, args->dp, args->blkno, &bp);
> > -	if (error)
> > -		return error;
> > -
> > -	/*
> >  	 * Look up the given attribute in the leaf block.  Figure out if
> >  	 * the given flags produce an error or call for an atomic rename.
> >  	 */
> > -	retval = xfs_attr3_leaf_lookup_int(bp, args);
> > +	retval = xfs_attr_leaf_hasname(args, &bp);
> > +	if (retval != -ENOATTR && retval != -EEXIST)
> > +		return retval;
> > +
> >  	if ((args->name.type & ATTR_REPLACE) && (retval == -ENOATTR)) {
> >  		xfs_trans_brelse(args->trans, bp);
> >  		return retval;
> > @@ -754,6 +782,27 @@ xfs_attr_leaf_addname(
> >  }
> >  
> >  /*
> > + * Return EEXIST if attr is found, or ENOATTR if not
> > + */
> > +STATIC int
> > +xfs_attr_leaf_hasname(
> > +	struct xfs_da_args      *args,
> > +	struct xfs_buf		**bp)
> > +{
> > +	int                     error = 0;
> > +
> > +	error = xfs_attr3_leaf_read(args->trans, args->dp, 0, bp);
> > +	if (error)
> > +		return error;
> > +
> > +	error = xfs_attr3_leaf_lookup_int(*bp, args);
> > +	if (error != -ENOATTR && error != -EEXIST)
> > +		xfs_trans_brelse(args->trans, *bp);
> > +
> > +	return error;
> > +}
> > +
> > +/*
> >   * Remove a name from the leaf attribute list structure
> >   *
> >   * This leaf block cannot have a "remote" value, we only call this routine
> > @@ -773,12 +822,11 @@ xfs_attr_leaf_removename(
> >  	 * Remove the attribute.
> >  	 */
> >  	dp = args->dp;
> > -	args->blkno = 0;
> > -	error = xfs_attr3_leaf_read(args->trans, args->dp, args->blkno, &bp);
> > -	if (error)
> > +
> > +	error = xfs_attr_leaf_hasname(args, &bp);
> > +	if (error != -ENOATTR && error != -EEXIST)
> >  		return error;
> >  
> > -	error = xfs_attr3_leaf_lookup_int(bp, args);
> >  	if (error == -ENOATTR) {
> >  		xfs_trans_brelse(args->trans, bp);
> >  		return error;
> > @@ -817,12 +865,10 @@ xfs_attr_leaf_get(xfs_da_args_t *args)
> >  
> >  	trace_xfs_attr_leaf_get(args);
> >  
> > -	args->blkno = 0;
> > -	error = xfs_attr3_leaf_read(args->trans, args->dp, args->blkno, &bp);
> > -	if (error)
> > +	error = xfs_attr_leaf_hasname(args, &bp);
> > +	if (error != -ENOATTR && error != -EEXIST)
> >  		return error;
> >  
> > -	error = xfs_attr3_leaf_lookup_int(bp, args);
> >  	if (error != -EEXIST)  {
> >  		xfs_trans_brelse(args->trans, bp);
> >  		return error;
> > @@ -832,6 +878,41 @@ xfs_attr_leaf_get(xfs_da_args_t *args)
> >  	return error;
> >  }
> >  
> > +/*
> > + * Return EEXIST if attr is found, or ENOATTR if not
> > + * statep: If not null is set to point at the found state.  Caller will
> > + *         be responsible for freeing the state in this case.
> > + */
> > +STATIC int
> > +xfs_attr_node_hasname(
> > +	struct xfs_da_args	*args,
> > +	struct xfs_da_state	**statep)
> > +{
> > +	struct xfs_da_state	*state;
> > +	int			retval, error;
> > +
> > +	state = xfs_da_state_alloc();
> > +	state->args = args;
> > +	state->mp = args->dp->i_mount;
> > +
> > +	if (statep != NULL)
> > +		*statep = NULL;
> > +
> > +	/*
> > +	 * Search to see if name exists, and get back a pointer to it.
> > +	 */
> > +	error = xfs_da3_node_lookup_int(state, &retval);
> > +	if (error == 0) {
> > +		if (statep != NULL)
> > +			*statep = state;
> > +		return retval;
> > +	}
> 
> If 'statep' were NULL, then this would leak the memory pointed to by 'state'
> right? 
> 
Apart from the above, the remaining changes look good to me.

Reviewed-by: Chandan Rajendra <chandanrlinux@gmail.com>

-- 
chandan



