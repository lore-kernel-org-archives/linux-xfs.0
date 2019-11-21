Return-Path: <SRS0=udUw=ZN=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 598F5C432C0
	for <linux-xfs@archiver.kernel.org>; Thu, 21 Nov 2019 04:50:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 22A512084D
	for <linux-xfs@archiver.kernel.org>; Thu, 21 Nov 2019 04:50:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="kc9/VfK8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726290AbfKUEuS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 20 Nov 2019 23:50:18 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:58842 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725819AbfKUEuS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 20 Nov 2019 23:50:18 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAL4nBXd057636;
        Thu, 21 Nov 2019 04:50:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=Ta0Nq0pN2zZqmU6v7PM9FqeW2TzicUpEfn1UmH8ir0E=;
 b=kc9/VfK88tJgnrCqS3QNViNGD0nec+t/uZlLvXUS2pVNq4aSVYTP2CNeoGi8z2/XJvdp
 EriuVOrBulAU7Og5X9AJgWe4JmkmdKHjFwOuQczOEm31WRRrHUrxmOKD4gbpWGu6RGiZ
 iFoD2xruMT6hQBfhYOWb9oKURRPGtHLR1rmJPXAQIt0AYOq5r4hv5pV/HcAj1mz3Lv8k
 Yiq+mjaLw2IZX5fETBsp3ca/4pomMFptHC6elI3WVLxvaycKhoW+lcxeoNEyJ5tDd95z
 cSWyePTAQeW7w7dzVopPTW03DHdA6JtXw5eTOGNc4R4TGmK3VtLRlBNA77i4bpZsmDmh xA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2wa92q1m7d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Nov 2019 04:50:08 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAL4hnxF136757;
        Thu, 21 Nov 2019 04:50:08 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 2wd46xm8pu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Nov 2019 04:50:07 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xAL4o5dg028806;
        Thu, 21 Nov 2019 04:50:06 GMT
Received: from localhost (/10.159.246.236)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 20 Nov 2019 20:50:04 -0800
Date:   Wed, 20 Nov 2019 20:50:03 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org, zhangshaokun@hisilicon.com
Subject: Re: [PATCH] xfs: gut error handling in
 xfs_trans_unreserve_and_mod_sb()
Message-ID: <20191121045003.GX6235@magnolia>
References: <20191121004437.9633-1-david@fromorbit.com>
 <20191121023836.GV6219@magnolia>
 <20191121040023.GD4614@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191121040023.GD4614@dread.disaster.area>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9447 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1911210042
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9447 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1911210043
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Nov 21, 2019 at 03:00:23PM +1100, Dave Chinner wrote:
> On Wed, Nov 20, 2019 at 06:38:36PM -0800, Darrick J. Wong wrote:
> > On Thu, Nov 21, 2019 at 11:44:37AM +1100, Dave Chinner wrote:
> > > From: Dave Chinner <dchinner@redhat.com>
> > > 
> > > Shaokun Zhang reported that XFs was using substantial CPU time in
> > > percpu_count_sum() when running a single threaded benchmark on
> > > a high CPU count (128p) machine from xfs_mod_ifree(). The issue
> > > is that the filesystem is empty when the benchmark runs, so inode
> > > allocation is running with a very low inode free count.
> > > 
> > > With the percpu counter batching, this means comparisons when the
> > > counter is less that 128 * 256 = 32768 use the slow path of adding
> > > up all the counters across the CPUs, and this is expensive on high
> > > CPU count machines.
> > > 
> > > The summing in xfs_mod_ifree() is only used to fire an assert if an
> > > underrun occurs. The error is ignored by the higher level code.
> > > Hence this is really just debug code. Hence we don't need to run it
> > > on production kernels, nor do we need such debug checks to return
> > > error values just to trigger an assert.
> > > 
> > > Further, the error handling in xfs_trans_unreserve_and_mod_sb() is
> > > largely incorrect - Rolling back the changes in the transaction if
> > > only one counter underruns makes all the other counters
> > > incorrect.
> > 
> > Separate change, separate patch...
> 
> Yeah, i can split it up, just wanted to see what people thought
> about the approach...

<nod>

> > >  	if (idelta) {
> > > -		error = xfs_mod_icount(mp, idelta);
> > > -		if (error)
> > > -			goto out_undo_fdblocks;
> > > +		percpu_counter_add_batch(&mp->m_icount, idelta,
> > > +					 XFS_ICOUNT_BATCH);
> > > +		if (idelta < 0)
> > > +			ASSERT(__percpu_counter_compare(&mp->m_icount, 0,
> > > +							XFS_ICOUNT_BATCH) >= 0);
> > >  	}
> > >  
> > >  	if (ifreedelta) {
> > > -		error = xfs_mod_ifree(mp, ifreedelta);
> > > -		if (error)
> > > -			goto out_undo_icount;
> > > +		percpu_counter_add(&mp->m_ifree, ifreedelta);
> > > +		if (ifreedelta < 0)
> > > +			ASSERT(percpu_counter_compare(&mp->m_ifree, 0) >= 0);
> > 
> > Since the whole thing is a debug statement, why not shove everything
> > into a single assert?
> > 
> > ASSERT(ifreedelta >= 0 || percpu_computer_compare() >= 0); ?
> 
> I could, but it still needs to be split over two lines and I find
> unnecessarily complex ASSERT checks hinder understanding. I can look
> at what I wrote at a glance and immediately understand that the
> assert is conditional on the counter being negative, but the single
> line compound assert form requires me to stop, read and think about
> the logic before I can identify that the ifreedelta check is just a
> conditional that reduces the failure scope rather than is a failure
> condition itself.
> 
> I like simple logic with conditional behaviour being obvious via
> pattern matching - it makes my brain hurt less because I'm really
> good at visual pattern matching and I'm really bad at reading
> and writing code.....

Fair enough.  I'm not a paragon of correctness wrt. boolean logic either.
I'm ok if you leave it as is.

> > > -out_undo_frextents:
> > > -	if (rtxdelta)
> > > -		xfs_sb_mod64(&mp->m_sb.sb_frextents, -rtxdelta);
> > > -out_undo_ifree:
> > > +	xfs_sb_mod64(&mp->m_sb.sb_frextents, rtxdelta);
> > 
> > As for these bits... why even bother with a three line helper?  I think
> > this is clearer about what's going on:
> > 
> > 	mp->m_sb.sb_frextents += rtxdelta;
> > 	mp->m_sb.sb_dblocks += tp->t_dblocks_delta;
> > 	...
> > 	ASSERT(!rtxdelta || mp->m_sb.sb_frextents >= 0);
> > 	ASSERT(!tp->t_dblocks_delta || mp->m_sb.sb.dblocks >= 0);
> 
> That required writing more code and adding more logic I'd have to
> think about to write, and then think about again every time I read
> it.

OTOH it's an opportunity to make the asserts more useful, because right
now they just say:

XFS (sda): Assertion failed: counter >= 0, file: xfs_trans.c, line XXX

*Which* counter just tripped the assert?  At least it could say:

XFS (sda): Assertion failed: mp->m_sb.sb_dblocks >= 0, file: xfs_trans.c, line XXX

> > I also wonder if we should be shutting down the fs here if the counts
> > go negative, but <shrug> that would be yet a different patch. :)
> 
> I also thought about that, but all this accounting should have
> already been bounds checked. i.e. We should never get an error here,
> and I don't think I've *ever* seen an assert in this code fire.
> Hence I just went for the dead simple nuke-it-from-orbit patch...

<nod> I have, but only after seriously fubaring some code. :)

--D

> Cheers,
> 
> Dave.
> 
> -- 
> Dave Chinner
> david@fromorbit.com
