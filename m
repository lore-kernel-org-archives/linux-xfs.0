Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 369E2C2D0A3
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Nov 2020 16:05:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B98C422227
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Nov 2020 16:05:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="mU7mRL8t"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728450AbgKLQFd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 12 Nov 2020 11:05:33 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:52630 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728389AbgKLQFd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 12 Nov 2020 11:05:33 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0ACG4CYW105158;
        Thu, 12 Nov 2020 16:05:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=QcG3U4kvcOQ8zFNcyoLknaXK3sdT4wyUM+MQ6f09P1o=;
 b=mU7mRL8tCevmVkxbo2q+31PpxeMFjQEAclVT/OIbQhZRT/IS5qa9DwQAratXi/PVfw/3
 VUDDeHKEmqUzcAuzRD3lu2BYKQ3gr1lLrll9/jAr3x12LBYHtBtp/SKlIW7sgjngRJ5q
 1JN3pzTuI1oaCmztxdHeGAixnbawmmYmC2Tw88V4PquX+yVPDsy5+iu1ebQ2ymQrYzfD
 9z0OHO8wdUDaKnz8MEpjNriXIRndTL0mWCj80MHTNE3Q8Cl2TzHsK8AYWy8dbheUl34x
 HX6VApFsOI3rnVw3xkH1Gyqs9YKigQwVGyPL7vp8r4Q1bQAb6NqXn1RL+s+o8LNIYAGQ 2w== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 34nh3b6bvy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 12 Nov 2020 16:05:29 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0ACG5Cba062880;
        Thu, 12 Nov 2020 16:05:29 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 34rt5691ak-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 Nov 2020 16:05:29 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0ACG5Rri031672;
        Thu, 12 Nov 2020 16:05:27 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 12 Nov 2020 08:05:27 -0800
Date:   Thu, 12 Nov 2020 08:05:26 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Chandan Babu R <chandanrlinux@gmail.com>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com
Subject: Re: [PATCH 1/4] xfs: fix brainos in the refcount scrubber's rmap
 fragment processor
Message-ID: <20201112160526.GS9695@magnolia>
References: <160494585293.772802.13326482733013279072.stgit@magnolia>
 <160494585913.772802.17231950418756379430.stgit@magnolia>
 <3965877.p3O8HGrD7x@garuda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3965877.p3O8HGrD7x@garuda>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9802 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 mlxscore=0
 mlxlogscore=999 suspectscore=1 adultscore=0 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011120095
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9802 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 priorityscore=1501
 clxscore=1015 malwarescore=0 mlxscore=0 spamscore=0 suspectscore=1
 mlxlogscore=999 impostorscore=0 phishscore=0 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011120095
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Nov 12, 2020 at 06:21:52PM +0530, Chandan Babu R wrote:
> On Monday 9 November 2020 11:47:39 PM IST Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Fix some serious WTF in the reference count scrubber's rmap fragment
> > processing.  The code comment says that this loop is supposed to move
> > all fragment records starting at or before bno onto the worklist, but
> > there's no obvious reason why nr (the number of items added) should
> > increment starting from 1, and breaking the loop when we've added the
> > target number seems dubious since we could have more rmap fragments that
> > should have been added to the worklist.
> > 
> > This seems to manifest in xfs/411 when adding one to the refcount field.
> > 
> > Fixes: dbde19da9637 ("xfs: cross-reference the rmapbt data with the refcountbt")
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  fs/xfs/scrub/refcount.c |    8 +++-----
> >  1 file changed, 3 insertions(+), 5 deletions(-)
> > 
> > 
> > diff --git a/fs/xfs/scrub/refcount.c b/fs/xfs/scrub/refcount.c
> > index beaeb6fa3119..dd672e6bbc75 100644
> > --- a/fs/xfs/scrub/refcount.c
> > +++ b/fs/xfs/scrub/refcount.c
> > @@ -170,7 +170,6 @@ xchk_refcountbt_process_rmap_fragments(
> >  	 */
> >  	INIT_LIST_HEAD(&worklist);
> >  	rbno = NULLAGBLOCK;
> > -	nr = 1;
> >  
> >  	/* Make sure the fragments actually /are/ in agbno order. */
> >  	bno = 0;
> > @@ -184,15 +183,14 @@ xchk_refcountbt_process_rmap_fragments(
> >  	 * Find all the rmaps that start at or before the refc extent,
> >  	 * and put them on the worklist.
> >  	 */
> > +	nr = 0;
> >  	list_for_each_entry_safe(frag, n, &refchk->fragments, list) {
> > -		if (frag->rm.rm_startblock > refchk->bno)
> > -			goto done;
> > +		if (frag->rm.rm_startblock > refchk->bno || nr > target_nr)
> > +			break;
> 
> In the case of fuzzed refcnt value of 1, The condition "nr > target_nr" causes
> "nr != target_nr" condition (appearing after the loop) to evaluate to true
> (since atleast two rmap entries would be present for the refcount extent)
> which in turn causes xchk_refcountbt_xref_rmap() to flag the data structure as
> corrupt. Please let me know if my understanding of the code flow is correct?

Right.

--D

> >  		bno = frag->rm.rm_startblock + frag->rm.rm_blockcount;
> >  		if (bno < rbno)
> >  			rbno = bno;
> >  		list_move_tail(&frag->list, &worklist);
> > -		if (nr == target_nr)
> > -			break;
> >  		nr++;
> >  	}
> >  
> > 
> > 
> 
> 
> -- 
> chandan
> 
> 
> 
