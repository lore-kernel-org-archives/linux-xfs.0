Return-Path: <SRS0=EAe2=4B=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7882AC352A4
	for <linux-xfs@archiver.kernel.org>; Thu, 13 Feb 2020 01:41:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 444E520873
	for <linux-xfs@archiver.kernel.org>; Thu, 13 Feb 2020 01:41:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="bk7JmKw5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729413AbgBMBl2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 12 Feb 2020 20:41:28 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:59592 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729285AbgBMBl2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 12 Feb 2020 20:41:28 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01D1dEfN028511;
        Thu, 13 Feb 2020 01:41:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=zUSfMMmyO6lx6xbzHm9vBaQnT8Fx7BHjTb+b4fS4jSo=;
 b=bk7JmKw56HIG3L/BZQWwX9abntTtrT5ulr4mUhcJRx6mUS0fJ298/DndHx0zeklPNUCR
 ARMQt3NzdrwrEKyn/1gxxYUt8Yf9Jl2hHd+2FTK0va3JsH1bDFFqYP+6GjGW6Zc3KQMj
 QIbB6j/UqlrQ/32i3v+TfccNZrOY7JwfXwQxz0Bw2LVUhICLqH/5niAf2m7oLzz67bT0
 rtRozOy6zAVq4lKJT0oq03eQaKbNaeDdc+HGPFP3YMb+0o1hSAzDJf7GRtHerzaLyNzZ
 QKaF9N7GFaLJ+mQZQYZoxpVOqoRhevsmMVaFAvppsj/FDwMS39PQrNNbh7YiPv26nPus 2Q== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2y2jx6euav-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 13 Feb 2020 01:41:25 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01D1bxIl157504;
        Thu, 13 Feb 2020 01:41:25 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 2y4k7xryan-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 13 Feb 2020 01:41:25 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 01D1fNqd011938;
        Thu, 13 Feb 2020 01:41:24 GMT
Received: from localhost (/10.159.151.237)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 12 Feb 2020 17:41:23 -0800
Date:   Wed, 12 Feb 2020 17:41:21 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 03/14] xfs: refactor quota exceeded test
Message-ID: <20200213014121.GX6870@magnolia>
References: <157784106066.1364230.569420432829402226.stgit@magnolia>
 <157784108138.1364230.6221331077843589601.stgit@magnolia>
 <b979d33d-361b-88cd-699c-7e5f1c621698@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b979d33d-361b-88cd-699c-7e5f1c621698@sandeen.net>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9529 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 suspectscore=0 mlxscore=0 bulkscore=0 malwarescore=0 phishscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002130012
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9529 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 priorityscore=1501 adultscore=0 phishscore=0 impostorscore=0 spamscore=0
 bulkscore=0 lowpriorityscore=0 mlxscore=0 suspectscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002130012
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Feb 12, 2020 at 05:51:18PM -0600, Eric Sandeen wrote:
> On 12/31/19 7:11 PM, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Refactor the open-coded test for whether or not we're over quota.
> 
> Ooh, nice.  This was horrible.
> 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  fs/xfs/xfs_dquot.c |   61 +++++++++++++++++++++-------------------------------
> >  1 file changed, 25 insertions(+), 36 deletions(-)
> > 
> > 
> > diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
> > index e50c75d9d788..54e7fdcd1d4d 100644
> > --- a/fs/xfs/xfs_dquot.c
> > +++ b/fs/xfs/xfs_dquot.c
> > @@ -99,6 +99,17 @@ xfs_qm_adjust_dqlimits(
> >  		xfs_dquot_set_prealloc_limits(dq);
> >  }
> >  
> > +static inline bool
> > +xfs_quota_exceeded(
> > +	const __be64		*count,
> > +	const __be64		*softlimit,
> > +	const __be64		*hardlimit) {
> 
> why pass these all as pointers?

I don't remember.  I think a previous iteration of bigtime had something
to do with messing with the dquot directly?

> > +
> > +	if (*softlimit && be64_to_cpup(count) > be64_to_cpup(softlimit))
> > +		return true;
> > +	return *hardlimit && be64_to_cpup(count) > be64_to_cpup(hardlimit);
> 
> The asymmetry bothers me a little but maybe that's just me.  Is
> 
> > +	if ((*softlimit && be64_to_cpup(count) > be64_to_cpup(softlimit)) ||
> > +	    (*hardlimit && be64_to_cpup(count) > be64_to_cpup(hardlimit)))
> > +		return true;
> > +	return false;
> 
> any better? *shrug*

Yeah, I could fix that function.

> > +}
> > +
> >  /*
> >   * Check the limits and timers of a dquot and start or reset timers
> >   * if necessary.
> > @@ -117,6 +128,8 @@ xfs_qm_adjust_dqtimers(
> >  	struct xfs_mount	*mp,
> >  	struct xfs_disk_dquot	*d)
> >  {
> > +	bool			over;
> > +
> >  	ASSERT(d->d_id);
> >  
> >  #ifdef DEBUG
> > @@ -131,71 +144,47 @@ xfs_qm_adjust_dqtimers(
> >  		       be64_to_cpu(d->d_rtb_hardlimit));
> >  #endif
> >  
> > +	over = xfs_quota_exceeded(&d->d_bcount, &d->d_blk_softlimit,
> > +			&d->d_blk_hardlimit);
> >  	if (!d->d_btimer) {
> > -		if ((d->d_blk_softlimit && (be64_to_cpu(d->d_bcount) > be64_to_cpu(d->d_blk_softlimit))) ||
> > -		    (d->d_blk_hardlimit && (be64_to_cpu(d->d_bcount) > be64_to_cpu(d->d_blk_hardlimit)))) {
> > +		if (over) {
> 
> I wonder why we check the hard limit.  Isn't exceeding the soft limit
> enough to start the timer?  Unrelated to the refactoring tho.

Suppose there's only a hard limit set?

> >  			d->d_btimer = cpu_to_be32(get_seconds() +
> >  					mp->m_quotainfo->qi_btimelimit);
> >  		} else {
> >  			d->d_bwarns = 0;
> >  		}
> >  	} else {
> > -		if ((!d->d_blk_softlimit || (be64_to_cpu(d->d_bcount) <= be64_to_cpu(d->d_blk_softlimit))) &&
> > -		    (!d->d_blk_hardlimit || (be64_to_cpu(d->d_bcount) <= be64_to_cpu(d->d_blk_hardlimit)))) {
> > +		if (!over) {
> >  			d->d_btimer = 0;
> >  		}
> 
> I guess that could be
> 
> >  	} else if (!over) {
> >  		d->d_btimer = 0;
> >  	}
> 
> ? but again *shrug* and that's beyond refactoring, isn't it.

Strictly speaking, yes, but I think they're logically equivalent.

--D
