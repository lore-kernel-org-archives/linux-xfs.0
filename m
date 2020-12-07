Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E60CDC433FE
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Dec 2020 17:19:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BC0DC2388E
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Dec 2020 17:19:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726377AbgLGRTj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 7 Dec 2020 12:19:39 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:34906 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725866AbgLGRTj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 7 Dec 2020 12:19:39 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B7HFQRk034605;
        Mon, 7 Dec 2020 17:18:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=t8CphUzX/vm95PmGD0WDLvZ5xNVmzh21p0yLG1gFugU=;
 b=Y78uIQu6NIv3JFeem2RedJ7YHp+o/YTEAKwOwjI3rqTOGIKsgATyImfGdiUBiV1zGSR6
 xNx6hmxgM47dCtzlf+MWk4vN3s4dS502Cl+xwVv0HQEGf7SSx5Nd+cEeVPfJFADMCt+d
 uwKWOHrinhUTN5EJbEUIC/XFLuaYOwDN76C8B+TDK6eq2drzgzMDTvQSqTs4mRBYGKJF
 agwYP/jtSKfFZeDRvY8DVtT4Re5dAj9g2jSXrpEvSiSzpxfQntCYhUOj4A0t4lst/zdr
 6QaXVBXxw9WxyO4h/YIPa45k3gyqUpRjHxGxSW0O34MBnldXPjUePndzOmRSeiiBjPzh lA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 35825kxh57-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 07 Dec 2020 17:18:55 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B7HFfYO177228;
        Mon, 7 Dec 2020 17:18:55 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 358m4wj7k2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 07 Dec 2020 17:18:54 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0B7HIrj9004945;
        Mon, 7 Dec 2020 17:18:53 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 07 Dec 2020 09:18:53 -0800
Date:   Mon, 7 Dec 2020 09:18:51 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] [RFC] xfs: initialise attr fork on inode create
Message-ID: <20201207171851.GQ629293@magnolia>
References: <20201202232724.1730114-1-david@fromorbit.com>
 <20201204123137.GA1404170@bfoster>
 <20201204212222.GG3913616@dread.disaster.area>
 <20201205113444.GA1485029@bfoster>
 <20201206233322.GK3913616@dread.disaster.area>
 <20201207163018.GD1585352@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201207163018.GD1585352@bfoster>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9827 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 suspectscore=1
 bulkscore=0 malwarescore=0 phishscore=0 adultscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012070111
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9827 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 adultscore=0 bulkscore=0
 phishscore=0 mlxlogscore=999 clxscore=1015 priorityscore=1501 mlxscore=0
 spamscore=0 lowpriorityscore=0 malwarescore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012070111
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Dec 07, 2020 at 11:30:18AM -0500, Brian Foster wrote:
> On Mon, Dec 07, 2020 at 10:33:22AM +1100, Dave Chinner wrote:
> > On Sat, Dec 05, 2020 at 06:34:44AM -0500, Brian Foster wrote:
> > > On Sat, Dec 05, 2020 at 08:22:22AM +1100, Dave Chinner wrote:
> > > > On Fri, Dec 04, 2020 at 07:31:37AM -0500, Brian Foster wrote:
> > > > > On Thu, Dec 03, 2020 at 10:27:24AM +1100, Dave Chinner wrote:
> > > > > > diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> > > > > > index 2bfbcf28b1bd..9ee2e0b4c6fd 100644
> > > > > > --- a/fs/xfs/xfs_inode.c
> > > > > > +++ b/fs/xfs/xfs_inode.c
> > > > > ...
> > > > > > @@ -918,6 +919,18 @@ xfs_ialloc(
> > > > > >  		ASSERT(0);
> > > > > >  	}
> > > > > >  
> > > > > > +	/*
> > > > > > +	 * If we need to create attributes immediately after allocating the
> > > > > > +	 * inode, initialise an empty attribute fork right now. We use the
> > > > > > +	 * default fork offset for attributes here as we don't know exactly what
> > > > > > +	 * size or how many attributes we might be adding. We can do this safely
> > > > > > +	 * here because we know the data fork is completely empty right now.
> > > > > > +	 */
> > > > > > +	if (init_attrs) {
> > > > > > +		ip->i_afp = xfs_ifork_alloc(XFS_DINODE_FMT_EXTENTS, 0);
> > > > > > +		ip->i_d.di_forkoff = xfs_default_attroffset(ip) >> 3;
> > > > > > +	}
> > > > > > +
> > > > > 
> > > > > Seems reasonable in principle, but why not refactor
> > > > > xfs_bmap_add_attrfork() such that the internals (i.e. everything within
> > > > > the transaction/ilock code) can be properly reused in both contexts
> > > > > rather than open-coding (and thus duplicating) a somewhat stripped down
> > > > > version?
> > > > 
> > > > We don't know the size of the attribute that is being created, so
> > > > the attr size dependent parts of it can't be used.
> > > 
> > > Not sure I see the problem here. It looks to me that
> > > xfs_bmap_add_attrfork() would do the right thing if we just passed a
> > > size of zero.
> > 
> > Yes, but it also does an awful lot that we do not need.
> > 
> 
> Hence the suggestion to refactor it..
> 
> > > The only place the size value is actually used is down in
> > > xfs_attr_shortform_bytesfit(), and I'd expect that to identify that the
> > > requested size is <= than the current afork size (also zero for a newly
> > > allocated inode..?) and bail out.
> > 
> > RIght it ends up doing that because an uninitialised inode fork
> > (di_forkoff = 0) is the same size as the requested size of zero, and
> > then it does ip->i_d.di_forkoff = xfs_default_attroffset(ip) >> 3;
> > 
> > But that's decided another two function calls deep, after a lot of
> > branches and shifting and comparisons to determine that the attr
> > fork is empty. Yet we already know that the attr fork is empty here
> > so all that extra CPU work is completely unnecessary.
> > 
> 
> xfs_bmap_add_attrfork() already asserts that the attr fork is
> nonexistent at the very top of the function, for one. The 25-30 lines of
> that function that we need can be trivially lifted out into a new helper
> that can equally as trivially accommodate the size == 0 case and skip
> all those shortform calculations.
> 
> > Keep in mind we do exactly the same thing in
> > xfs_bmap_forkoff_reset(). We don't care about all the setup stuff in
> > xfs_bmap_add_attrfork(), we just reset the attr fork offset to the
> > default if the attr fork had grown larger than the default offset.
> > 
> 
> I'm not arguing that the attr fork needs to be set up in a particular
> way on initial creation. I'm arguing that we don't need yet a third
> unique code path to set/initialize a default/empty attr fork. We can
> slowly normalize them all to the _reset() technique you're effectively
> reimplementing here if that works well enough and is preferred...
> 
> > > That said, I wouldn't be opposed to tweaking xfs_bmap_set_attrforkoff()
> > > by a line or two to just skip the shortform call if size == 0. Then we
> > > can be more explicit about the "size == 0 means preemptive fork alloc,
> > > use the default offset" use case and perhaps actually document it with
> > > some comments as well.
> > 
> > It just seems wrong to me to code a special case into some function
> > to optimise that special case when the code that needs the special
> > case has no need to call that function in the first place.....
> > 
> 
> I'm not sure what's so odd or controversial about refactoring and
> reusing an existing operational (i.e. add fork) function to facilitate
> review and future maintenance of that particular operation being
> performed from new and various contexts. And speaking in generalities
> like this just obfuscates and overcomplicates the argument. Let's be
> clear, we're literally arguing over a delta that would look something
> like this:
> 
> xfs_bmap_set_attrforkoff()
> {
> ...
> +		if (size)
> -               ip->i_d.di_forkoff = xfs_attr_shortform_bytesfit(ip, size);
> +			ip->i_d.di_forkoff = xfs_attr_shortform_bytesfit(ip, size);
>                 if (!ip->i_d.di_forkoff)
>                         ip->i_d.di_forkoff = xfs_default_attroffset(ip) >> 3;
> 		...
> }
> 
> Given all of that, I'm not convinced this is nearly the problem you seem
> to insinuate, yet I also don't think I'll convince you otherwise so it's
> probably not worth continuing to debate. You have my feedback, I'll let
> others determine how this patch comes together from here...

Alternate take: If you /are/ going to have a "init empty attr fork"
shortcut function, can it at least be placed next to the regular one in
xfs_bmap.c so that the di_forkoff setters are only split across three
source files instead of four?

--D

> Brian
> 
> > Cheers,
> > 
> > Dave.
> > -- 
> > Dave Chinner
> > david@fromorbit.com
> > 
> 
